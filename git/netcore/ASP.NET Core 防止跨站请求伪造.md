什么是反伪造攻击?
跨站点请求伪造（也称为XSRF或CSRF，发音为see-surf）是对Web托管应用程序的攻击，因为恶意网站可能会影响客户端浏览器和浏览器信任网站之间的交互。这种攻击是完全有可能的，因为Web浏览器会自动在每一个请求中发送某些身份验证令牌到请求网站。这种攻击形式也被称为 一键式攻击 或 会话控制 ，因为攻击利用了用户以前认证的会话。

CSRF攻击的示例：

用户登录 www.example.com，使用表单身份验证。
服务器对用户进行身份验证，并作出包含身份验证Cookie的响应。
用户访问恶意网站。
恶意网站包含类似于以下内容的HTML表单：
        <h1>You Are a Winner!</h1>
        <form action="http://example.com/api/account" method="post">
            <input type="hidden" name="Transaction" value="withdraw" />
            <input type="hidden" name="Amount" value="1000000" />
            <input type="submit" value="Click Me"/>
        </form>
请注意，表单的Action属性将请求发送到易受攻击的网站，而不是恶意网站。这是CSRF的“跨站点”部分。
用户点击提交按钮，浏览器会自动包含请求站点（在这种情况下为易受攻击的站点）的认证Cookie。
请求在拥有用户身份验证上下文的服务端运行，并且可以执行允许经过身份验证用户执行的任何操作。
此示例需要用户单击表单按钮，恶意页面也可以通过以下方式：

自动运行提交表单的脚本。
通过AJAX请求发送表单提交。
通过CSS隐藏的表单。
使用SSL不能阻止CSRF攻击，恶意网站可以发送https://请求。

针对GET请求站点的攻击，可以使用Image元素来执行（这种形式的攻击在允许图片的论坛网站上很常见）。使用GET请求更改应用程序状态更容易受到恶意攻击。

因为浏览器将所有相关的Cookie发送到目标网站，所以可以针对使用Cookie进行身份验证的网站进行CSRF攻击。然而，CSRF攻击并不仅限于利用Cookie，例如，Basic和Digest身份验证也很脆弱。用户使用Basic或Digest身份验证登录后，浏览器将自动发送凭据，直到会话（Session）结束。

注意：在这本文中，Session是指用户进行身份验证的客户端会话。它与服务器端会话或Session中间件无关。

用户可以通过以下方式防范CSRF漏洞：

网站使用完毕后，注销会话。
定期清理浏览器的Cookie。
然而，CSRF漏洞根本上是Web应用程序的问题，而不是依靠用户来解决。

ASP.NET Core MVC是如何处理CSRF的？
警告：
ASP.NET Core使用 ASP.NET Core data protection stack 来实现防请求伪造。如果在服务器集群中必配置 ASP.NET Core Data Protection，有关详细信息，请参阅 Configuring data protection 。

在ASP.NET Core MVC 2.0中，FormTagHelper为HTML表单元素注入防伪造令牌。例如，Razor文件中的以下标记将自动生成防伪令牌：

        <form method="post">
            <!-- form markup -->
        </form>
在以下情况为HTML格式元素自动生成防伪令牌：

该form标签包含method="post"属性
action属性为空( action="") 或者
未提供action属性(<form method="post">)。
您可以通过以下方式禁用自动生成HTML表单元素的防伪令牌：

明确禁止asp-antiforgery，例如
        <form method="post" asp-antiforgery="false">
        </form>
通过使用标签帮助器! 禁用语法，从标签帮助器转化为表单元素。
        <!form method="post">
        </!form>
在视图中移除FormTagHelper，您可以在Razor视图中添加以下指令移除FormTagHelper：
 @removeTagHelper Microsoft.AspNetCore.Mvc.TagHelpers.FormTagHelper, Microsoft.AspNetCore.Mvc.TagHelpers
提示：
Razor页面会自动受到XSRF/CSRF的保护。您不必编写任何其他代码，有关详细信息，请参阅XSRF/CSRF和Razor页面。

防御CSRF攻击的最常见方法是令牌同步模式（STP）。STP是当用户请求表单数据页面时使用的技术。服务器将与当前用户的标识相关联的令牌发送给客户端。客户端将令牌发回服务器进行验证。如果服务器接收到与验证用户身份不匹配的令牌，则该请求将被拒绝。令牌是唯一的，并且是不可预测的。令牌也可用于确保一系列请求的正确顺序（确保页面1在第2页之前，页面2在第3页之前）。ASP.NET Core MVC模板中的所有表单都会生成防伪令牌，以下两个示例演示在视图逻辑中生成防伪令牌：

        <form asp-controller="Manage" asp-action="ChangePassword" method="post">

        </form>

        @using (Html.BeginForm("ChangePassword", "Manage"))
        {
    
        }
您可以在不使用HTML标签助手的情况下，向<form>元素显式添加防伪令牌@Html.AntiForgeryToken：

        <form action="/" method="post">
            @Html.AntiForgeryToken()
        </form>
在前面的例子中，ASP.NET Core将添加一个隐藏的表单字段，类似于以下内容：

        <input name="__RequestVerificationToken" type="hidden" value="CfDJ8NrAkSldwD9CpLRyOtm6FiJB1Jr_F3FQJQDvhlHoLNJJrLA6zaMUmhjMsisu2D2tFkAiYgyWQawJk9vNm36sYP1esHOtamBEPvSk1_x--Sg8Ey2a-d9CV2zHVWIN9MVhvKHOSyKqdZFlYDVd69XYx-rOWPw3ilHGLN6K0Km-1p83jZzF0E4WU5OGg5ns2-m9Yw" />
ASP.NET Core 包括三个过滤器用于防伪令牌的运行：ValidateAntiForgeryToken、AutoValidateAntiforgeryToken和 IgnoreAntiforgeryToken。

ValidateAntiForgeryToken
ValidateAntiForgeryToken是一个可应用于单个Action、控制器或全局的操作过滤器。请求必须包含一个有效的令牌，否则对具有该过滤器Action的请求将被阻止。

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RemoveLogin(RemoveLoginViewModel account)
        {
            ManageMessageId? message = ManageMessageId.Error;
            var user = await GetCurrentUserAsync();
            if (user != null)
            {
                var result = await _userManager.RemoveLoginAsync(user, account.LoginProvider, account.ProviderKey);
                if (result.Succeeded)
                {
                    await _signInManager.SignInAsync(user, isPersistent: false);
                    message = ManageMessageId.RemoveLoginSuccess;
                }
            }
            return RedirectToAction(nameof(ManageLogins), new { Message = message });
        }
ValidateAntiForgeryToken特性标记的Action方法需要一个令牌，包括HTTP GET请求。如果您全局使用，您可以使用IgnoreAntiforgeryToken特性来覆盖它。

AutoValidateAntiforgeryToken
ASP.NET Core应用程序通常不会为HTTP安全方式（GET，HEAD，OPTIONS和TRACE）生成防伪令牌，而不是在全局范围内使用ValidateAntiForgeryToken特性，然后用IgnoreAntiforgeryToken特性覆盖它，您可以使用AutoValidateAntiforgeryToken特性。该特性与ValidateAntiForgeryToken特性相似，但对以下HTTP请求方式不需要请求令牌：

GET
HEAD
OPTIONS
TRACE
我们建议您在非API场景中广泛使用AutoValidateAntiforgeryToken。这确保您的POST Action 默认受保护。另一种方式是在默认情况下忽略反伪造令牌，除非在个别Action方法标记了ValidateAntiForgeryToken特性，不过在这种情况下，POST Action方法有可能不受保护，使您的应用程序容易受到CSRF攻击。即使匿名的POST请求也应该发送防伪令牌。

注意：API没有自动机制来发送非Cookie的令牌；您的实现可能取决于您的客户端代码的实现。

一些例子如下所示。

示例（控制器级别）：

        [Authorize]
        [AutoValidateAntiforgeryToken]
        public class ManageController : Controller
        {
示例（全局）

            services.AddMvc(options => 
                options.Filters.Add(new AutoValidateAntiforgeryTokenAttribute()));
IgnoreAntiforgeryToken
IgnoreAntiforgeryToken过滤器用于取消已经使用防伪标记的Action（或控制器）的需求。应用时，此过滤器将覆盖在更高级别（全局或控制器）上指定的过滤器ValidateAntiForgeryToken和/或AutoValidateAntiforgeryToken过滤器。

        [Authorize]
        [AutoValidateAntiforgeryToken]
        public class ManageController : Controller
        {
            [HttpPost]
            [IgnoreAntiforgeryToken]
            public async Task<IActionResult> DoSomethingSafe(SomeViewModel model)
            {
                // no antiforgery token required
            }
        }
JavaScript，AJAX和SPA(单页应用程序)
在传统基于HTML的应用程序中，使用隐藏的表单字段将防伪令牌发送到服务器。在当前基于JavaScript的应用程序和单页应用程序（SPA）中，许多请求以编程方式进行。这些AJAX请求可能会使用其它技术（如请求头或Cookie）来发送令牌。如果使用Cookie来存储身份验证令牌，并在服务器上验证API请求，那么CSRF将是一个潜在的问题，但是，如果使用本地存储来存储令牌，那么CSRF漏洞可能会被减轻，因为本地存储的值不会在每个请求时自动发送到服务器。因此，使用本地存储将反伪造令牌存储在客户机上，并将令牌作为请求头发送，这是一种推荐的方式。

AngularJS
AngularJS通过约定来解决CSRF。如果服务器发送带有名称为XSRF-TOKEN的Cookie ，则Angular的$http服务将向该服务器发送的请求将该Cookie的值添加到请求头。这个过程是自动的，您不需要明确设置请求头。请求头的名称是X-XSRF-TOKEN，服务器会检测该请求头并验证其内容。

对于ASP.NET Core API，使用此约定：

配置您的应用程序，在一个Cookie中提供一个称为XSRF-TOKEN的令牌；
配置防伪服务查找名为X-XSRF-TOKEN的请求头。
            services.AddAntiforgery(options => options.HeaderName = "X-XSRF-TOKEN");
查看示例。

JavaScript
在视图中使用JavaScript，您可以在视图中使用服务创建令牌，您将Microsoft.AspNetCore.Antiforgery.IAntiforgery服务注入视图并调用GetAndStoreTokens，如下所示：

@{
    ViewData["Title"] = "AJAX Demo";
}
@inject Microsoft.AspNetCore.Antiforgery.IAntiforgery Xsrf
@functions{
    public string GetAntiXsrfRequestToken()
    {
        return Xsrf.GetAndStoreTokens(Context).RequestToken;
    }
}
<h2>@ViewData["Title"].</h2>
<h3>@ViewData["Message"]</h3>

<div class="row">
    <input type="button" id="antiforgery" value="Antiforgery" />
    <script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-2.1.4.min.js"></script>
    <script>
                $("#antiforgery").click(function () {
                    $.ajax({
                        type: "post",
                        dataType: "html",
                        headers:
                        {
                            "RequestVerificationToken": '@GetAntiXsrfRequestToken()'
                        },
                        url: '@Url.Action("Antiforgery", "Home")',
                        success: function (result) {
                            alert(result);
                        },
                        error: function (err, scnd) {
                            alert(err.statusText);
                        }
                    });
                });
    </script>
</div>
这种方法无需在服务器设置Cookie或从客户端读取Cookie。

JavaScript还可以访问Cookie中提供的令牌，然后使用Cookie的内容创建带有令牌值的请求头，如下所示。

            context.Response.Cookies.Append("CSRF-TOKEN", tokens.RequestToken, 
                new Microsoft.AspNetCore.Http.CookieOptions { HttpOnly = false });
然后，假设您构建的脚本发送的请求，将令牌发送为一个名为X-CSRF-TOKEN的请求头中，请配置防伪服务以查找X-CSRF-TOKEN请求头：

            services.AddAntiforgery(options => options.HeaderName = "X-CSRF-TOKEN");
以下示例使用jQuery来创建一个包含相应请求头AJAX请求：

var csrfToken = $.cookie("CSRF-TOKEN");

$.ajax({
    url: "/api/password/changepassword",
    contentType: "application/json",
    data: JSON.stringify({ "newPassword": "ReallySecurePassword999$$$" }),
    type: "POST",
    headers: {
        "X-CSRF-TOKEN": csrfToken
    }
});
配置防伪
IAntiforgery提供API来配置防伪系统。它可以在Startup类的Configure方法中使用。以下示例在应用程序的主页生成防伪令牌，并将其作为Cookie发送到响应中（使用上述默认命名约定）：

        public void Configure(IApplicationBuilder app, IAntiforgery antiforgery)
        {
            app.Use(next => context =>
            {
                string path = context.Request.Path.Value;
                if ( string.Equals(path, "/", StringComparison.OrdinalIgnoreCase) || string.Equals(path, "/index.html", StringComparison.OrdinalIgnoreCase))
                {
                    // We can send the request token as a JavaScript-readable cookie, 
                    // and Angular will use it by default.
                    var tokens = antiforgery.GetAndStoreTokens(context);
                    context.Response.Cookies.Append("XSRF-TOKEN", tokens.RequestToken,  new CookieOptions() { HttpOnly = false });
                }

                return next(context);
            });
            
        }
选项
您可以在ConfigureServices方法中定制防伪选项：

        services.AddAntiforgery(options => 
        {
            options.CookieDomain = "mydomain.com";
            options.CookieName = "X-CSRF-TOKEN-COOKIENAME";
            options.CookiePath = "Path";
            options.FormFieldName = "AntiforgeryFieldname";
            options.HeaderName = "X-CSRF-TOKEN-HEADERNAME";
            options.RequireSsl = false;
            options.SuppressXFrameOptionsHeader = false;
        });
选项	描述
CookieDomain	Cookie的域名。默认为null。
CookieName	Cookie的名称。如果未设置，系统将生成一个以DefaultCookiePrefix（".AspNetCore.Antiforgery"）开头的唯一名称。
CookiePath	Cookie设置的路径。
FormFieldName	在视图中隐藏表单字段的名称。
HeaderName	防伪系统使用的请求头的名称。如果null，系统将仅使用表单数据。
RequireSsl	指定防伪系统是否需要SSL。默认为false。如果为true，非SSL请求会失败。
SuppressXFrameOptionsHeader	指定是否禁止X-Frame-Options响应头的生成。默认情况下，响应头生成的值为“SAMEORIGIN”。默认为false。
有关详细信息，请参阅 https://docs.microsoft.com/aspnet/core/api/microsoft.aspnetcore.builder.cookieauthenticationoptions。

扩展防伪
IAntiForgeryAdditionalDataProvider类型允许开发者扩展anti-XSRF系统的行为，在每个令牌中的增加额外数据。每次创建令牌时会调用GetAdditionalData方法，并且返回的值被嵌入生成的令牌内。实现者可以返回时间戳、随机数或任何其它值，然后在验证令牌时调用ValidateAdditionalData来验证此数据。客户的用户名已经嵌入到生成的令牌中，因此不需要包含此信息。如果令牌包含补充数据但没有配置IAntiForgeryAdditionalDataProvider，则补充数据不被验证。

常用场景
CSRF攻击依赖于浏览器默认行为，向站点发出请求同时，会发送与站点相关联的Cookie。这些Cookies存储在浏览器中，它们经常用于经过身份验证的用户提供会话Cookie。基于Cookie的身份验证是一种非常流行的身份验证模式。基于令牌的认证系统越来越受欢迎，特别是对于SPA和其它“智能客户端”场景。

基于Cookie的身份验证
一旦用户使用他们的用户名和密码进行身份验证，就会发出一个令牌，用于标识它们并验证它们是否经过身份验证。令牌存储为Cookie，客户端所做的每个请求都会附带令牌。生成和验证此Cookie是由Cookie身份验证中间件完成的。ASP.NET Core提供了将用户主体序列化为加密Cookie的Cookie 中间件，然后在随后的请求中验证Cookie，重新创建主体并将其分配给HttpContext的User属性。

当使用Cookie时，身份验证Cookie只是表单身份验证凭证的一个容器。在每个请求中，票据作为的表单认证Cookie的值传递并通过表单身份验证，在服务端，以标识经过身份验证的用户。

当用户登录到系统时，会在服务器端创建用户会话，并将其存储在数据库或其他持久存储中，系统生成指向数据存储中的会话密钥，并将其作为客户端Cookie发送。每当用户请求需要授权的资源时，Web服务器将检查此会话密钥，系统检查关联的用户会话是否具有访问请求的资源的权限。如果是，请求继续；否则，请求返回为未授权。在这种方法下，Cookie的使用，使应用程序看起来是有状态的，因为它能够“记住”用户以前已经在服务端完成了身份验证。

用户令牌
基于令牌的身份验证不会在服务器上存储会话。相反，当用户登录时，将颁发令牌（不是防伪令牌）。该令牌保存验证令牌所需的所有数据，它还包含用户信息，以claims的形式。当用户想要访问需要身份验证的服务器资源时，会使用 Bearer {token} 形式的附加授权头发送令牌给服务器。这使得应用程序无状态，因为在每个后续请求中，令牌在请求中传递给服务器端验证。该令牌未 加密 ， 而是 编码 。在服务器端，令牌可以被解码以访问令牌内的原始信息。要在随后的请求中发送令牌，您可以将其存储在浏览器的本地存储或Cookie中。如果您的令牌存储在本地存储中，则不必担心XSRF漏洞，但如果令牌存储在Cookie中，则会出现问题。

多个应用程序托管在一个域中
即使example1.cloudapp.net和example2.cloudapp.net是不同的主机，在.cloudapp.net域内的所有主机之间存在一种隐式信任关系。这种隐式信任关系允许潜在的不受信任的主机影响彼此的Cookie(管理AJAX请求的同源策略不一定适用于HTTP Cookie)。ASP.NET Core运行时提供了一些缓解，用户名被嵌入到字段令牌中，因此即使恶意子域能够覆盖会话令牌，它将无法为用户生成有效的字段令牌。然而，当托管在这样的环境中，内置的反XSRF例程仍然无法防止会话劫持或登录CSRF攻击。共享主机环境对会话劫持、登录CSRF和其它攻击都是不可控制的。

其他资源
XSRF on Open Web Application Security Project (OWASP)。
原文：《Preventing Cross-Site Request Forgery (XSRF/CSRF) Attacks in ASP.NET Core》https://docs.microsoft.com/en-us/aspnet/core/security/anti-request-forgery