前端防止 JS 调试技巧

简单模式：
setInterval(function() {
    debugger
}, 100);
稍微复杂一点：

function t() {
    try {
        var a = ["r", "e", "g", "g", "u", "b", "e", "d"].reverse().join("");
        ! function e(n) {
            (1 !== ("" + n / n).length || 0 === n) && function() {}
            .constructor(a)(),
            e(++n)
        }(0)
    } catch (a) {
        setTimeout(t, 500)
    }
}
这段代码首先是设置变量 a 表示字符串“debugger”，然后使用 constructor() 来实现调用 debugger 方法，再使用 setTimeout 实现每0.5秒中断一次。
解决方案：
　　将反调试具名函数重新定义一遍，然后重新打开 DevTools，就能进行调试了。对于上面的例子，可以在控制台中输入以下内容：

t = function() {}
我实际项目中的代码：

function t() {
    var r = "V",
        n = "5",
        e = "8";
 
    function o(r) {
        if (!r) return "";
        for (var t = "", n = 44106, e = 0; e < r.length; e++) {
            var o = r.charCodeAt(e) ^ n;
            n = n * e % 256 + 2333, t += String.fromCharCode(o)
        }
        return t
    }
    try {
        var a = ["r", o("갯"), "g", o("갭"), function (t) {
            if (!t) return "";
            for (var o = "", a = r + n + e + "7", c = 45860, f = 0; f < t.length; f++) {
                var i = t.charCodeAt(f);
                c = (c + 1) % a.length, i ^= a.charCodeAt(c), o += String.fromCharCode(i)
            }
            return o
        }("@"), "b", "e", "d"].reverse().join("");
        ! function c(r) {
            (1 !== ("" + r / r).length || 0 === r) && function () {}.constructor(a)(), c(++r)
        }(0)
    } catch (a) {
        setTimeout(t, 100);
    }
}
t();
document.onkeydown = function() {
    if ((e.ctrlKey) && (e.keyCode == 83)) {
        alert("CTRL + S 被管理员禁用");
        return false;
    }
}
document.onkeydown = function() {
    var e = window.event || arguments[0];
    if (e.keyCode == 123) {
        alert("F12 被管理员禁用");
        return false;
    }
}
document.oncontextmenu = function() {
    alert('右键被管理员禁用');
    return false;
}
到这一步了，没完，还有这段代码配合使用，仿伪君子必备。(通过正常函数来实现)：
<!DOCTYPE html>
<html lang="zh-cn">
 
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <script>
        // 反调试函数,参数：开关，执行代码
        function endebug(off, code) {
            if (!off) {
                ! function(e) {
                    function n(e) {
                        function n() {
                            return u;
                        }
 
                        function o() {
                            window.Firebug && window.Firebug.chrome && window.Firebug.chrome.isInitialized ? t("on") : (a = "off", console.log(d), console.clear(), t(a));
                        }
 
                        function t(e) {
                            u !== e && (u = e, "function" == typeof c.onchange && c.onchange(e));
                        }
 
                        function r() {
                            l || (l = !0, window.removeEventListener("resize", o), clearInterval(f));
                        }
                        "function" == typeof e && (e = {
                            onchange: e
                        });
                        var i = (e = e || {}).delay || 500,
                            c = {};
                        c.onchange = e.onchange;
                        var a, d = new Image;
                        d.__defineGetter__("id", function() {
                            a = "on"
                        });
                        var u = "unknown";
                        c.getStatus = n;
                        var f = setInterval(o, i);
                        window.addEventListener("resize", o);
                        var l;
                        return c.free = r, c;
                    }
                    var o = o || {};
                    o.create = n, "function" == typeof define ? (define.amd || define.cmd) && define(function() {
                        return o
                    }) : "undefined" != typeof module && module.exports ? module.exports = o : window.jdetects = o
                }(), jdetects.create(function(e) {
                    var a = 0;
                    var n = setInterval(function() {
                        if ("on" == e) {
                            setTimeout(function() {
                                if (a == 0) {
                                    a = 1;
                                    setTimeout(code);
                                }
                            }, 200);
                        }
                    }, 100);
                })
            }
        }
    </script>
</head>
 
<body>
    <h1>你可以看见吗？</h1>
    <script type="text/javascript">
        endebug(false, function() {
            // 非法调试执行的代码(不要使用控制台输出的提醒)
            document.write("检测到非法调试,请关闭后刷新重试!");
        });
    </script>
</body>
 
</html>
 

我们有两个方法来进行软件设计：一个是让其足够的简单以至于让BUG无法藏身；另一个就是让其足够的复杂，让人找不到BUG。前者更难一些。