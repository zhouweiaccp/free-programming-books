<?xml version="1.0" encoding="utf-8" ?>
<Languages>
  <Language From="SQL" To="C#">
    <Type From="bigint" To="long" />
    <Type From="binary" To="object" />
    <Type From="bit" To="bool" />
    <Type From="char" To="string" />
    <Type From="datetime" To="DateTime" />
    <Type From="decimal" To="decimal" />
    <Type From="float" To="double" />
    <Type From="image" To="byte[]" />
    <Type From="int" To="int" />
    <Type From="money" To="decimal" />
    <Type From="nchar" To="string" />
    <Type From="ntext" To="string" />
    <Type From="numeric" To="decimal" />
    <Type From="nvarchar" To="string" />
    <Type From="real" To="float" />
    <Type From="smalldatetime" To="DateTime" />
    <Type From="smallint" To="short" />
    <Type From="smallmoney" To="decimal" />
    <Type From="text" To="string" />
    <Type From="timestamp" To="byte[]" />
    <Type From="tinyint" To="byte" />
    <Type From="uniqueidentifier" To="Guid" />
    <Type From="varbinary" To="byte[]" />
    <Type From="varchar" To="string" />
    <Type From="xml" To="string" />
    <Type From="sql_variant" To="object" />
  </Language>
  <Language From="SQL" To="C# System Types">
    <Type From="bigint" To="System.Int64" />
    <Type From="binary" To="System.Object" />
    <Type From="bit" To="System.Boolean" />
    <Type From="char" To="System.String" />
    <Type From="datetime" To="System.DateTime" />
    <Type From="decimal" To="System.Decimal" />
    <Type From="float" To="System.Double" />
    <Type From="image" To="System.Byte[]" />
    <Type From="int" To="System.Int32" />
    <Type From="money" To="System.Decimal" />
    <Type From="nchar" To="System.String" />
    <Type From="ntext" To="System.String" />
    <Type From="numeric" To="System.Decimal" />
    <Type From="nvarchar" To="System.String" />
    <Type From="real" To="System.Single" />
    <Type From="smalldatetime" To="System.DateTime" />
    <Type From="smallint" To="System.Int16" />
    <Type From="smallmoney" To="System.Decimal" />
    <Type From="text" To="System.String" />
    <Type From="timestamp" To="System.Byte[]" />
    <Type From="tinyint" To="System.Byte" />
    <Type From="uniqueidentifier" To="System.Guid" />
    <Type From="varbinary" To="System.Byte[]" />
    <Type From="varchar" To="System.String" />
    <Type From="xml" To="System.String" />
    <Type From="sql_variant" To="System.Object" />
  </Language>
  <DbTarget From="SQL" To="SqlClient">
    <Type From="bigint" To="SqlDbType.BigInt" />
    <Type From="binary" To="SqlDbType.Binary" />
    <Type From="bit" To="SqlDbType.Bit" />
    <Type From="char" To="SqlDbType.Char" />
    <Type From="datetime" To="SqlDbType.DateTime" />
    <Type From="decimal" To="SqlDbType.Decimal" />
    <Type From="float" To="SqlDbType.Float" />
    <Type From="image" To="SqlDbType.Image" />
    <Type From="int" To="SqlDbType.Int" />
    <Type From="money" To="SqlDbType.Money" />
    <Type From="nchar" To="SqlDbType.NChar" />
    <Type From="ntext" To="SqlDbType.NText" />
    <Type From="numeric" To="SqlDbType.Decimal" />
    <Type From="nvarchar" To="SqlDbType.NVarChar" />
    <Type From="real" To="SqlDbType.Real" />
    <Type From="smalldatetime" To="SqlDbType.SmallDateTime" />
    <Type From="smallint" To="SqlDbType.SmallInt" />
    <Type From="smallmoney" To="SqlDbType.SmallMoney" />
    <Type From="text" To="SqlDbType.Text" />
    <Type From="timestamp" To="SqlDbType.Timestamp" />
    <Type From="tinyint" To="SqlDbType.TinyInt" />
    <Type From="uniqueidentifier" To="SqlDbType.UniqueIdentifier" />
    <Type From="varbinary" To="SqlDbType.VarBinary" />
    <Type From="varchar" To="SqlDbType.VarChar" />
    <Type From="xml" To="SqlDbType.Xml" />
    <Type From="sql_variant" To="SqlDbType.Variant" />
  </DbTarget>
  <DbTarget From="SQLCE" To="SqlServerCe">
    <Type From="bigint" To="SqlDbType.BigInt" />
    <Type From="binary" To="SqlDbType.Binary" />
    <Type From="bit" To="SqlDbType.Bit" />
    <Type From="char" To="SqlDbType.Char" />
    <Type From="datetime" To="SqlDbType.DateTime" />
    <Type From="decimal" To="SqlDbType.Decimal" />
    <Type From="float" To="SqlDbType.Float" />
    <Type From="image" To="SqlDbType.Image" />
    <Type From="int" To="SqlDbType.Int" />
    <Type From="money" To="SqlDbType.Money" />
    <Type From="nchar" To="SqlDbType.NChar" />
    <Type From="ntext" To="SqlDbType.NText" />
    <Type From="numeric" To="SqlDbType.Decimal" />
    <Type From="nvarchar" To="SqlDbType.NVarChar" />
    <Type From="real" To="SqlDbType.Real" />
    <Type From="smalldatetime" To="SqlDbType.SmallDateTime" />
    <Type From="smallint" To="SqlDbType.SmallInt" />
    <Type From="smallmoney" To="SqlDbType.SmallMoney" />
    <Type From="text" To="SqlDbType.Text" />
    <Type From="timestamp" To="SqlDbType.Timestamp" />
    <Type From="tinyint" To="SqlDbType.TinyInt" />
    <Type From="uniqueidentifier" To="SqlDbType.UniqueIdentifier" />
    <Type From="varbinary" To="SqlDbType.VarBinary" />
    <Type From="varchar" To="SqlDbType.VarChar" />
    <Type From="xml" To="SqlDbType.Xml" />
    <Type From="sql_variant" To="SqlDbType.Variant" />
  </DbTarget>
</Languages>
复制代码
读取方法

复制代码
        static Dictionary<string, string> list = new Dictionary<string, string>();
        static void Main(string[] args)
        {
            XElement root = XElement.Load("Languages.xml");

            var custs = (from c in root.Elements("DbTarget")
                         where c.Attribute("From").Value.Equals("SQL") && c.Attribute("To").Value.Equals("SqlClient")
                         select c).ToList();

            foreach (XElement node in custs.Elements("Type"))
            {
                list.Add(node.Attribute("From").Value, node.Attribute("To").Value);
            }

            Console.ReadKey();
        }
复制代码