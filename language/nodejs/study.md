** 前端 & Node.js **

- [前端资源](https://github.com/moklick/frontend-stuff)
- [前端开发指南](https://github.com/w3crange/Front-End-Develop-Guide)
- [前端技能汇总](http://html5ify.com/fks/)
- [前端资源大导航](http://www.daqianduan.com/nav)
- [收集前端方面的书籍](https://github.com/lisposter/frontend-books)
- [2014年最新前端开发面试题](https://github.com/markyun/My-blog/tree/master/Front-end-Developer-Questions)
- [简单清晰的JavaScript语言教程，代码示例](https://github.com/airbnb/javascript)
- [JavaScript编程规范](https://github.com/airbnb/javascript)
- [JavaScript必看视频](https://github.com/bolshchikov/js-must-watch)
- [JavaScript标准参考教程（阮一峰的，整理的不错）](http://javascript.ruanyifeng.com/)
- [JS必看](https://github.com/bolshchikov/js-must-watch)
- [AngularJS Guide的中文分支](https://github.com/jmcunningham/AngularJS-Learning/blob/master/ZH-CN.md)
- [Angular2学习资料](https://github.com/timjacobi/angular2-education)
- [AngularJS应用的最佳实践和风格指南](https://github.com/mgechev/angularjs-style-guide/blob/master/README-zh-cn.md)
- [React-Native学习指南](https://github.com/reactnativecn/react-native-guide)
- [七天学会NodeJS](http://nqdeng.github.io/7-days-nodejs/)
- [node.js中文资料导航](https://github.com/sergtitov/NodeJS-Learning/blob/master/cn_resource.md)
- [Nodejs学习路线图](http://blog.fens.me/nodejs-roadmap/)
- [如何学习nodejs](http://stackoverflow.com/questions/2353818/how-do-i-get-started-with-node-js/9629682#9629682)
- [url](https://github.com/zhouweiaccp/be-a-professional-programmer.git)
-  [node.js中文资料导航](https://github.com/youyudehexie/node123)
[http://blog.fens.me/series-nodejs/] (从零开始nodejs系列文章)



## Node 和 npm/Yarn可以更换镜像
yarn install   https://classic.yarnpkg.com/zh-Hans/docs/install/#windows-stable   https://github-production-release-asset-2e65be.s3.amazonaws.com/49970642/d78d7b00-61e5-11ea-93f6-feccc62e1d63?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200709%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200709T082622Z&X-Amz-Expires=300&X-Amz-Signature=5a5fb74bbbfd31db93ce1d0efa099338405972124e217ea5708e2b3023b14572&X-Amz-SignedHeaders=host&actor_id=0&repo_id=49970642&response-content-disposition=attachment%3B%20filename%3Dyarn-1.22.4.msi&response-content-type=application%2Foctet-stream
阿里：yarn config set registry https://registry.npm.taobao.org
华为：yarn config set registry https://mirrors.huaweicloud.com/repository/npm/
Node-Sass：npm config set sass_binary_site https://mirrors.huaweicloud.com/node-sass/
（https://segmentfault.com/a/1190000020693560?utm_source=tag-newest#articleHeader16）

### The engine “node” is incompatible with this module. Expected version
yarn config set ignore-engines true
