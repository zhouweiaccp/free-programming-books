


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