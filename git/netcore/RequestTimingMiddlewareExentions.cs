using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace WebApplication2
{
    /// <summary>
    /// 请求头
    /// </summary>
    public class RequestTimingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<RequestTimingMiddleware> _logger;

        public RequestTimingMiddleware(RequestDelegate next, ILoggerFactory loggerFactory)
        {
            _next = next;
            _logger = loggerFactory.CreateLogger<RequestTimingMiddleware>();
        }

        public async Task InvokeAsync(HttpContext context)
        {
            // set Headers
            context.Response.Headers.Add("MachineName", new Microsoft.Extensions.Primitives.StringValues("Environment.MachineName"));
            context.Response.Headers.Add("X-Powered-By", new Microsoft.Extensions.Primitives.StringValues(typeof(RequestTimingMiddleware).FullName));
            var sw = Stopwatch.StartNew();
            await _next(context);
            sw.Stop();
            if (sw.ElapsedMilliseconds > 5000)
            {
                _logger.LogError($"Request Execution Time: {sw.ElapsedMilliseconds}");
            }
        }
    }

    /// <summary>
    /// 请求头
    ///startup.cs  app.UseRequestHeader();
    /// </summary>
    public static class RequestTimingMiddlewareExentions {
        public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestHeader(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) {
            return builder.UseMiddleware<RequestTimingMiddleware>();
        }
    }
}
