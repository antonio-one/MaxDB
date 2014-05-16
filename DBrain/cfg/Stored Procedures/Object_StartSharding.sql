CREATE procedure [cfg].[Object_StartSharding]
	@ObjectName sysname, 
	@ShardKeyColumns varchar(4000)
as
begin

	set nocount on

	--Check table exists
	if not exists ( select top 1 1 from sys.tables where object_id = object_id(@ObjectName) )
	begin
		;throw 50000, 'Incorrect @ObjectName parameter value. Table does not exist.', 1	
	end

	--Check the column names exist 
	declare @ObjectValid table (Name sysname, Valid bit)
	
	insert @ObjectValid (
		Name,
		Valid
	)
	select 
		StringValue, 
		iif(StringValue = name, 1, 0) as Valid
	from fn.StringToList(@ShardKeyColumns, ',') as skc
		left join sys.columns c on skc.StringValue = c.name
	where c.object_id = object_id(@ObjectName) or skc.StringValue is not null

	if exists ( select top 1 1 from @ObjectValid where Valid = 0 )
	begin
		;throw 50000, 'Incorrect column name(s) in @ShardKeyColumns parameter.', 1		
	end

	--Now find out if sharding is already in progress
	else if ( select ShardStatusId from cfg.ObjectDefinition where name = @ObjectName ) != 1
	begin
		;throw 50000, 'You may not change the sharding key after it is set. Please delete and recreate object and then shard again.', 1
		return
	end

	else

	begin

		select @ObjectName as Name, @ShardKeyColumns as ShardKeyColumns 
		into #ObjectDefinition

		;merge cfg.ObjectDefinition as t
		using #ObjectDefinition as s
		on t.Name = s.Name
		when matched then
		update
		set t.ShardKeyColumns = s.ShardKeyColumns, t.ShardStatusId = 2
		when not matched then
		insert (Name, ShardKeyColumns, ShardStatusId)
		values (s.Name, s.ShardKeyColumns, 2);


		;merge cfg.ShardObject t
		using (
			select s.ShardId, od.ObjectDefinitionId, od.ShardKeyColumns, getutcdate() 
			from cfg.ObjectDefinition od cross apply cfg.Shard s
			where od.name = @ObjectName
		) as s (ShardId, ObjectDefinitionId, ShardKeyColumns, DateCreated)
		on s.ShardId = t.ShardId and s.ObjectDefinitionId = t.ObjectDefinitionId
		when matched then 
		update
		set 
			t.ShardKeyColumns = s.ShardKeyColumns,
			t.DateUpdated = getutcdate()
		when not matched then
		insert (ShardId, ObjectDefinitionId, ShardKeyColumns, DateCreated)
		values (ShardId, ObjectDefinitionId, ShardKeyColumns, DateCreated);

	end

end


