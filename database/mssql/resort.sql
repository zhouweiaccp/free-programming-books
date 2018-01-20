ALTER DATABASE [Macrowing.Organization]  SET OFFLINE WITH ROLLBACK IMMEDIATE
go
declare @filename varchar(50);
declare @datetime varchar(50);
declare @database varchar(400);
set @datetime =  convert(varchar(6),getdate(),112);
set @database='Macrowing.Organization'
set @filename='e:\212\'+@datetime+'_'+@database+'.bak'
print @filename


RESTORE DATABASE [Macrowing.Organization] FROM DISK=@filename with replace
go

ALTER database [Macrowing.Organization] set online
