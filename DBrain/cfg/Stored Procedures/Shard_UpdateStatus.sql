
CREATE procedure [cfg].[Shard_UpdateStatus] @ShardStatusId smallint
as
begin
	--update this later to do stuff for individual tables
	if @ShardStatusId not in ( select ShardStatusId from config.ShardStatus )
	begin
		;throw 50000, 'Incorrect @ShardStatusId parameter value', 1
	end

	else
	begin
		update config.ObjectDefinition
		set ShardStatusId = @ShardStatusId
	end

end