镜像地址
https://github.com/Microsoft/aspnet-docker
https://github.com/dotnet/dotnet-docker    netcore

https://hub.docker.com/_/microsoft-dotnet-core-runtime/
https://github.com/dotnet/dotnet-docker/blob/master/2.2/runtime/bionic/amd64/Dockerfile
https://github.com/dotnet/dotnet-docker/blob/master/2.2/runtime/stretch-slim/amd64/Dockerfile


https://docs.microsoft.com/zh-cn/dotnet/core/tools/dotnet-new?tabs=netcore21

https://docs.microsoft.com/zh-cn/dotnet/core/versions/
https://docs.microsoft.com/zh-cn/dotnet/core/versions/selection
.NET Core 项目指定SDK版本
自从 .NET Core 2.1.0版本发布以后，近几个月微软又进行了几次小版本的发布，可见 .NET Core 是一门生命力非常活跃的技术。经过一段时间的实践，目前做 ASP.NET Core 开发时，使用的 Nuget 包，比如 Microsoft.AspNetCore.App等的版本号要与 .NET Core 版本号（不是SDK版本号，后续说明）保持一致，否则编译的时候可能会出现一些稀奇古怪的错误，比如 Microsoft.AspNetCore.App 2.1.0版本对应 .NET Core 2.1.0版本，这可谓是一个坑。

二. 版本对照
.NET Core 版本	SDK 版本	Runtime 版本
2.1.2	2.1.400	2.1.2
2.1.2	2.1.302	2.1.2
2.1.1	2.1.301	2.1.1
2.1.0	2.1.300	2.10
在项目的根目录打开cmd，执行命令即可：

dotnet new global.json --sdk-version <SDK版本号>
dotnet new global.json --sdk-version 2.1.300
dotnet new global.json --sdk-version 2.2.101  --force
netcore跟SDK及runtime对照表：
https://dotnet.microsoft.com/download/dotnet-core/2.2
https://dotnet.microsoft.com/download/dotnet-core/2.1
https://dotnet.microsoft.com/download/dotnet-core/3.0

https://docs.microsoft.com/zh-cn/dotnet/core/tools/dotnet-add-package
dotnet new console
dotnet add  logdemo.csproj package NLog
dotnet add ToDo.csproj package Microsoft.Azure.DocumentDB.Core -v 1.0.0

添加项目引用：
dotnet add app/app.csproj reference lib/lib.csproj
向当前目录中的项目添加多个项目引用：
dotnet add reference lib1/lib1.csproj lib2/lib2.csproj


https://docs.microsoft.com/zh-cn/dotnet/standard/frameworks   目标框架  netcoreapp2.2
https://docs.microsoft.com/zh-cn/dotnet/core/rid-catalog  NET Core RID 目录
dotnet clean --configuration Debug
dotnet publish -c Release -o obj/Docker/publish --framework netcoreapp2.2 --runtime win10-x64 --self-contained true test1.csproj


##createdump 内存分析
/usr/share/dotnet/shared/Microsoft.NETCore.App/2.2.4/createdump -u -f 