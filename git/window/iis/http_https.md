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