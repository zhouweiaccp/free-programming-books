





- [FE-Guide](https://github.com/zhaoqize/FE-Guide#%E7%A7%BB%E5%8A%A8UI%E6%A1%86%E6%9E%B6) 汇集了前端技术书籍、前端热门技术、前端发展等资料。

### 前端标签
- [Jcrop](https://github.com/tapmodo/Jcrop/tree/v0.9.12) 图片剪切
- [cropperjs](https://fengyuanchen.github.io/cropperjs/)   功能更强
- [perfect-scrollbar](git@github.com:zhouweiaccp/perfect-scrollbar.git) 滚动条
- [measure](https://utom.design/measure.html) Sketch Measure http://www.cutterman.cn/zh
- [localstorage-browser-polyfill](https://www.npmjs.com/package/localstorage-browser-polyfill)
- [promise-polyfill](https://github.com/taylorhakes/promise-polyfill)If you would like to add a global Promise object (Node or Browser) if native Promise doesn't exist (polyfill Promise). Use the method below. This is useful it you are building a website and want to support older browsers. Javascript library authors should NOT use this method
- [requirejs-源码分析（上）](https://blog.shenfq.com/2017/requirejs-%E6%BA%90%E7%A0%81%E5%88%86%E6%9E%90%EF%BC%88%E4%B8%8A%EF%BC%89/)requirejs-源码分析（上）
- [](https://github.com/foxiswho/city-picker)下拉面板式省市区三级联动jquery插件，视觉更清爽，交互体验更友好 
- []()
- []()
- []()
- []()
- []()
- []()
- []()



### 后台模板
- [getstisla](https://github.com/stisla/stisla#quick-start)
- [layui]()



## IE10以下支持bind()方法
if (!Function.prototype.bind) {
    Function.prototype.bind = function (oThis) {
        if (typeof this !== "function") {      
            throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
        }
        var aArgs = Array.prototype.slice.call(arguments, 1),
        fToBind = this,
        fNOP = function () {},
        fBound = function () {
            return fToBind.apply(this instanceof fNOP && oThis ? this : oThis, aArgs.concat(Array.prototype.slice.call(arguments)));
        };
        fNOP.prototype = this.prototype;
        fBound.prototype = new fNOP();
        return fBound;
    };
}