--解决递归查询  1/2/2/21/2
--select dbo.SplitToTableval11(path,/')  from org_position  where position_identityID=3
--删除  func SplitToTableval11   select * from dbo.SplitToTableval11('1/3/',/') where value='1111'
 if object_id('SplitToTableval11') is not null
 begin 
 drop FUNCTION SplitToTableval11
 print 'SplitToTableval11 del'
 end 
 go
 ----init SplitToTableval11   select * from dbo.SplitToTableval11('1/3/',/') where value='1111'
Create FUNCTION dbo.SplitToTableval11
(
     @SplitString nvarchar(max),
     @Separator nvarchar(10)=' '
)
RETURNS  nvarchar(4000)
AS
BEGIN
     DECLARE @CurrentIndex int;
     DECLARE @NextIndex int;
	    DECLARE @temp varchar(20);
     DECLARE @ReturnText nvarchar(max);
	  DECLARE @val nvarchar(4000);
     SELECT @CurrentIndex=1;
	 set @temp=''
	    set @val=''
     WHILE(@CurrentIndex<=len(@SplitString))
         BEGIN
             SELECT @NextIndex=charindex(@Separator,@SplitString,@CurrentIndex);--CHARINDEX函数返回字符或者字符串在另一个字符串中的起始位置
             IF(@NextIndex=0 OR @NextIndex IS NULL)
                   SELECT @NextIndex=len(@SplitString)+1;
                 SELECT @ReturnText=substring(@SplitString,@CurrentIndex,@NextIndex-@CurrentIndex);
               select  @temp=position_name from org_position where position_identityID=@ReturnText --  INSERT INTO @SplitStringsTable([value]) VALUES(@ReturnText);
			   set @val=@val+'/'+@temp;
                 SELECT @CurrentIndex=@NextIndex+1;
				 	 set @temp='/
             END
     RETURN @val;
END
 go