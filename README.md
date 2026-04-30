# Mariner Navigator — Database Setup Guide

## Schema File: `consultant_resume_db_schema.sql`

This file is the single executable T-SQL script that builds the entire database from scratch. Run it once against a new, empty `db-mpi-navigator` database.

### What the script creates

| Section | Contents |
|---|---|
| **1 — Database change tracking** | Enables change tracking at database level (`CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON`) |
| **2 — Tables (6)** | Created in dependency order so foreign keys can be added without errors |
| **3 — Foreign key constraints (6)** | Enforces referential integrity with explicit `CASCADE` / `NO ACTION` rules |
| **4 — Indexes (11)** | Non-clustered indexes on filter columns + 2 unique indexes for merge-key enforcement |
| **5 — Triggers (2)** | `TR_consultants_updated_at` (auto-stamp `updated_at`) and `TR_resumes_log_setnull` (SET NULL on resume delete) |
| **6 — Table change tracking** | Enables change tracking on `consultants` for AI Search incremental sync |

### Tables and columns

#### `consultants` — source of truth, one row per consultant
| Column | Type | Notes |
|---|---|---|
| `consultant_id` | `INT IDENTITY` PK | |
| `external_id` | `NVARCHAR(100)` | Kantata / HRIS identifier |
| `first_name`, `last_name` | `NVARCHAR(100)` NOT NULL | |
| `email` | `NVARCHAR(255)` | |
| `role_title` | `NVARCHAR(200)` NOT NULL | Overwritten by each extraction run |
| `seniority_level` | `NVARCHAR(50)` | CHECK: `Junior`, `Intermediate`, `Senior`, `Lead`, `Principal` |
| `employment_type` | `NVARCHAR(30)` NOT NULL | CHECK: `Employee`, `Contractor`, `IC` |
| `region`, `city` | `NVARCHAR(100)` | Overwritten by each extraction run |
| `security_clearance` | `NVARCHAR(100)` | **Operational** — set by Resourcing, never by pipeline |
| `bill_rate` | `DECIMAL(10,2)` | **Operational** — set by Finance/Resourcing, never by pipeline |
| `availability_status` | `NVARCHAR(30)` NOT NULL | CHECK: `Available`, `Allocated`, `Partial`, `On Leave` — **Operational** |
| `available_from` | `DATE` | **Operational** |
| `profile_text` | `NVARCHAR(MAX)` NOT NULL | LLM-merged narrative, updated on each upload |
| `profile_text_source` | `NVARCHAR(500)` | Comma-separated `resume_id` values contributing to `profile_text` |
| `extraction_version` | `INT` NOT NULL | Prompt version that last processed this record |
| `last_extracted_at` | `DATETIME2` NOT NULL | |
| `created_at`, `updated_at` | `DATETIME2` NOT NULL | Default `GETUTCDATE()`; `updated_at` auto-stamped by trigger |

#### `consultant_resumes` — one row per resume file
| Column | Type | Notes |
|---|---|---|
| `resume_id` | `INT IDENTITY` PK | |
| `consultant_id` | `INT` NOT NULL | FK → `consultants` (CASCADE DELETE) |
| `sharepoint_path` | `NVARCHAR(450)` NOT NULL | Unique — prevents duplicate file tracking |
| `resume_type` | `NVARCHAR(50)` NOT NULL | CHECK: `General`, `Tailored`, `Proposal` |
| `file_hash` | `NVARCHAR(64)` | SHA-256; pipeline skips re-processing if hash matches |
| `uploaded_at` | `DATETIME2` NOT NULL | Default `GETUTCDATE()` |
| `processed_at` | `DATETIME2` | NULL until extraction completes |
| `extraction_version` | `INT` | Prompt version used for this specific resume |
| `status` | `NVARCHAR(30)` NOT NULL | CHECK: `pending`, `processing`, `success`, `failed`. Default `pending` |

#### `consultant_skills` — additive, one row per consultant per skill
| Column | Type | Notes |
|---|---|---|
| `skill_id` | `INT IDENTITY` PK | |
| `consultant_id` | `INT` NOT NULL | FK → `consultants` (NO ACTION) |
| `skill_name` | `NVARCHAR(200)` NOT NULL | Unique with `consultant_id` via `UQ_skills_merge_key` |
| `skill_category` | `NVARCHAR(100)` | e.g. `Cloud`, `Data`, `DevOps` |
| `proficiency` | `NVARCHAR(30)` | CHECK: `Beginner`, `Intermediate`, `Advanced`, `Expert` |
| `source_resume_id` | `INT` | Resume this skill was first extracted from |

#### `consultant_certifications` — additive, one row per consultant per certification
| Column | Type | Notes |
|---|---|---|
| `certification_id` | `INT IDENTITY` PK | |
| `consultant_id` | `INT` NOT NULL | FK → `consultants` (NO ACTION) |
| `certification_name` | `NVARCHAR(300)` NOT NULL | |
| `issuing_body` | `NVARCHAR(200)` | e.g. `Microsoft`, `AWS`, `PMI` |
| `date_obtained`, `expiry_date` | `DATE` | `expiry_date` updated if a later value appears in a newer resume |
| `source_resume_id` | `INT` | |

#### `consultant_projects` — additive, one row per consultant per engagement
| Column | Type | Notes |
|---|---|---|
| `project_id` | `INT IDENTITY` PK | |
| `consultant_id` | `INT` NOT NULL | FK → `consultants` (NO ACTION) |
| `project_name` | `NVARCHAR(300)` NOT NULL | |
| `client_name` | `NVARCHAR(200)` | |
| `sector` | `NVARCHAR(100)` | e.g. `Public Sector`, `Financial Services` |
| `role_on_project` | `NVARCHAR(200)` | |
| `description` | `NVARCHAR(MAX)` | Updated only if new version has greater character count |
| `start_date`, `end_date` | `DATE` | `end_date` updated only if previously NULL |
| `source_resume_id` | `INT` | |

#### `extraction_log` — audit log, one row per pipeline run
| Column | Type | Notes |
|---|---|---|
| `log_id` | `INT IDENTITY` PK | |
| `consultant_id` | `INT` NOT NULL | FK → `consultants` (CASCADE DELETE) |
| `resume_id` | `INT` | FK → `consultant_resumes` (NO ACTION); set to NULL by trigger when resume deleted |
| `status` | `NVARCHAR(30)` NOT NULL | CHECK: `success`, `failed`, `partial` |
| `extraction_version` | `INT` NOT NULL | |
| `error_message` | `NVARCHAR(MAX)` | Populated on `failed` or `partial` runs |
| `tokens_used` | `INT` | LLM tokens consumed |
| `duration_ms` | `INT` | Processing time in milliseconds |
| `executed_at` | `DATETIME2` NOT NULL | Default `GETUTCDATE()` |

### Key design rules enforced by the schema

- **Operational fields** (`security_clearance`, `bill_rate`, `availability_status`, `available_from`) are **never touched by the extraction pipeline** — only the web app API can write them.
- **Skills, certifications, and projects are additive** — rows are never deleted by the pipeline, only inserted or selectively updated.
- **`FK_log_resume` uses NO ACTION** (not SET NULL) to avoid SQL Server error 1785 (multiple cascade paths). The SET NULL behaviour is implemented by trigger `TR_resumes_log_setnull`.
- **`UQ_skills_merge_key`** on `(consultant_id, skill_name)` enforces one row per consultant per skill; case-insensitivity is satisfied by the default Azure SQL collation `SQL_Latin1_General_CP1_CI_AS`.

---

## Database Connection Details

| Property | Value |
|---|---|
| **Azure SQL Server** | `server-mpi-navigator.database.windows.net` |
| **Database** | `db-mpi-navigator` |
| **Port** | `1433` |
| **Encryption** | Required (`Encrypt=True`) |
| **Authentication (pipeline / API)** | Azure AD Managed Identity |
| **Authentication (AI Search)** | SQL username + password |

> **Where to find your server name:** Azure Portal → SQL databases → `db-mpi-navigator` → Overview → **Server name** field.

---

## Schema Overview

The schema (`consultant_resume_db_schema.sql`) creates 6 tables:

| Table | Purpose |
|---|---|
| `consultants` | One row per consultant — source of truth |
| `consultant_resumes` | Resume files tracked from SharePoint |
| `consultant_skills` | Skills extracted from resumes (additive) |
| `consultant_certifications` | Certifications extracted from resumes (additive) |
| `consultant_projects` | Project history extracted from resumes (additive) |
| `extraction_log` | Audit log for every pipeline run |

Change tracking is enabled on the database and on `consultants` (for AI Search incremental sync).

---

## Consumer Patterns

### Consumer 1 — Extraction Pipeline

| Property | Detail |
|---|---|
| **Host** | Azure Function App |
| **Authentication** | Managed Identity (system-assigned or user-assigned) |
| **Access** | `SELECT`, `INSERT`, `UPDATE`, `DELETE` on all 6 tables |

**Connection string** (add to Function App → Configuration → Application settings):

```
Server=tcp:server-mpi-navigator.database.windows.net,1433;
Initial Catalog=db-mpi-navigator;
Authentication=Active Directory Default;
Encrypt=True;
TrustServerCertificate=False;
Connection Timeout=30;
```

`Active Directory Default` picks up the managed identity automatically when running in Azure, and falls back to your local `az login` credentials during local development.

---

### Consumer 2 — Azure App Service or Azure Container App

| Property | Detail |
|---|---|
| **Host** | Azure Function App or App Service |
| **Authentication** | Managed Identity (system-assigned or user-assigned) |
| **Access** | `SELECT` on all 6 tables; `UPDATE` on `security_clearance`, `bill_rate`, `availability_status`, `available_from` columns of `consultants` only |

**Connection string** (same format as Consumer 1 — substitute this app's managed identity):

```
Server=tcp:server-mpi-navigator.database.windows.net,1433;
Initial Catalog=db-mpi-navigator;
Authentication=Active Directory Default;
Encrypt=True;
TrustServerCertificate=False;
Connection Timeout=30;
```

**Operational fields the API can write** (column-level grant, not full UPDATE on the table):

| Column | Set by |
|---|---|
| `security_clearance` | Resourcing team via web UI |
| `bill_rate` | Finance / Resourcing team via web UI |
| `availability_status` | Resourcing team via web UI |
| `available_from` | Resourcing team via web UI |

All other columns are managed exclusively by the extraction pipeline.

---

### Consumer 3 — Azure AI Search Indexer

| Property | Detail |
|---|---|
| **Host** | Azure AI Search service |
| **Authentication** | SQL username + password (`svc-ai-search`) |
| **Access** | `SELECT` and `VIEW CHANGE TRACKING` on `consultants` table only |

**Connection string** (store in Key Vault, reference from AI Search data source):

```
Server=tcp:server-mpi-navigator.database.windows.net,1433;
Database=db-mpi-navigator;
User ID=svc-ai-search;
Password=<ai-search-password>;
Encrypt=True;
TrustServerCertificate=False;
Connection Timeout=30;
```

**Why SQL auth instead of Managed Identity?**  
The Azure AI Search SQL connector uses a classic connection string; it does not support Azure AD Managed Identity authentication against Azure SQL at this time. SQL auth is therefore required for this consumer only.

**Why not `db_datareader` role?**  
`db_datareader` grants `SELECT` on every table and view in the database. `svc-ai-search` only needs `consultants`, so a targeted `GRANT SELECT` is used instead to enforce least privilege.

---

## Setting Up Database Users

### Prerequisites

- You must be connected to `db-mpi-navigator` as an **Azure AD admin** (not a SQL admin — SQL admins cannot create `FROM EXTERNAL PROVIDER` users).
- The Azure SQL Server must have an **Azure Active Directory admin** configured (Azure Portal → SQL Server → Azure Active Directory).
- The managed identity must be **enabled** on each Azure resource before you create its database user.

### Step 1 — Deploy the schema

Run `consultant_resume_db_schema.sql` against a new, empty `db-mpi-navigator` database.

```bash
# Using sqlcmd (replace placeholders)
sqlcmd -S server-mpi-navigator.database.windows.net \
       -d db-mpi-navigator \
       -G \                          # Use Azure AD auth
       -i consultant_resume_db_schema.sql
```

### Step 2 — Create users and grant permissions

Open `db_access_setup.sql` and replace all `<placeholder>` values:

| Placeholder | Replace with |
|---|---|
| `<extraction-function-app-name>` | Exact name of the extraction Azure Function App resource |
| `<webapp-app-name>` | Exact name of the web API App Service / Function App resource |
| `<ai-search-password>` | A strong password (≥16 chars, upper + lower + digit + symbol) |

Then run the script:

```bash
sqlcmd -S server-mpi-navigator.database.windows.net \
       -d db-mpi-navigator \
       -G \
       -i db_access_setup.sql
```

### Step 3 — Store the AI Search password in Key Vault

```bash
az keyvault secret set \
  --vault-name <your-key-vault-name> \
  --name "sql-ai-search-password" \
  --value "<ai-search-password>"
```

Then reference it from your AI Search data source connection string via Key Vault reference or directly in the AI Search portal.

### Step 4 — Verify permissions

The verification queries at the bottom of `db_access_setup.sql` will list all database users and their grants. Run them after setup to confirm the expected rows appear.

---

## Local Development

For local development, your personal Azure AD account is used instead of a managed identity. Ensure you are signed into the Azure CLI:

```bash
az login
az account set --subscription <subscription-id>
```

The connection string `Authentication=Active Directory Default` will pick up your `az login` credentials automatically. Your account needs equivalent grants in the database (or you are already the AAD admin and have full access).

---

## Incremental Indexing (AI Search)

The `consultants` table has SQL Server Change Tracking enabled (`CHANGE_RETENTION = 2 DAYS`). Configure the Azure AI Search indexer to use **Change Tracking** policy:

```json
{
  "dataDeletionDetectionPolicy": null,
  "dataChangeDetectionPolicy": {
    "@odata.type": "#Microsoft.Azure.Search.SqlIntegratedChangeTrackingPolicy"
  }
}
```

This allows the indexer to sync only changed rows since its last run rather than doing a full table scan.
