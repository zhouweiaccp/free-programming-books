1.Expression<Func<T,TResult>>是表达式
//使用LambdaExpression构建表达式树
            Expression<Func<int, int, int, int>> expr = (x, y, z) => (x + y) / z;
            Console.WriteLine(expr.Compile()(1, 2, 3));
https://msdn.microsoft.com/zh-cn/library/system.linq.expressions.expression(v=vs.100).aspx

https://msdn.microsoft.com/zh-cn/library/bb335710(v=vs.100).aspx

 

2.Func<T, TResult> 委托
封装一个具有一个参数并返回 TResult 参数指定的类型值的方法。
public delegate TResult Func<in T, out TResult>(T arg)
类型参数
in T
此委托封装的方法的参数类型。
该类型参数是逆变的。即可以使用指定的类型或派生程度更低的类型。有关协变和逆变的更多信息，请参见泛型中的协变和逆变。
out TResult
此委托封装的方法的返回值类型。
该类型参数是协变的。即可以使用指定的类型或派生程度更高的类型。有关协变和逆变的更多信息，请参见泛型中的协变和逆变。
参数
arg
类型：T
此委托封装的方法的参数。
返回值
类型：TResult
此委托封装的方法的返回值。

复制代码
  string mid = ",middle part,";
            ///匿名写法
            Func<string, string> anonDel = delegate(string param)
            {
                param += mid;
                param += " And this was added to the string.";
                return param;
            };
            ///λ表达式写法
            Func<string, string> lambda = param =>
                {
                    param += mid;
                    param += " And this was added to the string.";
                    return param;
                };
            ///λ表达式写法(整形)
            Func<int, int> lambdaint = paramint =>
                {
                    paramint = 5;
                    return paramint;
                };
            ///λ表达式带有两个参数的写法
            Func<int, int, int> twoParams = (x, y) =>
                {
                  return  x*y;
                };
            MessageBox.Show("匿名方法："+anonDel("Start of string"));
            MessageBox.Show("λ表达式写法:" + lambda("Lambda expression"));
            MessageBox.Show("λ表达式写法(整形):" + lambdaint(4).ToString());
            MessageBox.Show("λ表达式带有两个参数:" + twoParams(10, 20).ToString());
复制代码
 来自:

http://blog.csdn.net/shuyizhi/article/details/6598013

3.使用Expression进行查询拼接
复制代码
    public static class DynamicLinqExpressions
     {
 
         public static Expression<Func<T, bool>> True<T>() { return f => true; }
         public static Expression<Func<T, bool>> False<T>() { return f => false; }
 
         public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> expr1,
                                                             Expression<Func<T, bool>> expr2)
         {
             var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
             return Expression.Lambda<Func<T, bool>>
                   (Expression.Or(expr1.Body, invokedExpr), expr1.Parameters);
         }
 
         public static Expression<Func<T, bool>> And<T>(this Expression<Func<T, bool>> expr1,
                                                              Expression<Func<T, bool>> expr2)
         {
             var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
             return Expression.Lambda<Func<T, bool>>
                   (Expression.And(expr1.Body, invokedExpr), expr1.Parameters);
         }
 
     }
复制代码
使用方法

复制代码
       public static IEnumerable<T> FilterBy<T>(this IEnumerable<T> collection, IEnumerable<KeyValuePair<string, string>> query)
         {
             var filtersCount = int.Parse(query.SingleOrDefault(k => k.Key.Contains("filterscount")).Value);
             
             Expression<Func<T, bool>> finalquery = null;
 
             for (var i = 0; i < filtersCount; i += 1)
             {
                 var filterValue = query.SingleOrDefault(k => k.Key.Contains("filtervalue" + i)).Value;
                 var filterCondition = query.SingleOrDefault(k => k.Key.Contains("filtercondition" + i)).Value;
                 var filterDataField = query.SingleOrDefault(k => k.Key.Contains("filterdatafield" + i)).Value;
                 var filterOperator = query.SingleOrDefault(k => k.Key.Contains("filteroperator" + i)).Value;
 
                 Expression<Func<T, bool>> current = n => GetQueryCondition(n, filterCondition, filterDataField, filterValue);
 
                 if (finalquery == null)
                 {
                     finalquery = current;
                 }
                 else if (filterOperator == "1")
                 {
                     finalquery = finalquery.Or(current);
                 }
                 else
                 {
                     finalquery = finalquery.And(current);
                 }
             };
 
             if (finalquery != null)
                 collection = collection.AsQueryable().Where(finalquery);
 
             return collection;
         }
复制代码
要使用AsQueryable，必须引入 LinqKit.EntityFramework；如果不使用AsQueryable将会报错。

 

4.关于SelectListItem的扩展 
复制代码
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Web.Mvc;
using System.Web.UI;

namespace Web.Helper
{
    public static class SelectListItemExtensions
    {
        /// <summary>
        /// Data.ToSelectListItems(s=>s.Id,s=>s.Name);
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="baseEntities"></param>
        /// <param name="valueExpression"></param>
        /// <param name="textExpression"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static IEnumerable<SelectListItem> ToSelectListItems<T>(this IEnumerable<T> baseEntities, Expression<Func<T, string>> valueExpression, Expression<Func<T, string>> textExpression, object defaultValue = null)
        {
            dynamic valueNameObject = valueExpression.Body.GetType().GetProperty("Member").GetValue(valueExpression.Body, null);
            dynamic textNameobject = textExpression.Body.GetType().GetProperty("Member").GetValue(textExpression.Body, null);

            var valueName = (string)valueNameObject.Name;
            var textName = (string)textNameobject.Name;

            return ToSelectListItems(baseEntities, valueName, textName, null);
        }
        /// <summary>
        /// Data.ToSelectListItems("Id", "Name")
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="baseEntities"></param>
        /// <param name="valueName"></param>
        /// <param name="textName"></param>
        /// <param name="defaultValue"></param>
        /// <returns></returns>
        public static IEnumerable<SelectListItem> ToSelectListItems<T>(this IEnumerable<T> baseEntities, string valueName, string textName, object defaultValue = null)
        {
            if (string.IsNullOrWhiteSpace(valueName) || string.IsNullOrWhiteSpace(textName))
            {
                return new List<SelectListItem>();
            }
            var selectListItem = new List<SelectListItem>();
            if (defaultValue != null)
            {
                foreach (var baseEntity in baseEntities)
                {
                    var itemValue = GetPropertyValue(baseEntity, valueName);
                    selectListItem.Add(new SelectListItem()
                    {
                        Value = itemValue.ToString(),
                        Text = GetPropertyValue(baseEntity, textName).ToString(),
                        Selected = itemValue == defaultValue
                    });
                }
            }
            else
            {
                foreach (var baseEntity in baseEntities)
                {
                    selectListItem.Add(new SelectListItem()
                    {
                        Value = GetPropertyValue(baseEntity, valueName).ToString(),
                        Text = GetPropertyValue(baseEntity, textName).ToString(),
                    });
                }
            }

            return selectListItem;
        }

        public static object GetPropertyValue(object obj, string propertyName)
        {
            //反射去获得对象的某个属性值
            //Type t = obj.GetType();
            //PropertyInfo info = t.GetProperty(propertyName);
            //return info.GetValue(obj, null); //设置为SetValue

            return DataBinder.GetPropertyValue(obj, propertyName);
            //return DataBinder.Eval(obj, propertyName);
        }


    }
}


##   Expression Like
list.Filter("Customer == 'Name'");
做什么应该内部工作像解析器一样,将表达式==或！=转换为System.Linq.Expressions.Expression.在这种情况下,==成为System.Linq.Expressions.Expression.Equal.

不幸的是System.Linq.Expressions.Expression不包含类似的操作符,我不知道如何解决这个问题.

初始代码如下所示：

private static Dictionary<String, Func<Expression, Expression, Expression>> 
    binaryOpFactory = new Dictionary<String, Func<Expression, Expression, Expression>>();

static Init() {
    binaryOpFactory.Add("==", Expression.Equal);
    binaryOpFactory.Add(">", Expression.GreaterThan);
    binaryOpFactory.Add("<", Expression.LessThan);
    binaryOpFactory.Add(">=", Expression.GreaterThanOrEqual);
    binaryOpFactory.Add("<=", Expression.LessThanOrEqual);
    binaryOpFactory.Add("!=", Expression.NotEqual);
    binaryOpFactory.Add("&&", Expression.And);
    binaryOpFactory.Add("||", Expression.Or);
}
然后我创建了一个将要做的事情：

private static System.Linq.Expressions.Expression<Func<String, String, bool>>
    Like_Lambda = (item, search) => item.ToLower().Contains(search.ToLower());

private static Func<String, String, bool> Like = Like_Lambda.Compile();
例如

Console.WriteLine(like("McDonalds", "donAld")); // true
Console.WriteLine(like("McDonalds", "King"));   // false
但是binaryOpFactory需要这样做：

Func<Expression, Expression, Expression>
预定义的表达式似乎正是这样：

System.Linq.Expressions.Expression.Or;
任何人都可以告诉我如何转换我的表情？

就像是：
static IEnumerable<T> WhereLike<T>(
        this IEnumerable<T> data,
        string propertyOrFieldName,
        string value)
{
    var param = Expression.Parameter(typeof(T), "x");
    var body = Expression.Call(
        typeof(Program).GetMethod("Like",
            BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public),
            Expression.PropertyOrField(param, propertyOrFieldName),
            Expression.Constant(value, typeof(string)));
    var lambda = Expression.Lambda<Func<T, bool>>(body, param);
    return data.Where(lambda.Compile());
}
static bool Like(string a, string b) {
    return a.Contains(b); // just for illustration
}
关于Func<表达式,表达式,表达式>：

static Expression Like(Expression lhs, Expression rhs)
{
    return Expression.Call(
        typeof(Program).GetMethod("Like",
            BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public)
            ,lhs,rhs);
}