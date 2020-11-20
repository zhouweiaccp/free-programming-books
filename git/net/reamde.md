## commandline
*[commandline] (https://github.com/commandlineparser/commandline)
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
-[Newbe.Claptrap](https://gitee.com/yks/Newbe.Claptrap)以事件溯源和Actor模式作为基本理论的一套服务端开发框架。于此之上，开发者可以更为简单的开发出“分布式”、“可水平扩展”、“可测试性高”的应用系统
-[](https://github.com/egametang/ET)ET是一个开源的游戏客户端（基于unity3d）服务端双端框架，服务端是使用C# .net core开发的分布式游戏服务端，其特点是开发效率高，性能强，双端共享逻辑代码，客户端服务端热更机制完善，同时支持可靠udp tcp websocket协议，支持服务端3D recast寻路等等
-[MoreLINQ] (https://github.com/morelinq/MoreLINQ)  linq 扩展方法lefjoin   totable 等
- [LRUCache](https://github.com/duyanming/Anno.LRUCache/blob/master/Anno.LRUCache/LRUCache.cs)
- [](https://archive.codeplex.com/?p=aspnet#Samples%2fNet4%2fCS%2fWebApi%2fHttpRangeRequestSample%2fReadMe.txt)We just shipped Visual Studio 2012, .NET 4.5, MVC 4, Web API and Web Pages 2. We are working on our next release and we are working to have a preview available at the Build conference and an RTM before the end of year. The following items are what we are tentatively targeting for this next relea  [](链接: https://pan.baidu.com/s/1ZBrJFQk3Pev_BTVysRxkyA 提取码: 34xu 复制这段内容后打开百度网盘手机App，操作更方便哦)
- [](https://github.com/tpeczek/Lib.Web.Mvc)helper classes for ASP.NET MVC such as strongly typed jqGrid helper, attribute and helper providing support for HTTP/2 Server Push with Cache Digest, attribute and helpers providing support for Content Security Policy Level 2, FileResult providing support for Range Requests, action result and helper providing support for XSL transformation and more.
- [html5_video_play_largefile](https://gitee.com/abccc123/html5_video_play_largefile/blob/master/README.md)  html5视频播放分段下载
- [AutofacDemo](https://github.com/das2017/14-AutofacDemo) AutofacDemo 配置文件示例 企业架构demo比较全
    - [Examples](https://github.com/autofac/Examples/)  autofac 应用 wcf mvc webapi  netcore的demo
- [CSharpFlink](git@gitee.com:wxzz/CSharpFlink.git) netcore5.0 数据计算 用上 DotNetty  Microsoft.CodeAnalysis.CSharp 
- []()
- []()
- []()

## 常见问题


### Thread Theft
https://stackexchange.github.io/StackExchange.Redis/ThreadTheft.html
https://www.cnblogs.com/dudu/p/6251266.html  又踩.NET Core的坑：在同步方法中调用异步方法Wait时发生死锁(deadlock)
<add key="aspnet:UseTaskFriendlySynchronizationContext" value="true" />
这告诉ASP.NET使用全新的异步管道，它遵循CLR约定来启动异步操作，包括在必要时将线程返回到ThreadPool。ASP.NET 4.0及其以下版本遵循自己的约定，违背了CLR原则，如果交换机未启用，则    异步方法非常容易同步运行，死锁请求或以其他方式不按预期运行。


## webconfig中配置编码
<globalization fileEncoding="utf-8" requestEncoding="utf-8" responseEncoding="gb2312"/>
    </system.web>
    <location path="weather.aspx">
      <system.web>
        <globalization  requestEncoding="gb2312" responseEncoding="gb2312"/>
      </system.web>
    </location>
  <location path="updatesoft.aspx">
    <system.web>
      <globalization  requestEncoding="gb2312" responseEncoding="gb2312"/>
    </system.web>
  </location>
### 短网址

 -[aspnetcore-url-shortener]()  ![aspnetcore-url-shortener](GenerateShortURL.cs)

