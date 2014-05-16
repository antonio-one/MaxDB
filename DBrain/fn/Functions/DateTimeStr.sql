
CREATE function [fn].[DateTimeStr] ( @DateTime datetime )
returns varchar(17)
as
begin
	return 
		concat(
			convert(char(8), isnull(@DateTime, getutcdate()), 112), ' ', convert(char(8), isnull(@DateTime, getutcdate()), 114)
		)


	end


