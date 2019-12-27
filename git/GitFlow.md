
准确的说 GitFlow 是一种比较成熟的分支管理流程，我们先看一张图能清晰的描述他整个的工作流程：

图片描述

第一次看上面那个图是不是一脸懵逼？跟我当时一样，不急，我来用简单的话给你们解释下。

一般开发来说，大部分情况下都会拥有两个分支 master 和 develop，他们的职责分别是：

master：永远处在即将发布(production-ready)状态

develop：最新的开发状态

确切的说 master、develop 分支大部分情况下都会保持一致，只有在上线前的测试阶段 develop 比 master 的代码要多，一旦测试没问题，准备发布了，这时候会将 develop 合并到 master 上。

但是我们发布之后又会进行下一版本的功能开发，开发中间可能又会遇到需要紧急修复 bug ，一个功能开发完成之后突然需求变动了等情况，所以 Git Flow 除了以上 master 和 develop 两个主要分支以外，还提出了以下三个辅助分支：

feature: 开发新功能的分支, 基于 develop, 完成后 merge 回 develop

release: 准备要发布版本的分支, 用来修复 bug，基于 develop，完成后 merge 回 develop 和 master

hotfix: 修复 master 上的问题, 等不及 release 版本就必须马上上线. 基于 master, 完成后 merge 回 master 和 develop

什么意思呢？

举个例子，假设我们已经有 master 和 develop 两个分支了，这个时候我们准备做一个功能 A，第一步我们要做的，就是基于 develop 分支新建个分支：

git branch feature/A

看到了吧，其实就是一个规范，规定了所有开发的功能分支都以 feature 为前缀。

但是这个时候做着做着发现线上有一个紧急的 bug 需要修复，那赶紧停下手头的工作，立刻切换到 master 分支，然后再此基础上新建一个分支：

git branch hotfix/B

代表新建了一个紧急修复分支，修复完成之后直接合并到 develop 和 master ，然后发布。

然后再切回我们的 feature/A 分支继续着我们的开发，如果开发完了，那么合并回 develop 分支，然后在 develop 分支属于测试环境，跟后端对接并且测试的差不多了，感觉可以发布到正式环境了，这个时候再新建一个 release 分支：

git branch release/1.0

这个时候所有的 api、数据等都是正式环境，然后在这个分支上进行最后的测试，发现 bug 直接进行修改，直到测试 ok 达到了发布的标准，最后把该分支合并到 develop 和 master 然后进行发布。

以上就是 Git Flow 的概念与大概流程，看起来很复杂，但是对于人数比较多的团队协作现实开发中确实会遇到这么复杂的情况，是目前很流行的一套分支管理流程，但是有人会问每次都要各种操作，合并来合并去，有点麻烦，哈哈，这点 Git Flow 早就想到了，为此还专门推出了一个 Git Flow 的工具，并且是开源的：

GitHub 开源地址：https://github.com/nvie/gitflow

简单点来说，就是这个工具帮我们省下了很多步骤，比如我们当前处于 master 分支，如果想要开发一个新的功能，第一步切换到 develop 分支，第二步新建一个以 feature 开头的分支名，有了 Git Flow 直接如下操作完成了：

git flow feature start A

这个分支完成之后，需要合并到 develop 分支，然而直接进行如下操作就行：

git flow feature finish A

如果是 hotfix 或者 release 分支甚至会自动帮你合并到 develop、master 两个分支。

想必大家已经了解了这个工具的具体作用，具体安装与用法我就不多提了，感兴趣的可以看我下我之前写过的一篇博客：

http://stormzhang.com/git/2014/01/29/git-flow/

5. 总结

以上就是我分享给你们的关于分支的所有知识，一个人你也许感受不到什么，但是实际工作中大都以团队协作为主，而分支是团队协作必备技能，而 Git Flow 是我推荐给你们的一个很流行的分支管理流程，也是我们薄荷团队内部一直在实践的一套流程，希望对你们有借鉴意义。


## github gitee backup
-[](https://gitee.com/oschina/bgit)