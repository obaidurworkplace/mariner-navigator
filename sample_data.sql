-- =============================================
-- Mariner Navigator — Sample Seed Data
-- Database: db-mpi-navigator
-- 5 consultants, 2 resumes each, with skills, certifications,
-- projects, and extraction log entries.
-- Run AFTER consultant_resume_db_schema.sql on an empty database.
-- =============================================

USE [db-mpi-navigator];
GO

SET NOCOUNT ON;

-- =============================================
-- ID capture variables (populated via SCOPE_IDENTITY)
-- =============================================
DECLARE @c1 INT, @c2 INT, @c3 INT, @c4 INT, @c5 INT;
DECLARE @r1a INT, @r1b INT;
DECLARE @r2a INT, @r2b INT;
DECLARE @r3a INT, @r3b INT;
DECLARE @r4a INT, @r4b INT;
DECLARE @r5a INT, @r5b INT;

-- =============================================
-- CONSULTANTS
-- =============================================

-- Consultant 1: Sarah Chen — Lead Data Architect
INSERT INTO [dbo].[consultants] (
    [external_id], [first_name], [last_name], [email],
    [role_title], [seniority_level], [employment_type],
    [region], [city], [security_clearance], [bill_rate],
    [experience_start_date], [availability_status], [available_from],
    [profile_text], [profile_text_source],
    [extraction_version], [last_extracted_at]
) VALUES (
    'KNT-00142', 'Sarah', 'Chen', 'sarah.chen@marinerinnovations.com.au',
    'Lead Data Architect', 'Lead', 'Employee',
    'ACT', 'Canberra', 'Baseline', 1650.00,
    '2012-03-01', 'Available', NULL,
    'Sarah Chen is a Lead Data Architect with over 12 years of experience designing and delivering enterprise data platforms across government and financial services. She has deep expertise in Azure data engineering — including Azure Synapse Analytics, Azure Data Factory, and Azure Databricks — and has led data platform modernisation programs for federal agencies and major financial institutions. Sarah is skilled at translating complex business requirements into scalable data architectures, establishing data governance frameworks, and building high-performing data engineering teams. She holds active Baseline security clearance and has consistently delivered projects within budget and schedule across agile delivery environments.',
    NULL,
    3, '2025-11-15T09:05:11'
);
SET @c1 = SCOPE_IDENTITY();

-- Consultant 2: James O'Brien — Senior Cloud Engineer
INSERT INTO [dbo].[consultants] (
    [external_id], [first_name], [last_name], [email],
    [role_title], [seniority_level], [employment_type],
    [region], [city], [security_clearance], [bill_rate],
    [experience_start_date], [availability_status], [available_from],
    [profile_text], [profile_text_source],
    [extraction_version], [last_extracted_at]
) VALUES (
    'KNT-00289', 'James', 'OBrien', 'james.obrien@marinerinnovations.com.au',
    'Senior Cloud Engineer', 'Senior', 'Employee',
    'NSW', 'Sydney', NULL, 1400.00,
    '2015-06-01', 'Allocated', NULL,
    'James O''Brien is a Senior Cloud Engineer with 9 years of experience specialising in cloud infrastructure design, automation, and DevOps practices on the Microsoft Azure platform. He has delivered large-scale cloud migrations and greenfield platform builds for government agencies and financial services clients, with particular strength in infrastructure-as-code using Terraform, containerisation with Kubernetes and Docker, and CI/CD pipeline design using Azure DevOps. James brings a pragmatic approach to cloud architecture that balances reliability, security, and cost optimisation. He is currently engaged on a federal cloud landing zone program and will be available for new engagements in February 2026.',
    NULL,
    3, '2025-10-22T14:06:02'
);
SET @c2 = SCOPE_IDENTITY();

-- Consultant 3: Priya Sharma — Principal AI/ML Engineer
INSERT INTO [dbo].[consultants] (
    [external_id], [first_name], [last_name], [email],
    [role_title], [seniority_level], [employment_type],
    [region], [city], [security_clearance], [bill_rate],
    [experience_start_date], [availability_status], [available_from],
    [profile_text], [profile_text_source],
    [extraction_version], [last_extracted_at]
) VALUES (
    'KNT-00371', 'Priya', 'Sharma', 'priya.sharma@marinerinnovations.com.au',
    'Principal AI/ML Engineer', 'Principal', 'Employee',
    'VIC', 'Melbourne', NULL, 1900.00,
    '2010-08-01', 'Partial', '2026-03-01',
    'Priya Sharma is a Principal AI/ML Engineer with 15 years of experience building production machine learning systems and data science platforms. She has led the design and delivery of end-to-end AI solutions spanning natural language processing, recommendation systems, and predictive analytics for major financial institutions and the Australian Taxation Office. Priya is highly proficient in Python, Azure Machine Learning, Databricks, and emerging generative AI frameworks including LangChain and Azure OpenAI Service. She has a strong academic background in computer science and statistics and is a recognised thought leader in responsible AI practices within the Australian consulting market. She is currently available for part-time engagements and will be fully available from March 2026.',
    NULL,
    3, '2025-12-01T11:04:50'
);
SET @c3 = SCOPE_IDENTITY();

-- Consultant 4: Michael Torres — Senior Project Manager
INSERT INTO [dbo].[consultants] (
    [external_id], [first_name], [last_name], [email],
    [role_title], [seniority_level], [employment_type],
    [region], [city], [security_clearance], [bill_rate],
    [experience_start_date], [availability_status], [available_from],
    [profile_text], [profile_text_source],
    [extraction_version], [last_extracted_at]
) VALUES (
    NULL, 'Michael', 'Torres', 'michael.torres@contractor.net',
    'Senior Project Manager', 'Senior', 'Contractor',
    'QLD', 'Brisbane', NULL, 1350.00,
    '2011-02-01', 'Available', NULL,
    'Michael Torres is a Senior Project Manager with 14 years of experience delivering complex ICT and digital transformation programs across state government and the healthcare sector. He is PMP and PRINCE2 Practitioner certified and has led programs valued up to $45 million through the full project lifecycle from business case development through to post-implementation review. Michael has deep expertise in stakeholder engagement, vendor management, and agile-waterfall hybrid delivery methodologies. He has a consistent record of turning around at-risk programs and building high-trust relationships with executive sponsors. He is immediately available for new engagements.',
    NULL,
    3, '2025-09-18T08:35:22'
);
SET @c4 = SCOPE_IDENTITY();

-- Consultant 5: Emma Blackwood — Senior Security Architect
INSERT INTO [dbo].[consultants] (
    [external_id], [first_name], [last_name], [email],
    [role_title], [seniority_level], [employment_type],
    [region], [city], [security_clearance], [bill_rate],
    [experience_start_date], [availability_status], [available_from],
    [profile_text], [profile_text_source],
    [extraction_version], [last_extracted_at]
) VALUES (
    'IC-8821', 'Emma', 'Blackwood', 'emma.blackwood@securityic.com.au',
    'Senior Security Architect', 'Senior', 'IC',
    'ACT', 'Canberra', 'NV1', 1850.00,
    '2009-05-01', 'On Leave', '2026-04-01',
    'Emma Blackwood is a Senior Security Architect and independent contractor with 16 years of experience designing and assessing cyber security architectures for Australian Government agencies at PROTECTED and above classifications. She holds NV1 clearance and current IRAP assessor accreditation, enabling her to conduct formal security assessments against the Australian Government ISM. Emma has led whole-of-enterprise zero trust architecture implementations, designed SOC platforms using Microsoft Sentinel, and established security operating procedures under the Essential Eight framework. She holds CISSP, CISM, and AZ-500 certifications. Emma is currently on leave and returns to availability in April 2026.',
    NULL,
    3, '2025-08-30T16:05:33'
);
SET @c5 = SCOPE_IDENTITY();

-- =============================================
-- RESUMES (2 per consultant)
-- Simulates: first upload (General resume, extraction_version 2)
--            then a second upload (Tailored/Proposal, extraction_version 3)
-- =============================================

-- Sarah Chen
INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c1, '/sites/MarinerResources/Resumes/SarahChen/SarahChen_General_2025.docx', 'General',
    'a3f2e1d4c5b6a7f8e9d0c1b2a3f4e5d6c7b8a9f0e1d2c3b4a5f6e7d8c9b0a1f2',
    '2025-09-10T10:00:00', '2025-09-10T10:04:22', 2, 'success');
SET @r1a = SCOPE_IDENTITY();

INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c1, '/sites/MarinerResources/Resumes/SarahChen/SarahChen_FinServ_Tailored_2025.docx', 'Tailored',
    'b4e3f2a1d0c9b8a7f6e5d4c3b2a1f0e9d8c7b6a5f4e3d2c1b0a9f8e7d6c5b4a3',
    '2025-11-15T09:00:00', '2025-11-15T09:05:11', 3, 'success');
SET @r1b = SCOPE_IDENTITY();

-- James O'Brien
INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c2, '/sites/MarinerResources/Resumes/JamesOBrien/JamesOBrien_General_2025.docx', 'General',
    'c1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2',
    '2025-08-05T13:30:00', '2025-08-05T13:34:58', 2, 'success');
SET @r2a = SCOPE_IDENTITY();

INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c2, '/sites/MarinerResources/Resumes/JamesOBrien/JamesOBrien_CloudMigration_Proposal_2025.docx', 'Proposal',
    'd2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3',
    '2025-10-22T14:00:00', '2025-10-22T14:06:02', 3, 'success');
SET @r2b = SCOPE_IDENTITY();

-- Priya Sharma
INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c3, '/sites/MarinerResources/Resumes/PriyaSharma/PriyaSharma_General_2025.docx', 'General',
    'e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4',
    '2025-10-01T09:15:00', '2025-10-01T09:19:44', 2, 'success');
SET @r3a = SCOPE_IDENTITY();

INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c3, '/sites/MarinerResources/Resumes/PriyaSharma/PriyaSharma_GenAI_Tailored_2025.docx', 'Tailored',
    'f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5',
    '2025-12-01T11:00:00', '2025-12-01T11:04:50', 3, 'success');
SET @r3b = SCOPE_IDENTITY();

-- Michael Torres
INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c4, '/sites/MarinerResources/Resumes/MichaelTorres/MichaelTorres_General_2024.docx', 'General',
    'a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6',
    '2025-06-12T11:00:00', '2025-06-12T11:04:15', 2, 'success');
SET @r4a = SCOPE_IDENTITY();

INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c4, '/sites/MarinerResources/Resumes/MichaelTorres/MichaelTorres_General_2025.docx', 'General',
    'b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7',
    '2025-09-18T08:30:00', '2025-09-18T08:35:22', 3, 'success');
SET @r4b = SCOPE_IDENTITY();

-- Emma Blackwood
INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c5, '/sites/MarinerResources/Resumes/EmmaBlackwood/EmmaBlackwood_General_2025.docx', 'General',
    'c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8',
    '2025-07-20T10:30:00', '2025-07-20T10:35:08', 2, 'success');
SET @r5a = SCOPE_IDENTITY();

INSERT INTO [dbo].[consultant_resumes] ([consultant_id], [sharepoint_path], [resume_type], [file_hash], [uploaded_at], [processed_at], [extraction_version], [status])
VALUES (@c5, '/sites/MarinerResources/Resumes/EmmaBlackwood/EmmaBlackwood_PubSec_Tailored_2025.docx', 'Tailored',
    'd8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9',
    '2025-08-30T16:00:00', '2025-08-30T16:05:33', 3, 'success');
SET @r5b = SCOPE_IDENTITY();

-- =============================================
-- UPDATE profile_text_source with resume IDs
-- (done after resume INSERTs so IDs are known)
-- =============================================
UPDATE [dbo].[consultants] SET [profile_text_source] = CAST(@r1a AS NVARCHAR(10)) + ',' + CAST(@r1b AS NVARCHAR(10)) WHERE [consultant_id] = @c1;
UPDATE [dbo].[consultants] SET [profile_text_source] = CAST(@r2a AS NVARCHAR(10)) + ',' + CAST(@r2b AS NVARCHAR(10)) WHERE [consultant_id] = @c2;
UPDATE [dbo].[consultants] SET [profile_text_source] = CAST(@r3a AS NVARCHAR(10)) + ',' + CAST(@r3b AS NVARCHAR(10)) WHERE [consultant_id] = @c3;
UPDATE [dbo].[consultants] SET [profile_text_source] = CAST(@r4a AS NVARCHAR(10)) + ',' + CAST(@r4b AS NVARCHAR(10)) WHERE [consultant_id] = @c4;
UPDATE [dbo].[consultants] SET [profile_text_source] = CAST(@r5a AS NVARCHAR(10)) + ',' + CAST(@r5b AS NVARCHAR(10)) WHERE [consultant_id] = @c5;

-- =============================================
-- SKILLS
-- source_resume_id reflects which upload introduced each skill,
-- demonstrating the additive merge across two resumes.
-- =============================================

-- Sarah Chen — Data / Cloud
INSERT INTO [dbo].[consultant_skills] ([consultant_id], [skill_name], [skill_category], [proficiency], [source_resume_id]) VALUES
(@c1, 'Azure Synapse Analytics',  'Cloud', 'Expert',        @r1a),
(@c1, 'Azure Data Factory',       'Cloud', 'Expert',        @r1a),
(@c1, 'Azure Databricks',         'Cloud', 'Advanced',      @r1a),
(@c1, 'Azure Data Lake Storage',  'Cloud', 'Advanced',      @r1a),
(@c1, 'Python',                   'Data',  'Advanced',      @r1a),
(@c1, 'SQL Server',               'Data',  'Expert',        @r1a),
(@c1, 'Power BI',                 'Data',  'Advanced',      @r1a),
(@c1, 'Data Modelling',           'Data',  'Expert',        @r1a),
(@c1, 'Microsoft Purview',        'Data',  'Advanced',      @r1b),
(@c1, 'Delta Lake',               'Data',  'Intermediate',  @r1b);

-- James O'Brien — DevOps / Cloud
INSERT INTO [dbo].[consultant_skills] ([consultant_id], [skill_name], [skill_category], [proficiency], [source_resume_id]) VALUES
(@c2, 'Azure',                    'Cloud',  'Expert',   @r2a),
(@c2, 'Terraform',                'DevOps', 'Expert',   @r2a),
(@c2, 'Kubernetes',               'DevOps', 'Advanced', @r2a),
(@c2, 'Docker',                   'DevOps', 'Advanced', @r2a),
(@c2, 'Azure DevOps',             'DevOps', 'Expert',   @r2a),
(@c2, 'CI/CD Pipeline Design',    'DevOps', 'Advanced', @r2a),
(@c2, 'Azure Networking',         'Cloud',  'Advanced', @r2a),
(@c2, 'Bicep',                    'DevOps', 'Intermediate', @r2b),
(@c2, 'Azure Policy',             'Cloud',  'Advanced', @r2b),
(@c2, 'GitHub Actions',           'DevOps', 'Advanced', @r2b);

-- Priya Sharma — AI / ML / Data
INSERT INTO [dbo].[consultant_skills] ([consultant_id], [skill_name], [skill_category], [proficiency], [source_resume_id]) VALUES
(@c3, 'Python',                   'Data',  'Expert',   @r3a),
(@c3, 'Azure Machine Learning',   'Cloud', 'Expert',   @r3a),
(@c3, 'Databricks',               'Data',  'Expert',   @r3a),
(@c3, 'Apache Spark',             'Data',  'Advanced', @r3a),
(@c3, 'MLflow',                   'Data',  'Advanced', @r3a),
(@c3, 'Scikit-learn',             'Data',  'Expert',   @r3a),
(@c3, 'Statistical Modelling',    'Data',  'Expert',   @r3a),
(@c3, 'LangChain',                'Data',  'Advanced', @r3b),
(@c3, 'Azure OpenAI Service',     'Cloud', 'Advanced', @r3b),
(@c3, 'Responsible AI',           'Data',  'Advanced', @r3b);

-- Michael Torres — PM
INSERT INTO [dbo].[consultant_skills] ([consultant_id], [skill_name], [skill_category], [proficiency], [source_resume_id]) VALUES
(@c4, 'Project Management',       'PM', 'Expert',   @r4a),
(@c4, 'PRINCE2',                  'PM', 'Expert',   @r4a),
(@c4, 'Agile',                    'PM', 'Advanced', @r4a),
(@c4, 'Stakeholder Management',   'PM', 'Expert',   @r4a),
(@c4, 'Vendor Management',        'PM', 'Advanced', @r4a),
(@c4, 'Risk Management',          'PM', 'Advanced', @r4a),
(@c4, 'Business Case Development','PM', 'Expert',   @r4a),
(@c4, 'MS Project',               'PM', 'Advanced', @r4a),
(@c4, 'Jira',                     'PM', 'Intermediate', @r4b),
(@c4, 'Program Recovery',         'PM', 'Advanced', @r4b);

-- Emma Blackwood — Security
INSERT INTO [dbo].[consultant_skills] ([consultant_id], [skill_name], [skill_category], [proficiency], [source_resume_id]) VALUES
(@c5, 'Zero Trust Architecture',      'Security', 'Expert',       @r5a),
(@c5, 'Azure Active Directory',       'Security', 'Expert',       @r5a),
(@c5, 'Microsoft Sentinel',           'Security', 'Expert',       @r5a),
(@c5, 'IRAP Assessment',              'Security', 'Expert',       @r5a),
(@c5, 'Essential Eight',              'Security', 'Expert',       @r5a),
(@c5, 'ISO 27001',                    'Security', 'Advanced',     @r5a),
(@c5, 'ISM Compliance',               'Security', 'Expert',       @r5a),
(@c5, 'Penetration Testing',          'Security', 'Intermediate', @r5a),
(@c5, 'Microsoft Defender for Cloud', 'Security', 'Advanced',     @r5b),
(@c5, 'Privileged Identity Management','Security','Advanced',     @r5b);

-- =============================================
-- CERTIFICATIONS
-- =============================================

-- Sarah Chen
INSERT INTO [dbo].[consultant_certifications] ([consultant_id], [certification_name], [issuing_body], [date_obtained], [expiry_date], [source_resume_id]) VALUES
(@c1, 'Microsoft Certified: Azure Data Engineer Associate (DP-203)', 'Microsoft', '2023-04-12', '2025-04-12', @r1a),
(@c1, 'Microsoft Certified: Azure Fundamentals (AZ-900)',            'Microsoft', '2021-11-03', NULL,         @r1a),
(@c1, 'Microsoft Certified: Azure Database Administrator Associate (DP-300)', 'Microsoft', '2022-08-20', '2024-08-20', @r1b);

-- James O'Brien
INSERT INTO [dbo].[consultant_certifications] ([consultant_id], [certification_name], [issuing_body], [date_obtained], [expiry_date], [source_resume_id]) VALUES
(@c2, 'Microsoft Certified: Azure Administrator Associate (AZ-104)',         'Microsoft',                       '2022-03-15', '2024-03-15', @r2a),
(@c2, 'Microsoft Certified: Azure Solutions Architect Expert (AZ-305)',      'Microsoft',                       '2023-06-28', '2025-06-28', @r2a),
(@c2, 'HashiCorp Certified: Terraform Associate',                            'HashiCorp',                       '2023-01-10', '2025-01-10', @r2b),
(@c2, 'Certified Kubernetes Administrator (CKA)',                            'Cloud Native Computing Foundation','2022-09-05', '2025-09-05', @r2b);

-- Priya Sharma
INSERT INTO [dbo].[consultant_certifications] ([consultant_id], [certification_name], [issuing_body], [date_obtained], [expiry_date], [source_resume_id]) VALUES
(@c3, 'Microsoft Certified: Azure AI Engineer Associate (AI-102)',           'Microsoft',  '2024-02-14', '2026-02-14', @r3a),
(@c3, 'Microsoft Certified: Azure Data Scientist Associate (DP-100)',        'Microsoft',  '2023-07-22', '2025-07-22', @r3a),
(@c3, 'Databricks Certified: Associate Developer for Apache Spark',          'Databricks', '2022-11-30', NULL,         @r3b);

-- Michael Torres
INSERT INTO [dbo].[consultant_certifications] ([consultant_id], [certification_name], [issuing_body], [date_obtained], [expiry_date], [source_resume_id]) VALUES
(@c4, 'Project Management Professional (PMP)',  'PMI',           '2016-05-10', '2025-05-10', @r4a),
(@c4, 'PRINCE2 Practitioner',                  'AXELOS',        '2018-02-28', '2026-02-28', @r4a),
(@c4, 'PRINCE2 Agile Practitioner',            'AXELOS',        '2021-04-06', '2027-04-06', @r4b),
(@c4, 'Certified Scrum Master (CSM)',           'Scrum Alliance', '2019-09-14', '2025-09-14', @r4b);

-- Emma Blackwood
INSERT INTO [dbo].[consultant_certifications] ([consultant_id], [certification_name], [issuing_body], [date_obtained], [expiry_date], [source_resume_id]) VALUES
(@c5, 'Certified Information Systems Security Professional (CISSP)', 'ISC2',                           '2017-03-22', '2026-03-22', @r5a),
(@c5, 'Certified Information Security Manager (CISM)',               'ISACA',                          '2019-06-15', '2025-06-15', @r5a),
(@c5, 'IRAP Assessor Accreditation',                                 'Australian Signals Directorate', '2020-11-01', '2026-11-01', @r5a),
(@c5, 'Microsoft Certified: Azure Security Engineer Associate (AZ-500)', 'Microsoft',                  '2024-01-09', '2026-01-09', @r5b);

-- =============================================
-- PROJECTS
-- =============================================

-- Sarah Chen
INSERT INTO [dbo].[consultant_projects] ([consultant_id], [project_name], [client_name], [sector], [role_on_project], [description], [start_date], [end_date], [source_resume_id]) VALUES
(
    @c1, 'Whole-of-Government Analytics Platform', 'Department of Finance', 'Public Sector', 'Lead Data Architect',
    'Led the architecture and delivery of a consolidated analytics platform serving 14 federal agencies. Designed a medallion lakehouse on Azure Synapse Analytics and ADLS Gen2, built 30+ ingestion pipelines via Azure Data Factory, and implemented a shared data catalogue using Microsoft Purview. Delivered to 400+ analysts with 99.7% platform uptime.',
    '2023-02-01', '2024-08-31', @r1a
),
(
    @c1, 'Fraud Analytics Modernisation', 'National Australia Bank', 'Financial Services', 'Senior Data Architect',
    'Redesigned the transaction fraud detection data platform, migrating from on-premise SQL Server to Azure Databricks with Delta Lake. Reduced data latency from 4 hours to under 15 minutes, enabling near-real-time fraud scoring. Delivered a feature store on Databricks Feature Engineering that cut model retraining time by 60%.',
    '2021-09-01', '2023-01-31', @r1b
),
(
    @c1, 'Data Governance Framework', 'Services Australia', 'Public Sector', 'Data Architecture Consultant',
    'Established a whole-of-agency data governance framework including data stewardship model, data quality rules, and metadata management using Microsoft Purview. Trained 80 data stewards and produced policy documentation aligned to the Australian Government Data Policy.',
    '2020-06-01', '2021-08-31', @r1a
);

-- James O'Brien
INSERT INTO [dbo].[consultant_projects] ([consultant_id], [project_name], [client_name], [sector], [role_on_project], [description], [start_date], [end_date], [source_resume_id]) VALUES
(
    @c2, 'Azure Cloud Landing Zone Program', 'Services Australia', 'Public Sector', 'Lead Cloud Engineer',
    'Designed and delivered an Azure landing zone following the Microsoft Cloud Adoption Framework for a 5,000-person federal agency. Built a hub-and-spoke network topology, implemented Azure Policy guardrails for PROTECTED classification, and automated provisioning via Terraform. Hosts 120+ workloads; reduced new environment provisioning from 6 weeks to 2 days.',
    '2024-01-15', NULL, @r2b
),
(
    @c2, 'Digital Banking Platform Migration', 'Westpac', 'Financial Services', 'Senior Cloud Engineer',
    'Migrated 45 microservices from on-premise VMs to Azure Kubernetes Service. Designed CI/CD pipelines in Azure DevOps with progressive delivery gates, implemented Helm charts for all services, and established observability via Azure Monitor and Application Insights. Achieved zero-downtime migration for all production services.',
    '2022-04-01', '2023-12-31', @r2a
),
(
    @c2, 'Infrastructure Automation Uplift', 'Transport for NSW', 'Public Sector', 'DevOps Engineer',
    'Replaced manual infrastructure provisioning with Terraform IaC across a 200-resource Azure environment. Established a GitOps workflow with Azure DevOps, reducing configuration drift incidents by 85% and enabling fully tested environment provisioning in under 30 minutes.',
    '2020-11-01', '2022-03-31', @r2a
);

-- Priya Sharma
INSERT INTO [dbo].[consultant_projects] ([consultant_id], [project_name], [client_name], [sector], [role_on_project], [description], [start_date], [end_date], [source_resume_id]) VALUES
(
    @c3, 'AI Document Processing Platform', 'Australian Taxation Office', 'Public Sector', 'Principal AI Engineer',
    'Led the design and delivery of an NLP-based document processing platform to automate classification and extraction of tax correspondence. Implemented fine-tuned transformer models on Azure Machine Learning, achieving 94% classification accuracy across 22 document types. Processes 2 million documents per year, reducing manual review effort by 65%.',
    '2024-03-01', NULL, @r3b
),
(
    @c3, 'Personalisation Recommendation Engine', 'Commonwealth Bank of Australia', 'Financial Services', 'Senior Data Scientist',
    'Built a real-time personalisation engine for CBA''s digital banking app serving 8 million active customers. Designed a two-tower neural network model trained on 18 months of behavioural data using Databricks and MLflow. Improved click-through rate on product recommendations by 34% and contributed to a 12% uplift in product cross-sell.',
    '2021-07-01', '2023-09-30', @r3a
),
(
    @c3, 'Responsible AI Governance Framework', 'Medibank', 'Financial Services', 'AI Ethics Lead',
    'Developed an enterprise Responsible AI governance framework for a major health insurer, covering model risk management, fairness assessment, and transparency. Delivered model card templates, a bias audit methodology, and a model registry on Azure ML. Trained 35 data scientists in responsible AI practices.',
    '2020-01-01', '2021-06-30', @r3a
);

-- Michael Torres
INSERT INTO [dbo].[consultant_projects] ([consultant_id], [project_name], [client_name], [sector], [role_on_project], [description], [start_date], [end_date], [source_resume_id]) VALUES
(
    @c4, 'Enterprise CRM Transformation', 'Queensland Health', 'Public Sector', 'Senior Project Manager',
    'Managed a $22 million CRM implementation across 16 hospital and health services, replacing a legacy patient engagement system with Salesforce Health Cloud. Coordinated 7 delivery workstreams, managed 4 vendor contracts, and led change management for 2,400 staff. Delivered on time and 3% under budget.',
    '2022-06-01', '2024-05-31', @r4b
),
(
    @c4, 'ICT Strategy and Transformation Program', 'Department of Transport and Main Roads', 'Public Sector', 'Program Manager',
    'Led a three-year ICT transformation to modernise the department''s application portfolio and migrate 80% of workloads to Azure. Established a PMO, governed a $45 million program budget, and managed relationships with the Minister''s office and six executive sponsors. Achieved a 30% reduction in ICT operational costs.',
    '2019-03-01', '2022-05-31', @r4a
),
(
    @c4, 'Program Recovery — Grants Management System', 'City of Brisbane', 'Public Sector', 'Recovery Project Manager',
    'Brought in to recover an $8 million grants management system that was 14 months behind schedule and $2.1 million over budget. Conducted root cause analysis, renegotiated vendor contracts, restructured the delivery team, and implemented a recovery schedule. Delivered the system 5 months later with no further cost overrun.',
    '2018-01-01', '2019-02-28', @r4a
);

-- Emma Blackwood
INSERT INTO [dbo].[consultant_projects] ([consultant_id], [project_name], [client_name], [sector], [role_on_project], [description], [start_date], [end_date], [source_resume_id]) VALUES
(
    @c5, 'Zero Trust Security Architecture', 'Department of Home Affairs', 'Public Sector', 'Lead Security Architect',
    'Designed and led the implementation of a zero trust architecture for a federal security agency handling PROTECTED-classified information. Implemented Azure AD Conditional Access, Privileged Identity Management, and Microsoft Defender for Endpoint across 8,000 endpoints. Conducted IRAP assessment against ISM controls and achieved Authority to Operate for three mission-critical systems.',
    '2023-07-01', NULL, @r5b
),
(
    @c5, 'Security Operations Centre Platform', 'Australian Signals Directorate', 'Public Sector', 'Security Architect',
    'Designed the technical architecture for a new SOC platform using Microsoft Sentinel as the core SIEM. Built custom analytics rules, SOAR playbooks, and connectors for 40+ data sources. Developed detection content aligned to MITRE ATT&CK, achieving coverage of 78% of relevant techniques. Platform monitors over 2 billion security events per day.',
    '2021-02-01', '2023-06-30', @r5a
),
(
    @c5, 'Essential Eight Uplift Program', 'Department of Education', 'Public Sector', 'Cyber Security Consultant',
    'Assessed Essential Eight maturity across 12,000 endpoints and 280 systems, identifying gaps against Maturity Level 2 targets. Delivered a prioritised remediation roadmap and led technical implementation of application control, patching, and MFA controls. Uplifted Essential Eight maturity from Level 0 to Level 2 within 18 months.',
    '2019-06-01', '2021-01-31', @r5a
);

-- =============================================
-- EXTRACTION LOG (one entry per resume processed)
-- =============================================
INSERT INTO [dbo].[extraction_log] ([consultant_id], [resume_id], [status], [extraction_version], [error_message], [tokens_used], [duration_ms], [executed_at]) VALUES
(@c1, @r1a, 'success', 2, NULL, 4820,  8341,  '2025-09-10T10:04:22'),
(@c1, @r1b, 'success', 3, NULL, 5110,  9203,  '2025-11-15T09:05:11'),
(@c2, @r2a, 'success', 2, NULL, 4650,  7988,  '2025-08-05T13:34:58'),
(@c2, @r2b, 'success', 3, NULL, 5340,  9712,  '2025-10-22T14:06:02'),
(@c3, @r3a, 'success', 2, NULL, 5890,  10234, '2025-10-01T09:19:44'),
(@c3, @r3b, 'success', 3, NULL, 6120,  11089, '2025-12-01T11:04:50'),
(@c4, @r4a, 'success', 2, NULL, 4230,  7541,  '2025-06-12T11:04:15'),
(@c4, @r4b, 'success', 3, NULL, 4580,  8102,  '2025-09-18T08:35:22'),
(@c5, @r5a, 'success', 2, NULL, 5020,  8876,  '2025-07-20T10:35:08'),
(@c5, @r5b, 'success', 3, NULL, 5780,  10451, '2025-08-30T16:05:33');

-- =============================================
-- Verification — expected row counts:
--   Consultants: 5  |  Resumes: 10  |  Skills: 50
--   Certifications: 19  |  Projects: 15  |  Log: 10
-- =============================================
SELECT [Table], [Rows] FROM (
    SELECT 'Consultants'    AS [Table], COUNT(*) AS [Rows] FROM [dbo].[consultants]
    UNION ALL
    SELECT 'Resumes',        COUNT(*) FROM [dbo].[consultant_resumes]
    UNION ALL
    SELECT 'Skills',         COUNT(*) FROM [dbo].[consultant_skills]
    UNION ALL
    SELECT 'Certifications', COUNT(*) FROM [dbo].[consultant_certifications]
    UNION ALL
    SELECT 'Projects',       COUNT(*) FROM [dbo].[consultant_projects]
    UNION ALL
    SELECT 'Extraction Log', COUNT(*) FROM [dbo].[extraction_log]
) AS counts
ORDER BY [Table];
