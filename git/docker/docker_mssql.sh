


## Windows10下Docker安装SQL Server启动失败解决方案
经过查阅资料发现，原来在Windows环境下，其中两个参数需要使用双引号，而不是单引号，正确的启动容器命令如下
https://github.com/Microsoft/mssql-docker/issues/20#issuecomment-273783368




1.下载镜像
docker pull microsoft/mssql-server-linux
使用该命令就可以把数据库的docker镜像下载下来。

2.创建并运行容器
docker run --name MSSQL_1433 -m 512m -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz2WSX' -p 1433:1433 -d microsoft/mssql-server-linux
这个密码需要复杂密码，要有大小写和特殊符号，替换1qaz2WSX成你自己的密码就行。如果只Linux服务器，可以不用端口映射，直接使用宿主模式

docker run --name MSSQL_1433 -m 512m -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz2WSX' --net=host -d microsoft/mssql-server-linux
3.登入容器
docker exec -it MSSQL_1433 /bin/bash
4.连接到sqlcmd
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P '1qaz2WSX'
5.执行SQL语句创建数据库
CREATE DATABASE testDB
go
如果只想创建数据库，已经可以完成了，用Navicat Premium就可以连接到数据库了。

6.还原数据库
在容器内先创建一个文件夹

mkdir /var/opt/mssql/backup
在宿主把.bak备份文件复制到容器

sudo docker cp /Users/front/Downloads/beifen.bak MSSQL_1433:/var/opt/mssql/backup
运行sqlcmd到逻辑文件名称和备份内的路径的列表容器内

sudo docker exec -it MSSQL_1433 /opt/mssql-tools/bin/sqlcmd -S localhost  -U SA -P '1qaz2WSX'  -Q 'RESTORE FILELISTONLY FROM DISK =  "/var/opt/mssql/backup/beifen.bak"'  | tr -s ' ' | cut -d ' ' -f 1-2
运行结果

LogicalName PhysicalName
----------------------------------
beifen D:\Program
beifen_log D:\Program
还原数据库













# https://hub.docker.com/_/microsoft-mssql-server  https://github.com/Microsoft/mssql-docker
# mcr.microsoft.com/mssql/server:2019-CU6-ubuntu-16.04

# About this Image
# Official container images for Microsoft SQL Server on Linux for Docker Engine.

# How to use this Image
# Start a mssql-server instance using the CU8 release IMPORTANT NOTE: If you are using PowerShell on Windows to run these commands use double quotes instead of single quotes.

# docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz2WSX' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-CU8-ubuntu
# Start a mssql-server instance using the latest update for SQL Server 2017

# docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz2WSX' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest
# Start a mssql-server instance running as the SQL Express edition

# docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz2WSX' -e 'MSSQL_PID=Express' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu 
# Connect to Microsoft SQL Server You can connect to the SQL Server using the sqlcmd tool inside of the container by using the following command on the host:

# docker exec -it <container_id|container_name> /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P <your_password>
# You can also use the tools in an entrypoint.sh script to do things like create databases or logins, attach databases, import data, or other setup tasks. See this example of using an entrypoint.sh script to create a database and schema and bcp in some data.

# You can connect to the SQL Server instance in the container from outside the container by using various command line and GUI tools on the host or remote computers. See the Connect and Query topic in the SQL Server on Linux documentation.