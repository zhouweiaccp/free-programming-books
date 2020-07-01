


https://sass.bootcss.com/ruby-sass
Ruby Sass 是 Sass 的最初实现，但是 已经于 2019年 3 月 26 日将寿终正寝。我们已经不再对它提供任何支持了，请 Ruby Sass 用户 迁移到其它实现版本（LibSass 或 Dart Sass）。

为什么？
当 Natalie 和 Hampton 在 2006 年首次创建 Sass 时，Ruby 是当时 web 开发中最前沿的编程语言，同时也是两位作者开发的 Haml 模板语言所依赖的编程语言，更是两位作者 日常工作中最常用的编程语言。用 Ruby 编写 Sass 能够很方便地 吸引已有的用户甚至整个 Ruby 生态来使用。

后来，Node.js 在前端开发中变得无处不在，而 Ruby 则 逐渐淡入了后台。与此同时，Sass 项目的规模 已经远远超出了作者最初的设想，对 Sass 在性能上的需求 也已经超过了 Ruby 的能力。Dart Sass 和 LibSass 的运行速度都非常快、安装也容易，并且能够很容易地 通过 npm 获取。而 Ruby Sass 已经跟不上脚步了，把核心团队的资源花在这上面 已经没有意义了。

迁移
如果你在命令行通过 sass 命令来运行 Ruby Sass，那么你 只需要安装 Dart Sass 的 命令行可执行文件 即可。虽然接口不完全一致，但是大多数参数的工作方式是 相同的。

如果你使用的是 sass gem 工具库，那么 sassc gem 是 从 Ruby Sass 迁移出来的最顺畅的方式。它基于 LibSass 并提供了 与 Ruby Sass 相同的 API 用于编译 Sass 源码和自定义函数， 只是它使用的是 SassC 模块而不是 Sass。并且， 它 并不 支持与 Ruby Sass 相同的 Importer API。不过你可以 在 Ruby on Rails 中使用引入 sassc-rails gem 。

或者，如果你使用的是 JS 构建系统，你可以将 Dart Sass 作为 JavaScript 库来使用。