  Student stu = new Student()
             {
                 ID = 1,
                 Name = "曹操",
                 Sex = "男",
                 Age = 1000
             };
            //序列化
            DataContractJsonSerializer js = new DataContractJsonSerializer(typeof(Student));
            MemoryStream msObj = new MemoryStream();
            //将序列化之后的Json格式数据写入流中
            js.WriteObject(msObj, stu);
            msObj.Position = 0;
            //从0这个位置开始读取流中的数据
            StreamReader sr = new StreamReader(msObj, Encoding.UTF8);
            string json = sr.ReadToEnd();
            sr.Close();
            msObj.Close();
            Console.WriteLine(json);
 
 
            //反序列化
            string toDes = json;
            //string to = "{\"ID\":\"1\",\"Name\":\"曹操\",\"Sex\":\"男\",\"Age\":\"1230\"}";
            using (var ms = new MemoryStream(Encoding.Unicode.GetBytes(toDes)))
            {
                DataContractJsonSerializer deseralizer = new DataContractJsonSerializer(typeof(Student));
                Student model = (Student)deseralizer.ReadObject(ms);// //反序列化ReadObject
                Console.WriteLine("ID=" + model.ID);
                Console.WriteLine("Name=" + model.Name);
                Console.WriteLine("Age=" + model.Age);
                Console.WriteLine("Sex=" + model.Sex);
            }
            Console.ReadKey();



using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
 
namespace JsonSerializerAndDeSerializer
{
    [DataContract]
   public class Student
    {
        [DataMember]
       public int ID { get; set; }
 
        [DataMember]
       public string Name { get; set; }
 
        [DataMember]
       public int Age { get; set; }
 
        [DataMember]
       public string Sex { get; set; }
    }
}
//https://www.bamn.cn/news/views/335