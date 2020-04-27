
//  class A1 { 
//     public string groupname { get; set; }
//         public string groupcode { get; set; }
//         public string account { get; set; }

//     }
//      List<A1> list = new List<A1>();
//             list.Add(new A1 { account = "1a", groupcode = "cc", groupname = "cc" });
//             list.Add(new A1 { account = "2a1", groupcode = "cc", groupname = "cc" });
//             list.Add(new A1 { account = "3a2", groupcode = "cc", groupname = "cc" });
//             list.Add(new A1 { account = "44a", groupcode = "bb", groupname = "bb" });
//             list.Add(new A1 { account = "7a", groupcode = "bb", groupname = "bb" });
// list.Sort(new A1Compareer());


//using System.Collections.Generic;
    public class A1Compareer : IComparer<A1>
    {
          int IComparer<A1>.Compare( A1 x,  A1 y)
        {
            if (x == null || y == null)
                throw new ArgumentException("Parameters can't be null");
            string fileA = x.account as string;
            string fileB = y.account as string;
            char[] arr1 = fileA.ToCharArray();
            char[] arr2 = fileB.ToCharArray();
            int i = 0, j = 0;
            while (i < arr1.Length && j < arr2.Length)
            {
                if (char.IsDigit(arr1[i]) && char.IsDigit(arr2[j]) && !IsSBC(arr1[i]) && !IsSBC(arr2[j]))
                {
                    string s1 = "", s2 = "";
                    while (i < arr1.Length && char.IsDigit(arr1[i]))
                    {
                        s1 += arr1[i];
                        i++;
                    }
                    while (j < arr2.Length && char.IsDigit(arr2[j]))
                    {
                        s2 += arr2[j];
                        j++;
                    }
                    try
                    {
                        if (int.Parse(s1) > int.Parse(s2))
                        {
                            return 1;
                        }
                        if (int.Parse(s1) < int.Parse(s2))
                        {
                            return -1;
                        }
                    }
                    catch
                    {
                        return -1;
                    }
                }
                else
                {
                    if (arr1[i] > arr2[j])
                    {
                        return 1;
                    }
                    if (arr1[i] < arr2[j])
                    {
                        return -1;
                    }
                    i++;
                    j++;
                }
            }
            if (arr1.Length == arr2.Length)
            {
                return 0;
            }
            else
            {
                return arr1.Length > arr2.Length ? 1 : -1;
            }
        }
        /// <summary>
        /// 判断字符是否是全角符号
        /// </summary>
        /// <param name="ch">判断字符</param>
        /// <returns></returns>
        public  bool IsSBC(char ch)
        {
            if ((ch >= 65281 && ch <= 65374) || ch == 12288)
            {
                return true;
            }
            return false;
        }
    }