* [mysqldba](https://github.com/zhishutech/mysqldba) MySQL DBA用得到的东西


##备份表
create table bak_11 like org_user
insert into bak_11 select * from org_user