推荐这个配置文件 https://github.com/wklken/vim-for-server
curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

https://github.com/skywind3000/awesome-cheatsheets/blob/master/editors/vim.txt
vim模式：

编辑模式(命令模式)
输入模式
末行模式
模式转换：

编辑-->输入：

    i: 在当前光标所在字符的前面，转为输入模式；

    a: 在当前光标所在字符的后面，转为输入模式；

    o: 在当前光标所在行的下方，新建一行，并转为输入模式；

    I：在当前光标所在行的行首，转换为输入模式

    A：在当前光标所在行的行尾，转换为输入模式

    O：在当前光标所在行的上方，新建一行，并转为输入模式；
输入-->编辑：

    ESC
编辑-->末行：

    :
末行-->编辑：

    ESC, ESC
注：输入模式和末行模式之间不能直接切换
一、打开文件
    vim +# :打开文件，并定位于第#行

    vim +：打开文件，定位至最后一行

    vim +/PATTERN : 打开文件，定位至第一次被PATTERN匹配到的行的行首
注：默认处于编辑模式
二、关闭文件
1、末行模式关闭文件

    :q  退出

    :wq 保存并退出

    :q! 不保存并退出

    :w 保存

    :w! 强行保存

    :wq --> :x
2、编辑模式下退出

ZZ: 保存并退出
三、移动光标(编辑模式)
1、逐字符移动：

    h: 左

    l: 右

    j: 下

    k: 上

    #h: 移动#个字符
2、以单词为单位移动

    w: 移至下一个单词的词首

    e: 跳至当前或下一个单词的词尾

    b: 跳至当前或前一个单词的词首

    #w: 移动#个单词
3、行内跳转：

    0: 绝对行首

    ^: 行首的第一个非空白字符
  shift+4  行尾
    $: 绝对行尾
4、行间跳转

    #G：跳转至第#行

    gg: 第一行

    G：最后一行
5、末行模式

    .: 表示当前行

    $: 最后一行

    #：第#行

    +#: 向下的#行
四、翻屏
    Ctrl+f: 向下翻一屏
	
    Ctrl+b: 向上翻一屏

    Ctrl+d: 向下翻半屏

    Ctrl+u: 向上翻半屏
五、删除单个字符
    x: 删除光标所在处的单个字符

    #x: 删除光标所在处及向后的共#个字符
六、删除命令: d
d命令跟跳转命令组合使用

    #dw, #de, #db
    d$ 光标到行尾
dd: 删除当前光标所在行
#dd: 删除包括当前光标所在行在内的#行；

七、粘贴命令 p
    p: 如果删除或复制为整行内容，则粘贴至光标所在行的下方，如果复制或删除的内容为非整行，则粘贴至光标所在字符的后面

    P: 如果删除或复制为整行内容，则粘贴至光标所在行的上方，如果复制或删除的内容为非整行，则粘贴至光标所在字符的前面
八、复制命令 y
    用法同d命令
九、修改：先删除内容，再转换为输入模式
    c: 用法同d命令
十、替换：
    r：单字符替换

    #r: 光标后#个字符全部替换

    R: 替换模式
十一、撤消编辑操作 u
    u：撤消前一次的编辑操作

    #u: 直接撤消最近#次编辑操作

    连续u命令可撤消此前的n次编辑操作

    撤消最近一次撤消操作：Ctrl+r
十二、重复前一次编辑操作
    .：编辑模式重复前一次编辑操作
十三、可视化模式
    v: 按字符选取

    V：按矩形选取
十四、查找
    /PATTERN

    ?PATTERN

    n 下一个

    N 上一个
十五、查找并替换
在末行模式下使用s命令

    headline,footlines#PATTERN#string#g

    1,$:表示全文

    %：表示全文
十六、使用vim编辑多个文件
    vim FILE1 FILE2 FILE3

    :next 切换至下一个文件

    :prev 切换至前一个文件

    :last 切换至最后一个文件

    :first 切换至第一个文件

    :q退出当前文件

    :qa 全部退出
十七、分屏显示一个文件
    Ctrl+w, s: 水平拆分窗口

    Ctrl+w, v: 垂直拆分窗口
在窗口间切换光标：

    Ctrl+w, ARROW(h,j,k,l或方向键) 

    :qa 关闭所有窗口
十八、分窗口编辑多个文件
    vim -o : 水平分割显示

    vim -O : 垂直分割显示
十九、将当前文件中部分内容另存为另外一个文件
末行模式下使用w命令

    :ADDR1,ADDR2w /path/to/somewhere
二十、将另外一个文件的内容填充在当前文件中
    :r /path/to/somefile

    附加到当前文件光标后
二十一、跟shell交互
    :! COMMAND
二十二、高级话题
1、显示或取消显示行号

    :set nu

    :set nonu

    mu = number
2、显示忽略或区分字符大小写

    :set ic

    :set noic

    ic = ignorecase
3、设定自动缩进

    :set ai

    :set noai

    ai = autoindent
4、查找到的文本高亮显示或取消

    :set hlsearch

    :set nohlsearch
5、语法高亮

    :syntax on

    :syntax off
注:特性当前有效，如果想要永久有效需修改配置文件
二十三、配置文件
    /etc/vimrc    针对所有用户

    ~/.vimrc    针对当前用户


效果
1.高亮显示搜索结果
:set nohlsearch

vimdiff  a a1
窗口焦点切换，即切换当前窗口   CTRL-w h 跳转到左边的窗口   CTRL-w l 跳转到右边的窗口

文件合并
文件比较的最终目的之一就是合并，以消除差异。如果希望把一个差异点中当前文件的内容复制到另一个文件里，可以使用命令
dp （diff "put"）
如果希望把另一个文件的内容复制到当前行中，可以使用命令

do (diff "get"，之所以不用dg，是因为dg已经被另一个命令占用了)
https://www.ibm.com/developerworks/cn/linux/l-vimdiff/

:2,7 s/^/#   其中2,7代表起始结束行号，s是替换命令，/^代表行的开头/#代表替换为#号
:2,7 s/^#// 把开头的#：号替换为空字符
:g/^\s*$/d   vim批量删除空白行

## vim 可视化模式（visual模式）
v 进入字符可视化模式
V 进入行可视化模式
## Ctrl+v 进入块可视化模式
- [](https://www.ibm.com/developerworks/cn/linux/l-cn-vimcolumn/)
ctrl-v 进入纵向编辑模式
I 进入行首插入模式  ,r 批量插入 A 光标添加
输入所要求字符“#”
ESC 退出纵向编辑模式的同时所有选中的字符前都添加了“# ”，回到命令模式
批理删除列中的字符   x

#### 前添加
ctrl-v 进入纵向编辑模式
G 移动游标到最后一行第一列，可视块覆盖了第一列
I 进入行首插入模式
输入所要求字符 #
ESC 退出纵向编辑模式

#### 后添加
ctrl-v 进入纵向编辑模式
G 移动游标到最后一行第一列，可视块覆盖了第一列
A  进入行首插入模式
输入所要求字符 #
ESC 退出纵向编辑模式

Ctrl+g切换可视模式和选择模式
Ctrl+o切换可视模式两端光标
tab+ < > 左右移

# 批量插入
2,7s/^/#/g，在2到7行首插入#
2,7s/^#//g    批量删除字符快捷键
# 放弃所有修改
:e! 放弃所有修改，从上次保存文件开始再编辑

#  替换每一行中所有
:%s/vivian/sky/g（等同于 :g/vivian/s//sky/g） 替换每一行中所有 vivian 为 sky
sed -i -c -e '/^#/d' config_file ##sed去除注释行 kjyw\shell\sed\sed.sh
sed -i -c -e '/^$/d' config_file ##sed去除空行
sed -i -c -e '/^$/d;/^#/' config_file ##sed去空行和注释行
## 将命令结果插入文件：
     运行 :r! command ， command命令的结果插入光标下一行
            :nr! command,  command命令的结果插入n行后。
            
## 暂时离开vim来执行命令：
     运行:r sh，使用完sh后exit又可以返回vim   