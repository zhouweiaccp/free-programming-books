



### 从 DateTimeOffset 转换为 DateTime
DateTime baseTime = new DateTime(2008, 6, 19, 7, 0, 0);
DateTimeOffset sourceTime;
DateTime targetTime;

// Convert UTC to DateTime value
sourceTime = new DateTimeOffset(baseTime, TimeSpan.Zero);
targetTime = sourceTime.DateTime;
//https://docs.microsoft.com/zh-cn/dotnet/standard/datetime/converting-between-datetime-and-offset?redirectedfrom=MSDN


### C# 时间戳与DateTime/DateTimeOffset的相互转换
1.获取当前时间戳：
a.获取10位时间戳 　var UninTimeStamp = DateTimeOffset.UtcNow.ToUnixTimeSeconds();  
b.获取13位时间戳　　　 1 var UninTimeStamp = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds(); 
2.时间戳转换为DateTimea.10位时间戳转换　 1 var DateTimeUnix = DateTimeOffset.FromUnixTimeSeconds(UninTimeStamp); 
b.13位时间戳转换 1 var DateTimeUnix = DateTimeOffset.FromUnixTimeMilliseconds(UninTimeStamp); 

　　3.计算一个时间戳与当前时间的间隔　

1 //获取时间戳，并将其转换为DateTimeOffset
2             var UninTimeStamp = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
3             var DateTimeUnix = DateTimeOffset.FromUnixTimeMilliseconds(UninTimeStamp);
4             //计算两个时间间隔
5             TimeSpan timeSpan = new TimeSpan(DateTimeOffset.UtcNow.Ticks - DateTimeUnix.Ticks);


## 时区转换
```cs
using System;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            //转换成指定时区
            string s = "Tue Mar 27 14:17:00 +0900 2012";
            DateTime.TryParseExact(s, "ddd MMM dd HH:mm:ss zzz yyyy", System.Globalization.CultureInfo.CreateSpecificCulture("en-US"),System.Globalization.DateTimeStyles.None, out DateTime dt);
            Console.WriteLine(dt);
            

            Console.WriteLine("Hello World!");
            DateTime utcTime1 = TimeZoneInfo.ConvertTimeToUtc(DateTime.Now, TimeZoneInfo.Local);

            //1.根据本地时间取得时区列表：

            DateTimeOffset chinaDate = DateTimeOffset.Now; //本地当前时间
            Console.WriteLine(chinaDate.ToString() + "<br/>");

            System.Collections.ObjectModel.ReadOnlyCollection<TimeZoneInfo> zones = TimeZoneInfo.GetSystemTimeZones();//系统中地时区标识列表
            foreach (TimeZoneInfo timeZoneInfo in zones)
            {

                //通过本地时间取得格林威治标准时间，并通过这个标准时间取得不同时区ID的名称及它的相应时间
                DateTimeOffset easternDate = TimeZoneInfo.ConvertTime(chinaDate.UtcDateTime, TimeZoneInfo.FindSystemTimeZoneById(timeZoneInfo.Id));
                Console.WriteLine(timeZoneInfo.Id + ":&nbsp;&nbsp;&nbsp;&nbsp;" + easternDate.ToString() + $",TimeOfDay:{easternDate.TimeOfDay}");
            }

            Console.ReadLine();
        }
        /// <summary>
        /// 将指定时区中的时间转换为协调世界时 (UTC)。
        /// </summary>
        /// <param name="dateTime">要转的时区时间，此时间即为timeZone参数所在时区时间</param>
        /// <param name="zoneId">时区标识符</param>
        /// <returns></returns>
        public static DateTime ConvertTimeToUtc(DateTime dateTime, string zoneId)
        {
            return TimeZoneInfo.ConvertTimeToUtc(dateTime, TimeZoneInfo.FindSystemTimeZoneById(zoneId));
        }
    }
}
```