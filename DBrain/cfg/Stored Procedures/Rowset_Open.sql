CREATE procedure [cfg].[Rowset_Open]
	@Server [sysname],
	@Database [sysname],
	@Query nvarchar(max),
	@Print bit = null
as
begin

	set nocount on

	set @Print = isnull(@Print, 0)

	declare @OpenRowset nvarchar(max)

	set @OpenRowset = concat('select x.* from openrowset (''sqlncli'',''server=', @Server, ';database=',@Database,';trusted_connection=yes;'',N''', @Query, ''') as x')

	if @Print = 0
		exec ( @OpenRowset )
	else
		print @OpenRowset 
end