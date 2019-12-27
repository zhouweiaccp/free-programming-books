
LLDB Debugger (LLDB) 是一个开源、底层调试器(low level debugger)，具有REPL (Read-Eval-Print Loop，交互式解释器)、C++和Python插件，位于Xcode窗口底部控制台中，也可以在terminal中使用。具有流向控制 (flow control) 和数据检查 (data inspection) 功能。
LLDB使用了LLVM项目中的一些组件，如编译器、解释器、构建器等。LLDB是非常强大的工具，可以输出代码中变量，访问macOS系统底层的Unix，进行个性化配置等，且整个过程无需终止会话

## install
https://github.com/dotnet/diagnostics/blob/master/documentation/installing-sos-instructions.md

C:\Program Files\dotnet\shared\Microsoft.NETCore.App\2.2.7\sos.dll
/usr/share/dotnet/shared/Microsoft.NETCore.App/2.2.4/libsosplugin.so


/usr/share/dotnet/shared/Microsoft.NETCore.App/2.1.1/createdump 9364  -u -f    du.dmp
lldb du.dmp


### 所有的线程列表
thread list
5.1.4 切换到指定线程
thread select 161
5.1.5 查看指定线程正在执行的堆栈
dumpstack



createdump [options] pid
-f, --name - dump path and file name. The pid can be placed in the name with %d. The default is "/tmp/coredump.%d"
-n, --normal - create minidump (default).
-h, --withheap - create minidump with heap.
-t, --triage - create triage minidump.
-u, --full - create full core dump.
-d, --diag - enable diagnostic messages.

使用lldb调试分析netcore应用内存
https://www.cnblogs.com/chenyishi/p/11718560.html
https://docs.microsoft.com/zh-cn/dotnet/framework/tools/sos-dll-sos-debugging-extension
https://github.com/czd890/shell/blob/master/llvm_clang_lldb/3.9.0/llvm_clang_install.sh
https://www.cnblogs.com/chenyishi/p/11718589.html
https://blog.csdn.net/sD7O95O/article/details/82892195
https://www.cnblogs.com/Gool/p/9496505.html

参考资料：
coreclr调试说明指导文档
https://github.com/dotnet/coreclr/blob/master/Documentation/building/debugging-instructions.md
coreclr生成dmp说明指导文档
https://github.com/dotnet/coreclr/blob/master/Documentation/botr/xplat-minidump-generation.md
llvm，clang，lldb源代码下载地址(3.9.0)
http://releases.llvm.org/download.html#3.9.0
lldb源码安装指导文档
http://lldb.llvm.org/build.html#BuildingLldbOnLinux
llvm源码安装指导文档
http://releases.llvm.org/3.9.0/docs/GettingStarted.html
网友centos7安装llvm，clang，lldb等给力脚本
https://github.com/owent-utils/bash-shell/blob/master/LLVM%26Clang%20Installer/3.9/installer.sh
生产环境(基于docker)故障排除？ 有感于博客园三番五次翻车
https://www.cnblogs.com/JulianHuang/p/11365593.html
③ 执行 ./createdump  -f  -u {PId} 命令导出coredump文件，默认生成 /tmp/coredump.%d dump文件，  使用Visual Studio 或者Windebug调试dump文件

容器中遇到的障碍
 .netcore app容器中需要有容器特权模式才能执行createdump命令， 否则会如下图错误


         ps：可通过在docker run 生成该容器时增加--privileged = true操作特权

  常规.netcore app容器内不包含ps命令， 难以明确容器内dotnet 进程PID

  容器内导出的coredump文件，还需要使用 docker cp 命令导出到docker 主机，再行调试。

针对容器内.NetCore app生产调试，国外大牛已经针对 .NetCore特定runtime版本制成了工具镜像

Analyze running container
　　以下假设待分析容器使用的.netcore runtime与6opuc/lldb-netcore 工具镜像内runtime 相同。

1.找到待分析容器id (docker ps)，例如： b5063ef5787c

2.运行包含createdump工具的容器（需要sys_admin,sys_ptrace特权）， 如果运行的容器已经包含这个特权，可附加待分析容器并在容器中执行createdump工具

docker run --rm -it --cap-add sys_admin --cap-add sys_ptrace --net=container:b5063ef5787c --pid=container:b5063ef5787c -v /tmp:/tmp 6opuc/lldb-netcore /bin/bash
 --net=container:b5063ef5787c 重用待分析容器的网络堆栈

--pid=container:b5063ef5787c 加入待分析容器的PID命名空间
Joining another container’s pid namespace can be used for debugging that container
3. 找到待分析dotnet进程PID:    px aux

4. 生成dotnet进程的 coredump文件，并退出容器

createdump -u -f  /tmp/coredump 7            # 7是dotnet进程id
exit
5. 使用debugger打开coredump文件

docker run --rm -it -v /tmp/coredump:/tmp/coredump 6opuc/lldb-netcore
  output：

复制代码
(lldb) target create "/usr/bin/dotnet" --core "/tmp/coredump"
Core file '/tmp/coredump' (x86_64) was loaded.
(lldb) plugin load /coreclr/libsosplugin.so
(lldb) sos PrintException
There is no current managed exception on this thread
(lldb)
复制代码
6. 在lldb shell ： help命令继续探索

　　lldb使用方式可参考https://docs.microsoft.com/en-us/dotnet/framework/tools/sos-dll-sos-debugging-extension

常见用例
该DockerHub Repo还提供了基于docker 生产故障排除的常见用例：

Process hang with idle CPU
Process hang with high CPU usage
Process crash
Excessive memory usage
这个镜像对于基于容器的故障排除相当有用，不敢自称原创镜像；