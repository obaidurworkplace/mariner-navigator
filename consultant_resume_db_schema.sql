-- =============================================
-- Section 1: Database-Level Change Tracking
-- =============================================
USE [db-mpi-navigator];
GO
ALTER DATABASE [db-mpi-navigator]
    SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON);
GO

-- =============================================
-- Section 2: Tables
-- =============================================
CREATE TABLE [consultants] (
    [consultant_id]         INT IDENTITY(1,1)  NOT NULL,
    [external_id]           NVARCHAR(100)      NULL,
    [first_name]            NVARCHAR(100)      NOT NULL,
    [last_name]             NVARCHAR(100)      NOT NULL,
    [email]                 NVARCHAR(255)      NULL,
    [role_title]            NVARCHAR(200)      NOT NULL,
    [seniority_level]       NVARCHAR(50)       NULL
        CONSTRAINT [CK_consultants_seniority_level] CHECK ([seniority_level] IN ('Junior', 'Intermediate', 'Senior', 'Lead', 'Principal') OR [seniority_level] IS NULL),
    [employment_type]       NVARCHAR(30)       NOT NULL
        CONSTRAINT [CK_consultants_employment_type] CHECK ([employment_type] IN ('Employee', 'Contractor', 'IC')),
    [region]                NVARCHAR(100)      NULL,
    [city]                  NVARCHAR(100)      NULL,
    [security_clearance]    NVARCHAR(100)      NULL,
    [bill_rate]             DECIMAL(10,2)      NULL,
    [experience_start_date] DATE               NULL,
    [availability_status]   NVARCHAR(30)       NOT NULL
        CONSTRAINT [CK_consultants_availability_status] CHECK ([availability_status] IN ('Available', 'Allocated', 'Partial', 'On Leave')),
    [available_from]        DATE               NULL,
    [profile_text]          NVARCHAR(MAX)      NOT NULL,
    [profile_text_source]   NVARCHAR(500)      NULL,
    [extraction_version]    INT                NOT NULL,
    [last_extracted_at]     DATETIME2          NOT NULL,
    [created_at]            DATETIME2          NOT NULL
        CONSTRAINT [DF_consultants_created_at] DEFAULT GETUTCDATE(),
    [updated_at]            DATETIME2          NOT NULL
        CONSTRAINT [DF_consultants_updated_at] DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_consultants] PRIMARY KEY CLUSTERED ([consultant_id])
);
GO

CREATE TABLE [consultant_resumes] (
    [resume_id]           INT IDENTITY(1,1)  NOT NULL,
    [consultant_id]       INT                NOT NULL,
    -- NVARCHAR(450) = 900 bytes, the maximum allowed for a non-clustered index key (NVARCHAR(500) exceeds it).
    [sharepoint_path]     NVARCHAR(450)      NOT NULL,
    [resume_type]         NVARCHAR(50)       NOT NULL
        CONSTRAINT [CK_resumes_resume_type] CHECK ([resume_type] IN ('General', 'Tailored', 'Proposal')),
    [file_hash]           NVARCHAR(64)       NULL,
    [uploaded_at]         DATETIME2          NOT NULL
        CONSTRAINT [DF_resumes_uploaded_at] DEFAULT GETUTCDATE(),
    [processed_at]        DATETIME2          NULL,
    [extraction_version]  INT                NULL,
    [status]              NVARCHAR(30)       NOT NULL
        CONSTRAINT [DF_resumes_status] DEFAULT 'pending'
        CONSTRAINT [CK_resumes_status] CHECK ([status] IN ('pending', 'processing', 'success', 'failed')),
    CONSTRAINT [PK_consultant_resumes] PRIMARY KEY CLUSTERED ([resume_id])
);
GO

CREATE TABLE [consultant_skills] (
    [skill_id]            INT IDENTITY(1,1)  NOT NULL,
    [consultant_id]       INT                NOT NULL,
    [skill_name]          NVARCHAR(200)      NOT NULL,
    [skill_category]      NVARCHAR(100)      NULL,
    [proficiency]         NVARCHAR(30)       NULL
        CONSTRAINT [CK_skills_proficiency] CHECK ([proficiency] IN ('Beginner', 'Intermediate', 'Advanced', 'Expert') OR [proficiency] IS NULL),
    [source_resume_id]    INT                NULL,
    CONSTRAINT [PK_consultant_skills] PRIMARY KEY CLUSTERED ([skill_id])
);
GO

CREATE TABLE [consultant_certifications] (
    [certification_id]    INT IDENTITY(1,1)  NOT NULL,
    [consultant_id]       INT                NOT NULL,
    [certification_name]  NVARCHAR(300)      NOT NULL,
    [issuing_body]        NVARCHAR(200)      NULL,
    [date_obtained]       DATE               NULL,
    [expiry_date]         DATE               NULL,
    [source_resume_id]    INT                NULL,
    CONSTRAINT [PK_consultant_certifications] PRIMARY KEY CLUSTERED ([certification_id])
);
GO

CREATE TABLE [consultant_projects] (
    [project_id]          INT IDENTITY(1,1)  NOT NULL,
    [consultant_id]       INT                NOT NULL,
    [project_name]        NVARCHAR(300)      NOT NULL,
    [client_name]         NVARCHAR(200)      NULL,
    [sector]              NVARCHAR(100)      NULL,
    [role_on_project]     NVARCHAR(200)      NULL,
    [description]         NVARCHAR(MAX)      NULL,
    [start_date]          DATE               NULL,
    [end_date]            DATE               NULL,
    [source_resume_id]    INT                NULL,
    CONSTRAINT [PK_consultant_projects] PRIMARY KEY CLUSTERED ([project_id])
);
GO

CREATE TABLE [extraction_log] (
    [log_id]              INT IDENTITY(1,1)  NOT NULL,
    [consultant_id]       INT                NOT NULL,
    [resume_id]           INT                NULL,
    [status]              NVARCHAR(30)       NOT NULL
        CONSTRAINT [CK_log_status] CHECK ([status] IN ('success', 'failed', 'partial')),
    [extraction_version]  INT                NOT NULL,
    [error_message]       NVARCHAR(MAX)      NULL,
    [tokens_used]         INT                NULL,
    [duration_ms]         INT                NULL,
    [executed_at]         DATETIME2          NOT NULL
        CONSTRAINT [DF_log_executed_at] DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_extraction_log] PRIMARY KEY CLUSTERED ([log_id])
);
GO

-- =============================================
-- Section 3: Foreign Key Constraints
-- =============================================
ALTER TABLE [consultant_resumes]
    ADD CONSTRAINT [FK_resumes_consultant]
    FOREIGN KEY ([consultant_id]) REFERENCES [consultants] ([consultant_id]) ON DELETE CASCADE;

ALTER TABLE [consultant_skills]
    ADD CONSTRAINT [FK_skills_consultant]
    FOREIGN KEY ([consultant_id]) REFERENCES [consultants] ([consultant_id]) ON DELETE NO ACTION;

ALTER TABLE [consultant_certifications]
    ADD CONSTRAINT [FK_certs_consultant]
    FOREIGN KEY ([consultant_id]) REFERENCES [consultants] ([consultant_id]) ON DELETE NO ACTION;

ALTER TABLE [consultant_projects]
    ADD CONSTRAINT [FK_projects_consultant]
    FOREIGN KEY ([consultant_id]) REFERENCES [consultants] ([consultant_id]) ON DELETE NO ACTION;

ALTER TABLE [extraction_log]
    ADD CONSTRAINT [FK_log_consultant]
    FOREIGN KEY ([consultant_id]) REFERENCES [consultants] ([consultant_id]) ON DELETE CASCADE;

-- ON DELETE NO ACTION avoids SQL Server error 1785 (multiple cascade paths).
-- SET NULL behaviour when a resume is deleted is handled by TR_resumes_log_setnull below.
ALTER TABLE [extraction_log]
    ADD CONSTRAINT [FK_log_resume]
    FOREIGN KEY ([resume_id]) REFERENCES [consultant_resumes] ([resume_id]) ON DELETE NO ACTION;
GO

-- =============================================
-- Section 4: Indexes
-- =============================================
CREATE NONCLUSTERED INDEX [IX_consultants_availability]
    ON [consultants] ([availability_status], [available_from]);

CREATE NONCLUSTERED INDEX [IX_consultants_region]
    ON [consultants] ([region]);

CREATE NONCLUSTERED INDEX [IX_consultants_employment_type]
    ON [consultants] ([employment_type]);

CREATE NONCLUSTERED INDEX [IX_consultants_role_title]
    ON [consultants] ([role_title]);

CREATE NONCLUSTERED INDEX [IX_resumes_consultant_id]
    ON [consultant_resumes] ([consultant_id]);

CREATE UNIQUE NONCLUSTERED INDEX [UQ_resumes_sharepoint_path]
    ON [consultant_resumes] ([sharepoint_path]);

CREATE NONCLUSTERED INDEX [IX_skills_consultant_id]
    ON [consultant_skills] ([consultant_id]);

-- Case-insensitive uniqueness on skill_name is satisfied by the default Azure SQL collation SQL_Latin1_General_CP1_CI_AS.
CREATE UNIQUE NONCLUSTERED INDEX [UQ_skills_merge_key]
    ON [consultant_skills] ([consultant_id], [skill_name]);

CREATE NONCLUSTERED INDEX [IX_skills_name]
    ON [consultant_skills] ([skill_name]);

CREATE NONCLUSTERED INDEX [IX_certs_consultant_id]
    ON [consultant_certifications] ([consultant_id]);

CREATE NONCLUSTERED INDEX [IX_projects_consultant_id]
    ON [consultant_projects] ([consultant_id]);
GO

-- =============================================
-- Section 5: Triggers
-- =============================================
CREATE TRIGGER [TR_consultants_updated_at]
ON [consultants]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [consultants]
    SET [updated_at] = GETUTCDATE()
    FROM [consultants] c
    INNER JOIN inserted i ON c.[consultant_id] = i.[consultant_id];
END;
GO

-- Implements the SET NULL intent of FK_log_resume without triggering SQL Server error 1785.
-- When a resume row is deleted, nulls out extraction_log.resume_id for any log rows that referenced it.
CREATE TRIGGER [TR_resumes_log_setnull]
ON [consultant_resumes]
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [extraction_log]
    SET [resume_id] = NULL
    WHERE [resume_id] IN (SELECT [resume_id] FROM deleted);
END;
GO

-- =============================================
-- Section 6: Table-Level Change Tracking on consultants
-- =============================================
ALTER TABLE [consultants]
    ENABLE CHANGE_TRACKING
    WITH (TRACK_COLUMNS_UPDATED = OFF);
GO
