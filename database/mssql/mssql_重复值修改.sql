
 -- 唯一列 重复值删除
if object_id('temp_table','U') is not null 
drop table temp_table
print 'drop ok'
go

create table temp_table(
id int identity(1,1),
dept_code varchar(50)
)
go 
insert into temp_table (dept_code) select dept_code  from [org_department]   group by dept_code having count(1)>1  
declare @i int;
declare @count int;
declare @dept_code varchar(50);
set @count=0
set @i=0
set @dept_code=''


select @count=COUNT(1) from temp_table
print @count

if @count = 0
begin
print 'no  repeat code'
end

while @i<@count
begin
set @i+=1
select @dept_code=dept_code  from temp_table where id= @i
print @dept_code+'   '
-- һ���ظ�
 update  [org_department] set dept_code='new'+cast(@i as varchar(10)) where dept_id=( select top 1  dept_id  from [org_department] where  dept_code=@dept_code)


end
go

select  dept_code from [org_department] group by dept_code having count(1)>1  

--select * from temp_table