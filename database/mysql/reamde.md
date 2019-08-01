* [mysqldba](https://github.com/zhishutech/mysqldba) MySQL DBA用得到的东西

##MySQL入门教程
https://github.com/jaywcjlove/mysql-tutorial

##mysqltools 权威指南
https://github.com/Neeky/mysqltools

##awesome-mysql
https://github.com/shlomi-noach/awesome-mysql


##中国5级行政区域mysql库
https://github.com/kakuilan/china_area_mysql


##基于canal 的 mysql 与 redis/memcached/mongodb 的 nosql 数据实时同步方案 案例 demo canal client
https://github.com/liukelin/canal_mysql_nosql_sync


##学习笔记
https://github.com/lyb411/mysql  mysql笔记、研究，常见问题


##如何选择合适存储引擎
(https://github.com/Melody12ab/db_mysql_note/blob/master/table_type_and_code.md)
MyISAM

以读和插入操作为主，只有很少跟新和删除，并对事务的完整性和并发性要求不高。

InnoDB

用于事务处理应用程序，支持外键。对事务和并发有要求，并且除了插入和查询还有不少更新和删除。

MEMORY

将所有数据放在RAM中，因此很快，但对大小有限制，用于更新不太频繁的小表。

MERGE

将MyISAM表组合，作为一个对象引用它们，可以突破对单个MyISAM表大小的限制。

##备份表
create table bak_11 like org_user
insert into bak_11 select * from org_user

#3. 增加新用户：grant select on db_name.* to user_name@login_host identified by 'user_password'     [https://github.com/ycrao/mynotes/blob/master/mysql/basic.md]
/* mysql grant命令添加用户常用的三种模式 */
grant all PRIVILEGES on *.* to 'test'@'localhost' identified by '123';
grant all PRIVILEGES on *.* to 'test'@'%' identified by '123';
grant all PRIVILEGES on *.* to 'test'@'10.22.225.18' identified by '123';
说明：
第一条命令添加一个本地用户 'test' ，一般用于web服务器和数据库服务器在一起的情况； 第二条命令添加一个用户 'test' ，只要能连接数据库服务器的机器都可以使用，这个比较危险，一般不用；
最后条命令在数据库服务器上给 '10.22.225.18' 机器添加一个用户'test'，一般用于web服务器和数据库服务器分离的情况。
注意：
真正使用的时候不会用 grant all PRIVILEGES on *.* ，而是根据实际需要设定相关的权限。 比如 grant select,insert,delete,update on test.* to 'test'@'localhost' identified by '123';

#6. 增加字段：alter table table_name [ add field_name field_type / other_sql_expression ]
在表 user 中添加了一个字段 user_pic ，类型为 varchar(40)，默认值为 NULL alter table user add user_pic varchar(40) default NULL;

加索引 alter table employee add index emp_name (name);

加主关键字的索引 alter table employee add primary key(id);

加唯一限制条件的索引 alter table employee add unique emp_name2(cardnumber);

删除某个索引 alter table employee drop index emp_name;

增加字段 alter table user add user_pic varchar(40) default NULL;

修改原字段名称及类型 ALTER TABLE table_name CHANGE old_field_name new_field_name field_type;

删除字段 ALTER TABLE table_name DROP field_name;

alter table tname modify id int unsigned not null AUTO_INCREMENT;--为id增加自增索引
alter table tname engine=innodb;--修改表引擎(将该表修改为innodb引擎)
alter table tname engine=myisam;--修改表引擎
alter table tname CHARSET=utf8;--修改表字编码
ALTER TABLE  tname ADD age INT NOT NULL AFTER  'uid';--添加一个字段，在tname表中的uid之后age字段，整型，不为空
ALTER TABLE  tname ADD age INT NOT NULL;--添加一个字段,默认添加到最后

#8.备份数据库：
① 导出整个数据库，导出文件默认是存在mysql\bin目录下 mysqldump -u user_name -p user_password db_name > new_db_name.sql

② 导出一个表 mysqldump -u user_name -p user_password database_name table_name > outfile_name.sql

③ 导出一个数据库结构 mysqldump -u user_name -puser_password -d -add-drop-table database_name > outfile_name.sql -d 没有数据 -add-drop-table 在每个 create 语句之前增加一个 drop table

④带语言参数导出 mysqldump -u user_name -p user_password -default-character-set=latin1 -set-charset=gbk -skip-opt database_name > outfile_name.sql

##[OUTFILE 用法](https://jingyan.baidu.com/article/e75057f238ad34ebc91a8932.html)
 -- select  user_account,user_id into outfile 'd:\\1.txt' from org_user 
SELECT   user_account,user_id,user_identityID,user_changeTime  FROM org_user INTO OUTFILE 'd:/t_user_2.txt'

FIELDS

TERMINATED BY ','

ENCLOSED BY '\"'

ESCAPED BY '\''

LINES

TERMINATED BY '\r\n';

##将daochu.sql 导入到mysql数据库：
在终端运行：mysql -h localhost -u root -p test < /home/chuzj/daochu.sql --default-character-set=utf8　

##MySql查看表的创建时间
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dvpsmsdb01' ORDER BY create_time DESC;