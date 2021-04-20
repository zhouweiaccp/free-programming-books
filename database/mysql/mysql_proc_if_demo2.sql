-- mysql中变量不用事前申明，在用的时候直接用“@变量名”使用就可以了。
-- 第一种用法：set @num=1; 或set @num:=1; //这里要使用变量来保存数据，直接使用@num变量
-- 第二种用法：select @num:=1; 或 select @num:=字段名 from 表名 where ……
-- 注意上面两种赋值符号，使用set时可以用“=”或“：=”，但是使用select时必须用“：=赋值”




DROP TABLE IF EXISTS bak20190812org_user20200407; 
--  新建中间表  
CREATE TABLE `bak20190812org_user20200407` (
`id` INT(11) NOT NULL AUTO_INCREMENT,

	`perm_docType` INT(11) NOT NULL ,
	`perm_docId` INT(11) NOT NULL ,
	
		`perm_permType` INT(11) NOT NULL ,
			`perm_memberType` INT(11) NOT NULL ,
		`perm_memberId` INT(11) NOT NULL ,
	PRIMARY KEY (`id`)
);


--  扩展信息不存在数据插入中间表中，，选 中执行下，时间比较长
INSERT into bak20190812org_user20200407(perm_docType,perm_docId,perm_permType,perm_memberType,perm_memberId)
select  perm_docType, perm_docId
, perm_permType, perm_memberType
, perm_memberId
from dms_docPermission 
where perm_docType=1 
GROUP BY perm_memberType,perm_memberId,perm_permType,perm_docId,perm_docType
having COUNT(perm_id)>1;


--   创健  procedure  并执行，，，下面一起选中，时间比较长  中间不要随便中断
DROP PROCEDURE IF EXISTS buy1; 
create procedure buy1()
begin
   declare t_perm_docType INT(11) default 0;
   declare t_perm_docId INT(11) default 0;
   declare t_perm_permType INT(11) default 0;
   declare t_perm_memberType INT(11) default 0;
   declare t_perm_memberId INT(11) default 0;
 
	 
  
   declare ii int default 1;
   declare ssum int default 0;
select  count(1) as t into ssum from bak20190812org_user20200407;
SELECT ssum;

while ii<=ssum do
           select  @t_perm_docType:=`perm_docType` ,
					 @t_perm_docId:=`perm_docId`,
					@t_perm_permType:= `perm_permType` ,
					 @t_perm_memberType:=`perm_memberType`  ,
					@t_perm_memberId:= `perm_memberId`   
					 from bak20190812org_user20200407 where id=ii;


--            select  @t_perm_docType:=`perm_docType` 
-- 					 from bak20190812org_user20200407 where id=ii;
-- 
--  log
 SELECT CONCAT('start..t_folder_name','a','b ',' ,t_perm_docType:',cast(@t_perm_docType as char),' t_perm_docId: ',cast(@t_perm_docId as char)) as step1;




set ii=ii+1;
   set  t_perm_docType=0;
--    set @t_perm_docId=0;
--    set @t_perm_permType=0;
--    set @t_perm_memberType=0;
--    set @t_perm_memberId=0;
end while;
end;
call buy1();