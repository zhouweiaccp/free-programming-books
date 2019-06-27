1、我们需要下载并在IIS中安装microsoft URL重写模块2.0
下载地址：http://www.microsoft.com/zh-cn/download/details.aspx?id=7435 

2
web.config
 <system.webServer>
		<rewrite>
			<rules>
				<rule name="redirec to https" stopProcessing="true">
					<match url="(.*)" />
					<conditions>
                            <add input="{HTTPS}" pattern="^OFF$" />
					</conditions>
					<action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
				</rule>
			</rules>
		</rewrite>
</system.webServer>

3.绑定  80  443端口

http://download.microsoft.com/download/4/E/7/4E7ECE9A-DF55-4F90-A354-B497072BDE0A/rewrite_x64_zh-CN.msi
https://www.cnblogs.com/xiefengdaxia123/p/8542737.html


创建访问限制规则
<rewrite>
  <rules>
    <rule name="Fail bad requests">
      <match url=".*"/>
      <conditions>
        <add input="{HTTP_HOST}" pattern="localhost" negate="true" />
      </conditions>
      <action type="AbortRequest" />
    </rule>
    <rule name="Redirect from blog">
      <match url="^blog/([_0-9a-z-]+)/([0-9]+)" />
      <action type="Redirect" url="article/{R:2}/{R:1}" redirectType="Found" />
    </rule>
    <rule name="Rewrite to article.aspx">
      <match url="^article/([0-9]+)/([_0-9a-z-]+)" />
      <action type="Rewrite" url="article.aspx?id={R:1}&amp;title={R:2}" />
    </rule>
  </rules>
</rewrite>
