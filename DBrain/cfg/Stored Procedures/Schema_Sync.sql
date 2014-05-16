
CREATE procedure [cfg].[Schema_Sync] 
	@SchemaTable sysname, 
	@PrintOnly bit = 0
as
/*
	this version is dropping and re-creating the target table
	no data is saved
*/
begin

	set nocount on

	declare @DDL table (
		Query varchar(4000), 
		QueryNoCRLF as replace(replace(Query, CHAR(13) + CHAR(10), ' '), char(9), ' ')
	)

	insert into @DDL (Query)
	exec sp_getddl @SchemaTable

	declare	
		@Query varchar(max),
		@Server sysname,
		@ShardName sysname

	select @Query = concat (
		'
		if object_id(''', @SchemaTable,''') is not null 
		begin 
			drop table ', @SchemaTable, ' 
		end

		', QueryNoCRLF)
	from @DDL 

	declare FanOut cursor for
	select [Server], Name
	from cfg.Shard

	open FanOut

	fetch next from FanOut into @Server, @ShardName

	while @@fetch_status = 0
	begin

		if @PrintOnly = 0
		begin
			exec cfg.SqlCommand_Execute @Server, @ShardName, @Query
			print concat(@Server, char(13), @ShardName, char(13), @Query, char(13))
		end
		else
		begin
			print concat(@Server, char(13), @ShardName, char(13), @Query, char(13))
		end

		fetch next from FanOut into @Server, @ShardName

	end

	close FanOut
	deallocate FanOut

end


