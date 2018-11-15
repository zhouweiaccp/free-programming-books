https://blog.csdn.net/duduyuxiaonuo/article/details/79009837

实验数据准备：
 CREATE TABLE plch_employees
(
   employee_id   INTEGER
, department_id INTEGER
, last_name     VARCHAR2 (20)
, salary        NUMBER
);
BEGIN
   INSERT INTO plch_employees
        VALUES (100, 100, 'Jobs', 200000);
 
   INSERT INTO plch_employees
        VALUES (200, 200, 'Ellison', 300500);
 
   INSERT INTO plch_employees
        VALUES (300, 100, 'Gates', 199500);
 
   INSERT INTO plch_employees
        VALUES (400, 200, 'Feuerstein', 199400);
 
   INSERT INTO plch_employees
        VALUES (500, 200, 'Hansen', 200600);
 
   COMMIT;
END;


多行转字符串
使用||或concat函数可以实现

select 
CONCAT(CONCAT(last_name, '''s job department is '), department_id) 
from plch_employees;
字符串转多列
实际上就是拆分字符串的问题，可以使用 substr、instr、regexp_substr函数方式

wm_concat函数:
函数wm_concat(列名),该函数可以把列值以","号分隔起来,并显示成一行

 SELECT wm_concat(LAST_NAME) FROM PLCH_EMPLOYEES;

把结果里的逗号替换成"|"
 SELECT 
    REPLACE(wm_concat(LAST_NAME),',','|') as lastnames 
FROM PLCH_EMPLOYEES;


按部门分组合并name

 SELECT DEPARTMENT_ID,wm_concat(LAST_NAME) as lastnames 
FROM PLCH_EMPLOYEES 
GROUP BY DEPARTMENT_ID;

懒人扩展用法:
我要写一个视图,类似"create or replace view as select 字段1,...字段50 from tablename" ,基表有50多个字段,要是靠手工写太麻烦了,有没有什么简便的方法? 当然有了,看我如果应用wm_concat来让这个需求变简单。查询结果如下:
select 
  'CREATE OR REPLACE VIEW AS SELECT ' ||
  WMSYS.WM_CONCAT(COLUMN_NAME) || 
  ' FROM PLCH_EMPLOYEES ;' sqlstr 
from 
  user_tab_columns 
where 
  TABLE_NAME = 'PLCH_EMPLOYEES';


行列转换：

pivot

 

语法：

 SELECT ...
FROM   ...
PIVOT [XML]
   ( pivot_clause
     pivot_for_clause
     pivot_in_clause )
WHERE  ...

pivot_clause: defines the columns to be aggregated (pivot is an aggregate operation);这个是指定我们的聚合函数
pivot_for_clause: defines the columns to be grouped and pivoted;指定我们需要将行转成列的字段

pivot_in_clause: defines the filter for the column(s) in the pivot_for_clause (i.e. the range of values to limit the results to). The aggregations for each value in the pivot_in_clause will be transposed into a separate column (where appropriate).对pivot_for_clause 指定的列进行过滤，只将指定的行转成列。

数据

 

查询每个部门有多少名员工赚的钱少于2500，以及有多少人多于或等于2500

SELECT * FROM
  (SELECT DEPTNO , CASE when sal > 2500 then 'MORE' else 'LESS' end salary_category FROM EMP)
PIVOT 
  (COUNT(1) FOR salary_category IN ('LESS','MORE'))
;


查询每个部门每个job总工资

 select * from(
  SELECT DEPTNO , SAL,JOB FROM EMP
)
PIVOT (
  SUM(SAL) FOR JOB IN (
    'CLERK' AS CLERK, 
    'MANAGER' AS MANAGER,
    'SALESMAN' AS SALESMAN, 
    'PRESIDEN' AS PRESIDEN, 
    'ANALYST' AS ANALYST
  )
);


查询每个部门每个job员工人数以及总工资

 select * from(
  SELECT DEPTNO , SAL,JOB FROM EMP
)
PIVOT (
  count(1) as cnt,SUM(SAL) as sals
  FOR JOB 
  IN (
    'CLERK' AS CLERK, 
    'MANAGER' AS MANAGER,
    'SALESMAN' AS SALESMAN, 
    'PRESIDEN' AS PRESIDEN, 
    'ANALYST' AS ANALYST
  )
);


查询depno为30的部门里面，job为SALESMAN，MANAGER，CLERK的员工各有多少人以及总工资为多少。

select * from(
  SELECT DEPTNO , SAL,JOB FROM EMP
)
PIVOT (
  count(1) as cnt,SUM(SAL) as sals
  FOR (DEPTNO, JOB) 
  IN (
    (30,'CLERK') AS dep30_CLERK, 
    (30,'MANAGER') AS dep30_MANAGER,
    (30,'SALESMAN') AS dep30_SALESMAN
  )
);

unpivot:

语法：

SELECT ...
FROM   ...
UNPIVOT [INCLUDE|EXCLUDE NULLS]
   ( unpivot_clause
     unpivot_for_clause
     unpivot_in_clause )
WHERE  ...




数据：pivoted_data




SELECT *
    FROM   pivoted_data
    UNPIVOT (
      deptsal                              --<-- unpivot_clause
      FOR saldesc                        --<-- unpivot_for_clause
      IN  (d10_sal, d20_sal, d30_sal, d40_sal) --<-- unpivot_in_clause
  );


默认是不包含nulls的，我们通过命令处理nulls的结果
SELECT *
    FROM   pivoted_data
    UNPIVOT INCLUDE NULLS(
      deptsal                              --<-- unpivot_clause
      FOR saldesc                        --<-- unpivot_for_clause
      IN  (d10_sal, d20_sal, d30_sal, d40_sal) --<-- unpivot_in_clause
  );


使用别名
 SELECT job,saldesc,deptsal
 
    FROM   pivoted_data
 
    UNPIVOT (deptsal
 
    FOR      saldesc IN (d10_sal AS 'SAL TOTAL FOR 10',
 
                         d20_sal AS 'SAL TOTAL FOR 20',
 
                         d30_sal AS 'SAL TOTAL FOR 30',
 
                         d40_sal AS 'SAL TOTAL FOR 40'))
 
   ORDER  BY job,saldesc;