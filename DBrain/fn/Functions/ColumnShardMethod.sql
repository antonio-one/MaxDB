CREATE function [fn].[ColumnShardMethod] (@ObjectName sysname, @Columns varchar(4000))
returns @dtsm table (
	ColumnName sysname,
	DataType sysname,
	MaxLength int,
	Precision int,
	ShardBy sysname
)
as
begin

	insert @dtsm
	select 
		c.name as ColumnName, 
		t.name as DataType, 
		t.max_length as MaxLength, 
		t.Precision,
		case	
			when t.system_type_id in (48,52,56,59,60,62,106,108,122,127) then 'integer'
			when t.system_type_id in (167,175,231,239) then 'string'
			when t.system_type_id in (40,42,43,58,61,189) then 'date'
			when t.system_type_id = 41 then 'time'
			when t.system_type_id = 36 then 'guid'
		else 'Not Supported'
		end as Method
	from sys.columns c 
		join sys.types t on c.user_type_id = t.user_type_id
	where c.name in (select StringValue from fn.StringToList(@Columns,','))
		and object_id = object_id(@ObjectName)

	return

end