sql的行转列(PIVOT)与列转行(UNPIVOT)
在做数据统计的时候，行转列，列转行是经常碰到的问题。case when方式太麻烦了，而且可扩展性不强，可以使用 PIVOT，UNPIVOT比较快速实现行转列，列转行，而且可扩展性强

一、行转列

1、测试数据准备

复制代码
CREATE  TABLE [StudentScores]
(
   [UserName]         NVARCHAR(20),        --学生姓名
   [Subject]          NVARCHAR(30),        --科目
   [Score]            FLOAT,               --成绩
)

INSERT INTO [StudentScores] SELECT '张三', '语文', 80
INSERT INTO [StudentScores] SELECT '张三', '数学', 90
INSERT INTO [StudentScores] SELECT '张三', '英语', 70
INSERT INTO [StudentScores] SELECT '张三', '生物', 85
INSERT INTO [StudentScores] SELECT '李四', '语文', 80
INSERT INTO [StudentScores] SELECT '李四', '数学', 92
INSERT INTO [StudentScores] SELECT '李四', '英语', 76
INSERT INTO [StudentScores] SELECT '李四', '生物', 88
INSERT INTO [StudentScores] SELECT '码农', '语文', 60
INSERT INTO [StudentScores] SELECT '码农', '数学', 82
INSERT INTO [StudentScores] SELECT '码农', '英语', 96
INSERT INTO [StudentScores] SELECT '码农', '生物', 78
复制代码


2、行转列sql

复制代码
SELECT * FROM [StudentScores] /*数据源*/
AS P
PIVOT 
(
    SUM(Score/*行转列后 列的值*/) FOR 
    p.Subject/*需要行转列的列*/ IN ([语文],[数学],[英语],[生物]/*列的值*/)
) AS T
复制代码
执行结果：



二、列转行

1、测试数据准备

复制代码
CREATE TABLE ProgrectDetail
(
    ProgrectName         NVARCHAR(20), --工程名称
    OverseaSupply        INT,          --海外供应商供给数量
    NativeSupply         INT,          --国内供应商供给数量
    SouthSupply          INT,          --南方供应商供给数量
    NorthSupply          INT           --北方供应商供给数量
)

INSERT INTO ProgrectDetail
SELECT 'A', 100, 200, 50, 50
UNION ALL
SELECT 'B', 200, 300, 150, 150
UNION ALL
SELECT 'C', 159, 400, 20, 320
UNION ALL
复制代码


2、列转行的sql

复制代码
SELECT P.ProgrectName,P.Supplier,P.SupplyNum
FROM 
(
    SELECT ProgrectName, OverseaSupply, NativeSupply,
           SouthSupply, NorthSupply
     FROM ProgrectDetail
)T
UNPIVOT 
(
    SupplyNum FOR Supplier IN
    (OverseaSupply, NativeSupply, SouthSupply, NorthSupply )
) P
复制代码