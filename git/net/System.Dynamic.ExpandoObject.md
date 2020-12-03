


dynamic employee = new ExpandoObject();
employee.Name = "John Smith";
employee.Age = 33;

foreach (var property in (IDictionary<String, Object>)employee)
{
    Console.WriteLine(property.Key + ": " + property.Value);
}



  static void Main(string[] args)
        {
            dynamic obj = new System.Dynamic.ExpandoObject();
            obj.name = "jj";
            obj.age = 10;
            obj.gender = 1;

            foreach (var item in (IDictionary<string, object>)obj)
            {
                Console.WriteLine(item.Key + " : " + item.Value);
            }

            Console.WriteLine("************************************************");

            //动态删除属性
            var dic = (IDictionary<string, object>)obj;
            dic.Remove("name");
            foreach (var item in (IDictionary<string, object>)obj)
            {
                Console.WriteLine(item.Key + " : " + item.Value);
            }

            Console.Read();
        }

https://docs.microsoft.com/zh-cn/dotnet/api/System.Dynamic.ExpandoObject?view=netcore-3.1