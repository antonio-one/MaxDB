
create view [cfg].[SchemaVersion]
as
select
	row_number() over (order by Value) as SchemaVersionId,
	convert(date, left(convert(varchar(128), Value), 8)) as DateCreated,
	Name as Release,
	parsename(Name,1) as Sequence,
	Value
	from sys.extended_properties
	where class_desc = 'DATABASE'

