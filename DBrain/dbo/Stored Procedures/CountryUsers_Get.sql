
CREATE procedure [dbo].[CountryUsers_Get] @DateFrom datetime = null, @DateTo datetime = null
as
begin

	set nocount on

	declare @DataTable table (
		DatabaseName sysname,
		CountryId smallint,
		Users int
	)

	declare	
		@OuterQuery nvarchar(max),
		@InnerQuery nvarchar(max) = concat('	
			select CountryId, count(LocalUserId) as Users 
			from LocalUser 
			where CreatedDate >= ''''', fn.DateTimeStr(@DateFrom), ''''' and CreatedDate < ''''', fn.DateTimeStr(@DateTo), '''''
			group by CountryId'),
		@Server sysname,
		@Shard sysname

	declare FanOut cursor for
	select [Server], Name
	from config.Shard

	open FanOut

	fetch next from FanOut into @Server, @Shard

	while @@fetch_status = 0
	begin

		set @OuterQuery = concat('
		select ''', @Shard, ''' as DatabaseName, CountryId, Users
		from openrowset (
		''SQLNCLI'',
		''server=', isnull(@Server, 'ATOM'),';database=', @Shard, ';trusted_connection=yes;'',
		''', @InnerQuery, '''	
		)')
	
		print @OuterQuery

		insert @DataTable (DatabaseName, CountryId, Users)
		exec sp_executesql @OuterQuery

		fetch next from FanOut into @Server, @Shard

	end

	close FanOut
	deallocate FanOut

	select CountryId, sum(Users) as Users
	from @DataTable
	group by CountryId

end

