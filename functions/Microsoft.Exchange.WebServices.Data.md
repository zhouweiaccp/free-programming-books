











## Exchange 服务器
* [在 Exchange 服务器上配置邮件流和客户端访问](https://docs.microsoft.com/zh-cn/exchange/plan-and-deploy/post-installation-tasks/configure-mail-flow-and-client-access?view=exchserver-2019)
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()
* []()

## link
* [api](https://docs.microsoft.com/en-us/exchange/client-developer/exchange-web-services/explore-the-ews-managed-api-ews-and-web-services-in-exchange?redirectedfrom=MSDN)
* [earching-of-folders-in-public-folders](https://stackoverflow.com/questions/14561124/searching-of-folders-in-public-folders-by-giving-its-path-name)
* [exchangeserver](https://social.msdn.microsoft.com/Forums/en-US/home?category=exchangeserver&forum=exchangesvrdevelopment&filter=alltypes&brandIgnore=True&sort=relevancedesc&category=exchangeserver&forum=exchangesvrdevelopment&filter=alltypes&sort=relevancedesc&brandIgnore=true&filter=alltypes&searchTerm=foldername) 
* [ews-managed-api](https://github.com/OfficeDev/ews-managed-api) 官网 不在更新
* [](https://developer.microsoft.com/en-us/graph/blogs/upcoming-changes-to-exchange-web-services-ews-api-for-office-365/)  exchang 新版接口，
* [Searching for folders in a mailbox by using the EWS Managed API 2.0](https://docs.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2010/dd633627(v=exchg.80))
* [多条件搜索](https://docs.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2010/dd633695(v=exchg.80))
* [EwsClient](https://github.com/fr33k3r/SODA.NET/blob/master/SODA.Utilities/EwsClient.cs)
* []()
* []()
* []()
* []()




## code demo1
```cs
using System;
using System.DirectoryServices.AccountManagement;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using Microsoft.Exchange.WebServices.Data;

namespace EmailServices.Web.IntegrationTests
{
//https://stackoverflow.com/questions/14561124/searching-of-folders-in-public-folders-by-giving-its-path-name.
    // http://msdn.microsoft.com/en-us/library/exchange/jj220499(v=exchg.80).aspx
    internal class MsExchangeServices
    {
        public MsExchangeServices()
        {
            ServicePointManager.ServerCertificateValidationCallback = CertificateValidationCallBack;
            m_exchangeService = new ExchangeService { UseDefaultCredentials = true };

            // Who's running this test? They better have Exchange mailbox access.
            m_exchangeService.AutodiscoverUrl(UserPrincipal.Current.EmailAddress, RedirectionUrlValidationCallback);
        }

        public ExchangeService Service { get { return m_exchangeService; } }

        public Folder GetPublicFolderByPath(string ewsFolderPath)
        {
            string[] folders = ewsFolderPath.Split('\\');

            Folder parentFolderId = null;
            Folder actualFolder = null;

            for (int i = 0; i < folders.Length; i++)
            {
                if (0 == i)
                {
                    parentFolderId = GetTopLevelFolder(folders[i]);
                    actualFolder = parentFolderId;
                }
                else
                {
                    actualFolder = GetFolder(parentFolderId.Id, folders[i]);
                    parentFolderId = actualFolder;
                }
            }
            return actualFolder;
        }

        private static bool RedirectionUrlValidationCallback(string redirectionUrl)
        {
            // The default for the validation callback is to reject the URL.
            bool result = false;

            Uri redirectionUri = new Uri(redirectionUrl);

            // Validate the contents of the redirection URL. In this simple validation
            // callback, the redirection URL is considered valid if it is using HTTPS
            // to encrypt the authentication credentials. 
            if (redirectionUri.Scheme == "https")
                result = true;

            return result;
        }

        private static bool CertificateValidationCallBack(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            // If the certificate is a valid, signed certificate, return true.
            if (sslPolicyErrors == SslPolicyErrors.None)
                return true;

            // If there are errors in the certificate chain, look at each error to determine the cause.
            if ((sslPolicyErrors & SslPolicyErrors.RemoteCertificateChainErrors) == 0)
            {
                // In all other cases, return false.
                return false;
            }
            else
            {
                if (chain != null)
                {
                    foreach (X509ChainStatus status in chain.ChainStatus)
                    {
                        if ((certificate.Subject == certificate.Issuer) && (status.Status == X509ChainStatusFlags.UntrustedRoot))
                        {
                            // Self-signed certificates with an untrusted root are valid. 
                        }
                        else
                        {
                            if (status.Status != X509ChainStatusFlags.NoError)
                            {
                                // If there are any other errors in the certificate chain, the certificate is invalid,
                                // so the method returns false.
                                return false;
                            }
                        }
                    }
                }

                // When processing reaches this line, the only errors in the certificate chain are 
                // untrusted root errors for self-signed certificates. These certificates are valid
                // for default Exchange server installations, so return true.
                return true;
            }
        }

        private Folder GetTopLevelFolder(string folderName)
        {
            FindFoldersResults findFolderResults = m_exchangeService.FindFolders(WellKnownFolderName.PublicFoldersRoot, new FolderView(int.MaxValue));
            foreach (Folder folder in findFolderResults.Where(folder => folderName.Equals(folder.DisplayName, StringComparison.InvariantCultureIgnoreCase)))
                return folder;

            throw new Exception("Top Level Folder not found: " + folderName);
        }

        private Folder GetFolder(FolderId parentFolderId, string folderName)
        {
            FindFoldersResults findFolderResults = m_exchangeService.FindFolders(parentFolderId, new FolderView(int.MaxValue));
            foreach (Folder folder in findFolderResults.Where(folder => folderName.Equals(folder.DisplayName, StringComparison.InvariantCultureIgnoreCase)))
                return folder;

            throw new Exception("Folder not found: " + folderName);
        }
```

### Filtering on SearchFilterCollection
```cs
// Obtain a collection of e-mail messages that satisfy a specified Search filter.
//https://docs.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2010/dd633695(v=exchg.80)
ItemView view = new ItemView(10);
view.PropertySet = new PropertySet(BasePropertySet.IdOnly, ItemSchema.Subject);
// SearchFilterCollection - Filter on mail with the word "extended” in the Subject
// or an extended property value of six. 
SearchFilter.SearchFilterCollection searchFilterCollection = new SearchFilter.SearchFilterCollection(LogicalOperator.Or);
// Add the first search filter - search for the word "extended" in the Subject.
searchFilterCollection.Add(new SearchFilter.ContainsSubstring(ItemSchema.Subject, "extended"));
// Add the second search filter - search for the extended property value of six.
Guid MyPropertySetIdint = new Guid("{75A5486F-9267-49ca-9B4E-3D04CA9EC179}");
ExtendedPropertyDefinition extendedPropertyDefinitionint = new ExtendedPropertyDefinition(MyPropertySetIdint, "MyFlag", MapiPropertyType.Integer);
searchFilterCollection.Add(new SearchFilter.IsEqualTo(extendedPropertyDefinitionint, 6));

FindItemsResults<Item> findResults = service.FindItems(WellKnownFolderName.Inbox, searchFilterCollection, view);

```

### Perform a paged search by using the EWS Managed API
```cs
//https://docs.microsoft.com/en-us/exchange/client-developer/exchange-web-services/how-to-perform-paged-searches-by-using-ews-in-exchange
using Microsoft.Exchange.WebServices.Data;
static void PageSearchItems(ExchangeService service, WellKnownFolderName folder)
{
    int pageSize = 5;
    int offset = 0;
    // Request one more item than your actual pageSize.
    // This will be used to detect a change to the result
    // set while paging.
    ItemView view = new ItemView(pageSize + 1, offset);
    view.PropertySet = new PropertySet(ItemSchema.Subject);
    view.OrderBy.Add(ItemSchema.DateTimeReceived, SortDirection.Descending);
    view.Traversal = ItemTraversal.Shallow;
    bool moreItems = true;
    ItemId anchorId = null;
    while (moreItems)
    {
        try
        {
            FindItemsResults<Item> results = service.FindItems(folder, view);
            moreItems = results.MoreAvailable;
            if (moreItems && anchorId != null)
            {
                // Check the first result to make sure it matches
                // the last result (anchor) from the previous page.
                // If it doesn't, that means that something was added
                // or deleted since you started the search.
                if (results.Items.First<Item>().Id != anchorId)
                {
                    Console.WriteLine("The collection has changed while paging. Some results may be missed.");
                }
            }
            if (moreItems)
                view.Offset += pageSize;
                
            anchorId = results.Items.Last<Item>().Id;
            
            // Because you're including an additional item on the end of your results
            // as an anchor, you don't want to display it.
            // Set the number to loop as the smaller value between
            // the number of items in the collection and the page size.
            int displayCount = 0;
            if ((results.MoreAvailable == false && results.Items.Count > pageSize) || (results.Items.Count < pageSize))
            {
                displayCount = results.Items.Count;
            }
            else
            {
                displayCount = pageSize;
            }
            
            for (int i = 0; i < displayCount; i++)
            {
                Item item = results.Items[i];
                Console.WriteLine("Subject: {0}", item.Subject);
                Console.WriteLine("Id: {0}\n", item.Id.ToString());
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Exception while paging results: {0}", ex.Message);
        }
    }
}
````

## 比较完整例子
```cs
 public void accessShared()
    {
        ServicePointManager.ServerCertificateValidationCallback = m_UrlBack.CertificateValidationCallBack;

            ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2010_SP2);

            // Get the information of the account.
            service.Credentials = new WebCredentials(EMAIL_ACCOUNT, EMAIL_PWD);

            // Set the url of server.
            if (!AutodiscoverUrl(service, EMAIL_ACCOUNT))
            {
                return;
            }

            var mb = new Mailbox(SHARED_MAILBOX);

            var fid1 = new FolderId(WellKnownFolderName.Inbox, mb);

            // Add a search filter that searches on the body or subject.
            List<SearchFilter> searchFilterCollection = new List<SearchFilter>();
            searchFilterCollection.Add(new SearchFilter.ContainsSubstring(ItemSchema.Subject, SUBJECT_KEY_WORD));
            SearchFilter searchFilter = new SearchFilter.SearchFilterCollection(LogicalOperator.Or, searchFilterCollection.ToArray());

            // Create a view with a page size of 10.
            var view = new ItemView(10);

            // Identify the Subject and DateTimeReceived properties to return.
            // Indicate that the base property will be the item identifier
            view.PropertySet = new PropertySet(BasePropertySet.IdOnly, ItemSchema.Subject, ItemSchema.DateTimeReceived);

            // Order the search results by the DateTimeReceived in descending order.
            view.OrderBy.Add(ItemSchema.DateTimeReceived, SortDirection.Ascending);

            // Set the traversal to shallow. (Shallow is the default option; other options are Associated and SoftDeleted.)
            view.Traversal = ItemTraversal.Shallow;
            String[] invalidStings = { "\\", ",", ":", "*", "?", "\"", "<", ">", "|" };

            PropertySet itemPorpertySet = new PropertySet(BasePropertySet.FirstClassProperties,
                EmailMessageSchema.MimeContent);

            FindItemsResults<Item> findResults = service.FindItems(fid1, searchFilter, view);
            foreach (Item item in findResults.Items)
            {
                EmailMessage email = EmailMessage.Bind(service, item.Id, new PropertySet(BasePropertySet.IdOnly, ItemSchema.Attachments));
                email.Load(itemPorpertySet);

                string emailBody = email.Body.ToString();
            }
    }

```