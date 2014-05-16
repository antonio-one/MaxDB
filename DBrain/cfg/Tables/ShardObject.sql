CREATE TABLE [cfg].[ShardObject] (
    [ShardObjectId]      INT            IDENTITY (1, 1) NOT NULL,
    [ShardId]            INT            NOT NULL,
    [ObjectDefinitionId] INT            NOT NULL,
    [ShardKeyColumns]    VARCHAR (4000) NULL,
    [TableSizeKB]        BIGINT         NULL,
    [TableSizeMB]        AS             ([TableSizeKB]/(1024)),
    [TableSizeGB]        AS             (([TableSizeKB]/(1024))/(1024)),
    [Rows]               BIGINT         NULL,
    [LowerBoundInt]      BIGINT         NULL,
    [UpperBoundInt]      BIGINT         NULL,
    [LowerBoundStr]      VARCHAR (128)  NULL,
    [UpperBoundStr]      VARCHAR (128)  NULL,
    [LowerBoundDat]      DATETIME       NULL,
    [UpperBoundDat]      DATETIME       NULL,
    [DateCreated]        DATETIME       NULL,
    [DateUpdated]        DATETIME       NULL,
    CONSTRAINT [PK_ShardObject] PRIMARY KEY NONCLUSTERED ([ShardObjectId] ASC),
    CONSTRAINT [FK_ShardObject_ObjectDefinitionId] FOREIGN KEY ([ObjectDefinitionId]) REFERENCES [cfg].[ObjectDefinition] ([ObjectDefinitionId]),
    CONSTRAINT [FK_ShardObject_ShardId] FOREIGN KEY ([ShardId]) REFERENCES [cfg].[Shard] ([ShardId])
);




GO
CREATE UNIQUE CLUSTERED INDEX [UCIX_ShardFunction_ShardId_ObjectDefinitionId]
    ON [cfg].[ShardObject]([ShardId] ASC, [ObjectDefinitionId] ASC);

