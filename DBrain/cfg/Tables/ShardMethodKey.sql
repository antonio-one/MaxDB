CREATE TABLE [cfg].[ShardMethodKey] (
    [ShardMethodId] SMALLINT      NOT NULL,
    [Key]           VARCHAR (128) NOT NULL,
    CONSTRAINT [PK_KeyValue] PRIMARY KEY CLUSTERED ([ShardMethodId] ASC, [Key] ASC)
);

