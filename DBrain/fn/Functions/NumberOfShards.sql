
CREATE function [fn].[NumberOfShards]()
returns int
as 
begin

	return (
		select count(ShardId) 
		from cfg.Shard
	)
end
