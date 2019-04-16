--删除  func SplitToTable   select * from dbo.SplitToTable('1111;2222;3333',';') where value='1111'
 if object_id('SplitToTable') is not null
 begin 
 drop FUNCTION SplitToTable
 print 'SplitToTable del'
 end 
 go
 ----init SplitToTable   select * from dbo.SplitToTable('1111;2222;3333',';') where value='1111'
Create FUNCTION dbo.SplitToTable
(
     @SplitString nvarchar(max),
     @Separator nvarchar(10)=' '
)
RETURNS @SplitStringsTable TABLE
(
[id] int identity(1,1),
[value] nvarchar(max)
)
AS
BEGIN
     DECLARE @CurrentIndex int;
     DECLARE @NextIndex int;
     DECLARE @ReturnText nvarchar(max);
     SELECT @CurrentIndex=1;
     WHILE(@CurrentIndex<=len(@SplitString))
         BEGIN
             SELECT @NextIndex=charindex(@Separator,@SplitString,@CurrentIndex);--CHARINDEX函数返回字符或者字符串在另一个字符串中的起始位置
             IF(@NextIndex=0 OR @NextIndex IS NULL)
                 SELECT @NextIndex=len(@SplitString)+1;
                 SELECT @ReturnText=substring(@SplitString,@CurrentIndex,@NextIndex-@CurrentIndex);
                 INSERT INTO @SplitStringsTable([value]) VALUES(@ReturnText);
                 SELECT @CurrentIndex=@NextIndex+1;
             END
     RETURN;
END
 go