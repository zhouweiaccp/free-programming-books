##commandline
**[commandline] (https://github.com/commandlineparser/commandline)
* [CancellationTokenSource](https://github.com/dotnet/corefx/blob/release/2.2/src/System.Data.SqlClient/src/System/Data/SqlClient/SNI/SNITcpHandle.cs#L180)
* [SqlConnectionString](https://github.com/dotnet/corefx/blob/release/2.2/src/System.Data.SqlClient/src/System/Data/SqlClient/SqlConnectionString.cs#L35)

## 示例
- [practical-aspnetcore](git@github.com:dodyg/practical-aspnetcore.git)  
  - [ASP.NET-Core---Intermediate](https://channel9.msdn.com/Series/ASP.NET-Core---Intermediate) 官网视频站点
  - [aspnetcore](https://gitter.im/DotNetStudyGroup/aspnetcore) 聊天
  - [dotnet-api-docs](https://github.com/dotnet/dotnet-api-docs).net语言所有类库示例
- [dotnet-developer-projects](https://github.com/microsoft/dotnet/blob/master/dotnet-developer-projects.md#messaging)NET Open Source Developer Projects
- [ews-managed-api](https://github.com/OfficeDev/ews-managed-api/blob/master/README.md)
   - [how-to-set-the-ews-service-url-by-using-the-ews-managed-api](https://docs.microsoft.com/en-us/exchange/client-developer/exchange-web-services/how-to-set-the-ews-service-url-by-using-the-ews-managed-api) https://computername.domain.contoso.com/EWS/Exchange.asmx
   - [Exchange-2013-101-Code](http://code.msdn.microsoft.com/Exchange-2013-101-Code-3c38582c)
- [csharpcodi](https://www.csharpcodi.com/vs2/2258/osharp/src/OSharp.Core/Logging/DatabaseLoggerAdapter.cs/) 示例代码
- [csharpcodi](https://www.csharpcodi.com/csharp-examples/System.IServiceProvider.GetService()/)  示例代码
- [Migrate from ASP.NET Core 2.2 to 3.0](https://docs.microsoft.com/en-us/aspnet/core/migration/22-to-30?view=aspnetcore-3.0&tabs=visual-studio) Migrate from ASP.NET Core 2.2 to 3.0
-[older.Admin.AntdVue](https://gitee.com/Coldairarrow/Colder.Admin.AntdVue)Web后台快速开发框架,.NETCore3.1+Ant Design Vue版本





## 常见问题


### Thread Theft
https://stackexchange.github.io/StackExchange.Redis/ThreadTheft.html
https://www.cnblogs.com/dudu/p/6251266.html  又踩.NET Core的坑：在同步方法中调用异步方法Wait时发生死锁(deadlock)
<add key="aspnet:UseTaskFriendlySynchronizationContext" value="true" />
这告诉ASP.NET使用全新的异步管道，它遵循CLR约定来启动异步操作，包括在必要时将线程返回到ThreadPool。ASP.NET 4.0及其以下版本遵循自己的约定，违背了CLR原则，如果交换机未启用，则    异步方法非常容易同步运行，死锁请求或以其他方式不按预期运行。

### 短网址

 -[aspnetcore-url-shortener]()  ![aspnetcore-url-shortener](GenerateShortURL.cs)

