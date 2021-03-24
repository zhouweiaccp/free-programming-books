





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
- [LayX](https://gitee.com/monksoul/LayX) 弹框
- [jquery-popup-overlay](https://github.com/vast-engineering/jquery-popup-overlay)
- [jbox](https://www.npmjs.com/package/jbox)  ![](https://github.com/StephanWagner/jBox)   https://stephanwagner.me/blog  以前用过
- [jquery.timers](https://github.com/mgaert/jquery-timers/blob/master/src/jquery.timers.ts)
- []()
- []()
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

###  clipboard.js
[](https://github.com/zenorocha/clipboard.js.git)
```html
<input id="foo" value="https://github.com/zenorocha/clipboard.js.git">

<!-- Trigger -->
<button class="btn" data-clipboard-target="#foo">
    <img src="assets/clippy.svg" alt="Copy to clipboard">
</button>
```


### xss 
- [](https://github.com/leizongmin/js-xss)
```js
<script src="https://rawgit.com/leizongmin/js-xss/master/dist/xss.js"></script>
// 使用 filterXSS()方法处理内容
<script>
var html = filterXSS('<script>alert("xss");</scr' + 'ipt>');
console(html);
</script>
```
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

## 日期库 Luxon，Day.js，date-fns 
https://github.com/iamkun/dayjs
moment 停止更新

## js中的...扩展(展开)运算符
let a = [1,2,3]
let b = [...a]
console.log(b)  //[ 1, 2, 3 ]
当创建数组b和在a数组上使用扩展运算符时，不是将a数组直接插入到b中，而是将a数组扩展，然后将元素插入到b中 

### 一…在展开基本数据类型时，是深copy，基本数据类型位于栈区
let a = [1,2,3]
let b = [...a]
b[0] = 666;
console.log(b) // [ 666, 2, 3 ]
console.log(a) // [ 1, 2, 3 ]
console.log(a === b) // false 可以发现数组b复制数组a的元素后，改变b的第一个元素，a的并没有改变，所以是深copy


### 二.如果使用展开运算符 展开一个对象时，那么是浅copy，对象位于堆区
let obj = {name:"wang"}
let arr = [obj,2,3] 
let newArr = [...arr]
console.log(arr)  //[ { name: 'wang' }, 2, 3 ]
console.log(newArr)  //[ { name: 'wang' }, 2, 3 ]
newArr[0].name = "xia";
console.log(arr)   //[ { name: 'xia' }, 2, 3 ]
console.log(newArr)  //[ { name: 'xia' }, 2, 3 ]

### 三.如果数组中是基本数据类型，深copy

let arr = [1,2,3]
let newArr = arr.slice(0)
newArr[0] = 666;
console.log(arr)     //[ 1, 2, 3 ]
console.log(newArr)     //[ 666, 2, 3 ]

### 四.如果数组中有对象，就是浅copy

let obj = {name:"wang"}
let arr = [obj,2,3] 
let newArr = arr.slice(0)
console.log(arr)     //[ { name: 'wang' }, 2, 3 ]
console.log(newArr)     //[ { name: 'wang' }, 2, 3 ]
newArr[0].name = "lal";
console.log(arr)     //[ { name: 'lal' }, 2, 3 ]
console.log(newArr)     //[ { name: 'lal' }, 2, 3 ]
### 五.展开对象 对象就一层，是深copy

let obj = {name:"wang",age:100}
let newObj = {...obj}
console.log(obj)    //{ name: 'wang', age: 100 }
console.log(newObj)    //{ name: 'wang', age: 100 }
newObj.name = "ha"
console.log(obj)    //{ name: 'wang', age: 100 }
console.log(newObj)    //{ name: 'ha', age: 100 }

### 六.展开对象 对象是多层，是浅copy

let obj = {name:"wang",age:{number:100}}
let newObj = {...obj}
console.log(obj)     //{ name: 'wang', age: { number: 100 } }
console.log(newObj)     //{ name: 'wang', age: { number: 100 } }
newObj.age.number = 666
console.log(obj)     //{ name: 'wang', age: { number: 666 } }
console.log(newObj)     //{ name: 'wang', age: { number: 666 } }

### 七.实现多层对象的深copy

let obj = {name:"wang",age:{number:100}}
let newObj = {...obj,age:{...obj.age}}
newObj.age.number = 666
console.log(obj)    // { name: 'wang', age: { number: 100 } }
console.log(newObj)    // { name: 'wang', age: { number: 666 } }

### 八.通过 JSON.parse(JSON.stringify(obj))可以实现深copy

let obj = {name:"wang",age:{number:100}}
let str = JSON.stringify(obj)
let newObj = JSON.parse(str)
console.log(str)     //{"name":"wang","age":{"number":100}}
console.log(newObj)     //{ name: 'wang', age: { number: 100 } }
obj.age.number = 1000000;
console.log(obj)     //{ name: 'wang', age: { number: 1000000 } }
console.log(newObj)     //{ name: 'wang', age: { number: 100 } }



## js判断页面放大缩小
```js
// 若返回100则为默认无缩放，如果大于100则是放大，否则缩小
function detectZoom (){
  var ratio = 0,
    screen = window.screen,
    ua = navigator.userAgent.toLowerCase();
  
   if (window.devicePixelRatio !== undefined) {
      ratio = window.devicePixelRatio;
  }
  else if (~ua.indexOf('msie')) { 
    if (screen.deviceXDPI && screen.logicalXDPI) {
      ratio = screen.deviceXDPI / screen.logicalXDPI;
    }
  }
  else if (window.outerWidth !== undefined && window.innerWidth !== undefined) {
    ratio = window.outerWidth / window.innerWidth;
  }
    
   if (ratio){
    ratio = Math.round(ratio * 100);
  }
    
   return ratio;
};
```


### JS代码阻止浏览器的command+F、ctrl+F
```js
document.addEventListener('keydown', function(e){ 
    if(e.ctrlKey && e.key === 'f'){ 
        e.preventDefault(); 
    }
})

window.addEventListener("keydown",function (e) {
    if (e.keyCode === 114 || (e.ctrlKey && e.keyCode === 70)) { 
        e.preventDefault();
    }
})
```

### jquery format
```js
   $.format = function (source, params) {
            if (arguments.length == 1)
                return function () {
                    var args = $.makeArray(arguments);
                    args.unshift(source);
                    return $.format.apply(this, args);
                };
            if (arguments.length > 2 && params.constructor != Array) {
                params = $.makeArray(arguments).slice(1);
            }
            if (params.constructor != Array) {
                params = [params];
            }
            $.each(params, function (i, n) {
                source = source.replace(new RegExp("\\{" + i + "\\}", "g"), n);
            });
            return source;
        };
```

### 参数
```js
    var __GetQueryString = function (name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]); return null;
        }
```


### Js中的window.parent ,window.top,window.self 详解
在应用有frameset或者iframe的页面时，parent是父窗口，top是最顶级父窗口（有的窗口中套了好几层frameset或者iframe），self是当前窗口， opener是用open方法打开当前窗口的那个窗口。
window.self
功能：是对当前窗口自身的引用。它和window属性是等价的。
语法：window.self
注：window、self、window.self是等价的。

window.top
功能：返回顶层窗口，即浏览器窗口。
语法：window.top
注：如果窗口本身就是顶层窗口，top属性返回的是对自身的引用。

 
window.parent

功能：返回父窗口。

语法：window.parent

注：如果窗口本身是顶层窗口，parent属性返回的是对自身的引用。

在框架网页中，一般父窗口就是顶层窗口，但如果框架中还有框架，父窗口和顶层窗口就不一定相同了。

 
判断当前窗口是否在一个框架中：

<script type="text/javascript">
var b = window.top!=window.self;
document.write( "当前窗口是否在一个框架中："+b );
</script>
你应当将框架视为窗口中的不同区域，框架是浏览器窗口中特定的部分。一个浏览器窗口可以根据你的需要分成任意多的框架，一个单个的框架也可以分成其它多个框架，即所谓的嵌套框架。


### 禁用浏览器的缩放功能（js）
一、移动端禁止缩放
移动端在禁止缩放上比较简单,添加meta标签即可

<meta name="viewport" 
	content="
		width=device-width,
		initial-scale=1.0,
		minimum-scale=1.0,
		maximum-scale=1.0,
		user-scalable=no">
width // 设置 viewport 的宽度，正整数/字符串 device-width
height // 设置 viewport 的高度，正整数/字符串 device-height
initial-scale // 设置设备宽度与 viewport大小之间的缩放比例，0.0-10.0之间的正数
maximum-scale // 设置最大缩放系数，0.0-10.0之间的正数
minimum-scale // 设置最小缩放系数，0.0-10.0之间的正数
user-scalable // 如果设置为 no 用户将不能缩放网页，默认为 yes，yes / no
二、PC（web）端禁止浏览器缩放
S（情景）
当某些页面有了特定的布局后，开发者不希望用户通过浏览器对其进行缩放（会导致布局、排版问题）

T（任务）
我希望通过Js的方式禁止用户对浏览器进行缩放，（如果用户是通过系统设置的网页缩放，也应进行提示）

A（我做了什么）
查询了许多文章，大部分思路都集中在这篇文章内stackoverflow-传送门
查找W3C、谷歌、火狐的官方提示（发现浏览器不希望你禁用用户的缩放功能，即缩放功能是浏览器赋予用户的权利和功能，所以它不会给出官网的禁用方式）
采用覆盖键、覆盖鼠标滑动事件；
具体实现代码如下：

const keyCodeMap = {
    // 91: true, // command
    61: true,
    107: true, // 数字键盘 +
    109: true, // 数字键盘 -
    173: true, // 火狐 - 号
    187: true, // +
    189: true, // -
};
// 覆盖ctrl||command + ‘+’/‘-’
document.onkeydown = function (event) {
    const e = event || window.event;
    const ctrlKey = e.ctrlKey || e.metaKey;
    if (ctrlKey && keyCodeMap[e.keyCode]) {
        e.preventDefault();
    } else if (e.detail) { // Firefox
        event.returnValue = false;
    }
};
// 覆盖鼠标滑动
document.body.addEventListener('wheel', (e) => {
    if (e.ctrlKey) {
        if (e.deltaY < 0) {
            e.preventDefault();
            return false;
        }
        if (e.deltaY > 0) {
            e.preventDefault();
            return false;
        }
    }
}, { passive: false });
//https://www.cnblogs.com/xiaobaiou/p/10731062.html
window.addEventListener('mousewheel', function(event){
    if (event.ctrlKey === true || event.metaKey) {
          event.preventDefault();
    }
},{ passive: false});

//firefox
 window.addEventListener('DOMMouseScroll', function(event){
    if (event.ctrlKey === true || event.metaKey) {
           event.preventDefault();
    }
},{ passive: false});


主流浏览器，window、mac（OS / Win）可以做到，极端兼容下带测试。 


## 深究apply

apply()方法调用一个具有给定this值的函数，以及作为一个数组（或类似数组对象）提供的参数。

语法为func.apply(thisArg, [argsArray])。

thisArg：如果这个函数处于非严格模式下，则指定为 null 或 undefined 时会自动替换为指向全局对象。浏览器环境下，这个值为null、undefined和window是等价的，测试结果如下：
//https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Function/apply
https://www.dazhuanlan.com/2019/08/18/5d594b50e0124/