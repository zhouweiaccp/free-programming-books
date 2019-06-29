makecert -n “CN=www.lwwl.tech” -b 06/22/2018 -e 06/23/2022 -eku 1.3.6.1.5.5.7.3.1 -ss my -sr localmachine -sky exchange -sp “Microsoft RSA SChannel Cryptographic Provider” -sy 12 -$ commercial -cy authority -iv RootIssuer.pvk -ic RootIssuer.cer -sv lwwl.pvk lwwl.cer

cert2spc lwwl.cer lwwl.spc

pvk2pfx.exe  -pvk lwwl.pvk -spc lwwl.spc -pfx lwwl.pfx

makecert -n "CN=Root" -r -sv RootIssuer.pvk RootIssuer.cer

https://www.cnblogs.com/aiqingqing/p/4503051.html
https://docs.microsoft.com/zh-tw/windows-hardware/drivers/devtest/tools-for-signing-drivers
https://docs.microsoft.com/zh-tw/windows-hardware/drivers/devtest/makecert
https://docs.microsoft.com/zh-cn/windows-hardware/drivers/devtest/pvk2pfx

Windows Server2008、IIS7启用CA认证及证书制作完整过程
https://blog.csdn.net/wyxhd2008/article/details/7984535

https://blog.csdn.net/lwwl12/article/details/80799604  
SSL数字证书（二）使用makecert.exe签发证书

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
