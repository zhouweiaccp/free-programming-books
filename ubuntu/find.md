find命令格式：
find   path  -option  【 -print 】  【 -exec   -ok   |xargs  |grep  】 【  command  {} \;  】

find命令的参数：

1）path：要查找的目录路径。 

      ~ 表示$HOME目录
       . 表示当前目录
       / 表示根目录 
2）print：表示将结果输出到标准输出。 

3）exec：对匹配的文件执行该参数所给出的shell命令。 
      形式为command {} \;，注意{}与\;之间有空格 

4）ok：与exec作用相同，
      区别在于，在执行命令之前，都会给出提示，让用户确认是否执行 

5）|xargs  与exec作用相同 ，起承接作用

区别在于 |xargs 主要用于承接删除操作 ，而 -exec 都可用 如复制、移动、重命名等

6）options ：表示查找方式

options常用的有下选项：

-name   filename               #查找名为filename的文件
-perm                                #按执行权限来查找
-user    username             #按文件属主来查找
-group groupname            #按组来查找
-mtime   -n +n                   #按文件更改时间来查找文件，-n指n天以内，+n指n天以前
-atime    -n +n                   #按文件访问时间来查找文件，-n指n天以内，+n指n天以前
-ctime    -n +n                  #按文件创建时间来查找文件，-n指n天以内，+n指n天以前
-nogroup                          #查无有效属组的文件，即文件的属组在/etc/groups中不存在
-nouser                            #查无有效属主的文件，即文件的属主在/etc/passwd中不存
-type    b/d/c/p/l/f             #查是块设备、目录、字符设备、管道、符号链接、普通文件
-size      n[c]                    #查长度为n块[或n字节]的文件
-mount                            #查文件时不跨越文件系统mount点
-follow                            #如果遇到符号链接文件，就跟踪链接所指的文件
-prune                            #忽略某个目录

下面通过一些简单的例子来介绍下find的常规用法： 

1、按名字查找 

      在当前目录及子目录中，查找大写字母开头的txt文件 
       $ find . -name '[A-Z]*.txt' -print 　　

      在/etc及其子目录中，查找host开头的文件 
      $ find /etc -name 'host*' -print 　　

      在$HOME目录及其子目录中，查找所有文件 　　
      $ find ~ -name '*' -print 

      在当前目录及子目录中，查找不是out开头的txt文件 　　
      $ find . -name "out*" -prune -o -name "*.txt" -print 

2、按目录查找 　　

      在当前目录除aa之外的子目录内搜索 txt文件 　　
      $ find . -path "./aa" -prune -o -name "*.txt" -print 　　

      在当前目录及除aa和bb之外的子目录中查找txt文件 　　
      $ find . −path′./dir0′−o−path′./dir1′−path′./dir0′−o−path′./dir1′ -a -prune -o -name '*.txt' -print



注意：在1、2处都需要加空格，否则会出现如图所示的报错

           在3处加不加 -a都可以

      在当前目录，不再子目录中，查找txt文件 
      $ find . ! -name "." -type d -prune -o -type f -name "*.txt" -print 

     或者   find . -name *.txt -type f -print


友情链接：Linux中find命令-path -prune用法详解

3、按权限查找 　　
      
      在当前目录及子目录中，查找属主具有读写执行，其他具有读执行权限的文件 　　
      $ find . -perm 755 -print 

      查找用户有写权限或者组用户有写权限的文件或目录
      find ./ -perm /220
      find ./ -perm /u+w,g+w
      find ./ -perm /u=w,g=w


4、按类型查找 　（b/d/c/p/l/f ）　

      在当前目录及子目录下，查找符号链接文件 　　
      $ find . -type l -print 

5、按属主及属组 　　

      查找属主是www的文件 　　
      $ find / -user www -type f -print 　　

      查找属主被删除的文件 
      $ find / -nouser -type f -print 　　

      查找属组 mysql 的文件 
      $ find / -group mysql -type f -print 　　

      查找用户组被删掉的文件 
      $ find / -nogroup -type f -print 

6、按时间查找 　　

      查找2天内被更改过的文件 
       $ find . -mtime -2 -type f -print 　　

      查找2天前被更改过的文件 
      $ find . -mtime +2 -type f -print 　　

      查找一天内被访问的文件 
      $ find . -atime -1 -type f -print 　　

      查找一天前被访问的文件 
      $ find . -atime +1 -type f -print 　　

      查找一天内状态被改变的文件 
      $ find . -ctime -1 -type f -print 　　

      查找一天前状态被改变的文件 
      $ find . -ctime +1 -type f -print 　　

      查找10分钟以前状态被改变的文件 
      $ find . -cmin +10 -type f -print 

7、按文件新旧 　　
      
      查找比 aa.txt 新的文件 
      $ find . -newer "aa.txt" -type f -print 　　

      查找比 aa.txt 旧的文件 
      $ find . ! -newer "aa.txt" -type f -print 　　

      查找比aa.txt新，比bb.txt旧的文件 
      $ find . -newer 'aa.txt' ! -newer 'bb.txt' -type f -print 

8、按大小查找 　　

      查找超过1M的文件 
      $ find / -size +1M -type f -print 　　

      查找等于6字节的文件 
      $ find . -size 6c -print 　　

      查找小于32k的文件 
      $ find . -size -32k -print 

9、执行命令 　　
      
      1）查找 del.txt 并删除，删除前提示确认 
      $ find . -name 'del.txt' -ok rm {} \; 　　

     2） 查找 aa.txt 并备份为aa.txt.bak 
      $ find . -name 'aa.txt' -exec cp {} {}.bak \;

     3）查当前目录下的所有普通文件

    # find . -type f -exec ls -l {} \; 
   -rw-r–r–    1 root      root         34928 2003-02-25   ./conf/httpd.conf 
   -rw-r–r–    1 root      root         12959 2003-02-25   ./conf/magic 
   -rw-r–r–    1 root      root          180 2003-02-25   ./conf.d/README 


   查当前目录下的所有普通文件，并在 - exec 选项中使用 ls -l 命令将它们列出


   4）在 /logs 目录中查找更改时间在5日以前的文件并删除它们
   $ find logs -type f -mtime +5 -exec   -ok   rm {} \;


   5）查询当天修改过的文件
   # find   ./   -mtime   -1   -type f   -exec   ls -l   {} \;


   6）查询文件并询问是否要显示


    # find   ./   -mtime   -1   -type f   -ok   ls -l   {} \;  
    < ls … ./classDB.inc.php > ? y
    -rw-r–r–    1 cnscn    cnscn       13709   1月 12 12:22 ./classDB.inc.php
    # find   ./   -mtime   -1   -type f   -ok   ls -l   {} \;  
    < ls … ./classDB.inc.php > ? n

关于 有没有 -print 的区别

加  -print

查找目录并列出目录下的文件(为找到的每一个目录单独执行ls命令，没有选项-print时文件列表前一行不会显示目录名称)
find /home -type d -print -exec ls {} \;



##  查找目录下所有config  中有url
find -type f -name 'config' | xargs cat {} \ |grep git |awk -F '=' '{print $2}'