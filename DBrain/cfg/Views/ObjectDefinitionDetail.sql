



CREATE view [cfg].[ObjectDefinitionDetail]
as

select 
	od.Name as ObjectName,
	o.type_desc as [Type],
	s.Name as ShardName, 
	s.[Server],
	s.IP,
	s.Port,
	od.ShardKeyColumns,
	isnull(so.Rows, 0) as Rows,
	so.TableSizeKB,
	so.LowerBoundDat,
	so.UpperBoundDat,
	so.LowerBoundInt,
	so.UpperBoundInt,
	so.LowerBoundStr,
	so.UpperBoundStr
from cfg.ShardObject so 
	join cfg.ObjectDefinition od on od.ObjectDefinitionId = so.ObjectDefinitionId
	join cfg.Shard s on s.ShardId = so.ShardId
	join sys.objects o on object_id(od.Name) = o.object_id
	



