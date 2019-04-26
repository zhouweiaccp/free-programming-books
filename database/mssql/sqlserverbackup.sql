declare @device varchar(30);
declare @filename varchar(50);
declare @datetime varchar(50);
declare @database varchar(400);
 set @datetime =  convert(varchar(6),getdate(),112);
set @database='Macrowing.Organization'
set @filename='e:\212\'+@datetime+'_'+@database+'.bak'

begin
backup database @database to disk=@filename --with differential
--EXEC sp_addumpdevice 'disk', 'mybackupdisk', @filename ;

--删除磁盘备份设备
--EXEC sp_dropdevice 'mybackupdisk', 'delfile' ;
end
--select * from  sys.backup_devices;
 