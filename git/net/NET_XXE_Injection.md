https://www.cnblogs.com/zhuawang/p/10194474.html
接下来关于.NET中XXE注入的内容来自Dean Fleming单元测试的Web站点：https://github.com/deanf1/dotnet-security-unit-tests。该站点覆盖了目前.NET下支持的所有XML解析器，且测试用例均展示了哪些情况下它们对于XXE注入而言是安全的，哪些情况下又是不安全的。这些内容更早之前是基于James Jardine这篇关于.NET XXE的杰出文章：https://www.jardinesoftware.net/2016/05/26/xxe-and-net/。与微软这篇在.NET下如何预防XXE以及XML拒绝服务的老文章http://msdn.microsoft.com/en-us/magazine/ee335713.aspx 相比它提供了更新更全的内容，但与Dean Fleming的Web站点覆盖的地方相比还是有些不准确的地方。

下表罗列了.NET下所有支持的XML解析器其默认的安全级别：

XML解析器	默认是否安全？
LINQ to XML	是
XmlDictionaryReader	是
XmlDocument	 
4.5.2之前的版本
4.5.2及之后的版本	否
是
XmlNodeReader	是
XmlReader	是
XmlTextReader	 
4.5.2之前的版本
4.5.2及之后的版本	否
是
XPathNavigator	 
4.5.2之前的版本
4.5.2及之后的版本	否
是
XslCompiledTransform	是
LINQ to XML
System.Xml.Linq 类库下的 XElement和 XDocment 对于XXE注入而言默认都是安全的。XElement 仅解析XML中的元素，直接忽略了 DTDs。XDocment 默认禁止 DTDs，其仅在基于非安全的XML解析器构建时才是不安全的。

XmlDictionaryReader
System.Xml.XmlDictionaryReader 默认情况下是安全的，当它尝试解析 DTDs 时，编译器会抛出一个 “CData elements not valid at top level of an XML document” 的异常，其仅在基于非安全的XML解析器构建时才是不安全的。

XmlDocment
在.NET Framework 4.5.2之前的版本中，System.Xml.XmlDocument 默认是不安全的。要预防XXE，在4.5.2之前的版本中，XmlDocument 下的 XmlResolver 属性需要手工设置为null。而在4.5.2及其之后的版本中，XmlResolver 默认就已经被设置为了null。下面的例子展示了如何进行预防：

        static void Reader()
        {
            string xml = @"<?xml version=""1.0"" ?><!DOCTYPE doc 
    [< !ENTITY win SYSTEM ""file:///C:/Users/user/Documents/testdata2.txt"">]
    >< doc > &win;</ doc >";
            XmlReader myReader = XmlReader.Create(new StringReader(xml));
            while (myReader.Read())
            {
                Console.WriteLine(myReader.Value);
            }
            Console.ReadLine();
        }
1
2
3
4
5
6
7
8
9
10
11
12
如果你使用非空且具有默认或不安全设置的 XmlResolver，那么 XmlDocument 将无法预防XXE。如果你需要允许处理 DTD，这篇MSDN的文章详细介绍了如何安全的处理 DTD。

XmlNodeReader
System.Xml.XmlNodeReader 默认情况下是安全的，且就算它是基于非安全的XML解析器构建，或被封装到其它非安全的XML解析器时，它也不会处理而是忽略掉 DTDs。

XmlReader
System.Xml.XmlReader 默认情况下是安全的。在4.0及之前的版本中，其ProhibitDtd属性被设置为 false，而在4.0及其之后的版本中，其DtdProcessing属性被设置为 Prohibit。另外，在4.5.2及更高版本中，XmlReader的 XmlReaderSettings 默认将其XmlResolver 属性设置为了null，用于提供额外的安全措施。因此，在4.5.2及之后的版本中，必须同时将 DtdProcessing 属性设置为Parse，且 XmlReaderSetting 的 XmlResolver 属性必须赋值为非空且具有默认或不安全设置的相关实现。如果你需要允许处理 DTD，这篇MSDN的文章详细介绍了如何安全的处理 DTD。

XmlTextReader
在.NET Framework 4.5.2之前的版本中，System.Xml.XmlTextReader 默认是不安全的。下面是在不同的.NET版本中进行安全设置：

4.0之前的版本
.NET4.0之前，在 System.Xml.XmlReaderSettings 和 System.Xml.XmlTextReader 类中，像 XmlTextReader 这类 XmlReader 的DTD解析行为是由Boolean类型的 ProhibitDtd 属性来控制的，将该值设置为 true 将可以完全禁止内联DTDs。

XmlTextReader reader = new XmlTextReader(stream);
reader.ProhibitDtd = true;  // NEEDED because the default is FALSE!!
1
2
.NET 4.0 - .NET 4.5.2
.NET4.0版本中DTD的解析行为发生了变化。已不再推荐通过 ProhibitDtd 属性进行安全控制，取而代之的是 DtdProcessing 属性。然而他们并没有改变其默认设置，所以在默认情况下，XmlTextReader 对于XXE而言仍然是易受攻击的。将 DtdProcessing 设置为Prohibit 后，如果XML包含 <!DOCTYPE> 元素将会在程序运行时抛出一个异常。你可以这样设置这个值：

XmlTextReader reader = new XmlTextReader(stream);
reader.DtdProcessing = DtdProcessing.Prohibit;  // NEEDED because the default is Parse!!
1
2
或者你可以将 DtdProcessing 设置为 Ignore，这样就算有<!DOCTYPE>程序也不会抛出异常，而是简单的跳过且不处理它。最后，你可以将 DtdProcessing 属性设置为 Parse 来允许处理内联DTDs。

.NET 4.5.2及之后的版本
.NET4.5.2及其之后的版本中，XmlTextReader 的 XmlResolver 属性（可访问性为internal）默认被设置为null，这样默认XmlTextReader 将会忽略DTDs。当使用非空且具有默认或不安全设置的 XmlResolver 时，XmlTextReader 将会变得不安全。

XPathNavigator
在4.5.2版本之前，System.Xml.XPath.XPathNavigator 默认是不安全的。这是因为它像 XmlDocument 那样实现了 IXPathNavigable 接口，这个接口在4.5.2之前的版本中默认也是不安全的。你可以通过传递安全的Xml解析器（比如 XmlReader，它默认是安全的）到XPathNavigator 的构造函数中来获取安全的 XPathNavigator 实例，以下是例子：

XmlReader reader = XmlReader.Create("example.xml");
XPathDocument doc = new XPathDocument(reader);
XPathNavigator nav = doc.CreateNavigator(); 
string xml = nav.InnerXml.ToString();
1
2
3
4
XslCompiledTransform
只要给定的Xml解析器是安全的，那么 System.Xml.Xsl.XslCompiledTransform（Xml转换器）默认就是安全的。它之所以安全是因为Transform() 方法默认的解析器是 XmlReader，这个解析器默认是安全的（前面有描述）。你可以在此处查看它的源代码。有些Transform() 的重构方法接受像 XmlReader 、IXPathNavigable（比如 XmlDocument）之类的参数，如果你传递的是不安全的Xml解析器，那么 Transform 方法也将不安全。

英文地址：https://www.owasp.org/index.php/XML_External_Entity_(XXE)_Prevention_Cheat_Sheet#.NET