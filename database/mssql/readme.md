
https://github.com/SqlAdmin/AwesomeSQLServer 性能计数  cpu mem disk
https://github.com/SqlAdmin/  比较 table row index object


##MSSQL]帐户当前被锁定,所以用户 sa 登录失败。系统管理员无法将该帐户解锁 解决方法
ALTER LOGIN sa ENABLE ;
GO
ALTER LOGIN sa WITH PASSWORD = 'password' unlock, check_policy = off,
check_expiration = off ;
GO



## 主键插入IDENTITY
CREATE TABLE Orders(
OrderID    INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
PriceDate DateTime
)
SET IDENTITY_INSERT Orders ON
INSERT INTO Orders (OrderID ,PriceDate ) VALUES(1,GETDATE())
SET IDENTITY_INSERT Orders OFF

## 帮助文档
- [sp_datatype_info](https://docs.microsoft.com/zh-cn/sql/relational-databases/system-stored-procedures/sp-datatype-info-transact-sql?view=sql-server-ver15#examples)  EXEC sp_datatype_info
- [sp_help]()EXEC sp_help;    exec sp_help @objname='Sys_PositionList'
- []()
- []()
- []()
- []()
## 客户端下载
[](https://download.microsoft.com/download/f/e/b/feb0e6be-21ce-4f98-abee-d74065e32d0a/SSMS-Setup-CHS.exe)