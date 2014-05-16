CREATE TABLE [cfg].[Shard] (
    [ShardId]    INT             IDENTITY (1, 1) NOT NULL,
    [Name]       [sysname]       NOT NULL,
    [Server]     [sysname]       NULL,
    [Alias]      [sysname]       NULL,
    [IP]         VARCHAR (15)    NULL,
    [Port]       INT             NULL,
    [UserCrypto] VARBINARY (MAX) NULL,
    [PassCrypto] VARBINARY (MAX) NULL,
    [SizeInKB]   INT             DEFAULT ((0)) NOT NULL,
    [Updated]    DATETIME        NULL,
    CONSTRAINT [PK_Shard] PRIMARY KEY CLUSTERED ([ShardId] ASC)
);






GO
create trigger cfg.ShardUpdateTrigger 
on cfg.Shard 
after update
as
begin
	
	update cfg.Shard 
	set Updated = getutcdate()
	where ShardId in ( select ShardId from inserted )

end