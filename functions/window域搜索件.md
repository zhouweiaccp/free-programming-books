



##  Search Filter Syntax
SEARCH FILTER SYNTAX
Search filter	Description
"(objectClass=*)"	All objects.
"(&(objectCategory=person)(objectClass=user)(!(cn=andy)))"	All user objects but "andy".
"(sn=sm*)"	All objects with a surname that starts with "sm".
"(&(objectCategory=person)(objectClass=contact)(|(sn=Smith)(sn=Johnson)))"	All contacts with a surname equal to "Smith" or "Johnson".



## demo 不同步qq1
(&(objectCategory=person)(objectClass=user)(!(sAMAccountName=qq1)))

- [](https://docs.microsoft.com/zh-cn/windows/win32/adsi/search-filter-syntax?redirectedfrom=msdn)