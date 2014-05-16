
CREATE procedure [dbo].[LocalUser_Insert]
	@DateCreated datetime, 
	@Username nvarchar(128), 
	@Email nvarchar(128), 
	@Pwd nvarchar(128), 
	@RegistrationIP nvarchar(15)
as

begin

set nocount on

	declare @Query nvarchar(max) = concat('
	insert into LocalUser (DateCreated, Username, Email, Pwd, RegistrationIP)
	values (''', fn.DateTimeStr(@DateCreated), ''', ''', @Username, ''',''', @Email, ''',''', @Pwd, ''', ''', @RegistrationIP, ''')')

	print @Query

end



