


## 
windows将在此状态下保持连接240秒（由其设置[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\TcpTimedWaitDelay]）。Windows可以快速打开新套接字的速度有限，因此如果您耗尽连接池，那么您可能会看到如下错误：



### https
var httpclientHandler = new HttpClientHandler();
    httpclientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, error) => true;
    var httpClient = new HttpClient(httpclientHandler);



###　FormUrlEncodedContent
  FormUrlEncodedContent formUrlEncoded = new FormUrlEncodedContent(new new Dictionary<string, string>(){});
                var response = client.PostAsync(SSOUrl + pingUrl, formUrlEncoded).Result;
### 方法1

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
### 方法2
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

            _httpClient.DefaultRequestHeaders.Accept.Clear();
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(contentType));


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