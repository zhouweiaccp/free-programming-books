



## windows下安装Redis并部署成服务
windows版本：
    https://github.com/MSOpenTech/redis/releases
Linux版本：
    官网下载：
        http://www.redis.cn/
    git下载
        https://github.com/antirez/redis/release
卸载服务：redis-server --service-uninstall
开启服务：redis-server --service-start
停止服务：redis-server --service-stop
重命名服务：redis-server --service-name name

以下将会安装并启动三个不同的Redis实例作服务：

redis-server --service-install --service-name redisService1 --port 10001

redis-server --service-start --service-name redisService1

redis-server --service-install --service-name redisService2 --port 10002

redis-server --service-start --service-name redisService2

redis-server --service-install --service-name redisService3 --port 10003

redis-server --service-start --service-name redisService3







## 文章
- [C#两大知名Redis客户端连接哨兵集群的姿势](https://www.cnblogs.com/JulianHuang/p/12687090.html)  https://github.com/zaozaoniao/Redis-sentinel-with-docker-compose