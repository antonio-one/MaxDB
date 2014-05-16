CREATE procedure cfg.TableSize_Update 
as
begin

	set nocount on

	declare @Server sysname, @ShardName sysname, @TableName sysname, @Query nvarchar(max)

	declare @TableCursor table (Name sysname)

	declare @ShardTableSize table (ShardName sysname, TableName sysname, SizeInKB int, Rows int)

	declare ShardCursor cursor for
	select Server, Name 
	from cfg.Shard

	open ShardCursor 

	fetch next from ShardCursor into @Server, @ShardName

	while @@fetch_status = 0
	begin
	
		delete @TableCursor 
		insert @TableCursor (Name) 
		exec cfg.Rowset_Open @Server, @ShardName, 'select name from sys.tables'

		declare TableCursor cursor for
		select Name 
		from @TableCursor

		open TableCursor 

		fetch next from TableCursor into @TableName

		while @@fetch_status = 0
		begin
			
			set @Query = concat('
			select ''''', @ShardName ,''''',''''', @TableName, ''''' as Name, sum(a.total_pages) * 8 as SizeInKB, p.Rows
			from sys.tables t
			inner join sys.schemas s on s.schema_id = t.schema_id
			inner join sys.indexes i on t.object_id = i.object_id
			inner join sys.partitions p on i.object_id = p.object_id AND i.index_id = p.index_id
			inner join sys.allocation_units a on p.partition_id = a.container_id
			where t.NAME = ''''', @TableName, '''''
			group by t.Name, s.Name, p.Rows
			order by s.Name, t.Name')

			insert @ShardTableSize
			exec cfg.Rowset_Open @Server, @ShardName, @Query 

			fetch next from TableCursor into @TableName

		end

		close TableCursor
		deallocate TableCursor

		fetch next from ShardCursor into @Server, @ShardName

	end

	close ShardCursor 

	deallocate ShardCursor 	

	;with _ShardTableSize as (
		select 
			( select ShardId from cfg.Shard where name = sts.ShardName ) as ShardId,
			( select ObjectDefinitionId from cfg.ObjectDefinition where name = sts.TableName ) as ObjectDefinitionId,
			sts.SizeInKB,
			sts.Rows
		from @ShardTableSize sts 
	)

	update so
	set so.TableSizeKB = sts.SizeInKB, so.Rows = sts.Rows
	from cfg.ShardObject so 
		join _ShardTableSize sts 
			on so.ShardId = sts.ShardId and so.ObjectDefinitionId = sts.ObjectDefinitionId
end