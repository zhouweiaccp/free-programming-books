











## code 
```cs
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;

static void Main(string[] args)
{
　　var cache = new MemoryCache(new MemoryCacheOptions());
　　//设置静态缓存
　　cache.Set("A", 1);
　　if (cache.TryGetValue("User", out int value))
　　　　Console.WriteLine(value);
   //设置一秒后过期         
　　cache.Set("B",2,DateTimeOffset.Now.AddMilliseconds(1000).DateTime);
　　Console.ReadLine();
}    
```

## link
-[](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.caching.memory?view=dotnet-plat-ext-5.0)