


https://specopssoft.com/blog/configuring-chrome-and-firefox-for-windows-integrated-authentication/
https://stackoverflow.com/questions/52895711/chrome-browser-enable-integrated-windows-authentication-auto-logon
https://stackoverflow.com/questions/7800938/how-to-enable-auto-logon-user-authentication-for-google-chrome

## 
gpmc.msc 是域控端管理组策略的工具 gpedit.msc 是系统自带工具

http://woshub.com/how-to-configure-google-chrome-via-group-policies/  

## 0
https://knowledge.broadcom.com/external/article/174437/configure-kerberos-authentication-in-dif.html
Download and unzip the latest Chrome policy templates
Start > Run > gpedit.msc
Navigate to Local Computer Policy > Computer Configuration > Administrative Templates
Right-click Administrative Templates, and select Add/Remove Templates
Add the windows\adm\en-US\chrome.adm template via the dialog
In Computer Configuration > Administrative Templates > Classic Administrative Templates > Google > Google Chrome > Policies for HTTP Authentication enable and configure Authentication server whitelist
Restart Chrome and navigate to chrome://policy to view active policies

## 1
FireFox Browser
By default, Kerberos support in Firefox is disabled. To enable it, do the following:

Open the browser configuration window
Type about:config in the address bar.
Then in the following parameters specify the addresses of the web servers, for which you are going to use Kerberos/NTLM authentication.
Search for term: network.automatic
Enable and set the following for NTLM:
network.automatic-ntlm-auth.trusted-uris - value: e.g http://bcca-fqdn.com
network.automatic-ntlm-auth.allow-non-fqdn - value: true
Enable and set the following for Kerberos:
network.negotiate-auth.delegation-uris - value: e.g http://bcca-fqdn.com
network.negotiate-auth.trusted-uris - value: e.g http://bcca-fqdn.com
network.negotiate-auth.allow-non-fqdn - value: true

## 2
Windows Integrated Authentication allows a users’ Active Directory credentials to pass through their browser to a web server. Windows Integrated Authentication is enabled by default for Internet Explorer but not Google Chrome or Mozilla Firefox. Users who use the non-Microsoft browsers will receive a pop-up box to enter their Active Directory credentials before continuing to the website. This adds additional steps and complexity for users who are using web based applications like self-service password reset solutions Specops uReset and Specops Password Reset. In an effort to make this process as easy as possible for end-users, many IT administrators enable Windows Integrated Authentication for the third party browsers. This can be done with Chrome and Firefox with a few additional steps. This article will show you how to enable Windows Integrated Authentication for Google Chrome and Mozilla Firefox.

Configuring Delegated Security for Mozilla Firefox
To configure Firefox to use Windows Integrated Authentication:

1. Open Firefox.

2. In the address bar type about:config

3. You will receive a security warning. To continue, click I’ll be careful, I promise.



4. You will see a list of preferences listed. Find the settings below by browsing through the list or searching for them in the search box. Once you have located each setting, update the value to the following:

Setting	Value
network.automatic-ntlm-auth.trusted-uris	MyIISServer.domain.com
network.automatic-ntlm-auth.allow-proxies	True
network.negotiate-auth.allow-proxies	True
** MyIISServer.domain.com should be the fully qualified name of your IIS server that you are setting up the Windows Integrated Authentication to.

Negotiate authentication is not supported in versions of Firefox prior to 2006.





Configuring Delegated Security in Google Chrome
Note: The latest version of Chrome uses existing Internet Explorer settings. Older version of Chrome require additional configurations (see below).

You can use three methods to enable Chrome to use Windows Integrated Authentication.Your options are the command line, editing the registry, or using ADMX templates through group policy. If you choose to use the command line or edit the registry, you could use Group Policy Preferences to distribute those changes on a broader scale. Below are the steps for the three methods:

To use the command line to configure Google Chrome
Start Chrome with the following command:

Chrome.exe –auth-server-whitelist=”MYIISSERVER.DOMAIN.COM” –auth-negotiate-delegatewhitelist=”MYIISSERVER.DOMAIN.COM” –auth-schemes=”digest,ntlm,negotiate”



 

To modify the registry to configure Google Chrome
Configure the following registry settings with the corresponding values:

Registry                               

AuthSchemes

Data type: String (REG_SZ)

Windows registry location: Software\Policies\Google\Chrome\AuthSchemes

Mac/Linux preference name: AuthSchemes

Supported on: Google Chrome (Linux, Mac, Windows) since version 9

Supported features:Dynamic Policy Refresh: No, Per Profile: No

Description: Specifies which HTTP Authentication schemes are supported by Google Chrome. Possible values are ‘basic’, ‘digest’, ‘ntlm’ and ‘negotiate’. Separate multiple values with commas. If this policy is left not set, all four schemes will be used.

Value: “basic,digest,ntlm,negotiate”

AuthServerWhitelist

Data type: String (REG_SZ)

Windows registry location: Software\Policies\Google\Chrome\AuthServerWhitelist

Mac/Linux preference name: AuthServerWhitelist

Supported on: Google Chrome (Linux, Mac, Windows) since version 9

Supported features: Dynamic Policy Refresh: No, Per Profile: No

Description: Specifies which servers should be whitelisted for integrated authentication. Integrated authentication is only enabled when Google Chrome receives an authentication challenge from a proxy or from a server which is in this permitted list. Separate multiple server names with commas. Wildcards (*) are allowed. If you leave this policy not set Chrome will try to detect if a server is on the Intranet and only then will it respond to IWA requests. If a server is detected as Internet then IWA requests from it will be ignored by Chrome.

Value: “MYIISSERVER.DOMAIN.COM”

AuthNegotiateDelegateWhitelist

Data type: String (REG_SZ)

Windows registry location: Software\Policies\Google\Chrome\AuthNegotiateDelegateWhitelist 

Mac/Linux preference name: AuthNegotiateDelegateWhitelist

Supported on: Google Chrome (Linux, Mac, Windows) since version 9

Supported features: Dynamic Policy Refresh: No, Per Profile: No

Description: Servers that Google Chrome may delegate to. Separate multiple server names with commas. Wildcards (*) are allowed. If you leave this policy not set Chrome will not delegate user credentials even if a server is detected as Intranet.

Example Value: ”MYIISSERVER.DOMAIN.COM”

To use ADM/ADMX templates through Group Policy to configure Google Chrome
1.       Download Zip file of ADM/ADMX templates and documentation from: http://www.chromium.org/administrators/policy-templates.

2.       Add the ADMX template to your central store, if you are using a central store.

3. Configure a GPO with your application server DNS host name with Kerberos Delegation Server Whitelist and Authentication Server Whitelist enabled.

Each of these three methods achieve the same results for configuring Google Chrome for Windows Integrated Authentication. The method that is best for you will depend on how your organization is set up.  Personally, I would use the command line or the registry if you are deploying across an enterprise. You can easily distribute a shortcut on the user’s desktop with the command and distribute that with Group Policy preferences. If you choose to use the registry method, that is able to be distributed with Group Policy.

With a variety of third-party browsers available, many users will receive a pop-up box to enter their Active Directory credentials before continuing to an IIS hosted web application. This leads to additional steps, complexity and confusion for many end-users. By setting up Windows Integrated Authentication into Chrome and Firefox, you will be able to give your users the greatest amount of flexibility for their choice of browser as well as ease of use with your web-based applications.

Making everyday IT tasks easier for end users and IT admins is something we specialize in. Our self-service password reset solution Specops uReset guarantees end user adoption thanks to its flexible approach to multi-factor authentication.