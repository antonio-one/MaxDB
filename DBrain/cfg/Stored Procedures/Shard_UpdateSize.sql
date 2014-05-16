CREATE procedure cfg.[Shard_UpdateSize]
as
begin

	set nocount on

	declare @Server sysname, @Database sysname, @Query nvarchar(max)

	declare @ShardSize table (Name sysname, SizeInKB int)

	declare ShardCursor cursor for
	select Server, Name 
	from cfg.Shard

	open ShardCursor 

	fetch next from ShardCursor into @Server, @Database

	while @@fetch_status = 0
	begin
	
		set @Query = concat('
			select ''''', @Database, ''''' as [Database], cast(sum(size) * 8. as decimal(8,2)) as SizeInKB 
			from sys.master_files with(nowait) 
			where database_id = db_id(''''', @Database, ''''')')
	
		insert @ShardSize
		exec cfg.Rowset_Open @Server, @Database, @Query 

		fetch next from ShardCursor into @Server, @Database

	end

	close ShardCursor 

	deallocate ShardCursor 

	update s1
	set s1.SizeInKB = s2.SizeInKB 
	from cfg.Shard s1 
		join @ShardSize s2
			on s1.Name = s2.Name		

end