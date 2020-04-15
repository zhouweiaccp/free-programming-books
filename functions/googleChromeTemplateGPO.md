

http://www.chromium.org/administrators/policy-templates
http://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip

链接：https://pan.baidu.com/s/1MxILgfdm02ABBoCLi1IwJg 
提取码：i7s1
http://woshub.com/how-to-configure-google-chrome-via-group-policies/#h2_2
https://docs.alfresco.com/5.2/concepts/auth-kerberos-clientconfig.html


1) download Chrome group policy templates here: http://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip
下载这个7a64e58685e5aeb931333363373733包并解压（我传到百度网盘了http://pan.baidu.com/s/1plJg）
2) Copy [zip]\windows\admx\chrome.admx to c:\windows\policydefinitions
复制压缩包里的windows\admx\chrome.admx 到 c:\windows\policydefinitions
3) Copy [zip]\windows\admx\[yourlanguage]\chrome.adml to c:\windows\policydefinitions\[yourlanguage]\chrome.adml (not c:\windows\[yourlanguage])
复制压缩包里的windows\admx\[你的语言]\chrome.adml 到 c:\windows\policydefinitions\[你的语言]\chrome.adml (注意不是这个 c:\windows\[你的语言])
在c:\windows\policydefinitions下面可以看到你现在用的语言比如zh-CN或en-US，我两个都有就都复制了
4) In Chrome, go to Settings -> Extensions
Chrome里打开 设置 -> 扩展程序
5) Check the Developer Mode checkbox at the top
选中上面的“开发者模式”选框
6) Scroll down the list of disabled extensions and note the ID's of the extensions you want to enable. LogMeIn, for example, is ID: nmgnihglilniboicepgjclfiageofdfj
找到被禁用的扩展，记下ID（设白名单用）
7) Click Start -> Run, and type gpedit.msc
开始 -> 运行，输入gpedit.msc确定（这是打开 本地组策略编辑器）
8) Expand User Configuration -> Administrative Templates -> Google -> Google Chrome -> Extensions
展开 用户配置 -> 管理模板 -> Google -> Google Chrome -> 扩展程序
（这里有两个Google Chrome用第一个就好，第二个里面也没有 扩展程序 这一项）
9) Double-click to open "Configure extension installation whitelist"
双击打开“配置扩展程序安装白名单”
10) Select "Enabled", then click "Show..."
选中“已启用”，点击“显示...”
11) In the list, enter all the ID's for the extensions you noted in Step 6
在列表中输入刚才记下的ID值
12) Click OK and restart Chrome.