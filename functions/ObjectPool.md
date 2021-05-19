

Microsoft.Extensions.ObjectPool  git@github.com:aspnet/Extensions.git
https://gitlab.com/pomma89/object-pool stream string pool



https://stackoverflow.com/questions/2510975/c-sharp-object-pooling-pattern-implementation

## Microsoft.IO.RecyclableMemoryStream.
Install-Package Microsoft.IO.RecyclableMemoryStream
https://github.com/Microsoft/Microsoft.IO.RecyclableMemoryStream

## Array-Pool
System.Buffers.ArrayPool<T>
https://www.nuget.org/packages/System.Buffers
https://adamsitnik.com/Array-Pool/ 
https://github.com/dotnet/coreclr/blob/39f9e894aa16113c2c0dda1e99ce5dd606bd45a6/src/System.Private.CoreLib/shared/System/Buffers/ArrayPool.cs#L94-L96
https://github.com/dotnet/corefx/issues/4547
https://github.com/aspnet/Common/blob/dev/src/Microsoft.Extensions.MemoryPool/IArraySegmentPool.cs
https://github.com/dotnet/coreclr/blob/39f9e894aa16113c2c0dda1e99ce5dd606bd45a6/src/System.Private.CoreLib/shared/System/Buffers/ConfigurableArrayPool.cs



https://github.com/yanggujun/commonsfornet/blob/master/src/Commons.Pool/GenericObjectPool.cs



## PipeReader 
[PipeReader ](https://github.com/davidfowl/TcpEcho/blob/master/src/Server/Program.cs)  ![](.\PipeReader.cs)


## 数据库连接池
- [SafeObjectPool](https://github.com/zhouweiaccp/SafeObjectPool)
- [Mssql](https://github.com/2881099/dng.Mssql/blob/master/Mssql/SqlConnectionPool.cs)
- [Mysql](https://github.com/zhouweiaccp/dng.Mysql)
- [Npgsql](https://github.com/2881099/dng.Pgsql/blob/master/Npgsql/NpgsqlConnectionPool.cs)
- [.NETCore + Mysql 生成器](https://github.com/zhouweiaccp/dotnetGen_mysql)
- [Pool](https://github.com/NewLifeX/X/blob/master/NewLife.Core/Collections/ObjectPool.cs) 数据库连接池
     ```cs
     //重写
         protected virtual T OnCreate() 
          protected virtual Boolean OnPut(T value)
     ```