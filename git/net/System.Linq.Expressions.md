


//  Expression<Func<Banner, bool>> expre = x => x.Status == 1;
//             if (!string.IsNullOrEmpty(search))
//             {
//                 expre = ExpressionFuncExtender.And(expre, x => x.Title.Contains(search));
//             }

using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Common
{
    public static class ExpressionFuncExtender
    {
        /// <summary>
        ///     以特定的条件运行组合两个Expression表达式
        /// </summary>
        /// <typeparam name="T">表达式的主实体类型</typeparam>
        /// <param name="first">第一个Expression表达式</param>
        /// <param name="second">要组合的Expression表达式</param>
        /// <param name="merge">组合条件运算方式</param>
        /// <returns>组合后的表达式</returns>
        public static Expression<T> Compose<T>(this Expression<T> first, Expression<T> second,
            Func<Expression, Expression, Expression> merge)
        {
            var map = first.Parameters.Select((f, i) => new { f, s = second.Parameters[i] }).ToDictionary(p => p.s, p => p.f);
            var secondBody = ParameterRebinder.ReplaceParameters(map, second.Body);
            return Expression.Lambda<T>(merge(first.Body, secondBody), first.Parameters);
        }

        /// <summary>
        ///     以 Expression.AndAlso 组合两个Expression表达式
        /// </summary>
        /// <typeparam name="T">表达式的主实体类型</typeparam>
        /// <param name="first">第一个Expression表达式</param>
        /// <param name="second">要组合的Expression表达式</param>
        /// <returns>组合后的表达式</returns>
        public static Expression<Func<T, bool>> And<T>(this Expression<Func<T, bool>> first,
            Expression<Func<T, bool>> second)
        {
            return first.Compose(second, Expression.AndAlso);
        }

        /// <summary>
        ///     以 Expression.OrElse 组合两个Expression表达式
        /// </summary>
        /// <typeparam name="T">表达式的主实体类型</typeparam>
        /// <param name="first">第一个Expression表达式</param>
        /// <param name="second">要组合的Expression表达式</param>
        /// <returns>组合后的表达式</returns>
        public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> first,
            Expression<Func<T, bool>> second)
        {
            return first.Compose(second, Expression.OrElse);
        }

        private class ParameterRebinder : ExpressionVisitor
        {
            private readonly Dictionary<ParameterExpression, ParameterExpression> _map;

            private ParameterRebinder(Dictionary<ParameterExpression, ParameterExpression> map)
            {
                _map = map ?? new Dictionary<ParameterExpression, ParameterExpression>();
            }

            public static Expression ReplaceParameters(Dictionary<ParameterExpression, ParameterExpression> map,
                Expression exp)
            {
                return new ParameterRebinder(map).Visit(exp);
            }

            protected override Expression VisitParameter(ParameterExpression node)
            {
                ParameterExpression replacement;
                if (_map.TryGetValue(node, out replacement))
                    node = replacement;
                return base.VisitParameter(node);
            }
        }
    }
}




##  demo2

// var where = PredicateBuilder.True<BaoGaiTouBit>();
// where = where.And(e => e.IsEnable);
// where = where.And(e => e.DeadLine >= mindate);
// where = where.And(e => e.DeadLine < maxdate);
public static class PredicateBuilder
{
 
/// <summary>
/// 机关函数应用True时：单个AND有效，多个AND有效；单个OR无效，多个OR无效；混应时写在AND后的OR有效
/// </summary>
/// <typeparam name="T"></typeparam>
/// <returns></returns>
public static Expression<Func<T, bool>> True<T>() { return f => true; }
 
/// <summary>
/// 机关函数应用False时：单个AND无效，多个AND无效；单个OR有效，多个OR有效；混应时写在OR后面的AND有效
/// </summary>
/// <typeparam name="T"></typeparam>
/// <returns></returns>
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