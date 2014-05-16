CREATE TABLE [dbo].[LocalUser] (
    [LocalUserId]    BIGINT           IDENTITY (1, 1) NOT NULL,
    [GlobalUserId]   UNIQUEIDENTIFIER CONSTRAINT [DF_LocalUser_GlobalUserId] DEFAULT (newid()) NOT NULL,
    [DateCreated]    DATETIME         CONSTRAINT [DF_LocalUser_DateCreated] DEFAULT (getutcdate()) NOT NULL,
    [Username]       NVARCHAR (128)   NOT NULL,
    [Email]          NVARCHAR (128)   NOT NULL,
    [Pwd]            NVARCHAR (128)   NOT NULL,
    [RegistrationIP] VARCHAR (15)     NOT NULL,
    [CountryId]      SMALLINT         NOT NULL,
    CONSTRAINT [PK_LocalUser] PRIMARY KEY CLUSTERED ([LocalUserId] ASC)
);

