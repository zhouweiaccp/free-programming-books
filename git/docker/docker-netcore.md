docker pull  microsoft/dotnet 
docker run -it  microsoft/dotnet

FROM microsoft/dotnet:latest
WORKDIR /app
COPY bin/release/netcoreapp2.0/publish .
ENV ASPNETCORE_URLS http://0.0.0.0:80
ENTRYPOINT ["dotnet", "test1.dll"]

docker build -t test1image .
docker run -p 8080:80 --name test1c1 test1image





----------SQL Server 2017 Linux 容器映像  (https://docs.microsoft.com/zh-cn/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&pivots=cs1-bash)
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz2WSX'  -p 1433:1433 --name sql1  -d mcr.microsoft.com/mssql/server:2017-latest
docker exec -it sql1 "bash"
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P '1qaz2WSX'

netcore 镜像
https://github.com/dotnet/dotnet-docker
https://hub.docker.com/_/microsoft-dotnet-core

https://github.com/Microsoft/dotnet-framework-docker
https://github.com/dotnet/dotnet-docker/tree/master/samples



好的docker 资源
http://dockerfile.github.io/#/ubuntu