
- 算术运算符 (https://github.com/Melody12ab/db_mysql_note/blob/master/mysql_operator_and_func.md)

运算符 | 注解
----- | -----
  +   | 加法
  -   | 减法
  *   |乘法
  /   |除法，除数为0，返回结果NULL
  %   | 取商
  
- 比较运算符

运算符 | 注解
---|---
=   | 等于，不能用于NULL比较
<>或!=|不等于，不能用于NULL比较
<=> |NULL安全的等于，可用于NULL比较
<   |
<=  |
>   |
>=  |
BETWEEN|存在于指定范围（>= and <=）
IN  |存在于指定集合
IS NULL |
IS NOT NULL |
LIKE |模糊匹配（“*”匹配一个，“%”匹配多个）
REGEXP或RLIKE |正则匹配，用法类似于LIKE
>比较运算符可比较数字、字符串和表达式。数字作浮点数比较，字符串以不区分大小写的方式比较。

- 逻辑运算符

运算符 | 注解
---|---
NOT ！|非，但NOT NULL返回值为NULL
AND && | 与
OR || | 或
XOR | 异或

- 位运算符

运算符| 注解
---|---
&  |位于
\|  |位或
^ |位亦或
~ |位取反（~1）
>> |位右移
<< |位左移

##常用函数
- 字符串函数

函数 | 功能
---|---
CONCAT(S1,S2,...Sn) |连接S1,S2,...Sn字符串，于NULL连接返回NULL
INSERT(str,x,y,instr)|将字符串str从第x位置开始，y个字符长的字符串替换为字符串instr
LOWER(str)|转为小写
UPPER(str) |转为大写
LEFT(str,x)|返回str最左边的x个字符，第二个参数为NULL将不返回任何字符串
RIGHT(str,x)|最右边x个字符
LPAD(str,n,pad)|用字符串pad对str最左边进行填充，知道长度为n个字符
RPAD(str,n,pad)|对str最右边
LTRIM(str)|去掉字符串str左侧空格
RTRIM(str)|去掉右侧空格
REPEAT(str,x)|返回str重复x次结果
REPLACE(str,a,b)|用b替换str中所有出现的a
STRCMP(s1,s2)|比较s1和s2，比较ASCII码大小
TRIM(str)|去掉行尾和头的空格
SUBSTRING(str,x,y)|返回str从x起到y个字符字符串的长度

- 数值函数

函数| 功能
---|---
ABS(x)|绝对值
CEIL(x)|大于x的最小整数
FLOOR(x)|小于x的最大整数
MOD(x,y)|x/y的模
RAND() |0~1内随机值
ROUND(x,y)|四舍五入
TRUNCATE(x,y)|x截断为y位小数

- **日期和时间函数（重要）**

函数 | 功能
---|---
CURDATE()|当前日期
CURTIME()|当前时间
NOW()| 当前日期和时间
UNIX_TIMESTAMP(date)|日期date的UNIX时间戳
FROM_UNIXTIME(timestamp)|UNIX时间戳的日期值
WEEK(date)|返回date为一年中的第几周
YEAR(date)|date的年份
HOUR(time)|time的小时值
MINUTE(time)|time的分钟值
MONTHNAME(date)|date的月份名
DATE_FORMAT(date,fmt)| 格式化date
DATE_ADD(date,INTERVAL expr type)|一个日期或时间加上一个时间间隔的时间值
DATEDIFF(expr,expr2)|返回expr和expr2之间的天数

- mysql时间相加表达式类型 DATE_ADD(date,INTERVAL **expr** type)

表达式类型|描述|格式
---|---|---
HOUR|小时|hh
MINUTE|分|mm
SECOND|秒|ss
YEAR|年|YY
MONTH|月|MM
DAY|日|DD
YEAR_MONTH|年和月|YY_MM
DAY_HOUR|日和小时|DD hh
DAY_MINUTE|日和分钟| DD hh:mm
DAY_SECOND |日和秒 |DD hh:mm:ss
HOUR_MINUTE|小时和分|hh:mm
HOUR_SECOND|小时和秒|hh:ss
MINUTE_SECOND|分钟和秒|mm:ss
	
	select now() current,date_add(now(),INTERVAL 31 day) after31days,date_add(now(),INTERVAL '1_2' year_month) after_oneyear_twomonth;
	select now() current,date_add(now(),interval -31 day) after31days,date_add(now(),interval '-1_-2' year_month) after_oneyear_twomonth;
    SELECT CURDATE(),CURTIME(),VERSION(),USER(),MD5('str'),PASSWORD('str')


    -这种情况就可以创建视图：
   create view myview as select * from tname where id > 3242 and id < 45434;
 --在需要这个区间的数据的时候，直接读取视图即可：
   select *  from myview;
  
-- 修改视图 https://github.com/lyb411/mysql/blob/master/sql%E8%AF%AD%E5%8F%A5%E5%8F%88%E4%B8%80%E6%AC%A1%E6%80%BB%E6%80%BB%E7%BB%93%3D.sql
alter view myview as select * from myview;

--返回当期日期：curdate();
  select curdate();--//输出：2012-06-12
--返回当前时间：curtime();
  select curtime(); --输出：18:32:23
--返回当期完整日期：now();
  select now();--2012-03-21 14:23:23
--返回当期date的unlix时间戳
  select unix_timestamp();
--计算两个日期相差多少天
  select datediff('date1','date2');

--==数学函数
--十进制转换二进制：bin(int num)
  select bin(23232);--
--最大值：max，最小值：min，平均值：avg,求和：sum，条数：count 配合聚合才使用
--
--=====字符串函数
--连接字符串：concat(str1,str2,...)
  select * concat('aa','mm');--输出aamm
  select * concat('aa','mm') as str;--输出aamm
--将字符串转换为小写：lcase(str)
  select lcase('MYSQL-LYB');--输出：mysql-lyb
--将字符串转换为大写：ucase(str)
  select ucase('mysql-lyb');--输出：MYSQL-LYB
--得到字符串的长度：length(str);
  select length('linux very good');--输出：18
--去除左边空格：ltrim(str);
  select ltrim('  abc');--输出：abc
--去除右边空格：rtrim(str);
  select rtrim('  abc');--输出：abc
--重复某字符串次数：repeat(str,int num)
   select repeat('abc',3);--把abc重复3次输出，abcabcabc