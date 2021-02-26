

## 为什么在jQuery插件中返回this.each（function（））？
我向您展示两个可以澄清您问题的“等效”代码：
https://www.itranslater.com/qa/details/2131255827624363008
使用jQuery“each”功能：

(function($) {
    $.fn.mangle = function(options) {
        return this.each(function() {
            $(this).append(' - ' + $(this).data('x'));
        });
    };
})(jQuery);
没有jQuery“each”功能：

(function($) {
    $.fn.mangle = function(options) {
        var objs = this;
        for (var i=0; i<objs.length; i++) {
            var obj = objs[i];
            $(obj).append(' - ' + $(obj).data('x'));
        };
        return this;
    };
})(jQuery);
所以，基本上，each函数用于将一些代码应用于each对象中包含的所有元素（因为each通常是指由jQuery选择器返回的一组元素）并返回引用this（因为each函数总是返回该引用 ）

作为旁注：第二种方法（-each loop-）比以前的方法（-each函数 - 更快）（特别是在旧浏览器上）。
另外，看看这些链接，他们将为您提供有关jQuery插件开发的大量信息。

[http://www.webresourcesdepot.com/jquery-plugin-development-10-tutorials-to-get-started/]
[http://www.learningjquery.com/2007/10/a-plugin-development-pattern]
[http://snook.ca/archives/javascript/jquery_plugin]
https://stackoverflow.com:/questions/2678185/why-return-this-eachfunction-in-jquery-plugins




###  publishing-your-jquery-plugin-to-npm-the-quick
```javascript
(function ($){
  $.fn.maxHeight = function (){//https://javascript.ruanyifeng.com/jquery/plugin.html
    var max = 0;
	// 下面这个this，指的是jQuery对象实例
    this.each(function() {
		// 回调函数内部，this指的是DOM对象
	    max = Math.max(max, $(this).height());
    });
    return max;
  };
})(jQuery);

//https://blog.npmjs.org/post/111475741445/publishing-your-jquery-plugin-to-npm-the-quick
```