CREATE TABLE [cfg].[ObjectDefinition] (
    [ObjectDefinitionId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]               [sysname]      NOT NULL,
    [StaticData]         BIT            NULL,
    [Sharded]            BIT            CONSTRAINT [DF_ObjectDefinition_Sharded] DEFAULT ((0)) NOT NULL,
    [ShardKeyColumns]    VARCHAR (4000) NULL,
    [ShardMethodId]      SMALLINT       CONSTRAINT [DF__ObjectDef__Shard__6EF57B66] DEFAULT ((0)) NOT NULL,
    [ShardStatusId]      SMALLINT       CONSTRAINT [DF_ObjectDefinition_ShardStatusId] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ObjectDefinition] PRIMARY KEY NONCLUSTERED ([ObjectDefinitionId] ASC),
    CONSTRAINT [FK_ObjectDefinition_ShardMethodId] FOREIGN KEY ([ShardMethodId]) REFERENCES [cfg].[ShardMethod] ([ShardMethodId])
);




GO
CREATE UNIQUE CLUSTERED INDEX [UCIX_ObjectDefinition_Name]
    ON [cfg].[ObjectDefinition]([Name] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'Purpose', @value = N'Contains database table catalogue high level information', @level0type = N'SCHEMA', @level0name = N'cfg', @level1type = N'TABLE', @level1name = N'ObjectDefinition';

