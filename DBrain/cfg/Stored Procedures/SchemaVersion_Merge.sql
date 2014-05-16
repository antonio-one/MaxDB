
create procedure [cfg].[SchemaVersion_Merge] @Release sysname, @Script sysname, @Operation char(1)
as
begin

if @Operation in ('I','U','M')

begin

if not exists ( select name from sys.extended_properties where name = @Release )

begin

exec sp_addextendedproperty @name = @Release, @value = @Script

end

else

begin

exec sp_updateextendedproperty @name = @Release, @value = @Script

end

end

else if @Operation = 'D'

begin

if exists ( select name from sys.extended_properties where name = @Release )

begin

exec sp_dropextendedproperty @name = @Release

end

end

else

begin

;throw 50000, 'incorrect @Operation parameter value', 1

end

end

