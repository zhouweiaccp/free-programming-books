



## 
```
 Install-Package Microsoft.CodeAnalysis
 Install-Package Microsoft.CodeAnalysis.CSharp.Scripting



 using Microsoft.CodeAnalysis.Scripting;
 using Microsoft.CodeAnalysis.CSharp.Scripting;
 using Microsoft.CodeAnalysis.CSharp;
 using Microsoft.CodeAnalysis.CSharp.Syntax;



#region 02 References and Namespaces
ScriptOptions scriptOptions = ScriptOptions.Default;
#region 引用配置
//Add reference to mscorlib
var mscorlib = typeof(System.Object).Assembly;
var systemCore = typeof(System.Linq.Enumerable).Assembly;
scriptOptions = scriptOptions.AddReferences(mscorlib);
scriptOptions = scriptOptions.AddReferences(systemCore);
scriptOptions = scriptOptions.AddImports("System", "System.Linq", "System.Collections.Generic");
#endregion
var state = CSharpScript.RunAsync(@"int x=2;int y=3;int z =x*y;return z+1;");
//int x=2 => 2
string x = state.Result.GetVariable("x").Value.ToString();
//return return z+1 => 7
string retvalue = state.Result.ReturnValue.ToString();
//Int32
Type xtype = state.Result.GetVariable("x").Value.GetType();
if(xtype.FullName == typeof(int).FullName)
{

}
//int z =x*y => 6
string z =state.Result.GetVariable("z").Value.ToString();

string sourceCode = state.Result.Script.Code;

string output = "";
foreach (var p in state.Result.Variables)
{
    output += string.Format("name:{0},type:{1},value:{2};", p.Name, p.Type, p.Value);
}
Console.WriteLine(output);
#endregion

```



#region 03 SyntaxTree
var tree = CSharpSyntaxTree.ParseText(@"
        public class MyClass
        {
            public int FnSum(int x,int y)
            {
                    return x+y;
            }
        }");

var syntaxRoot = tree.GetRoot();
var MyClass = syntaxRoot.DescendantNodes().OfType<ClassDeclarationSyntax>().First();
var MyMethod = syntaxRoot.DescendantNodes().OfType<MethodDeclarationSyntax>().First();

Console.WriteLine(MyClass.Identifier.ToString());
Console.WriteLine(MyMethod.Identifier.ToString());
Console.WriteLine(MyMethod.ParameterList.ToString());
#endregion



#region 04 Globals

var state4 = CSharpScript.RunAsync(@"var ret = requestData + "" from globals""; ", globals: new Globals { requestData = "hello world" });
Console.WriteLine( state4.Result.GetVariable("ret").Value);

#endregion

public class Globals
    {
        /// <summary>
        /// 可以在脚本中直接进行调用
        /// </summary>
        public string requestData { get; set; }

    }

## link
 -[](https://docs.microsoft.com/en-us/dotnet/api/microsoft.codeanalysis.csharp?view=roslyn-dotnet)
 - [](https://www.cnblogs.com/isaboy/p/Microsoft_CodeAnalysis_CSharp_Scripting.html)