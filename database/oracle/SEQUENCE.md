你首先要有CREATE SEQUENCE或者CREATE ANY SEQUENCE权限， 
CREATE SEQUENCE emp_sequence 
INCREMENT BY 1 -- 每次加几个 
START WITH 1 -- 从1开始计数 
NOMAXvalue -- 不设置最大值 
NOCYCLE -- 一直累加，不循环 
CACHE 10; --设置缓存cache个序列，如果系统down掉了或者其它情况将会导致序列不连续，也可以设置为---------NOCACHE

create sequence S_S_DEPART
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;


SELECT S_S_DEPART.Nextval FROM DUAL; 


--Alter sequence 的例子 
==DROP SEQUENCE order_seq;