
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