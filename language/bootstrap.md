




BS4的新特性
在开启我们的探索之前，有必要先梳理一下BS4添加的新特性：
1）从Less迁移到Sass： 
现在，Bootstrap已加入Sass的大家庭中。得益于Libsass（Sass 解析器），Bootstrap的编译速度比以前更快；

2）改进网格系统：
新增一个网格层适配移动设备，并整顿语义混合。

3）默认弹性盒模型（flexbox）：
这是项划时代的变动，利用flexbox的优势快速布局。

4）废弃了wells、thumbnails和panels，使用cards代替。

5）新的自定义选项：
不再像上个版本一样，将渐变、淡入淡出、阴影等效果分放在单独的样式表中。而是将所有选项都移到一个Sass变量中。
想要给全局或考虑不到的角落定义一个默认效果？很简单，只要更新变量值，然后重新编译就可以了。

6）使用rem和em单位。

7）重构所有JavaScript插件：
Bootstrap 4用ES6重写了所有插件。现在提供UMD支持、泛型拆解方法、选项类型检查等特性。

8）改进工具提示和popovers自动定位：
这部分要感谢Tether（A positioning engine to make overlays, tooltips and dropdowns better）工具的帮助，
如果你还不知道Tether是什么，可以去他家Github地址。
https://segmentfault.com/a/1190000013051472 bootstrap4之栅格系统
https://segmentfault.com/a/1190000008291037  bootstrap4新特性
http://segmentfault.com/a/1190000013332869




## bootstrap 居中布局
在bootstrap中实现元素居中的方法主要有这几种：

1.加类.text-center（子元素居中）

2.加类.center-block（自身居中）

3.利用bootstrap中列偏移的概念。例如：col-md-offset-2(外边距向右偏移两列)