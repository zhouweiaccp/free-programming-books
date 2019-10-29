emperf又名mcperf，是一款memcached的性能测试工具。Mcperf就像httperf，但它基于memcached的协议，它使用memcached的ASCII协议并且能够快速的产生大量memcached连接和请求。该工具主要用于memcached性能测试，模拟大并发set、get等操作，mcperf只能运行在unix/linux环境下。

我们可以通过下面的链接来获取mcperf:

https://github.com/twitter/twemperf

进入下面页面获取最新发行版:

https://github.com/twitter/twemperf/releases

获取到最新的tar包后，将其上传到linux服务器。

解压包：

[root@localhost ~]#tar xzvf mcperf-0.1.1.tar.gz
在debug模式下构建源码

[root@localhost ~]#cd mcperf-0.1.1
[root@localhost ~]#CFLAGS="-ggdb3 -O0" ./configure --enable-debug
[root@localhost ~]#make
[root@localhost ~]#sudo make install
到此，mcperf就全部安装完成了。

Github上给出了两个简单的例子来说明mcperf的使用方法。

第一种：创建1000个并发连接，来连接本机的11211端口（此端口是该工具的默认端口），连接创建的速度是每秒1000个，每一个连接发送“set”请求10次（相当于迭代10次），这10次请求在每秒1000的请求的速度下发送，发送的数据大小在（也就是存入到memcached中的value的大小）1~16个字节中正态分布。

命令如下：

[root@localhost ~]#mcperf --linger=0 --timeout=5 --conn-rate=1000 --call-rate=1000 --num-calls=10 --num-conns=1000 --sizes=u1,16
执行结果：

Total: connections 1000 requests 10000 responses 10000 test-duration 1.009 s
   Connection rate: 991.1 conn/s (1.0 ms/conn <= 23 concurrent connections)
   Connection time [ms]: avg 10.3 min 10.1 max 14.1 stddev 0.1
   Connect time [ms]: avg 0.2 min 0.1 max 0.8 stddev 0.0
   Request rate: 9910.5 req/s (0.1 ms/req)
   Request size [B]: avg 35.9 min 28.0 max 44.0 stddev 4.8
   Response rate: 9910.5 rsp/s (0.1 ms/rsp)
   Response size [B]: avg 8.0 min 8.0 max 8.0 stddev 0.0
   Response time [ms]: avg 0.2 min 0.1 max 13.4 stddev 0.00
   Response time [ms]: p25 1.0 p50 1.0 p75 1.0
   Response time [ms]: p95 1.0 p99 1.0 p999 1.0
   Response type: stored 10000 not_stored 0 exists 0 not_found 0
   Response type: num 0 deleted 0 end 0 value 0
   Response type: error 0 client_error 0 server_error 0
   Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
   Errors: fd-unavail 0 ftab-full 0 addrunavail 0 other 0
   CPU time [s]: user 0.64 system 0.35 (user 63.6% system 35.1% total 98.7%)
   Net I/O: bytes 428.7 KB rate 424.8 KB/s (3.5*10^6 bps)
第二种：创建100个连接，来连接本机的11211端口，每一个连接在上一个连接断开后创建，每一个连接发送100个“set”请求，每一个请求是在收到上一个请求的响应之后创建，发送的数据大小是1个字节。

命令如下：

[root@localhost ~]#mcperf --linger=0 --call-rate=0 --num-calls=100 --conn-rate=0 --num-conns=100 --sizes=d1
执行结果：

Total: connections 100 requests 10000 responses 10000 test-duration 1.268 s
   Connection rate: 78.9 conn/s (12.7 ms/conn <= 1 concurrent connections)
   Connection time [ms]: avg 12.7 min 12.6 max 13.5 stddev 0.1
   Connect time [ms]: avg 0.0 min 0.0 max 0.1 stddev 0.0
   Request rate: 7886.1 req/s (0.1 ms/req)
   Request size [B]: avg 28.0 min 28.0 max 28.0 stddev 0.0
   Response rate: 7886.1 rsp/s (0.1 ms/rsp)
   Response size [B]: avg 8.0 min 8.0 max 8.0 stddev 0.0
   Response time [ms]: avg 0.1 min 0.1 max 1.0 stddev 0.00
   Response time [ms]: p25 1.0 p50 1.0 p75 1.0
   Response time [ms]: p95 1.0 p99 1.0 p999 1.0
   Response type: stored 10000 not_stored 0 exists 0 not_found 0
   Response type: num 0 deleted 0 end 0 value 0
   Response type: error 0 client_error 0 server_error 0
   Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
   Errors: fd-unavail 0 ftab-full 0 addrunavail 0 other 0
   CPU time [s]: user 0.51 system 0.75 (user 40.0% system 59.0% total 99.0%)
   Net I/O: bytes 351.6 KB rate 277.2 KB/s (2.3*10^6 bps)
官方对每一个参数的解释：

Usage: mcperf [-?hV] [-v verbosity level] [-o output file]
   [-s server] [-p port] [-H] [-t timeout] [-l linger]
   [-b send-buffer] [-B recv-buffer] [-D]
   [-m method] [-e expiry] [-q] [-P prefix]
   [-c client] [-n num-conns] [-N num-calls]
   [-r conn-rate] [-R call-rate] [-z sizes]
   Options:
   -h, --help            : this help
   -V, --version         : show version and exit
   -v, --verbosity=N     : set logging level (default: 5, min: 0, max: 11)
   -o, --output=S        : set logging file (default: stderr)
   -s, --server=S        : set the hostname of the server (default: localhost)
   -p, --port=N          : set the port number of the server (default: 11211)
   -H, --print-histogram : print response time histogram
   -t, --timeout=X       : set the connection and response timeout in sec (default: 0.0 sec)
   -l, --linger=N        : set the linger timeout in sec, when closing TCP connections (default: off)
   -b, --send-buffer=N   : set socket send buffer size (default: 4096 bytes)
   -B, --recv-buffer=N   : set socket recv buffer size (default: 16384 bytes)
   -D, --disable-nodelay : disable tcp nodelay
   -m, --method=M        : set the method to use when issuing memcached request (default: set)
   -e, --expiry=N        : set the expiry value in sec for generated requests (default: 0 sec)
   -q, --use-noreply     : set noreply for generated requests
   -P, --prefix=S        : set the prefix of generated keys (default: mcp:smile:
   -c, --client=I/N      : set mcperf instance to be I out of total N instances (default: 0/1)
   -n, --num-conns=N     : set the number of connections to create (default: 1)
   -N, --num-calls=N     : set the number of calls to create on each connection (default: 1)
   -r, --conn-rate=R     : set the connection creation rate (default: 0 conns/sec)
   -R, --call-rate=R     : set the call creation rate (default: 0 calls/sec)
   -z, --sizes=R         : set the distribution for item sizes (default: d1 bytes)
部分主要的参数中文解释：

Options:
   -h, --help                : 显示帮助
   -V, --version               : 显示版本
   -v, --verbosity=N            : 设置日志级别（默认为5，最小0，最大11）
   -o, --output=S              : 设置日志文件（默认输出标准错误）
   -s, --server=S               : 设置需要测试的服务器（默认是本机）
   -p, --port=N          : 设置需要测试的端口（默认是11211）
   -H, --print-histogram       :打印响应时间的柱状图
   -t, --timeout=X       : 设置链接和响应的超时时间（默认是0秒）
   -l, --linger=N              : 设置TCP连接的断开时间（默认不开启）
   -b, --send-buffer=N   : 设置socket发送缓冲区大小（默认是4096字节）
   -B, --recv-buffer=N        : 设置socket接收缓冲区大小（默认是16384字节）
   -D, --disable-nodelay       : 显示TCP延迟
   -m, --method=M     : memcached的一些基本操作（例如set、get、add、delete等）
   -n, --num-conns=N   :设置连接数（默认是1）
   -N, --num-calls=N    : 设置每一个连接发送的请求数（默认是1）
   -r, --conn-rate=R     : 设置每秒建立多少个连接（默认是每秒0个连接，每一个连接在上一个连接断开后创建）
   -R, --call-rate=R     : 设置每秒发送的请求数（默认是每秒0个请求，每一个请求在上一个请求响应后发送）
   -z, --sizes=R        : 发送存储数据的大小（默认是1个字节）
执行结果参数中文解释：

Total：显示总的连接数，总的请求数，总的响应数以及测试所花费的时间。
   Connection rate：实际每秒的连接数
   Connection time：实际每个连接花费的时间（包括连接时间，set时间等）
   Connect time：连接所花费的时间（仅仅是连接所用的时间）
   Request rate：每秒的请求数
   Request size：每个请求的字节大小
   Response rate：每秒的响应数
   Response size：响应的字节大小
   Response time：响应的时间（单位毫秒）
   Response type：stored表示存储的数量，not_stored表示没有存储的数量，
   exists表示已经存在的数量（add时候用到），not_found表示没有找到的数量（get时候用到）
通过上面的介绍，可以看出，用mcperf测试memcache的方法就是调整不同的参数值来执行命令，经过多次采样后得出结果。这里，我们也设定一个目标，测试出最大的并发连接数及最大的请求/响应速率，这样才能确定我们需要配置哪些参数，这里的并发数是指同时活动的连接数。

我们要测试最大的并发连接数，是取请求/响应速率最快时的并发数。所以这里的可变量是连接数–num-conns，其他参数固定，分别测试300、400、500、1000、1500、2000等不同连接数下，set/get的请求/响应速率，我们取速率最大时的连接数，并可得出速率最快时的最大并发连接数。

当然，我们还可以测试set/get操作不同字节数的数据对速率的影响，找出支持get/set操作的最大数值，那么可变量就换成–sizes。注意–conn-rate和–call-rate这两个参数，分别是生成连接的速率和发送请求的速率。这两个值根据测试机配置不同，不宜设置过大，否者会导致测试机本身性能不够导致无法生成足够的连接和请求数来进行测试。

创建1000个并发连接，来连接127.20.99.136的11211端口（此端口是该工具的默认端口），连接创建的速度是每秒1000个，每一个连接发送“set”请求1000次（相当于迭代1000次），这1000次请求在每秒1000的请求的速度下发送，发送的数据大小是10-1024字节（也就是存入到memcached中的value的大小）之间正态分布。

命令如下：

[root@localhost ~]# mcperf --linger=0 --timeout=5 --num-conns=1000 --conn-rate=1000 --num-calls=1000 --call-rate=1000 --sizes=u10,1024 --method=set --server=172.20.99.136 --port=11211 --verbosity=6 --output=/usr/src/log/log_1000_1000.txt
测试结果：

Total: connections 1000 requests 1000000 responses 1000000 test-duration 10.854 s
   Connection rate: 92.1 conn/s (10.9 ms/conn <= 1000 concurrent connections)
   Connection time [ms]: avg 6971.1 min 2983.4 max 10144.3 stddev 2771.72
   Connect time [ms]: avg 100.2 min 0.0 max 581.1 stddev 152.71
   Request rate: 92135.9 req/s (0.0 ms/req)
   Request size [B]: avg 545.9 min 38.0 max 1054.0 stddev 292.64
   Response rate: 92135.9 rsp/s (0.0 ms/rsp)
   Response size [B]: avg 8.0 min 8.0 max 8.0 stddev 0.00
   Response time [ms]: avg 175.8 min 0.1 max 1925.9 stddev 0.19
   Response time [ms]: p25 64.0 p50 114.0 p75 177.0
   Response time [ms]: p95 581.0 p99 906.0 p999 1375.0
   Response type: stored 1000000 not_stored 0 exists 0 not_found 0
   Response type: num 0 deleted 0 end 0 value 0
   Response type: error 0 client_error 0 server_error 0
   Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0
   Errors: fd-unavail 0 ftab-full 0 addrunavail 0 other 0
   CPU time [s]: user 5.11 system 5.68 (user 47.1% system 52.4% total 99.4%)
   Net I/O: bytes 528.2 MB rate 49838.6 KB/s (408.3*10^6 bps)
测试分析：

我们主要关注下面这几个值，从执行的测试结果可以得出：

总计：并发了1000个连接，请求了1000000次，响应了1000000次，耗时10.854 s

实际建立连接的速率：每秒92.1个

请求速率：每秒92135.9次

响应速率：每秒92135.9次

响应时间：平均175.8毫秒

成功存储：1000000次

网络传输：共传输528.2MB 每秒传输49838.6 KB

我们需要进行多次测试采样，得到以上需要的数据后，用excel表格统计出图表，就能很明显的看出结果了，下面是set操作的统计图：



可以看出在2000并发时响应速率和请求速率达到最大，2200个并发时速率开始下降。在实际测试过程中，应该尽可能进行多次采样，让测试结果更准确。

以上便是用mcperf测试memcache的大致过程。
https://www.bstester.com/2013/12/memcache-performance-test-tool-for-twemperf-use