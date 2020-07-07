响应式布局的基础
如果进行响应式开发需要加入以下代码   
 <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
我们把html5页面放到手机上预览，默认情况下，不管手机设备有多宽，HTML都是按照
980<安卓，iOS>(或者1024<黑莓>)宽度渲染的，这样页面会整体缩小(内容也都会缩小)
解决方案：viewport 视口（layout viewport 布局视口），设定页面渲染中的一些规则
content(规则内容):
width=device-width:让页面渲染的宽度和设备宽度保持一致
initial-scale=1.0 :初始缩放比例1:1
maximum-scale=1.0: 最大缩放比例1:1 (适配一些低版本安卓，如果不加user-scalable禁止会失效)
minimum-scale=1.0: 最小缩放比例1:1 (适配一些低版本安卓，如果不加user-scalable禁止会失效)
user-scalable=no:是否可对页面进行缩放，no 禁止缩放

如何实现 PC端和移动端用同一套项目：
第一种 @media：
css中设定条件就是基于@media完成的（类似if）
1. 媒体设备 all(所有的设备)/print(打印机设备)/screen(屏幕设备<电脑，手机，ipad等>)
2. 媒体条件 符合某个条件，写对应的样式
- max-width 最大宽度为
- min-width 最小宽度为
- width
- 横屏/竖屏
...

 @media screen and (max-width: 500px){
            /* 如果当前页面宽度<=500 */
            /* .person {
                width: 200px;
            } */
        }
第二种 rem响应式布局方案(等比缩放)：
使用的时候按照1920的设计稿来做。100px=1rem，font-size设置成100px; 750px的设计稿 1rem = 100px 设置屏幕超过2560及以上，就固定1rem = 200px， 宽度小于600及以下，就固定1rem = 32px
第三方库用的一般是使用px单位，无法使用rem适配不同设备的屏幕。
解决办法：使用px2rem-loader插件将第三方ui库的px转换成rem单位。

第一步：拿到设计稿后(现在移动端设计稿一般都是750px的)，我们设定一个
初始的REM和PX的换算比例(一般设置为1rem=100px，为了方便后期换算)
第二步：测量出设计稿元素的尺寸(PS测出来的是PX单位)，在编写样式的时候全部
转换为REM的单位(除以100即可) =>100%还原设计稿，最外层一般按照100%设置
第三步：编写一段JS，获取当前设备的宽度，让其除以设计稿的宽度(设计稿是750PX或者1920PX)，在乘以初始
的换算比例100，计算出当前设备下，一个rem应该=多少像素(只要改变HTML的font-size就
可以)；这样HTML字体大小一改，之前所有以REM单位的元素都会跟着自动缩放..
现在真实项目中，主体响应式布局以REM为主，部分效果实现可以基于flex来做，需要样式微调整还是要基于@media来完成的...

<style>
html {
            font-size: 100px;
        }
</style>
<script>
    function computedREM() {
        let HTML = document.documentElement;
        winW = HTML.clientWidth || document.body.clientWidth;;
        HTML.style.fontSize = winW / 1920 * 100 + 'px';
    }
    // 进入时执行computedREM
    computedREM();
    // 当浏览器窗口大小发生改变的时候执行computedREM
    window.addEventListener('resize',computedREM);
</script>
DPR适配：屏幕像素密度比，@2x @3x
通过在F12进入网页调试模式，可以看到iphoneX 的DPR为3.0
image.png

iphone6/7/8 的DPR维2.0
image.png

如果图片的真实大小是2020的话，那在DPR为2.0的手机上 会按照4040来渲染
如果图片的真实大小是2020的话，那在DPR为3.0的手机上 会按照6060来渲染
这样一来图片就因为被放大而渲染"模糊"，所以需要设计师提供对应的4040(@2x) 6060(@3x)的图片。
原生app开发或者H5移动端开发中，理论上应该按照多张素材准备:
logo.png,
logo@2x.png,
logo@3x.png
样式布局(CSS中)基于@media指定不同DPR下用不同的素材图；在或者在JS中，监听DPR值，让其加载不同的素材图；这样的好处是，在DPR为1.0的时候，加载小图，速度会更快
真实开发中:
只准备最大的，不管DPR多少,都加载最大的，DPR1.0也不会失真，只是多加载一些图片资源，速度慢一些，所以需要做图片懒加载，BASE64、雪碧图
移动端设计稿一般都是750px的，所切的图就是@2x 的，在一些DPR为3.0的手机上使用@2x图片大多数也会显示的很清晰，这样就是为什么设计稿要750px的


image.png

作者：程序萌
链接：https://www.jianshu.com/p/6e77c838ab71