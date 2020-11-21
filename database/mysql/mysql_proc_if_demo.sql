-- 操作说明，1.备份好数据库，2执行sql， 3.重启服务
-- 功能 部分用户没有创建个人内容库，org_metadata 关系不存在

DROP TABLE IF EXISTS bak20190812org_user20200407; 
--  新建中间表  
CREATE TABLE `bak20190812org_user20200407` (
`id` INT(11) NOT NULL AUTO_INCREMENT,
	`user_identityID` INT(11) NOT NULL ,
	`user_account` VARCHAR(255) NOT NULL,
	`TopPersonalFolderId` INT(11),
	`FavoriteId` INT(11),
	`user_id` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`id`)
);


--  扩展信息不存在数据插入中间表中，，选 中执行下，时间比较长
INSERT into bak20190812org_user20200407(user_identityID,user_account,TopPersonalFolderId,FavoriteId,user_id)
select t.user_identityid,t.user_account,0 TopPersonalFolderId,0 FavoriteId, t.user_id from (
SELECT a.user_identityid, a.user_id,a.user_account,b.meta_values,b.meta_id from org_user a LEFT JOIN org_metadata b on a.user_id=b.meta_objectId
)t where LOCATE('TopPersonalFolderId',t.meta_values)=0 ORDER BY t.user_account;


--   创健  procedure  并执行，，，下面一起选中，时间比较长  中间不要随便中断
DROP PROCEDURE IF EXISTS buy1; 
create procedure buy1()
begin
   declare t_folder_name   varchar(64) DEFAULT '';
   declare t_user_account   varchar(64) DEFAULT '';
   declare t_user_identityID int default 0;
 declare t_user_ID   VARCHAR(64) DEFAULT '';
  declare t_folderid int default 0;
   declare t_num int default 0;

   declare ii int default 1;
   declare ssum int default 0;
 --  declare e tinyint(1) default 0;
  -- declare continue handler for SQLEXCEPTION set e=1;
-- SELECT replace(uuid(), '-', '');
select  count(1) as t into ssum from bak20190812org_user20200407;
SELECT ssum;

while ii<=ssum do
           select  user_account,user_identityID ,user_id into t_user_account,t_user_identityID, t_user_ID from bak20190812org_user20200407 where id=ii;
-- select t_user_account,t_user_identityID ;
set t_folderid:=0;
set t_folder_name:=CONCAT(t_user_account,'_',cast(t_user_identityID as char));
SELECT folder_id into t_folderid from  dms_folder where folder_parentFolderId=2 and folder_name=t_folder_name;

--  log
SELECT CONCAT('start..t_folder_name',t_folder_name,' ',t_user_account,' ',cast(t_folderid as char),'  ',t_user_ID) as step1;

--   查询文件id
IF t_folderid=0 THEN
INSERT into dms_folder (`instance_id`,`folder_name` ,`area_id`,`folder_parentFolderId` ,`folder_path`,`folder_createTime`,`folder_modifyTime`,`folder_createOperator`  ,`folder_modifyOperator`,	`folder_ownerId`,	`folder_size`,`folder_type`,`folder_code`)
SELECT 1 instance_id, t_folder_name folder_name,2 area_id,2  folder_parentFolderId,'2\\' folder_path,now() folder_createTime,NOW() folder_createTime,t_user_identityID as folder_createOperator,t_user_identityID as folder_modifyOperator,t_user_identityID folder_ownerId,1073741824 folder_size,1 folder_type,replace(uuid(), '-', '') as folder_code ;

--  log
 SELECT CONCAT('start..t_folder_name-1',t_folder_name,cast(t_folderid as char)) as step2;

SELECT folder_id into t_folderid from  dms_folder where folder_parentFolderId=2 and folder_name=t_folder_name;
UPDATE dms_folder set folder_path=CONCAT('2\\',cast(t_folderid as char)) where  folder_parentFolderId=2 and folder_name=t_folder_name;
end if;
--   查询文件id 结束
SELECT CONCAT('start..t_folder_name-ok,start org_metadata',t_folder_name,cast(t_folderid as char))as step2;
set t_num=0;
-- org_metadata TopPersonalFolderId
SELECT count(1) as a into t_num from org_metadata where meta_objectid =t_user_ID and LOCATE('TopPersonalFolderId', meta_values)>0; 

-- SELECT CONCAT('start..t_folder_name-ok,start org_metadata',t_folder_name,'__',cast(t_num as char))as step20;
 IF t_num=0 THEN 
-- SELECT CONCAT('start..t_folder_name-ok,start org_metadata',t_folder_name,cast(t_folderid as char))as step3;
 update org_metadata set meta_values= CONCAT('{"Configuration":{"language":"zh-cn"},','"EDoc2Extension":{"EnableOfflineSecurity":"false","EnablePersonFolder":"true","Speed":"","TopPersonalMaxFolderSize":"1024","FavoriteId":0,"TopPersonalFolderId":',cast(t_folderid as CHAR),'}}')  WHERE  meta_objectid =t_user_ID ;
 -- update org_metadata set meta_values= CONCAT(SUBSTRING('meta_values',1,LENGTH('meta_values')-1),'"EDoc2Extension":{"EnableOfflineSecurity":"false","EnablePersonFolder":"true","Speed":"","TopPersonalMaxFolderSize":"1024","FavoriteId":0,"TopPersonalFolderId":',cast(t_folderid as CHAR),'}}')  WHERE  meta_objectid =t_user_ID ;
 end if;

set ii=ii+1;
set t_folder_name='';

end while;
end;
call buy1();