




##Network Load Balancing
- [](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc725691(v=ws.10))



### install
-[](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc731695%28v%3dws.10%29)servermanagercmd.exe -install nlb


### common
-[](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc770345(v=ws.10))nlb.exe stop
-[]()nlb.exe start

## 
nlb要求mac地址的伪传输必须是打开的
1：交换机上要设置OR虚拟机上的网卡设置OR命令行直接改 [MAC地址欺骗](https://www.cnblogs.com/dreamer-fish/p/3841023.html)  [] (https://www.cnblogs.com/sky5hat/p/12040793.html)


## iis  windowsAuthentication
[](https://stackoverflow.com/questions/8616818/integrated-windows-auth-ntlm-on-a-mac-using-google-chrome-or-safari)
appcmd set config /section:windowsAuthentication /-providers.[value='Negotiate']

!/bin/bash
cd /Applications/Google\ Chrome.app/Contents/MacOS/
if [ -f 'Google Chrome.bin' ];
then
   echo "Already Modified"
else
   sudo chmod u+wr ./
   sudo mv 'Google Chrome' 'Google Chrome.bin'
   sudo echo "#!/bin/bash" > "Google Chrome"
   sudo echo 'exec /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome.bin --args --auth-server-whitelist="*DOMAIN.TLD" --auth-negotiate-delegate-whitelist="*DOMAIN.TLD" --auth-schemes="digest,ntlm,negotiate"' >> "Google Chrome"
   sudo chmod a+x 'Google Chrome'
   echo "NTLM Will now work in chrome"
fi