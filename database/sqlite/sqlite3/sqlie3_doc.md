https://www.sqlite.org/2019/sqlite-tools-win32-x86-3280000.zip
https://www.sqlite.org/2019/sqlite-dll-win64-x64-3280000.zip


https://www.runoob.com/sqlite/sqlite-create-database.html

--使用 SQLite .dump 点命令来导出完整的数据库在一个文本文件中
$sqlite3 testDB.db .dump > testDB.sql

--恢复
$sqlite3 testDB.db < testDB.sql
 

 

创建、附加、分离数据库：

 --创建数据库
 $sqlite3 DatabaseName.db 
复制代码
 --附加数据库 
 ATTACH DATABASE 'DatabaseName' As 'Alias-Name';
 
 --如：
 sqlite> ATTACH DATABASE 'testDB.db' as 'TEST';
 
 
 --分离数据库
 DETACH DATABASE 'Alias-Name';
 
 --如：
 sqlite> DETACH DATABASE 'TEST';
复制代码
 

 

创建、删除(drop)、更改表(基于'TABLE'）；插入、查询、更新、删除(delete)表项(基于'FROM')

复制代码
 sqlite> CREATE TABLE COMPANY(
        ID INT PRIMARY KEY     NOT NULL,
        NAME           TEXT    NOT NULL,
        AGE            INT     NOT NULL,
        ADDRESS        CHAR(50),
        SALARY         REAL
     );
 
 sqlite>.tables
 
 sqlite>.schema company
 
 
 --//DROP TABLE database_name.table_name;
 
 sqlite>DROP TABLE COMPANY;
 
 
  /*
 INSERT INTO TABLE_NAME (column1, column2, column3,...columnN)]
     VALUES (value1, value2, value3,...valueN); 
 INSERT INTO TABLE_NAME VALUES (value1,value2,value3,...valueN);
 */
 sqlite>INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
     VALUES (1, 'Paul', 32, 'California', 20000.00 );
 sqlite>INSERT INTO COMPANY VALUES (7, 'James', 24, 'Houston', 10000.00 );
 
 --SELECT column1, column2, columnN FROM table_name;
 
 
 UPDATE table_name
     SET column1 = value1, column2 = value2....columnN=valueN
     [ WHERE  CONDITION ];
 
 
 //ALTER
 //重命名已有表
 ALTER TABLE database_name.table_name RENAME TO new_table_name;
  
 
 //在已有表中添加一个新的列
 ALTER TABLE database_name.table_name ADD COLUMN column_def...; 
复制代码
 

 

关键字：DISTINCT　　GROUP BY　　HAVING　　ORDER BY　　LIMIT　　OFFSET

复制代码
 //LIMIT    OFFSET
 SELECT column1, column2, columnN
     FROM table_name
     LIMIT [num of rows] OFFSET [row num];
 
 
 
 
 
 //在 SELECT 语句中，GROUP BY 子句放在 WHERE 子句之后，放在 ORDER BY 子句之前。
     SELECT column-list
     FROM table_name
     WHERE [ conditions ]
     [GROUP BY column1, column2....columnN]
     [ORDER BY column1, column2, .. columnN] [ASC | DESC];
 
 sqlite> SELECT NAME, SUM(SALARY) FROM COMPANY GROUP BY NAME ORDER BY NAME DESC;;
 
 
     SELECT
     FROM
     WHERE
     GROUP BY
     HAVING
     ORDER BY
 
 
 //HAVING 子句必须放在 GROUP BY 子句之后，必须放在 ORDER BY 子句之前
     SELECT column1, column2
     FROM table1, table2
     WHERE [ conditions ]
     GROUP BY column1, column2
     HAVING [ conditions ]
     ORDER BY column1, column2
 
 sqlite > SELECT * FROM COMPANY GROUP BY name HAVING count(name) > 2;
 
 
 // DISTINCT
     SELECT DISTINCT column1, column2,.....columnN
     FROM table_name
     WHERE [condition]
复制代码
 

 

sqlite3约束：

NOT NULL 约束：确保某列不能有 NULL 值。
DEFAULT 约束：当某列没有指定值时，为该列提供默认值。
UNIQUE 约束：确保某列中的所有值是不同的。
PRIMARY Key 约束：唯一标识数据库表中的各行/记录。
CHECK 约束：CHECK 约束确保某列中的所有值满足一定条件。
删除约束
SQLite 支持 ALTER TABLE 的有限子集。在 SQLite 中，ALTER TABLE 命令允许用户重命名表，或向现有表添加一个新的列。重命名列，删除一列，或从一个表中添加或删除约束都是不可能的。

 

JOIN[INNER/OUTER/NATURAL]　　UNION　　UNION ALL　　表、列别名

复制代码
 //ON、USING 用在join中
 //内连接（INNER JOIN）是最常见的连接类型，是默认连接类型。INNER 关键字是可选的。
 //外链接 OUTER 关键字必选
 SELECT ... FROM table1 LEFT [OUTER/INNER] JOIN table2 ON conditional_expression ...
 
 SELECT ... FROM table1 LEFT [OUTER/INNER] JOIN table2 USING ( column1 ,... ) ...
 
 //自然连接（NATURAL JOIN）类似于 JOIN...USING，只是它会自动测试存在两个表中的每一列的值之间相等值：
 SELECT ... FROM table1 NATURAL JOIN table2...
 
 //UNION 子句/运算符用于合并两个或多个 SELECT 语句的结果，不返回任何重复的行。
     SELECT column1 [, column2 ]
     FROM table1 [, table2 ]
     [WHERE condition]
 
     UNION
 
     SELECT column1 [, column2 ]
     FROM table1 [, table2 ]
     [WHERE condition]
 
 //UNION ALL 运算符用于结合两个 SELECT 语句的结果，包括重复行。
     SELECT column1 [, column2 ]
     FROM table1 [, table2 ]
     [WHERE condition]
 
     UNION ALL
 
     SELECT column1 [, column2 ]
     FROM table1 [, table2 ]
     [WHERE condition]
 
 
 //表 别名
     SELECT column1, column2....
     FROM table_name AS alias_name
     WHERE [condition];
 
 sqlite> SELECT C.ID, C.NAME, C.AGE, D.DEPT
             FROM COMPANY AS C, DEPARTMENT AS D
             WHERE  C.ID = D.EMP_ID;
 
 //列 别名
     SELECT column_name AS alias_name
     FROM table_name
     WHERE [condition];
 
 sqlite> SELECT C.ID AS COMPANY_ID, C.NAME AS COMPANY_NAME, C.AGE, D.DEPT
             FROM COMPANY AS C, DEPARTMENT AS D
             WHERE  C.ID = D.EMP_ID;
复制代码
  

SQLite 触发器
 SQLite 触发器（Trigger）是数据库的回调函数，它会在指定的数据库事件发生时自动执行/调用。以下是关于 SQLite 的触发器（Trigger）的要点：

SQLite 的触发器（Trigger）可以指定在特定的数据库表发生 DELETE、INSERT 或 UPDATE 时触发，或在一个或多个指定表的列发生更新时触发。
SQLite 只支持 FOR EACH ROW 触发器（Trigger），没有 FOR EACH STATEMENT 触发器（Trigger）。因此，明确指定 FOR EACH ROW 是可选的。
WHEN 子句和触发器（Trigger）动作可能访问使用表单 NEW.column-name 和 OLD.column-name 的引用插入、删除或更新的行元素，其中 column-name 是从与触发器关联的表的列的名称。
如果提供 WHEN 子句，则只针对 WHEN 子句为真的指定行执行 SQL 语句。如果没有提供 WHEN 子句，则针对所有行执行 SQL 语句。
BEFORE 或 AFTER 关键字决定何时执行触发器动作，决定是在关联行的插入、修改或删除之前或者之后执行触发器动作。
当触发器相关联的表删除时，自动删除触发器（Trigger）。
要修改的表必须存在于同一数据库中，作为触发器被附加的表或视图，且必须只使用 tablename，而不是database.tablename。
一个特殊的 SQL 函数 RAISE() 可用于触发器程序内抛出异常。
语法
创建 触发器（Trigger） 的基本语法如下：

复制代码
 CREATE  TRIGGER trigger_name [BEFORE|AFTER] event_name
     ON table_name
     BEGIN
      -- Trigger logic goes here....
     END;
 /*event_name 可以是在所提到的表 table_name 上的 INSERT、DELETE 和 UPDATE 数据库操作。您可以在表名后选择指定 FOR EACH ROW */
 CREATE TRIGGER database_name.trigger_name [BEFORE|AFTER] INSERT ON table_name FOR EACH ROW
     BEGIN
        stmt1;
        stmt2;
        ....
     END;
 
 //以下是在 UPDATE 操作上在表的一个或多个指定列上创建触发器（Trigger）的语法：
     CREATE  TRIGGER trigger_name [BEFORE|AFTER] UPDATE OF column_name ON table_name
     BEGIN
      -- Trigger logic goes here....
     END;
 
 
 //如：将创建一个名为 AUDIT 的新表。每当 COMPANY 表中有一个新的记录项时，日志消息将被插入其中：
 sqlite> CREATE TABLE COMPANY(
        ID INT PRIMARY KEY     NOT NULL,
        NAME           TEXT    NOT NULL,
        AGE            INT     NOT NULL,
        ADDRESS        CHAR(50),
        SALARY         REAL
     );
 
 sqlite> CREATE TABLE AUDIT(
         EMP_ID INT NOT NULL,
         ENTRY_DATE TEXT NOT NULL
     );
 
 /*在这里，ID 是 AUDIT 记录的 ID，EMP_ID 是来自 COMPANY 表的 ID，DATE 将保持 COMPANY 中记录被创建时的时间戳。所以，现在让我们在 COMPANY 表上创建一个触发器*/
 
 sqlite> CREATE TRIGGER audit_log AFTER INSERT
     ON COMPANY
     BEGIN
        INSERT INTO AUDIT(EMP_ID, ENTRY_DATE) VALUES (new.ID, datetime('now'));
     END;
 
 
 //从 sqlite_master 表中列出所有触发器
 sqlite> SELECT name FROM sqlite_master
     WHERE type = 'trigger';
 
 //列出特定表上的触发器，则使用 AND 子句连接表名
 sqlite> SELECT name FROM sqlite_master
     WHERE type = 'trigger' AND tbl_name = 'COMPANY';
 
 
 //删除已有的触发器
 sqlite> DROP TRIGGER trigger_name;
复制代码
  

VIEW

视图（View）可以包含一个表的所有行或从一个或多个表选定行。视图（View）可以从一个或多个表创建，这取决于要创建视图的 SQLite 查询。

视图（View）是一种虚表，允许用户实现以下几点：

用户或用户组查找结构数据的方式更自然或直观。
限制数据访问，用户只能看到有限的数据，而不是完整的表。
汇总各种表中的数据，用于生成报告。
SQLite 视图是只读的，因此可能无法在视图上执行 DELETE、INSERT 或 UPDATE 语句。但是可以在视图上创建一个触发器，当尝试 DELETE、INSERT 或 UPDATE 视图时触发，需要做的动作在触发器内容中定义。

复制代码
     CREATE [TEMP | TEMPORARY] VIEW view_name AS
     SELECT column1, column2.....
     FROM table_name
     WHERE [condition];
 
 
     DROP VIEW view_name;
复制代码