<!--  
create procedure my_procedure() -- 创建存储过程  
begin -- 开始存储过程  
declare my_user_id varchar(48); -- '唯一标识,用户id',
declare my_login_code varchar(64); -- '账号',

declare done int default false; -- 自定义控制游标循环变量,默认false  

declare my_cursor cursor for ( select  user_account,user_id from org_user ); -- 定义游标并输入结果集  
declare continue handler for not found set done = true; -- 绑定控制变量到游标,游标循环结束自动转true  

open my_cursor; -- 打开游标  
  myloop: loop -- 开始循环体,myloop为自定义循环名,结束循环时用到  
    fetch my_cursor into my_user_id,my_login_code; -- 将游标当前读取行的数据顺序赋予自定义变量12  
    if done then -- 判断是否继续循环  
      leave myloop; -- 结束循环  
    end if;  
    -- 自己要做的事情,在 sql 中直接使用自定义变量即可  
   -- insert into sp_user values(my_user_id,my_login_code); -- 左右去空格  
    SELECT my_user_id,my_login_code;
-- SELECT my_user_id,my_login_code  into outfile 'd:\\resulsst.txt';
    commit; -- 提交事务  
  end loop myloop; -- 结束自定义循环体  
  close my_cursor; -- 关闭游标  
end; -- 结束存储过程  

call my_procedure();  

drop procedure my_procedure;  -->


create procedure test()
    begin
        declare a int default 5;
        declare b int default 6;
        declare c int default 0;
        set c=a+b;
        select c as num;
    end;
call test();


create procedure oshu()
    begin
        declare i int default 1;
        while i<11 do
            if i%2 = 0  then
                select i;
            end if;
            set i=i+1;
        end while;
    end;
call oshu();
