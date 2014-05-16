CREATE PROCEDURE [cfg].[SqlCommand_Execute]
@Server [sysname], @Database [sysname], @Query NVARCHAR (MAX)
AS EXTERNAL NAME [CLR].[StoredProcedures].[SqlCommand_Execute]



