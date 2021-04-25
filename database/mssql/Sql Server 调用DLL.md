

https://www.cnblogs.com/woxpp/p/3990277.html
背景
在处理数据或者分析数据时，我们常常需要加入一定的逻辑，该些处理逻辑有些sql是可以支持，有些逻辑SQL则无能为力，在这种情况下，大多数人都会编写相关的程序来处理成自己想要的数据，但每次处理相同逻辑时，都需要运行一次程序非常麻烦。

案例
IE地址栏上的地址在记入日志表中时，其数据是通过编码的，如果我们想要看到明文，则需要相应的解码，可以用SQL语句来实现，如：

摘自：http://blog.csdn.net/ruijc/article/details/6931189

复制代码
CREATE FUNCTION FN_URLDecode  
(  
 @Str VARCHAR(8000)
)  
RETURNS VARCHAR(8000)  
AS  
BEGIN  
  DECLARE @Position  INT;          --'%'字符所在位置  
  DECLARE @Chr       CHAR(16);     --字符常量  
  DECLARE @Pattern   CHAR(21);  
  DECLARE @ParseStr  VARCHAR(8000);--解码后的字符串  
  DECLARE @Hex       UNIQUEIDENTIFIER;--定义16进制模板,因为GUID方便转为BYTE  
  DECLARE @CurrWord  INT        ;--当前字  
  DECLARE @BitsCount INT        ;--当前解码位数  
  DECLARE @HightByte TINYINT;--高位字节  
  DECLARE @LowByte   TINYINT;--低位字节  
     
  SET     @Chr = '0123456789abcdef';  
  SET     @Pattern = '%[%][a-f0-9][a-f0-9]%';  
  SET     @ParseStr=@Str;  
  SET     @Hex= '00000000-0000-0000-0000-000000000000';  
  SET     @CurrWord=0;  
  SET     @BitsCount=0;  
  SET     @HightByte=0;  
  SET     @LowByte=0;  
    
  IF (@Str IS NOT NULL OR @Str<>'')  
   BEGIN  
     SET    @Position = PATINDEX(@Pattern, @ParseStr);
     WHILE @Position>0  
      BEGIN  
        SET @Hex=STUFF(@Hex,7,2,LEFT(RIGHT(@ParseStr,len(@ParseStr) - @Position),2));  
        SET @HightByte=CAST(CAST(@Hex AS BINARY(1)) AS INT);  
          
        IF (@HightByte & 127=@HightByte)  
         BEGIN  
           SET @CurrWord=@HightByte;  
           SET @BitsCount=1;  
         END  
           
        IF (@HightByte & 192=192)  
         BEGIN
           SET @CurrWord=@HightByte & 31 ;  
           SET @BitsCount=2;  
         END  
  
        IF (@HightByte & 224=224)  
         BEGIN 
            SET @CurrWord = @HightByte & 15  
            SET @BitsCount = 3    
         END  
  
        IF (@HightByte & 240=240)  
         BEGIN
            SET @CurrWord = @HightByte & 7  
            SET @BitsCount = 4    
         END  
  
        DECLARE @Index INT;          
        DECLARE @NEWCHAR NVARCHAR(2);  
        SET @Index=1;  
        SET @NEWCHAR='';  
        WHILE @Index<@BitsCount  
         BEGIN  
              IF (LEN(@ParseStr)-@Position-3*@Index)<0  
               BEGIN  
                   SET @ParseStr=@Str ;     
                   SET @Position=0;  
                   BREAK;                
               END  
            SET @NEWCHAR = LEFT(RIGHT(@ParseStr,LEN(@ParseStr) - @Position - 3* @Index),2);     
            IF @NEWCHAR NOT LIKE '[a-f0-9][a-f0-9]'  
             BEGIN  
                SET @ParseStr = @Str  
                SET @Position=0;
                BREAK;  
             END      
  
            SET @Hex = STUFF(@Hex, 7, 2, @NEWCHAR)        
  
            SET @LowByte = CAST(CAST(@Hex AS BINARY(1)) AS INT);  
  
            IF @LowByte&192=192  
            BEGIN  
                SET @ParseStr = @Str  
                SET @Position=0;
                BREAK;  
            END   
              
            SET @CurrWord = (@CurrWord * 64) | (@LowByte & 63)                
            SET @Index =@Index+ 1                                                  
         END                                     
  
         IF @BitsCount > 1             
          SET @ParseStr = STUFF(@ParseStr, @Position, 3*(@BitsCount), NCHAR(@CurrWord))  
         ELSE   
          BEGIN  
            set @ParseStr = STUFF(@ParseStr, @Position, 2, NCHAR(@CurrWord))  
            set @ParseStr = STUFF(@ParseStr, @Position+1, 1, N'')         
          END   
        SET  @Position = PATINDEX(@Pattern, @ParseStr);  
      END  
   END  
   RETURN @ParseStr;  
END  
复制代码
其执行结果如下：


利用SQL不仅需要写很复杂的函数，如果需要加入其他操作时，也需要花大量时间来修改。

如果采用程序处理此类问题那将简单的多，如下：

复制代码
using System.Text;
using System.Web;

namespace UrlDecode
{
    /*code 释迦苦僧*/
    public class UrlDll
    {
        /// <summary>
        /// 获取URL的值
        /// </summary> 
        public static string GetUrlPara(string url, string key)
        {
            key = key + "=";
            string[] strs = url.Split('&');
            foreach (string str in strs)
            {
                if (str.IndexOf(key) >= 0)
                {
                    string sub = str.Substring(str.IndexOf(key) + key.Length, str.Length - str.IndexOf(key) - key.Length);
                    string sub2 = MyUrlDeCode(sub, null);
                    if (sub2.IndexOf('?') >= 0)
                    {
                        sub2 = sub2.Substring(0, sub2.IndexOf('?'));
                    }
                    return sub2;
                }
            }
            return string.Empty;
        }
        /// <summary>
        /// 解码URL.
        /// </summary>
        /// <param name="encoding">null为自动选择编码</param>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string MyUrlDeCode(string str, Encoding encoding)
        {
            if (encoding == null)
            {
                Encoding utf8 = Encoding.UTF8;
                //首先用utf8进行解码                     
                string code = HttpUtility.UrlDecode(str, utf8);
                string tempcode = code;
                if (code.IndexOf('?') >= 0)
                {
                    tempcode = code.Substring(0, code.IndexOf('?'));
                }
                //将已经解码的字符再次进行编码.
                string encode = HttpUtility.UrlEncode(tempcode, utf8).ToUpper();
                if (encode.IndexOf('+') >= 0)
                {
                    encode = encode.Substring(0, encode.IndexOf('+'));
                }
                if (str.ToUpper().Contains(encode.ToUpper()))
                    encoding = Encoding.UTF8;
                else
                    encoding = Encoding.GetEncoding("gb2312");
            }
            string encodeing = HttpUtility.UrlDecode(str, encoding);
            if (encodeing.Contains("%") && encodeing.Length > 8)
            {
                return MyUrlDeCode2(encodeing, null);
            }
            return encodeing;
        }
        public static string MyUrlDeCode2(string str, Encoding encoding)
        {
            if (encoding == null)
            {
                Encoding utf8 = Encoding.UTF8;
                //首先用utf-8进行解码                     
                string code = HttpUtility.UrlDecode(str.ToUpper(), utf8);
                //将已经解码的字符再次进行编码.
                string encode = HttpUtility.UrlEncode(code, utf8).ToUpper();
                if (str.ToUpper() == encode)
                    encoding = Encoding.UTF8;
                else
                    encoding = Encoding.GetEncoding("gb2312");
            }
            return HttpUtility.UrlDecode(str, encoding);
        }
    }
}
复制代码
在SQL中调用此类的方法，需要将其封装在DLL中，如下：
1.将类库设置为.NET Framework2.0 如下：



2.在Release下编译成dll



3.将dll添加到SQL Server中

复制代码
--code 释迦苦僧
--修改系统配置的存储过程当设置 show advanced options 参数为 1 时，才允许修改系统配置中的某些高级选相！！系统中这些高级选项默认是不允许修改
exec sp_configure 'show advanced options','1'
go
--重新配置 就是用来更新使用sp_configure 系统存储过程更改的配置选项的当前配置值
reconfigure
go
--建立可信赖
alter database Auth3 set trustworthy on
go
--添加关联DLL
CREATE ASSEMBLY [System.Web] FROM 'C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Web.dll' WITH PERMISSION_SET = UNSAFE
go
--开启CLR集成
EXEC sp_configure 'clr enabled','1'
go
--重新配置 就是用来更新使用sp_configure 系统存储过程更改的配置选项的当前配置值
reconfigure
--添加刚刚编译的DLL
create assembly SqlUrlDecode from  'D:\Test VS Project\UrlDll\UrlDecode\bin\Release\UrlDecode.dll'  
go

--创建函数
CREATE FUNCTION dbo.FunUrlDecode
( 
@url as nvarchar(500),
@key as nvarchar(120) 
)
RETURNS nvarchar(200) 
AS EXTERNAL NAME SqlUrlDecode.[UrlDecode.UrlDll].GetUrlPara
               --Sql命名空间   dll命名空间 dll类 dll方法
复制代码
将dll添加成功后，我们可以在SQL SERVER 找到相关的Assembiles,如下：