


## ASP.NET Core中获取完整的URL
在之前的ASP.NET中，可以通过 Request.Url.AbsoluteUri 获取，但在ASP.NET Core没有这个实现，请问如何获取呢？
方法一：先引用“using Microsoft.AspNetCore.Http.Extensions;”，然后直接用“Request.GetDisplayUrl();”
方法二：后来参考 Microsoft.AspNetCore.Rewrite 的源代码，写了一个扩展方法实现了。

namespace Microsoft.AspNetCore.Http
{
    public static class HttpRequestExtensions
    {
        public static string GetAbsoluteUri(this HttpRequest request)
        {
            return new StringBuilder()
                .Append(request.Scheme)
                .Append("://")
                .Append(request.Host)
                .Append(request.PathBase)
                .Append(request.Path)
                .Append(request.QueryString)
                .ToString();
        }
    }
}



## netcore静态文件目录访问
```cscharp
app.UseStaticFiles();//提供将wwwroot目录开放访问,例如：http://localhost:52723/css/site.css将访问wwwroot目录下的css目录中的site.css文件

app.UseStaticFiles(new StaticFileOptions()//自定义自己的文件路径,例如提供访问D盘下的Study目录，http://localhost:52723/MyStudy/README.md将访问D盘的Study目录中的README.md文件
            {
                FileProvider = new PhysicalFileProvider(@"D:\Study"),//指定实际物理路径
                RequestPath = new PathString("/MyStudy")//对外的访问路径
            });


app.UseDirectoryBrowser(new DirectoryBrowserOptions()//提供文件目录访问形式
            {
                FileProvider = new PhysicalFileProvider(@"D:\Study"),
                RequestPath = new PathString("/Study")
            });
app.UseFileServer(new FileServerOptions()//直接开启文件目录访问和文件访问
            {
                EnableDirectoryBrowsing = true,//开启目录访问
                FileProvider = new PhysicalFileProvider(@"D:\Git"),
                RequestPath = new PathString("/Git")
            });

```

## IHostLifetime
- [探索 ASP.Net Core 3.0系列五：引入IHostLifetime并弄清Generic Host启动交互](https://www.cnblogs.com/runningsmallguo/p/11617246.html)



## dotnet nuget locals
https://docs.microsoft.com/zh-cn/nuget/consume-packages/configuring-nuget-behavior 常见的 NuGet 配置
https://docs.microsoft.com/zh-cn/dotnet/core/tools/dotnet-nuget-locals
dotnet nuget locals all -l 
C:\Users\Administrator\.nuget\packages\


C:\Program Files (x86)\NuGet\Config\Microsoft.VisualStudio.Offline.config
```cs
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  </packageSources>
 <config> 
    <add key="globalPackagesFolder" value="D:\Users\dist\NuGetPackages" />
 </config>
</configuration>
```
## lib
    CSRedisCore  3.6.5  
    
    Dapper  2.0.35  
    Dapper.SqlBuilder  2.0.35  
    DotNetCore.NPOI  1.2.2  
    
    HtmlAgilityPack  1.11.27  
    log4net  2.0.12  
    Microsoft.AspNetCore.Mvc  2.2.0  
    Microsoft.Data.Sqlite  3.1.9  
    Microsoft.EntityFrameworkCore  3.1.9  
    Microsoft.EntityFrameworkCore.Sqlite  3.1.9  
    Microsoft.EntityFrameworkCore.SqlServer  3.1.9  
    Microsoft.Extensions.Caching.Memory  3.1.9  
    Microsoft.Extensions.Caching.StackExchangeRedis  3.1.9  
    Microsoft.Extensions.Configuration  3.1.9  
    Microsoft.Extensions.DependencyInjection  3.1.9  
    Microsoft.Extensions.DependencyModel  3.1.6  
    Microsoft.Extensions.Logging  3.1.9  
    
    MiniProfiler.AspNetCore  4.2.1  
    MiniProfiler.AspNetCore.Mvc  4.2.1  
    MiniProfiler.EntityFrameworkCore  4.2.1  
  
    Autofac  6.0.0  
    AutoMapper.Extensions.Microsoft.DependencyInjection  8.1.0  

    MySql.Data  8.0.22  
    MySql.Data.EntityFrameworkCore  8.0.22  
    
    Npgsql  4.1.5  
    Npgsql.EntityFrameworkCore.PostgreSQL  3.1.4  
    NPinyin.Core  3.0.0  
    
    Oracle.EntityFrameworkCore  3.19.80  
    Oracle.ManagedDataAccess.Core  2.19.91  
    QRCoder  1.3.9  
    Quartz  3.2.3  
    SgmlReader.NetCore  1.0.0  
    
    System.Data.SqlClient  4.8.2  
    System.Drawing.Common  4.7.0  
    System.Management  4.7.0  




## net core 抓取dump包三种方式
1. https://docs.microsoft.com/en-us/dotnet/core/diagnostics/dotnet-dump
https://github.com/dotnet/diagnostics/blob/master/documentation/dotnet-dump-instructions.md
在Linux上，运行时版本必须为3.0或更高，windows 无限制。使用 dotnet-dump collect 命令收集需要程序为3.0才行，而使用 dotnet-dump analyze 则无限制。

2. https://github.com/microsoft/ProcDump-for-Linux
没运行时的限制，缺点是生成的文件大

3. https://stackoverflow.com/questions/58213127/how-to-generate-a-reasonably-sized-memory-dump-file-of-a-net-core-process-on-li
使用 .netcore 自带的 createdump 程序来抓取包，默认在 /usr/share/dotnet/shared/Microsoft.NETCore.App/版本下。可以抓2.x/3x 版本的 dump
/usr/share/dotnet/shared/Microsoft.NETCore.App/5.0.5/createdump


4. docker dotnet-dump 
```sh
一、 vi docker-compose.yml，添加以下配置

cap_add:
  - SYS_PTRACE
#二、查看docker版本，小于20.x版本需要进程升级

#三、进入edoc2容器
docker exec -it $(docker ps |grep edoc2:|awk '{print $1}') bash
#四、查看线程情况
top -n 1 -H -p $(pidof dotnet)  #返回结果截图给到研发
#  ./tools.tar.gz 解压到/opt/tools/
cd /opt/tools/
./dotnet-dump collect -p $(pidof dotnet) -o edoc2_$(date +%F).dump
docker cp $(docker ps |grep edoc2:|awk '{print $1}'):/opt/tools/edoc2_$(date +%F).dump /opt/
#  https://www.cnblogs.com/zhouandke/p/11070114.html 使用dotnet-dump 查找 .net core 3.0 占用CPU 100%的原因
```


## net 分析dump包2种方式
1. windbg
2. sos [sos-dll-sos-debugging-extension](https://docs.microsoft.com/zh-cn/dotnet/framework/tools/sos-dll-sos-debugging-extension)