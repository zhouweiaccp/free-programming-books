


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