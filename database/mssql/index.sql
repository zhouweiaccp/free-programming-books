--删除主键
alter table 表名 drop constraint 主键名
--添加主键
--alter table 表名 add constraint 主键名 primary key(字段名1,字段名2……)

alter table [dms_instanceCfg125] add   CONSTRAINT [PK_DMS_INSTANCECFG125] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC,
	[cfg_name] ASC
)
