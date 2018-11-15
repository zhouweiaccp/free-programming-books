学校里面记录成绩，每个人的选课不一样,而且以后会添加课程，所以不需要把所有课程当作列。数据表里面数据如下图，使用姓名+课程作为联合主键（有些需求可能不需要联合主键）。本文以MySQL为基础，其他数据库会有些许语法不同。

数据库表数据：




处理后的结果（行转列）：


方法一：

这里可以使用Max，也可以使用Sum；

注意第二张图，当有学生的某科成绩缺失的时候，输出结果为Null; 

SELECT
	SNAME,
	MAX(
		CASE CNAME
		WHEN 'JAVA' THEN
			SCORE
		END
	) JAVA,
	MAX(
		CASE CNAME
		WHEN 'mysql' THEN
			SCORE
		END
	) mysql
FROM
	stdscore
GROUP BY
	SNAME;

可以在第一个Case中加入Else语句解决这个问题:

SELECT
	SNAME,
	MAX(
		CASE CNAME
		WHEN 'JAVA' THEN
			SCORE
		ELSE
			0
		END
	) JAVA,
	MAX(
		CASE CNAME
		WHEN 'mysql' THEN
			SCORE
		ELSE
			0
		END
	) mysql
FROM
	stdscore
GROUP BY
	SNAME;
方法二：

SELECT DISTINCT  a.sname,
(SELECT score FROM stdscore b WHERE a.sname=b.sname AND b.CNAME='JAVA' ) AS 'JAVA',
(SELECT score FROM stdscore b WHERE a.sname=b.sname AND b.CNAME='mysql' ) AS 'mysql'
FROM stdscore a

方法三：

DROP PROCEDURE
IF EXISTS sp_score;
DELIMITER &&
 
CREATE PROCEDURE sp_score ()
BEGIN
	#课程名称
	DECLARE
		cname_n VARCHAR (20) ; #所有课程数量
		DECLARE
			count INT ; #计数器
			DECLARE
				i INT DEFAULT 0 ; #拼接SQL字符串
			SET @s = 'SELECT sname' ;
			SET count = (
				SELECT
					COUNT(DISTINCT cname)
				FROM
					stdscore
			) ;
			WHILE i < count DO
 
 
			SET cname_n = (
				SELECT
					cname
				FROM
					stdscore
				GROUP BY CNAME 
				LIMIT i,
				1
			) ;
			SET @s = CONCAT(
				@s,
				', SUM(CASE cname WHEN ',
				'\'',
				cname_n,
				'\'',
				' THEN score ELSE 0 END)',
				' AS ',
				'\'',
				cname_n,
				'\''
			) ;
			SET i = i + 1 ;
			END
			WHILE ;
			SET @s = CONCAT(
				@s,
				' FROM stdscore GROUP BY sname'
			) ; #用于调试
			#SELECT @s;
			PREPARE stmt
			FROM
				@s ; EXECUTE stmt ;
			END&&
 
CALL sp_score () ;

处理后的结果（行转列）分级输出：





方法一：


这里可以使用Max，也可以使用Sum；

注意第二张图，当有学生的某科成绩缺失的时候，输出结果为Null; 

SELECT
	SNAME,
	MAX(
		CASE CNAME
		WHEN 'JAVA' THEN
			(
				CASE
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 20 THEN
					'优秀'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 10 THEN
					'良好'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') >= 0 THEN
					'普通'
				ELSE
					'较差'
				END
			)
		END
	) JAVA,
	MAX(
		CASE CNAME
		WHEN 'mysql' THEN
			(
				CASE
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 20 THEN
					'优秀'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 10 THEN
					'良好'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') >= 0 THEN
					'普通'
				ELSE
					'较差'
				END
			)
		END
	) mysql
FROM
	stdscore
GROUP BY
	SNAME;
 

方法二：
SELECT DISTINCT  a.sname,
(SELECT (
				CASE
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 20 THEN
					'优秀'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 10 THEN
					'良好'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') >= 0 THEN
					'普通'
				ELSE
					'较差'
				END
			) FROM stdscore b WHERE a.sname=b.sname AND b.CNAME='JAVA' ) AS 'JAVA',
(SELECT (
				CASE
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 20 THEN
					'优秀'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') > 10 THEN
					'良好'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME='JAVA') >= 0 THEN
					'普通'
				ELSE
					'较差'
				END
			) FROM stdscore b WHERE a.sname=b.sname AND b.CNAME='mysql' ) AS 'mysql'
FROM stdscore a

方法三：

DROP PROCEDURE
IF EXISTS sp_score;
DELIMITER &&
 
CREATE PROCEDURE sp_score ()
BEGIN
	#课程名称
	DECLARE
		cname_n VARCHAR (20) ; #所有课程数量
		DECLARE
			count INT ; #计数器
			DECLARE
				i INT DEFAULT 0 ; #拼接SQL字符串
			SET @s = 'SELECT sname' ;
			SET count = (
				SELECT
					COUNT(DISTINCT cname)
				FROM
					stdscore
			) ;
			WHILE i < count DO
 
 
			SET cname_n = (
				SELECT
					cname
				FROM
					stdscore
        GROUP BY CNAME 
				LIMIT i, 1
			) ;
			SET @s = CONCAT(
				@s,
				', MAX(CASE cname WHEN ',
				'\'',
				cname_n,
				'\'',
				' THEN (
				CASE
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME=\'',cname_n,'\') > 20 THEN
					\'优秀\'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME=\'',cname_n,'\') > 10 THEN
					\'良好\'
				WHEN SCORE - (select avg(SCORE) from stdscore where CNAME=\'',cname_n,'\') >= 0 THEN
					\'普通\'
				ELSE
					\'较差\'
				END
			) END)',
				' AS ',
				'\'',
				cname_n,
				'\''
			) ;
			SET i = i + 1 ;
			END
			WHILE ;
			SET @s = CONCAT(
				@s,
				' FROM stdscore GROUP BY sname'
			) ; 
			#用于调试
			#SELECT @s;
			PREPARE stmt
			FROM
				@s ; EXECUTE stmt ;
			END&&
 
 
CALL sp_score ();
几种方法比较分析
第一种使用了分组，对每个课程分别处理。
第二种方法使用了表连接。
第三种使用了存储过程，实际上可以是第一种或第二种方法的动态化，先计算出所有课程的数量，然后对每个分组进行课程查询。这种方法的一个最大的好处是当新增了一门课程时，SQL语句不需要重写。

小结
关于行转列和列转行

这个概念似乎容易弄混，有人把行转列理解为列转行，有人把列转行理解为行转列；

这里做个定义：

行转列：把表中特定列（如本文中的：CNAME）的数据去重后做为列名（如查询结果行中的“Java，mysql”，处理后是做为列名输出）；

列转行：可以说是行转列的反转，把表中特定列（如本文处理结果中的列名“JAVA，mysql”）做为每一行数据对应列“CNAME”的值；



关于效率

不知道有什么好的生成模拟数据的方法或工具，麻烦小伙伴推荐一下，抽空我做一下对比；

