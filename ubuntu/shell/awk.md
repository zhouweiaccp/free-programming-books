# awk
**1** awk是一个强大的文本分析工具，相对于grep的查找，sed的编辑，awk在其对数据分析并生成报告时，显得尤为强大


## 使用方法   ： awk '{pattern + action}' {filenames}

## awk内置变量
ARGC               命令行参数个数
ARGV               命令行参数排列
ENVIRON            支持队列中系统环境变量的使用
FILENAME           awk浏览的文件名
FNR                浏览文件的记录数
FS                 设置输入域分隔符，等价于命令行 -F选项
NF                 浏览记录的域的个数----列的信息
NR                 已读的记录数--------行号
OFS                输出域分隔符
ORS                输出记录分隔符
RS                 控制记录分隔符
$0变量是指整条记录。$1表示当前行的第一个域,$2表示当前行的第二个域,......以此类推。
$NF是number finally,表示最后一列的信息，跟变量NF是有区别的，变量NF统计的是每行列的总数



## 统计/etc/passwd:文件名，每行的行号，每行的列数，对应的完整行内容:
awk -F: '{printf ("filename:%10s, linenumber:%3s,column:%3s,content:%3f\n",FILENAME,NR,NF,$0)}' /etc/passwd

## 打印/etc/passwd/的第二行信息
awk -F: 'NR==2{print "filename: "FILENAME, $0}' /etc/passwd

## awk的过滤使用方法
ls -lF | awk '/^d/'

## 指定特定的分隔符，查询第一列
awk -F ":" '{print $1}' /etc/passwd

## 指定特定的分隔符，查询最后一列
awk -F ":" '{print $NF}' /etc/passwd

## 指定特定的分隔符，查询倒数第二列
awk -F ":" '{print $NF-1}' /etc/passwd

## 获取第12到31行的第一列的信息
awk -F ":"  '{if(NR<31 && NR >12) print $1}' /etc/passwd

## 添加了BEGIN和END
cat /etc/passwd | awk -F: 'BEGIN{print "name, shell"} {print $1,$NF} END{print "hello  world"}'


## 查看最近登录最多的IP信息
last | awk '{S[$3]++} END{for(a in S ) {print S[a],a}}' |uniq| sort -rh

## 利用正则过滤多个空格
ifconfig |grep eth* | awk -F '[ ]+' '{print $1}'


# awk编程--变量和赋值
***除了awk的内置变量，awk还可以自定义变量, awk中的循环语句同样借鉴于C语言，支持while、do/while、for、break、continue，这些关键字的语义和C语言中的语义完全相同**


## 统计某个文件夹下的大于100k文件的数量和总和
【因为awk会轮询统计，所以会显示整个过程】
ls -l|awk '{if($5>100){count++; sum+=$5}} {print "Count:" count,"Sum: " sum}' 
【天界END后只显示最后的结果】
ls -l|awk '{if($5>100){count++; sum+=$5}} END{print "Count:" count,"Sum: " sum}' 


## 统计显示/etc/passwd的账户
awk -F ':' 'BEGIN {count=0;} {name[count] = $1;count++;}; END{for (i = 0; i < NR; i++) print i, name[i]}' /etc/passwd