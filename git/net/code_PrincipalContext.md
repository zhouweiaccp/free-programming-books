   --分页查询
   private static SearchResultCollection GetAdInfor2(DirectoryEntry ouDirEntrty, string schemaClassNameToSearch, SearchScope scope, int offset)
        {
            DirectorySearcher searcher = new DirectorySearcher();
            searcher.SearchRoot = ouDirEntrty;
            searcher.Filter = schemaClassNameToSearch;
            searcher.SearchScope = scope;
            searcher.Sort = new SortOption("name", System.DirectoryServices.SortDirection.Ascending);
            //  searcher.PageSize = 10;
            searcher.SizeLimit = 10;
            searcher.VirtualListView = new DirectoryVirtualListView(10, 0, offset);
            searcher.PropertiesToLoad.AddRange(new string[] { "name", "Path", "displayname", "samaccountname", "mail" });
            searcher.ServerTimeLimit = new TimeSpan(1, 0, 0);
            SearchResultCollection results = searcher.FindAll();
            return results;
        }

    
       --查询ad 所有用户，没有分页
         PrincipalContext ctx = new PrincipalContext(ContextType.Domain, "192.168.251.49:389", "OU=syncOrg,dc=sftest,dc=com", @"sftest\administrator", "1qaz2WSX");

                // define a "query-by-example" principal - here, we search for a UserPrincipal 
                // and with the first name (GivenName) of "Bruce"
                UserPrincipal qbeUser = new UserPrincipal(ctx);
              //  qbeUser.GivenName = "administrator";
           

                // create your principal searcher passing in the QBE principal    
                PrincipalSearcher srch = new PrincipalSearcher(qbeUser);

                // set the PageSize on the underlying DirectorySearcher to get all 3000 entries
                ((DirectorySearcher)srch.GetUnderlyingSearcher()).PageSize = 500;
                var datas = srch.FindAll();

             
                // find all matches
                foreach (var found in datas)
                {
                    var dirEntry2 = (DirectoryEntry)found.GetUnderlyingObject();
                    LogUtility.InforLog("", found.DisplayName +"{0},{1},{2}", dirEntry2.Path, dirEntry2.Guid.ToString(),found.Guid.Value.ToString());
                    // do whatever here - "found" is of type "Principal" - it could be user, group, computer.....          
                }




--创建Windows用户及组
 public static class Commons
    {
        static Configuration config;
        static AppSettingsSection appSetting;
        public static ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        static bool CreateLocalWindowsAccount(string userName, string passWord, string displayName, string description, string groupName, bool canChangePwd, bool pwdExpires)
        {
            bool retIsSuccess = false;
            try
            {
                PrincipalContext context = new PrincipalContext(ContextType.Machine);
                UserPrincipal user = new UserPrincipal(context);
                user.SetPassword(passWord);
                user.DisplayName = displayName;
                user.Name = userName;
                user.Description = description;
                user.UserCannotChangePassword = canChangePwd;
                user.PasswordNeverExpires = pwdExpires;
                user.Save();

                GroupPrincipal group = GroupPrincipal.FindByIdentity(context, groupName);
                group.Members.Add(user);
                group.Save();
                retIsSuccess = true;
            }
            catch (Exception ex)
            {
                retIsSuccess = false;
            }
            return retIsSuccess;
        }

        static GroupPrincipal CreateGroup(string groupName, Boolean isSecurityGroup)
        {
            GroupPrincipal retGroup = null;
            try
            {
                retGroup = IsGroupExist(groupName);
                if (retGroup == null)
                {
                    PrincipalContext ctx = new PrincipalContext(ContextType.Machine);
                    GroupPrincipal insGroupPrincipal = new GroupPrincipal(ctx);
                    insGroupPrincipal.Name = groupName;
                    insGroupPrincipal.IsSecurityGroup = isSecurityGroup;
                    insGroupPrincipal.GroupScope = GroupScope.Local;
                    insGroupPrincipal.Save();
                    retGroup = insGroupPrincipal;
                }
            }
            catch (Exception ex)
            {

            }

            return retGroup;
        }

        static GroupPrincipal IsGroupExist(string groupName)
        {
            GroupPrincipal retGroup = null;
            try
            {
                PrincipalContext ctx = new PrincipalContext(ContextType.Machine);
                GroupPrincipal qbeGroup = new GroupPrincipal(ctx);
                PrincipalSearcher srch = new PrincipalSearcher(qbeGroup);
                foreach (GroupPrincipal ingrp in srch.FindAll())
                {
                    if (ingrp != null && ingrp.Name.Equals(groupName))
                    {
                        retGroup = ingrp;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {

            }
            return retGroup;
        }

        public static int UpdateGroupUsers(string groupName, List<string> usersName)
        {
            List<string> addedUsers = new List<string>();
            int retAddCount = 0;

            GroupPrincipal qbeGroup = CreateGroup(groupName, false);
            foreach (UserPrincipal user in qbeGroup.GetMembers())
            {
                if (usersName.Contains(user.Name))
                {
                    addedUsers.Add(user.Name);
                    retAddCount++;
                }
                else
                {
                    user.Delete();
                }
            }
            foreach (string addedUserName in addedUsers)
            {
                usersName.Remove(addedUserName);
            }
            foreach (string addUserName in usersName)
            {
                bool isSuccess = CreateLocalWindowsAccount(addUserName, "password", addUserName, "", groupName, false, false);
                if (isSuccess)     retAddCount++;
            }return retAddCount;
        }


    }