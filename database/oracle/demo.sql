---功能 每一分钟同步一次数据

CREATE TABLE DMS_MAIL_SYNC_LOG_ORACLEJOB
(
t date
);
--drop TABLE DMS_MAIL_SYNC_LOG;
CREATE TABLE DMS_MAIL_SYNC_LOG
(
    "ID" Number(4) NOT NULL,
"maiid" NVARCHAR2(60) NOT NULL ,
  "file_id" NUMBER NULL ,
 "FormAddr" VARCHAR2(255 BYTE) NOT NULL ,
    "c_status" NVARCHAR2(5),
    "update_date" timestamp NOT NULL
);
create sequence seq_DMS_MAIL_SYNC_LOG
minvalue 1        --最小值
nomaxvalue        --不设置最大值
start with 1      --从1开始计数
increment by 1    --每次加1个
nocycle           --一直累加，不循环
nocache;          --不建缓冲区
--DMS_MAIL_SYNC_LOG.nextval   作为主键插入值


----2.
create or replace procedure UPDATE_DMS_MAILARCHMETA
IS
BEGIN
--For 循环游标
--（1）定义游标
--（2）定义游标变量
--（3）使用for循环来使用这个游标
declare cursor c_job
       is
      select a."opertype",a."maiid",a."file_id", a."FormAddr",b."c_tenantid",b."c_tenantname"  
      from DMS_MAILARCHMETA   a left JOIN PPOS_P_V_PPOS_USERINFO_ALL   b on a."FormAddr"=b."c_email" 
       where a."opertype"=1 and ROWNUM<=20;
       --定义一个游标变量v_cinfo c_emp%ROWTYPE ，该类型为游标c_emp中的一行数据类型
       c_row c_job%rowtype;
begin
INSERT into DMS_MAIL_SYNC_LOG_ORACLEJOB(t) VALUES(sysdate);
       for c_row in c_job loop
           dbms_output.put_line(c_row."FormAddr"||'-'||c_row."maiid"||'-'||c_row."c_tenantid"||'-'||c_row."c_tenantname");
--dbms_output.put_line(c_row."FormAddr"||'-'||c_row."maiid");

---log
INSERT INTO DMS_MAIL_SYNC_LOG
		("ID"
		,"maiid"
		,"file_id"
		,"FormAddr"
		,"c_status"
		,"update_date")	VALUES	(seq_DMS_MAIL_SYNC_LOG.nextval,c_row."maiid"	,c_row."file_id",c_row."FormAddr",c_row."opertype",sysdate);

--update table DMS_MAILARCHMETA
UPDATE DMS_MAILARCHMETA set "opertype"=2,"customerOpertime"=SYSDATE where "maiid"=c_row."maiid";
--COMMENT;
       end loop;
end c_job;END UPDATE_DMS_MAILARCHMETA;

----------------3.计划任务
declare
  job number;
BEGIN
  DBMS_JOB.SUBMIT(  
        JOB => job,  /*自动生成JOB_ID*/  
        WHAT => 'UPDATE_DMS_MAILARCHMETA;',  /*需要执行的存储过程名称或SQL语句*/  
        NEXT_DATE => sysdate+3/(24*60),  /*初次执行时间-下一个3分钟*/  
        INTERVAL => 'trunc(sysdate,''mi'')+1/(24*60)' /*每隔1分钟执行一次*/
      );  
  commit;
  dbms_output.put_line(job);
   DBMS_JOB.RUN(job); 
end;

SELECT * from DMS_MAIL_SYNC_LOG_ORACLEJOB;