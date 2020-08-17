SameSite-cookies是一种机制，用于定义cookie如何跨域发送。这是谷歌开发的一种安全机制，并且现在在最新版本（Chrome Dev 51.0.2704.4）中已经开始实行了。SameSite-cookies的目的是尝试阻止CSRF（Cross-site request forgery 跨站请求伪造）以及XSSI（Cross Site Script Inclusion (XSSI) 跨站脚本包含）攻击。详细介绍可以看这一篇文章。

SameSite-cookies之前一直受到广大安全研究人员的关注，现在它终于在Chrome-dev上工作了，这是一个好消息。这意味着如果你有一个使用cookies的网站，你应该开始支持SameSite-cookies。事实上，这非常容易。你只需要在Set-Cookie中添加一个SameSite属性。需要注意的是，SameSite需要一个值（如果没有设置值，默认是Strict），值可以是Lax或者Strict。你可以在草案中阅读这些属性的相关定义，但这里我会简单解释几种常见的属性，这样叫你就可以很容易的理解它们是如何工作的。

使用语法是SameSite=<value>, 例如SameSite=Lax

Strict

Strict是最严格的防护，有能力阻止所有CSRF攻击。然而，它的用户友好性太差，因为它可能会将所有GET请求进行CSRF防护处理。

例如：一个用户在reddit.com点击了一个链接（GET请求），这个链接是到facebook.com的，而假如facebook.com使用了Samesite-cookies并且将值设置为了Strict，那么用户将不能登陆Facebook.com，因为在Strict情况下，浏览器不允许将cookie从A域发送到Ｂ域。

Lax

Lax(relax的缩写？)属性只会在使用危险HTTP方法发送跨域cookie的时候进行阻止，例如POST方式。

例1：一个用户在reddit.com点击了一个链接（GET请求），这个链接是到facebook.com的，而假如facebook.com使用了Samesite-cookies并且将值设置为了Lax，那么用户可以正常登录facebok.com，因为浏览器允许将cookie从A域发送到B域。

例2：一个用户在reddit.com提交了一个表单（POST请求），这个表单是提交到facebook.com的，而假如facebook.com使用了Samesite-cookies并且将值设置为了Lax，那么用户将不能正常登陆Facebook.com，因为浏览器不允许使用POST方式将cookie从A域发送到Ｂ域。

注意

根据草案中所说，Lax并没有充分防止CSRF和XSSI攻击。但我还是建议先使用Lax进行一个较好的CSRF攻击缓解措施，之后再考虑是否使用Strict。

同时，需要注意，不要将所有的cookie都设置SameSite属性，因为不同的cookie有不同的用途，如果你的网站使用有会话cookie，它可以被设置为Lax属性；其他的可以设置为Strict属性。这可能是一种合适的方式。

## SameSiteMode
SameSiteMode.Strict，只允许相同的站点。SameSiteMode.Lax允许以安全的 http方式附加到不同站点或相同站点

sameSite="None" 必须和 requireSSL="true" 配合使用.

https://www.anquanke.com/post/id/83773
https://www.jianshu.com/p/eee9426c42df
https://docs.microsoft.com/zh-cn/aspnet/samesite/system-web-samesite  在 ASP.NET 中使用 SameSite cookie

https://www.cnblogs.com/qixinbo/p/12495995.html  IdentityServer4登录后无法跳转samesite=none
https://docs.microsoft.com/zh-cn/dotnet/core/compatibility/3.0-3.1 
https://docs.microsoft.com/zh-cn/aspnet/samesite/system-web-samesite 在 ASP.NET 中使用 SameSite cookie
https://docs.microsoft.com/zh-cn/aspnet/samesite/system-web-samesite#sob