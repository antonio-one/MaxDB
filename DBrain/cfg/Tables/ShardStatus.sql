CREATE TABLE [cfg].[ShardStatus] (
    [ShardStatusId] SMALLINT  IDENTITY (1, 1) NOT NULL,
    [Name]          [sysname] NOT NULL,
    CONSTRAINT [PK_ShardStatus] PRIMARY KEY CLUSTERED ([ShardStatusId] ASC)
);

