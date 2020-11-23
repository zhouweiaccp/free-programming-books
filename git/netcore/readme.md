


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