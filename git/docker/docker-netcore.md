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
 docker pull mcr.microsoft.com/mssql/server:2017-latest
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=<YourStrong!Passw0rd>' \
   -p 1433:1433 --name sql1 \
   -d mcr.microsoft.com/mssql/server:2017-latest



