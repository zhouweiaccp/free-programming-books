--ɾ������
alter table ���� drop constraint ������
--�������
--alter table ���� add constraint ������ primary key(�ֶ���1,�ֶ���2����)

alter table [dms_instanceCfg125] add   CONSTRAINT [PK_DMS_INSTANCECFG125] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC,
	[cfg_name] ASC
)
