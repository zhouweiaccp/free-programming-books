



##  Search Filter Syntax
SEARCH FILTER SYNTAX
Search filter	Description
"(objectClass=*)"	All objects.
"(&(objectCategory=person)(objectClass=user)(!(cn=andy)))"	All user objects but "andy".
"(sn=sm*)"	All objects with a surname that starts with "sm".
"(&(objectCategory=person)(objectClass=contact)(|(sn=Smith)(sn=Johnson)))"	All contacts with a surname equal to "Smith" or "Johnson".



## demo 不同步qq1
(&(objectCategory=person)(objectClass=user)(!(sAMAccountName=qq1)))




## code
```cs
//https://codereview.stackexchange.com/questions/158821/ldap-search-helper-for-system-directoryservices-protocols
LdapConnection ldapConnection = new LdapConnection(
    new LdapDirectoryIdentifier("172.18.0.50", 389),
    new NetworkCredential("CN=Administrator,CN=Users,DC=my-domain,DC=com", "SuperSecret"))
{
    AuthType = AuthType.Basic,
    Timeout = new TimeSpan(0, 10, 0)
};
ldapConnection.SessionOptions.ProtocolVersion = 3;
ldapConnection.SessionOptions.ReferralChasing = ReferralChasingOptions.None;

string baseDn = "OU=Lab,DC=my-domain,DC=com";
string ldapFilter = "(objectClass=group)";
SearchScope searchScope = SearchScope.Subtree;
string[] attributeList = { "member", "objectClass", "sAMAccountName" };
int pageSize = 1000;
int sizeLimit = 2000;

LdapSearch ldapSearch = new LdapSearch(ldapConnection)
{
    BaseDn = baseDn,
    LdapFilter = ldapFilter,
    SearchScope = searchScope,
    SizeLimit = sizeLimit,
    AttributeList = attributeList,
    PageSize = pageSize
};

foreach (LdapEntry ldapEntry in ldapSearch.Search())
{
    Console.WriteLine(ldapEntry.DistinguishedName);
    foreach (LdapAttribute ldapAttribute in ldapEntry.Attributes.Values)
    {
        Console.WriteLine($"    * {ldapAttribute.Name}: {ldapAttribute.Values.Count}");
        //foreach (string value in ldapAttribute.Values)
        //{
        //    Console.WriteLine($"        - \"{value}\"");
        //}
    }
}
```


## msdn DirectoryEntry
```cs

https://stackoverflow.com/questions/12271114/activedirectory-with-range-not-changing-results-using-directorysearcher
uint rangeStep = 1500;   
uint rangeLow = 0;   
uint rangeHigh = rangeLow + (rangeStep - 1);   
bool lastQuery = false;   
bool quitLoop = false;   

do   
{                       
    string attributeWithRange;   
    if (!lastQuery)   
    {   
        attributeWithRange = String.Format("member;Range={0}-{1}", rangeLow, rangeHigh);   
    }   
    else   
    {   
        attributeWithRange = String.Format("member;Range={0}-*", rangeLow);   
    }   
    DirectoryEntry dEntryhighlevel = new DirectoryEntry("LDAP://OU=C,OU=x,DC=h,DC=nt");   
    DirectorySearcher dSeacher = new DirectorySearcher(dEntryhighlevel,"(&(objectClass=user)(memberof=CN=Users,OU=t,OU=s,OU=x,DC=h,DC=nt))",new string[] {attributeWithRange});   
    dSeacher.PropertiesToLoad.Add("givenname");   
    dSeacher.PropertiesToLoad.Add("sn");   
    dSeacher.PropertiesToLoad.Add("samAccountName");   
    dSeacher.PropertiesToLoad.Add("mail");   
    dSeacher.PageSize = 1500;   
    SearchResultCollection resultCollection = resultCollection = dSeacher.FindAll();   
    dSeacher.Dispose();   

    foreach (SearchResult userResults in resultCollection)   
    {   

        string Last_Name = userResults.Properties["sn"][0].ToString();   
        string First_Name = userResults.Properties["givenname"][0].ToString();   
        string userName = userResults.Properties["samAccountName"][0].ToString();   
        string Email_Address = userResults.Properties["mail"][0].ToString();   
        OriginalList.Add(Last_Name + "|" + First_Name + "|" + userName + "|" + Email_Address);   
    }   
    if(resultCollection.Count == 1500)   
    {   
        lastQuery = true;   
        rangeLow = rangeHigh + 1;   
        rangeHigh = rangeLow + (rangeStep - 1);   
    }   
    else   
    {   
        quitLoop = true;   
    }   

}   
while (!quitLoop);
```





## Linux服务器端测试Ldap同步是否验证通
 yum install -y openldap-clients
测试ldap配置是否验证通过：
ldapsearch -h 192.168.251.41 -p 389 -b "dc=farawaygalaxy,dc=net" -D "cn=admin,dc=farawaygalaxy,dc=net" -w passw0rd
注意：
1.-h是 LDAP 主机名。
2.-p是 LDAP 端口名。
3.-b是 LDAP 基点值。
4.-D是 LDAP 绑定标识。
5.-w是 LDAP 绑定密码。

## 链接
- [语法](https://docs.microsoft.com/zh-cn/windows/win32/adsi/search-filter-syntax?redirectedfrom=msdn)
- [Active Directory: LDAP Syntax Filters](https://social.technet.microsoft.com/wiki/contents/articles/5392.active-directory-ldap-syntax-filters.aspx) 好例子
- [Default LDAP Filters and Attributes for Users, Groups and Containers](https://docs.oracle.com/cd/E26217_01/E26214/html/ldap-filters-attrs-users.html)
- [The SQL dialect](https://docs.microsoft.com/zh-cn/windows/win32/adsi/sql-dialect)
- [msdn 文章](https://docs.microsoft.com/en-us/previous-versions/dotnet/articles/bb332056(v=msdn.10)?redirectedfrom=MSDN#sdspintro_topic5_pagedsearch)
- [The .NET Developer's Guide to Identity](https://docs.microsoft.com/en-us/previous-versions/windows/server-2003/aa480245(v=msdn.10)?redirectedfrom=MSDN#dotnetidm_topic2)




