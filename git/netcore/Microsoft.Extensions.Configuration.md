一、新建.net core控制台程序

二、通过Nuget引入 Microsoft.Extensions.Configuration和microsoft.extensions.configuration.json

三、引入配置文件appsettings.Debug.json

复制代码
{
  "AppConfig": {
    "DbConnection": "Server=;port=;database=",
    "EnableTrace": false,
    "IpWhiteList": [
      "127.0.0.1"
    ],
    "Port": 123,
    "ServiceName": "myapi"
  },
  "Auth": {
    "Users": [ "hanmeimei", "Lucy", "lilei" ]
  }
}
复制代码
 

四、新建类JsonConfigTest

复制代码
public class JsonConfigTest
    {
        public IConfiguration Configuration { get; }

        public static void Run()
        {
            var Configuration = StartAppsettings();
            //get DbConn
            var connectionStr = Configuration.GetSection("AppConfig")["DbConnection"];//第一种方法
            Console.WriteLine(connectionStr);
            connectionStr = Configuration["AppConfig:DbConnection"];//第二种方法
            Console.WriteLine(connectionStr);
            //get user
            IEnumerable<string> users = Configuration.GetSection("Auth:Users").GetChildren().Select(x => x.Value);
            foreach (var user in users)
            {
                Console.WriteLine(user);
            }
            Console.ReadKey();
        }
        public static IConfiguration StartAppsettings()
        {
            bool isOptional = true;
            var builder = new ConfigurationBuilder()
                .AddJsonFile($"appsettings.debug.json", isOptional);
            var config = builder.Build();
            return config;
        }
    }
复制代码
五、执行程序

复制代码
    class Program
    {
        static void Main(string[] args)
        {
            JsonConfigTest.Run();
        }
    }
复制代码