




## link
- [lttng](https://lttng.org/features/)
- [使用LTTng链接内核和用户空间应用程序追踪](https://blog.csdn.net/longerzone/article/details/12623359)
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()




一、LTTng简介
      LTTng: (Linux Trace Toolkit Next Generation),它是用于跟踪 Linux 内核、应用程序以及库的系统软件包。LTTng 主要由内核模块和动态链接库(用于应用程序和动态链接库的跟踪)组成。它由一个会话守护进程控制,该守护进程接受来自命令行接口的命令。babeltrace 项目允许将追踪信息翻译成用户可读的日志,并提供一个读追踪库,即 libbabletrace。


        LTTng 不仅使用了 Linux 内核中的追踪点(tracepoint)手段,而且可以使用其他各种信息来源,比如kprobes 和 Perf(Linux 中的性能监检测工具)。这对于调试大范围内的bug 是非常有用的,否则这种调试工作将极具挑战性。比如,包括并行系统和实时系统中的性能问题。另外,用户自己定制的工具也可以加入到其中。LTTng 的设计目标是将性能影响最小化,而且在没有跟踪的情况下,对系统的影响应该几乎为零。



        LTTng如今已支持多个发行版（Ubuntu/Dibian、Fedora、OpenSUSE、Arch etc.）和多种架构（x86 and x86-64 、ARM 、PowerPC, Sparc, Mips etc.），此外官方还说支持Android和FreeBSD系统。

更多相关知识参见： 《使用LTTng链接内核和用户空间应用程序追踪》

 

二、LTTng使用实战 -- 安装
2.0 LTTng需要的内核配置（通过读取LTTng-module文档中的README了解）

必选配置： 

CONFIG_MODULES   内核模块支持
CONFIG_KALLSYMS   查看wrapper/ 文件。 
CONFIG_HIGH_RES_TIMERS  高精度时钟，LTTng2.0的时钟源 
CONFIG_TRACEPOINTS  内核追踪点


可选配置（下面的内核配置会影响LTTng的特性）：

CONFIG_HAVE_SYSCALL_TRACEPOINTS:  
            系统调用追踪：
               lttng enable-event -k --syscall
               lttng enable-event -k -a
CONFIG_PERF_EVENTS:             lttng add-context -t perf:*
CONFIG_EVENT_TRACING:
            事件追踪，块层的追踪
CONFIG_KPROBES                      lttng enable-event -k --probe ...
CONFIG_KRETPROBES               lttng enable-event -k --function ...



2.1  Ubuntu  :
从Ubuntu 12.04开始，LTTng的包可以直接从包管理器的仓库里找到，所以安装变得非常简单：
                 sudo apt-get install lttng-tools
对于其他版本，需要添加PPA才能使用包管理器安装（https://launchpad.net/~lttng/+archive/ppa）：
                $ sudo apt-add-repository ppa:lttng/ppa
                $ sudo apt-get update
                $ sudo apt-get install lttng-tools lttng-modules-dkms babeltrace

2.2 Fedora:
从 Fedora 17开始, UST 和工具包也可以使用yum直接安装：
                $ sudo yum install lttng-tools
但是你需要手动的编译lttng模块。（从官网下载一个lttng-modules-***.tar.bz2）
# tar xvf lttng-modules-2.3.2.tar.bz2 
# cd lttng-modules-2.3.2
# vim README --- > 通过读README学习如何安装
# make
# make modules_install
# depmod -a

2.3 OpenSUSE（或者其他的使用rpm包的Linux发行版）的RPM包：
https://build.opensuse.org/project/show?project=devel%3Atools%3Alttng


2.4 Arch Linux:
https://aur.archlinux.org/packages.php?O=0&K=lttng&do_Search=Go

 

三、LTTng使用实战 -- 内核追踪
 

首先我们得确认你是否已经安装了lttng-modules 和lttng-tools。

 

3.1  内核追踪
列出所有的可追踪内核事件:
# lttng list -k
Kernel events:
-------------
     timer_init (loglevel: TRACE_EMERG (0)) (type: tracepoint)
     timer_start (loglevel: TRACE_EMERG (0)) (type: tracepoint)
     timer_expire_entry (loglevel: TRACE_EMERG (0)) (type: tracepoint)
 ……



3.2 创建一个追踪会话（session），这个命令会创建一个目录用以存放追踪结果：
 

                 # lttng create mysession
                Session mysession created.
                Traces will be written in /home/dslab/lttng-traces/mysession-20131010-145153

假如你当前已经有了很多的会话，我们可以设置当前追踪会话：

# lttng set-session myothersession
Session set to myothersession


3.3 创建追踪规则（探测点/系统调用 etc.）
1) 追踪内核所有的探测点和所有的系统调用事件(-k/--kernel)：
# lttng enable-event -a -k

2)  追踪探测点事件，这里我们追踪 sched_switch和sched_wakeup为例 (-k/--kernel) 。

 

# lttng enable-event sched_switch,sched_wakeup -k
或者追踪所有的探测点事件：
# lttng enable-event -a -k --tracepoint

3) 追踪所有的系统调用：
# lttng enable-event -a -k --syscall


4) 使用 kprobes 以及 （或） 其他追踪器作为lttng的源：
这是一个LTTng2.0内核追踪器的一个新特性，你可以使用一个动态probe作为源，probe的追踪结果会显示在lttng的追踪结果中。

# lttng enable-event aname -k --probe symbol+0x0
or
# lttng enable-event aname -k --probe 0xffff7260695
可以为probe制定一个准确的地址0xffff7260695或者 symbol+offset。

你也可以使用功能追踪（使用的Ftrace API），追踪结果也会显示在lttng的追踪结果中：

# lttng enable-event aname -k --function <symbol_name>


5) 打开一个事件的上下文信息：
这也是一个新特性，可以让你添加一个事件的上下文信息。比如说你可以添加PID：

# lttng add-context -k -e sched_switch -t pid
你也可以使用多个上下文信息：
# lttng add-context -k -e sched_switch -t pid -t nice -t tid

你可以使用' lttng add-context --help ' 学习所有的上下文格式的用法。

6) 打开事件的Perf计数器： 
这也是一个新的很强大的特性，为每个追踪的事件添加Perf计数器数据（使用Perf的API）。下面实例为为每个事件添加CPU周期：
# lttng add-context -k -e sched_switch -t perf:cpu-cycles

注： 你需要使用 add-context 的help学习所有的perf计数器值的含义。


3.4 开始追踪：
# lttng start

追踪结果会写到上面创建会话时创建的文件夹中。比如上面的 ：/home/dslab/lttng-traces/mysession-20131010-145153

注意：这个命令会打开所有的追踪，如果你想同时追踪用户空间和内核空间，你在使用这个之前需要设置好所有的追踪规则。


3.5 停止追踪：
# lttng stop

注：在这时候，你可一使用 lttng start 重新追踪，也可以打开/关闭某个事件或者隔段时间再来追踪。当然你也可以查看追踪信息。

 



3.6 关闭追踪（你的追踪工作已经结束）
# lttng destroy 

 


四、LTTng使用实战 -- 用户空间追踪
待以后添加。

 

五、LTTng使用实战 -- 追踪数据分析
5.1 分析工具 -- babeltrace
 

babeltrace是lttng tools中自带的分析工具，很强大。我们可以直接使用babeltrace打开追踪数据，比如上面提到的 /home/dslab/lttng-traces/mysession-20131010-145153。

我们先查看下这个追踪结果下的结构：

# tree /home/dslab/lttng-traces/mysession-20131010-145153
 

/home/dslab/lttng-traces/mysession-20131010-145153
└── kernel
    ├── channel0_0
    ├── channel0_1
    ├── channel0_2
    ├── channel0_3
    └── metadata

可以看出来追踪目录下只有一个目录，叫做kernel，所以……如果追踪前也打开了用户追踪，那么这里面还会多个追踪目录（用户空间的）。kernel目录下分几个文件保存追踪数据。但是我们使用babeltrace查看追踪结果时不能指定到具体的文件，需要指定到kernel。

# babeltrace /home/dslab/lttng-traces/mysession-20131010-145153

[13:09:27.585271256] (+?.?????????) Raring-Ringtail sys_geteuid: { cpu_id = 2 }, { }
[13:09:27.585273674] (+0.000002418) Raring-Ringtail exit_syscall: { cpu_id = 2 }, { ret = 0 }
[13:09:27.585275886] (+0.000002212) Raring-Ringtail sys_pipe: { cpu_id = 2 }, { fildes = 0xB6588B84 }
[13:09:27.585283170] (+0.000007284) Raring-Ringtail exit_syscall: { cpu_id = 2 }, { ret = 0 }
……

如果我们将babeltrace的输出信息输出到一个文件中，比如# babeltrace /home/dslab/lttng-traces/mysession-20131010-145153 > /tmp/trace 。我们就可以使用shell脚本获取/tmp/trace中的追踪数据并进一步分析。

https://www.cnblogs.com/suncoolcat/p/3366045.html