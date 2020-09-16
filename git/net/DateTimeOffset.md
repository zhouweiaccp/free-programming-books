



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