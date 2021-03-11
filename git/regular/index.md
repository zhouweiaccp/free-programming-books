



## 常用正则表达式
/^[\u4e00-\u9fa5_a-zA-Z0-9\s]+$/.test(' 2Admin istrat orw')     中 英 空格 _



## 正则表达式[\w]+,\w+,[\w+] 三者区别？ [],[ABC]+,[\w./-]+ 表达什么？
正则表达式[\w]+,\w+,[\w+] 三者有何区别：
[\w]+和\w+没有区别，都是匹配数字和字母下划线的多个字符；
[\w+]表示匹配数字、字母、下划线和加号本身字符；

## 正则表达式\w和\W
\w :匹配包括下划线的任何单词字符,等价于 [A-Z a-z 0-9_]
\W :匹配任何非单词字符,等价于 [^A-Z a-z 0-9_]


##  数字 字母
```js
  var reg = /^(([a-zA-Z]+[0-9])|([0-9]+[a-zA-Z]))[a-zA-Z0-9]*$/;
        var r = newPassword.value.match(reg);
```
##  数字 字母 特殊符号
var r = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[~!@#$%^&*()_+`\-={}:";'<>?,.\/]).{1,16}$/.test(newPassword.value);//newPassword.value.match(reg);


## 学习demo
```js
//https://github.com/leixiaokou/waimai-uniapp/blob/main/components/marked/lib/marked.js
block.tables = merge({}, block.gfm, {
  nptable: /^ *([^|\n ].*\|.*)\n *([-:]+ *\|[-| :]*)(?:\n((?:.*[^>\n ].*(?:\n|$))*)\n*|$)/,
  table: /^ *\|(.+)\n *\|?( *[-:]+[-| :]*)(?:\n((?: *[^>\n ].*(?:\n|$))*)\n*|$)/
});

/**
 * Pedantic grammar
 */

block.pedantic = merge({}, block.normal, {
  html: edit(
    '^ *(?:comment *(?:\\n|\\s*$)'//  ?:comment 匹配comment但是不捕获匹配的文本     
    + '|<(tag)[\\s\\S]+?</\\1> *(?:\\n{2,}|\\s*$)' // closed tag
    + '|<tag(?:"[^"]*"|\'[^\']*\'|\\s[^\'"/>\\s]*)*?/?> *(?:\\n{2,}|\\s*$))')
    .replace('comment', block._comment)
    .replace(/tag/g, '(?!(?:'
      + 'a|em|strong|small|s|cite|q|dfn|abbr|data|time|code|var|samp|kbd|sub'
      + '|sup|i|b|u|mark|ruby|rt|rp|bdi|bdo|span|br|wbr|ins|del|img)'
      + '\\b)\\w+(?!:|[^\\w\\s@]*@)\\b')
    .getRegex(),
  def: /^ *\[([^\]]+)\]: *<?([^\s>]+)>?(?: +(["(][^\n]+[")]))? *(?:\n+|$)/
});
```