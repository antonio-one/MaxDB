CREATE TABLE [cfg].[ShardMethod] (
    [ShardMethodId] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (128) NOT NULL,
    [Position]      VARCHAR (128) NULL,
    [Length]        INT           NULL,
    [Reversed]      BIT           NULL,
    PRIMARY KEY CLUSTERED ([ShardMethodId] ASC)
);

