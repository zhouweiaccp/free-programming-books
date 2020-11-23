-- 1.登录MySQL
-- 
-- mysql -u root -p 
-- 2.添加新用户（允许所有ip访问)
-- 
create user 'testuser'@'%' identified by '123456';
-- #testuser:用户名，%：所有ip地址，123456：密码

-- 3.创建数据库
CREATE DATABASE test_db  DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
-- 4.为新用户分配权限
grant all privileges on `test_db`.* to 'testuser'@'%' identified by '123456'; 
-- #授权给用户testuser，数据库test_db相关的所有权限，并且该用户test在所有网络IP上都有权限，%是指没有网络限制
-- GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON TUTORIALS.* TO 'zara'@'localhost' IDENTIFIED BY 'zara123';
-- #分配特定的权限

-- 5.刷新权限
flush privileges;
 
-- 
-- 6. 修改用户的IP访问权限
-- 
-- use mysql;
-- update user set host = '%' where user ='testuser';
-- 7. 授予管理员权限
-- 
-- grant all privileges on *.* to 'dba'@'1.2.3.4' IDENTIFIED BY 'mypassword' with grant option;
-- 授予用户dba访问所有库和表的权限，*.* 第一个*是所有的库，第二个*是所有的表
-- 
-- 1.2.3.4是可以访问的IP地址，
-- 
-- with grant option是指允许用户dba，传递其拥有的权限给其他的用户
-- 
-- 8. 授予只读权限
-- 
-- grant select on *.* to 'select_only_user'@'%' IDENTIFIED BY 'your_password';
-- 授予用户select_only_user 所有库和表的select 权限
-- 
-- 9. 收回权限
-- 
-- revoke insert on *.* from 'someone'@'%';
-- 收回用户someone的所有库和表的插入权限
-- 
-- revoke跟grant语法差不多，只需要把关键字 “to” 换成 “from” 即可，并且revoke语句中不需要跟密码设置。
-- 注意：revoke可以回收所有权限，也可以回收部分权限。
-- 
-- 10. 要废掉已经拥有的with grant option权限
-- 
-- revoke grant option on *.* from somebody;
-- 11. 授予很多的权限
-- 
-- grant insert,select,update on test_db.test_tbl to someone@'localhost' identified by '123456';
-- grant 权限列表 on 数据库名.数据表名 to '用户名'@'主机' identified by '密码' with grant option;