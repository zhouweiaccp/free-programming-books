


## 工具
-[](https://www.microsoft.com/en-us/download/details.aspx?id=26798)
-[net-debugging-demos](https://docs.microsoft.com/en-us/archive/blogs/tess/net-debugging-demos-information-and-setup-instructions)


## IIS上的项目网站关闭Http请求中的Trace和OPTIONS
https://blog.csdn.net/XR1986687846/article/details/89345899
在Web.config中的<system.webServer>节点内添加以下配置即可：
<security>
<requestFiltering>
<verbs>
<add verb="OPTIONS" allowed="false" />
<add verb="Trace" allowed="false" />
</verbs>
</requestFiltering>
</security>


## 禁用对 ASP.NET 应用程序的调试
https://docs.microsoft.com/zh-cn/troubleshoot/aspnet/disable-debugging-application
<compilation
 debug="false"
/>

## runAllManagedModulesForAllRequests
在某些 IIS 版本中，并不会将所有请求交给 UrlRoutingModule 处理，所以，我们可以在 Web.config 中进行如下设置：
<system.webServer>
    <modules>
      <remove name="UrlRoutingModule-4.0" />
      <add name="UrlRoutingModule-4.0" type="System.Web.Routing.UrlRoutingModule" preCondition="" />
    </modules>
</system.webServer>


<system.webServer>
    <modules runAllManagedModulesForAllRequests="true" >
    </modules>  
</system.webServer>


%windir%\system32\inetsrv\config\applicationhost.config
https://www.cnblogs.com/tianma3798/p/4257573.html
https://docs.microsoft.com/en-us/iis/get-started/introduction-to-iis/iis-modules-overview

## http-error-500-19
https://docs.microsoft.com/zh-CN/troubleshoot/iis/http-error-500-19-webpage


## 解决 Windows Server 中与 IIS Web 服务器相关的问题的数据收集策略
https://docs.microsoft.com/zh-cn/troubleshoot/iis/data-collection-strategies


## 使用JSON JavaScriptSerializer 进行序列化或反序列化时出错。字符串的长度超过了为 maxJsonLength属性
“/”应用程序中的服务器错误。
使用 JSON JavaScriptSerializer 进行序列化或反序列化时出错。字符串的长度超过了为 maxJsonLength 属性设置的值。
说明: 执行当前 Web 请求期间，出现未经处理的异常。请检查堆栈跟踪信息，以了解有关该错误以及代码中导致错误的出处的详细信息。

异常详细信息: System.InvalidOperationException: 使用 JSON JavaScriptSerializer 进行序列化或反序列化时出错。字符串的长度超过了为 maxJsonLength 属性设置的值。
1.解决办法是在web.config增加如下节点到<configuration>下

<system.web.extensions>
    <scripting>
      <webServices>
        <jsonSerialization maxJsonLength="1024000000" />
      </webServices>
    </scripting>
  </system.web.extensions>

2.
JavaScriptSerializer jsSerializer  = new JavaScriptSerializer();
jsSerializer.MaxJsonLength = Int32.MaxValue;
 
