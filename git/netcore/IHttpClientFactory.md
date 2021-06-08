


## 
windows将在此状态下保持连接240秒（由其设置[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpTimedWaitDelay]）。Windows可以快速打开新套接字的速度有限，因此如果您耗尽连接池，那么您可能会看到如下错误：

- [](https://github.com/dotnet/AspNetCore.Docs/blob/main/aspnetcore/fundamentals/http-requests/samples/5.x/HttpClientFactorySample/Startup2.cs)


### https
var httpclientHandler = new HttpClientHandler();
    httpclientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, error) => true;
    var httpClient = new HttpClient(httpclientHandler);

### Configure a client with Polly's Retry policy, in Startup
- [](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/implement-resilient-applications/implement-http-call-retries-exponential-backoff-polly)
- [Polly and HttpClientFactory](https://github.com/App-vNext/Polly/wiki/Polly-and-HttpClientFactory)Polly and HttpClientFactory
```cs
services.AddHttpClient<IBasketService, BasketService>()
        .SetHandlerLifetime(TimeSpan.FromMinutes(5))  //Set lifetime to five minutes
        .AddPolicyHandler(GetRetryPolicy());

// Configuring the Polly policies
// Using .AddTransientHttpErrorPolicy(...)
// Let's look at the example from Step 2 above again:
//https://github.com/App-vNext/Polly/wiki/Polly-and-HttpClientFactory
services.AddHttpClient("GitHub", client =>
{
    client.BaseAddress = new Uri("https://api.github.com/");
    client.DefaultRequestHeaders.Add("Accept", "application/vnd.github.v3+json");
})
.AddTransientHttpErrorPolicy(builder => builder.WaitAndRetryAsync(new[]
{
    TimeSpan.FromSeconds(1),
    TimeSpan.FromSeconds(5),
    TimeSpan.FromSeconds(10)
}))

var retryPolicy = Policy.Handle<HttpRequestException>()
    .OrResult<HttpResponseMessage>(response => MyCustomResponsePredicate(response))
    .WaitAndRetryAsync(new[]
    {
        TimeSpan.FromSeconds(1),
        TimeSpan.FromSeconds(5),
        TimeSpan.FromSeconds(10)
    }));

services.AddHttpClient(/* etc */)
    .AddPolicyHandler(retryPolicy);
```

###　FormUrlEncodedContent
  FormUrlEncodedContent formUrlEncoded = new FormUrlEncodedContent(new new Dictionary<string, string>(){});
                var response = client.PostAsync(SSOUrl + pingUrl, formUrlEncoded).Result;
### 方法1
```cs
  public void Configure(IApplicationBuilder app, IHostingEnvironment env, IHttpContextAccessor accessor)
  app.UseStaticHttpContext();

   public static class HttpContext
    {
        private static IHttpContextAccessor _contextAccessor;

        public static Microsoft.AspNetCore.Http.HttpContext Current
        {
            get
            {
                if (_contextAccessor != null)
                {
                    return _contextAccessor.HttpContext;
                }
                return null;
            }
        }
        public static System.Net.Http.IHttpClientFactory HttpClientFactory
        {
            get
            {
                if (httpClientFactory != null)
                {
                    return httpClientFactory;
                }
                return null;
            }
        }
        private static System.Net.Http.IHttpClientFactory httpClientFactory;
        internal static void Configure(IHttpContextAccessor contextAccessor,System.Net.Http.IHttpClientFactory _httpClientFactory)
        {
            _contextAccessor = contextAccessor;
            httpClientFactory = _httpClientFactory;
        }
    }

    public static class StaticHttpContextExtensions
    {
        public static IApplicationBuilder UseStaticHttpContext(this IApplicationBuilder app)
        {
            var httpContextAccessor = app.ApplicationServices.GetRequiredService<IHttpContextAccessor>();
            var httpClientFactory = app.ApplicationServices.GetRequiredService<System.Net.Http.IHttpClientFactory>();
            HttpContext.Configure(httpContextAccessor, httpClientFactory);
            return app;
        }
    }
```
### 方法2
```cs
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

 public class Monitor
    {

        /// <summary>
        /// POST请求
        /// </summary>
        /// <param name="url"></param>
        /// <param name="obj"></param>
        /// <param name="contentType">application/xml、application/json、application/text、application/x-www-form-urlencoded</param>
        /// <param name="charset"></param>
        /// <returns></returns>       
        public string HttpPostAsync(string url, object obj, string contentType = "", string charset = "UTF-8")
        {
            string result = "";

            var serviceProvider = new ServiceCollection().AddHttpClient().BuildServiceProvider();
            IHttpClientFactory _httpClientFactory = serviceProvider.GetService<IHttpClientFactory>();
            var _httpClient = _httpClientFactory.CreateClient("CTCCMonitor");
            string content = JsonConvert.SerializeObject(obj);

            var httpContent = new StringContent(content, Encoding.UTF8, contentType);

            var response = _httpClient.PostAsync(url, httpContent).Result;
            if (response.IsSuccessStatusCode)
            {
                Task<string> t = response.Content.ReadAsStringAsync();
                if (t != null)
                {
                    result = t.Result;
                }
            }
            return result;
        }

        /// <summary>
        /// GET请求
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public string HttpGetAsync(string url)
        {
            string result = "";
            var serviceProvider = new ServiceCollection().AddHttpClient().BuildServiceProvider();
            IHttpClientFactory _httpClientFactory = serviceProvider.GetService<IHttpClientFactory>();

            var _httpClient = _httpClientFactory.CreateClient("CTCCMonitor");

            var response = _httpClient.GetAsync(url).Result;

            if (response.IsSuccessStatusCode)
            {
                Task<string> t = response.Content.ReadAsStringAsync();
                if (t != null)
                {
                    result = t.Result;
                }
            }
            return result;
        }

        /// <summary>
        /// 拼接请求参数
        /// </summary>
        /// <param name="method">请求方式GET/POST</param>
        /// <param name="dic"></param>
        /// <returns></returns>
        public string GetPara(string method, Dictionary<string, string> dic)
        {
            StringBuilder strPara = new StringBuilder();
            method = method.ToUpper();
            switch (method)
            {
                case "POST":
                    foreach (var item in dic)
                    {
                        if (!string.IsNullOrEmpty(strPara.ToString()))
                        {
                            strPara.Append("&");
                        }

                        strPara.Append(item.Key).Append("=").Append(item.Value);
                    }
                    break;
                case "GET":
                    foreach (var item in dic)
                    {
                        if (string.IsNullOrEmpty(strPara.ToString()))
                        {
                            strPara.Append("?");
                        }
                        else
                        {
                            strPara.Append("&");
                        }
                        strPara.Append(item.Key).Append("=").Append(item.Value);
                    }
                    break;
            }
            return strPara.ToString();
        }
    }
}
```


### 下载图片  Authorization
```cs
//https://zetcode.com/csharp/httpclient/
using System;
using System.IO;
using System.Net.Http;

using var httpClient = new HttpClient();
var url = "http://webcode.me/favicon.ico";
byte[] imageBytes = await httpClient.GetByteArrayAsync(url);

string documentsPath = System.Environment.GetFolderPath(
        System.Environment.SpecialFolder.Personal);

string localFilename = "favicon.ico";
string localPath = Path.Combine(documentsPath, localFilename);

Console.WriteLine(localPath);
File.WriteAllBytes(localPath, imageBytes);
//In the example, we download an image from the webcode.me website. The image is written to the user's Documents folder.
byte[] imageBytes = await httpClient.GetByteArrayAsync(url)


var userName = "user7";
var passwd = "passwd";
var url = "https://httpbin.org/basic-auth/user7/passwd";

using var client = new HttpClient();

var authToken = Encoding.ASCII.GetBytes($"{userName}:{passwd}");
client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic",
        Convert.ToBase64String(authToken));

var result = await client.GetAsync(url);

var content = await result.Content.ReadAsStringAsync();
Console.WriteLine(content);
```


### Creating an HttpClient and HttpMessageHandler 源码分析
```cs
//https://andrewlock.net/exporing-the-code-behind-ihttpclientfactory/
//https://github.com/dotnet/runtime/blob/main/src/libraries/Microsoft.Extensions.Http/src/DefaultHttpClientFactory.cs
//https://www.cnblogs.com/lizhizhang/p/9502862.html
// Created in the constructor
readonly ConcurrentDictionary<string, Lazy<ActiveHandlerTrackingEntry>> _activeHandlers;;

readonly Func<string, Lazy<ActiveHandlerTrackingEntry>> _entryFactory = (name) =>
    {
        return new Lazy<ActiveHandlerTrackingEntry>(() =>
        {
            return CreateHandlerEntry(name);
        }, LazyThreadSafetyMode.ExecutionAndPublication);
    };

public HttpMessageHandler CreateHandler(string name)
{
    ActiveHandlerTrackingEntry entry = _activeHandlers.GetOrAdd(name, _entryFactory).Value;

    entry.StartExpiryTimer(_expiryCallback);

    return entry.Handler;
}

// Injected in constructor
private readonly IOptionsMonitor<HttpClientFactoryOptions> _optionsMonitor

public HttpClient CreateClient(string name)
{
    HttpMessageHandler handler = CreateHandler(name);
    var client = new HttpClient(handler, disposeHandler: false);//disposeHandler参数为false值时表示要重用内部的handler对象

    HttpClientFactoryOptions options = _optionsMonitor.Get(name);
    for (int i = 0; i < options.HttpClientActions.Count; i++)
    {
        options.HttpClientActions[i](client);
    }

    return client;
}






// The root service provider, injected into the constructor using DI
private readonly IServiceProvider _services;

// A collection of IHttpMessageHandler "configurers" that are added to every handler pipeline
private readonly IHttpMessageHandlerBuilderFilter[] _filters;

private ActiveHandlerTrackingEntry CreateHandlerEntry(string name)
{
    IServiceScope scope = _services.CreateScope(); 
    IServiceProvider services = scope.ServiceProvider;
    HttpClientFactoryOptions options = _optionsMonitor.Get(name);

    HttpMessageHandlerBuilder builder = services.GetRequiredService<HttpMessageHandlerBuilder>();
    builder.Name = name;

    // This is similar to the initialization pattern in:
    // https://github.com/aspnet/Hosting/blob/e892ed8bbdcd25a0dafc1850033398dc57f65fe1/src/Microsoft.AspNetCore.Hosting/Internal/WebHost.cs#L188
    Action<HttpMessageHandlerBuilder> configure = Configure;
    for (int i = _filters.Length - 1; i >= 0; i--)
    {
        configure = _filters[i].Configure(configure);
    }

    configure(builder);

    // Wrap the handler so we can ensure the inner handler outlives the outer handler.
    var handler = new LifetimeTrackingHttpMessageHandler(builder.Build());

    return new ActiveHandlerTrackingEntry(name, handler, scope, options.HandlerLifetime);

    void Configure(HttpMessageHandlerBuilder b)
    {
        for (int i = 0; i < options.HttpMessageHandlerBuilderActions.Count; i++)
        {
            options.HttpMessageHandlerBuilderActions[i](b);
        }
    }
}

```