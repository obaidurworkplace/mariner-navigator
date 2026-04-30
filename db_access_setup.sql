-- =============================================
-- Mariner Navigator — Database Access Setup
-- Database: db-mpi-navigator
-- Run this script connected to [db-mpi-navigator] as an Azure AD admin.
-- Replace all <placeholder> values before executing.
-- =============================================

USE [db-mpi-navigator];
GO

-- =============================================
-- Consumer 1: Extraction Pipeline (Azure Function — Managed Identity)
-- Identity:   System-assigned or user-assigned managed identity of the
--             Azure Function App that runs the extraction pipeline.
-- Access:     SELECT, INSERT, UPDATE, DELETE on all 6 tables.
-- Auth:       Azure AD (no password — token-based via Managed Identity).
-- Replace:    <extraction-function-app-name> with the exact Azure Function
--             App resource name as it appears in the Azure portal.
-- =============================================
CREATE USER [<extraction-function-app-name>] FROM EXTERNAL PROVIDER;
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[consultants]               TO [<extraction-function-app-name>];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[consultant_resumes]        TO [<extraction-function-app-name>];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[consultant_skills]         TO [<extraction-function-app-name>];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[consultant_certifications] TO [<extraction-function-app-name>];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[consultant_projects]       TO [<extraction-function-app-name>];
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[extraction_log]            TO [<extraction-function-app-name>];
GO


-- =============================================
-- Consumer 2: Web App API Layer (Azure Function / App Service — Managed Identity)
-- Identity:   System-assigned or user-assigned managed identity of the
--             web-facing API host (Function App or App Service).
-- Access:     SELECT on all 6 tables.
--             UPDATE restricted to operational fields on [consultants] only:
--               security_clearance, bill_rate, availability_status, available_from.
--             No INSERT or DELETE — the extraction pipeline owns structural writes.
-- Auth:       Azure AD (no password — token-based via Managed Identity).
-- Replace:    <webapp-app-name> with the exact App Service / Function App
--             resource name as it appears in the Azure portal.
-- =============================================
CREATE USER [<webapp-app-name>] FROM EXTERNAL PROVIDER;
GO

GRANT SELECT ON [dbo].[consultants]               TO [<webapp-app-name>];
GRANT SELECT ON [dbo].[consultant_resumes]        TO [<webapp-app-name>];
GRANT SELECT ON [dbo].[consultant_skills]         TO [<webapp-app-name>];
GRANT SELECT ON [dbo].[consultant_certifications] TO [<webapp-app-name>];
GRANT SELECT ON [dbo].[consultant_projects]       TO [<webapp-app-name>];
GRANT SELECT ON [dbo].[extraction_log]            TO [<webapp-app-name>];

-- Column-level UPDATE: operational fields only (never overwritten by extraction pipeline)
GRANT UPDATE (
    [security_clearance],
    [bill_rate],
    [availability_status],
    [available_from]
) ON [dbo].[consultants] TO [<webapp-app-name>];
GO


-- =============================================
-- Consumer 3: Azure AI Search Indexer (SQL Authentication)
-- Identity:   Dedicated SQL user — no Azure AD dependency, required by the
--             Azure AI Search SQL connector which uses a connection string
--             with username/password.
-- Access:     SELECT on [consultants] only.
--             VIEW CHANGE TRACKING on [consultants] — required for the
--             High Water Mark / Change Tracking incremental index mode.
-- Auth:       SQL username + password, stored in Azure Key Vault and
--             referenced via the AI Search data source connection string.
-- Replace:    <ai-search-password> with a strong password (min 16 chars,
--             upper + lower + digit + symbol). Store it in Key Vault.
-- =============================================
CREATE USER [svc-ai-search] WITH PASSWORD = '<ai-search-password>';
GO

GRANT SELECT             ON [dbo].[consultants] TO [svc-ai-search];
GRANT VIEW CHANGE TRACKING ON [dbo].[consultants] TO [svc-ai-search];
GO


-- =============================================
-- Verification queries — run after setup to confirm grants
-- =============================================
-- Check all database users
SELECT name, type_desc, authentication_type_desc
FROM sys.database_principals
WHERE type IN ('S', 'E', 'X')          -- SQL user, External (AAD) user/group
  AND name NOT IN ('dbo', 'guest', 'INFORMATION_SCHEMA', 'sys');

-- Check table-level permissions
SELECT
    dp.name          AS principal,
    o.name           AS object_name,
    p.permission_name,
    p.state_desc
FROM sys.database_permissions p
JOIN sys.objects             o  ON p.major_id    = o.object_id
JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
WHERE o.schema_id = SCHEMA_ID('dbo')
  AND dp.name NOT IN ('dbo', 'public')
ORDER BY dp.name, o.name, p.permission_name;
