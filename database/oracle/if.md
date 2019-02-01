create table t1 (t date);
declare
i int:=0; 
begin
 SELECT  count(1) into i from t1; 
dbms_output.put_line('x is less than10');
if i>10 THEN 
--dbms_output.put_line(i);
--DELETE FROM t1;
--truncate table t1;
execute immediate 'truncate table t1' ; 
end IF;
end;
