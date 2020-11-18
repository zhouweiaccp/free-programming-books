


## 安装crontab：
yum install crontabs

/sbin/service crond start //启动服务 
/sbin/service crond stop //关闭服务 
/sbin/service crond restart //重启服务 
/sbin/service crond reload //重新载入配置 

## 状态
service crond start //启动服务
service crond stop //关闭服务
service crond restart //重启服务
service crond reload //重新载入配置
service crond status //查看服务状态

 cat /etc/crontab
# SHELL=/bin/bash
# PATH=/sbin:/bin:/usr/sbin:/usr/bin
# MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
在以上各个字段中，还可以使用以下特殊字符：

星号（*）：代表所有可能的值，例如month字段如果是星号，则表示在满足其它字段的制约条件后每月都执行该命令操作。
逗号（,）：可以用逗号隔开的值指定一个列表范围，例如，“1,2,5,7,8,9”
中杠（-）：可以用整数之间的中杠表示一个整数范围，例如“2-6”表示“2,3,4,5,6”
正斜线（/）：可以用正斜线指定时间的间隔频率，例如“0-23/2”表示每两小时执行一次。同时正斜线可以和星号一起使用，例如*/10，如果用在minute字段，表示每十分钟执行一次。


## cron服务提供crontab命令来设定cron服务的

crontab -u //设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数 
crontab -l //列出某个用户cron服务的详细内容 
crontab -r //删除某个用户的cron服务 
crontab -e //编辑某个用户的cron服务  

// 每天早上6点 
0 6 * * * echo "Good morning." >> /tmp/test.txt

// 每两个小时 
0 */2 * * * echo "Have a break now." >> /tmp/test.txt 

// 每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点 
0 11 4 * 1-3 command line 

// 1月1日早上4点
0 4 1 1 * command line 

30 21 * * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每晚的21:30重启lighttpd 。

45 4 1,10,22 * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每月1、10、22日的4 : 45重启lighttpd 。

10 1 * * 6,0 /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每周六、周日的1 : 10重启lighttpd 。

0,30 18-23 * * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示在每天18 : 00至23 : 00之间每隔30分钟重启lighttpd 。

0 23 * * 6 /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每星期六的11 : 00 pm重启lighttpd 。

* */1 * * * /usr/local/etc/rc.d/lighttpd restart
每一小时重启lighttpd

* 23-7/1 * * * /usr/local/etc/rc.d/lighttpd restart
晚上11点到早上7点之间，每隔一小时重启lighttpd

0 11 4 * mon-wed /usr/local/etc/rc.d/lighttpd restart
每月的4号与每周一到周三的11点重启lighttpd

0 4 1 jan * /usr/local/etc/rc.d/lighttpd restart
一月一号的4点重启lighttpd


每隔两天的上午8点到11点的第3和第15分钟执行

3,15 8-11 */2 * * command
每个星期一的上午8点到11点的第3和第15分钟执行

3,15 8-11 * * 1 command
每晚的21:30重启smb 

30 21 * * * /etc/init.d/smb restart
每月1、10、22日的4 : 45重启smb 

45 4 1,10,22 * * /etc/init.d/smb restart
每周六、周日的1 : 10重启smb

10 1 * * 6,0 /etc/init.d/smb restart
每天18 : 00至23 : 00之间每隔30分钟重启smb 

0,30 18-23 * * * /etc/init.d/smb restart
每星期六的晚上11 : 00 pm重启smb

0 23 * * 6 /etc/init.d/smb restart
 每一小时重启smb

* */1 * * * /etc/init.d/smb restart
 晚上11点到早上7点之间，每隔一小时重启smb

* 23-7/1 * * * /etc/init.d/smb restart
 每月的4号与每周一到周三的11点重启smb

0 11 4 * mon-wed /etc/init.d/smb restart
 一月一号的4点重启smb

0 4 1 jan * /etc/init.d/smb restart
每小时执行/etc/cron.hourly目录内的脚本

01 * * * * root run-parts /etc/cron.hourly
————————————————
版权声明：本文为CSDN博主「沈安心」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_22172133/java/article/details/81263736