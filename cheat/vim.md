# 目录
<!-- vim-markdown-toc GFM -->

- [SpaceVim定制版](#spacevim定制版)
  - [插入模式](#插入模式)
  - [普通模式](#普通模式)
  - [可视模式](#可视模式)
  - [窗口](#窗口)
  - [标签页](#标签页)
  - [缓冲区](#缓冲区)
  - [屏幕滚动](#屏幕滚动)
  - [快速搜索及移动光标](#快速搜索及移动光标)
  - [其它g命令](#其它g命令)
  - [其它z命令](#其它z命令)
  - [界面与工具](#界面与工具)
  - [文件树](#文件树)
  - [制表与对齐](#制表与对齐)
  - [代码注释](#代码注释)
  - [补全](#补全)
  - [符号包围](#符号包围)
  - [Toggle命令](#toggle命令)
  - [Git](#git)
  - [浏览器搜索与翻译](#浏览器搜索与翻译)
  - [文件内容搜索](#文件内容搜索)
  - [LeaderF模糊搜索](#leaderf模糊搜索)
  - [代码符号跳转](#代码符号跳转)
  - [语法错误检测](#语法错误检测)
  - [书签记号](#书签记号)
  - [lang#c](#langc)
  - [lang#markdown](#langmarkdown)
  - [杂项](#杂项)
- [基础概念](#基础概念)
  - [命令模式](#命令模式)
  - [范围](#范围)
  - [寄存器](#寄存器)
  - [宏录制](#宏录制)
  - [标记与跳转](#标记与跳转)
  - [临时文件](#临时文件)
  - [runtimepath目录结构](#runtimepath目录结构)
  - [命令别名](#命令别名)
  - [初步配置](#初步配置)
  - [gvim配置](#gvim配置)
- [简单的vimscript语法](#简单的vimscript语法)
  - [变量](#变量)
  - [函数](#函数)

<!-- vim-markdown-toc -->
# SpaceVim定制版
本手册适用于[该项目的配置](https://github.com/mrbeardad/SpaceVim)  
手册中还介绍了vim自带的按键，一些按键功能未具体指出，读者可以打开vim试试便知其意

## 插入模式
* 插入模式
    > 进入插入模式：`gi` `i` `a` `I` `A` `o` `O`

| 按键                   | 作用                                                                |
|------------------------|---------------------------------------------------------------------|
| `<c-a>与<c-e>`         | 行首，行尾                                                          |
| `<s-left>与<s-right>`  | 左移一个单词，右移一个单词                                          |
| `<s-down>与<s-up>`     | 光标行下滚半屏，光标行上滚半屏                                      |
| `<c-d>与<c-b>`         | 下半屏，上半屏                                                      |
| `<c-u>与<c-k>`         | 删除光标前文本，删除光标后文本                                      |
| `<c-w>`                | 删除光标前单词                                                      |
| `<c-l>`                | 删除光标后一个字符                                                  |
| `<c-r>{reg}`           | 粘贴`reg`寄存器                                                     |
| `<c-y>`                | 粘贴`"`寄存器                                                       |
| `<m-s>`                | 跳转结对符的另一边(即普通模式的`%`)                                 |
| `<m-n>`                | 跳转下对结对符                                                      |
| `<m-e>`                | 将光标后的字符向后移                                                |
| `<m-{char}>`           | {char}可以是`}` `]` `)`等，表示将光标后的字符移动到下一个{char}后面 |
| `<c-o>`                | 下行插入                                                            |
| `<c-s-down>与<c-s-up>` | 将本行下移，将本行上移                                              |
| `<c-c>`                | 退出插入模式且避免触发InsertLeave                                   |
| `<c-v>{char}`          | 插入{char}（控制）字符                                              |
| `<c-v>x{hh}`           | 插入编码为0xhh的ascii字符                                           |
| `<c-v>u{hhhh}`         | 插入码点为hhhh的unicode字符                                         |
<!--  -->

## 普通模式
* 普通模式
> 复合操作符可以结合光标移动，对初始位置与移动后位置之间的文本进行操作  
> 也可以结合文本对象，对文本对象中的内容进行操作
 * 复合操作符：  
    `d`，`c`，`y`，`gu`，`gU`，`g~` `v`  
 * 光标移动：  
    `0`，`^`，`$`，`w`，`W`，`b`，`B`，`e`，`E`，`ge`，`gE`  
    `f`，`F`，`%` `(`，`)`，`{`，`}`  
    `gg`，`G`，`H`，`L`，`M`，`{num}|`，`gm`  
 * 文本对象：需要带前缀`i`或`a`  
    `w`，`s`，`p`，`(`，`{`，`[`，`<`，`"`，`'`，`` ` ``  
    `e`，`l`，`i`，`f`，`,`  
 * 替换：  
    `R`，`r`

| 按键                   | 作用                                 |
|------------------------|--------------------------------------|
| `<c-a>与<c-e>`         | 行首，行尾                           |
| `x与s`                 | 删除相当于`dl与cl`                   |
| `D与C`                 | 删除相当于`d$与c$`                   |
| `dd与S`                | 删除当前行                           |
| `,`                    | 复制相当于`yl`                       |
| `Y`                    | 复制相当于`y$`                       |
| `<leader>y`            | 复制到系统剪切板`"+y`                |
| `<leader>,`            | 复制到系统剪切板`"+yl`               |
| `<leader>Y`            | 复制到系统剪切板`"+y$`               |
| `<space>bY`            | 复制整个buffer至系统剪切板           |
| `<leader>p与<leader>P` | 粘贴系统剪切板到光标后/前            |
| `<leader>o与<leader>O` | 粘贴系统剪切板到光标下/上行          |
| `<space>bP`            | 粘贴系统至整个buffer(覆盖原来的内容) |
| `=p与=P`               | 粘贴`0`寄存器到光标前/后             |
| `=O与=o`               | 粘贴`0`寄存器到光标上/下             |
| `<c-s-down>与<c-s-up>` | 将本行下/上移                        |
| `[<space>与]<space>`   | 上/下一行添加空行                    |
| `~`                    | 转换大小写                           |
| `J`                    | 将下行文本连接到此行                 |
| `u与<c-r>`             | 撤销树回溯与前进                     |
| `.`                    | 重复上次操作                         |

## 可视模式
* 可视模式
> 进入可视模式：`v` `V` `<c-v>` `gv`  
> 其中`<c-v>`进入可视块模式，按`I` `A` `s`修改后按`<esc>`，可以对所有选中的行进行修改  
> 其中`v`可以作为复合操作符，见[普通模式](#普通模式)  
> 其中`gv`会重新选择上次选择的文本

| 按键           | 作用                                               |
|----------------|----------------------------------------------------|
| `<c-a>与<c-e>` | 行首，行尾                                         |
| `o`            | 块选取时对角线跳转                                 |
| `O`            | 块选取时邻角跳转                                   |
| `v与V`         | 扩大可视范围，缩小可视范围                         |
| `<c-r>`        | 交互式替换此行以下选中的文本                       |
| `<leader>Y`    | 复制到`http://pastebin.com`并将URL赋值到系统剪切板 |
| `<leader>y`    | 复制到系统剪切板`"+y`                              |
| `<leader>p`    | 粘贴系统剪切板                                     |
| `=p`           | 粘贴`0`寄存器                                      |

## 窗口
* 窗口

| 按键                       | 作用                            |
|----------------------------|---------------------------------|
| `<c-w>=`                   | 所有窗口等高等宽                |
| `<c-w>-与<c-w>+`           | 减少与增加窗口高度              |
| `<c-w><与<c-w>>`           | 减少与增加窗口宽度              |
| `{num}<c-w>_与{num}<c-w>|` | 设置窗口高度与宽度为num         |
| `<c-w>c`                   | 关闭窗口                        |
| `<c-w>o`                   | 关闭其它所有窗口                |
| `<c-w>s`                   | 水平分割窗口                    |
| `<c-w>v`                   | 垂直分割窗口                    |
| `<space>{numr}`            | 切换至第{numr}号窗口            |
| `<tab>`                    | 切换至下个窗口                  |
| `<s-tab>`                  | 切换至上个窗口                  |
| `<c-{arrow}>`              | 切换至指定方向上的窗口          |
| `<c-w>H`                   | 将当前窗口移动到最左边，JKL同理 |
<!-- -->

## 标签页
* 标签页

| 按键                  | 作用                   |
|-----------------------|------------------------|
| `<F7>`                | 打开标签管理器         |
| `<M-{numr}>`          | 切换至第{numr}个标签页 |
| `<M-Left>与<M-Right>` | 切换至上/下一个标签页  |
<!-- -->

## 缓冲区
* 缓冲区
> 常用命令：:ene，:e，:bd，:qa，:wa，:wq，:wqa，:saveas  
> 参数列表：:args，:arga，:argd，:argdo  
> 详情：:h ls

| 按键                   | 作用                     |
|------------------------|--------------------------|
| `<leader>n与<leader>b` | 下/上一个缓冲区          |
| `<leader>{numr}`       | 第{numr}个buffer         |
| `<c-s>`                | 保存buffer至硬盘         |
| `<c-w>x`               | 安全删除该buffer         |
| `<c-w>X`               | 安全删除所有未激活buffer |
| `<c-w>W`               | 用sudo写入文件           |
<!--  -->

## 屏幕滚动
* 屏幕滚动
> 前三组是为了滚动屏幕以获取窗口视野之外的内容，且当前光标行仍然需要在窗口中可见  
> 第四组是只为了翻页，即接下来无需处理当前光标行  
> 故前三组的按键会尽量保持滚动后光标行的行号不变

| 按键                | 作用                     |
|---------------------|--------------------------|
| `z<cr>与zz与zb`     | 光标行滚动到屏幕顶/中/底 |
| `z<down>与z<up>`    | 光标行下/上滚三行        |
| `<s-down>与<s-up>`  | 光标行下/上滚半屏        |
| `<c-d>与<c-b>`      | 下半屏，上半屏           |
| `zs`                | 光标列移至屏幕左边       |
| `z<left>与z<right>` | 屏幕左/右移半屏          |
<!--  -->

## 快速搜索及移动光标
* 快速移动光标

| 按键               | 作用                                  |
|--------------------|---------------------------------------|
| `*与#`             | 搜索当前单词，向下/上                 |
| `g*与g#`           | 搜索当前字符串(不加单词边界)，向下/上 |
| `/与?`             | 正向和反向正则匹配                    |
| `K`                | 快速查找doc                           |
| `gf`               | 快速跳转光标下的URL与文件             |
| `[c与]c`           | diff中跳转至上/下个diff点             |
| `g,与g;`           | 跳转新/旧更改表                       |
| `<space>jw`        | 跳转至某单词                          |
| `<space>jl`        | 跳转至某行                            |
| `<space>ju`        | 跳转至某URL                           |
| `;{char}{char}`    | 跳转至指定字符处                      |
| `f{char}与F{char}` | 连续按`f`与`F`可以重复移动            |
<!-- -->

## 其它g命令
* g命令

| 按键     | 作用                           |
|----------|--------------------------------|
| `g+与g-` | 新/旧撤销树(按时间)            |
| `g&`     | 重复上次:s命令                 |
| `g<c-g>` | 光标位置                       |
| `g<`     | 上次命令输出                   |
| `g=`     | 格式化                         |
| `gd`     | 跳转定义                       |
| `ga`     | 查看ascii字符编码或unicode码点 |
| `g8`     | 查看utf-8字符编码              |
<!-- -->
## 其它z命令
* z命令

| 按键       | 作用                                           |
|------------|------------------------------------------------|
| `zF`       | 手动折叠N行，需要用`<space>tf`切换手动折叠模式 |
| `za与zA`   | 切换折叠                                       |
| `zc与zC`   | 关闭折叠                                       |
| `zo与zO`   | 打开折叠                                       |
| `zR`       | 打开所有折叠                                   |
| `zM`       | 关闭所有折叠                                   |
| `zj与zJ`   | 下一个折叠                                     |
| `zk与zK`   | 上一个折叠                                     |
| `z=`       | 拼写建议(可以用`<c-p>与<c-n>`补全词典)         |
| `zg与zG`   | 标记单词为good                                 |
| `zw与zW`   | 标记单词为wrong                                |
<!-- -->

## 界面与工具
* 界面与工具：

| 按键        | 作用                 |
|-------------|----------------------|
| `<F1>`      | 开关标签栏           |
| `<F3>`      | 开关文件树           |
| `<F5>`      | 开关撤销树           |
| `<F7>`      | 标签页管理器         |
| `<space>ac` | 计算器               |
| `<space>al` | 日历                 |
| `<space>as` | Startify启动界面     |
| `<space>ar` | 阅读模式             |
| `<leader>q` | quickfix窗口操作前缀 |
<!-- -->

## 文件树
* 文件树

| 按键      | 作用                                    |
|-----------|-----------------------------------------|
| `<left>`  | 关闭目录                                |
| `<right>` | 展开目录，或打开文件                    |
| `R`       | 切换到项目根目录                        |
| `p`       | 预览文件，利用Guake（或tmux）与ranger   |
| `f`       | 搜索文件，利用Leaderf搜索光标位置的目录 |
| `O`       | 利用其它桌面工具打开当前目录或文件      |
| `.`       | 切换显示隐藏文件                        |
| `K`       | 新建目录                                |
| `N`       | 新建文件                                |
| `yy`      | 复制文件路径                            |
<!-- -->

## 制表与对齐
* 制表与对齐：

| 按键               | 作用                                |
|--------------------|-------------------------------------|
| `<leader>tt`       | 快速自动制表                        |
| `<leader>tm`       | 切换制表模式（插入模式可用`<m-m>`） |
| `<space>xa{char}`  | 根据{char}对齐                      |
| `<space>xao`       | 根据运算符对齐                      |
| `<space>xj{c/l/r}` | 居中/左/右对齐该段落                |
<!-- -->

## 代码注释
* 代码注释：

| 按键        | 作用               |
|-------------|--------------------|
| `<space>cl` | 切换该行注释状态   |
| `<space>cL` | 注释该行           |
| `<space>cp` | 切换该段落注释状态 |
| `<space>cP` | 注释该段落         |
<!-- -->

## 补全
* 补全

| 按键         | 作用                                           |
|--------------|------------------------------------------------|
| `<CR>`       | YCM结束补全，解决了与AutoPair的映射冲突        |
| `<m-/>`      | UltiSnips补全(或下一个位置)，`<M-B>`上一个位置 |
| `<c-x><c-f>` | 补全路径                                       |

## 符号包围
* 符号包围
> 举例：`cs{[`将`{content}`替换成`[ content ]`，`cs{]`则是将`{content}`替换成`[content]`(内部无空格)，
> 其它同理。替换的字符(第二个{char})若是`<`，则还可以继续输入直到`>`来添加**html标签**  
> 详见[surround](https://github.com/tpope/vim-surround)

| 按键                 | 作用             |
|----------------------|------------------|
| `cs{char}{char}`     | 替换包围符       |
| `ds{char}{char}`     | 删除包围符       |
| `ys{text-obj}{char}` | 添加包围符       |
| `yss{char}`          | 为改行添加包围符 |
<!-- -->

## Toggle命令
* Toggle命令

| 按键        | 作用                             |
|-------------|----------------------------------|
| `<space>tl` | 切换linebreak                    |
| `<space>tw` | 切换wrap                         |
| `<space>tv` | 切换virtualedit                  |
| `<space>te` | 切换expandtab                    |
| `<space>ts` | 切换spell                        |
| `<space>tf` | 切换foldmethod                   |
| `<space>t8` | 切换长行提醒                     |
| `<space>tb` | 切换背景颜色                     |
| `<space>tc` | 切换隐藏符号显示，如`\n` `\t` 等 |
| `<space>tn` | 切换行号显示                     |
| `<bs>`      | 关闭高亮搜索                     |
<!-- -->
## Git
* Git

| 按键         | 作用                |
|--------------|---------------------|
| `<space>gs`  | git status          |
| `<space>gd`  | git diff            |
| `<space>gl`  | 当前文件的git-log   |
| `<space>gL`  | 当前仓库的git-log   |
| `<space>gS`  | 暂存当前文件        |
| `<space>gg`  | GitGutterToggle     |
| `<space>ghr` | undo cursor hunk    |
| `<space>ghv` | preview cursor hunk |
<!-- -->
## 浏览器搜索与翻译
* 浏览器搜索

| 按键  | 作用                   |
|-------|------------------------|
| `gss` | 智能搜索URL            |
| `gsb` | baidu搜索引擎          |
| `gsg` | google搜索引擎         |
| `gsi` | iciba翻译              |
| `gsy` | youdao翻译             |
| `gse` | youdac翻译（手动输入） |
<!-- -->
## 文件内容搜索
* 文件内容搜索

| 按键        | 作用                 |
|-------------|----------------------|
| `<space>ss` | 搜索当前缓冲区       |
| `<space>sb` | 搜索所有缓冲区       |
| `<space>sd` | 搜索当前目录         |
| `<space>sf` | 搜索指定目录         |
| `<space>sp` | 搜索工程目录         |
| `<space>sj` | 后台搜索工程目录     |
| `<space>lt` | 打开上次后台搜索结果 |
<!-- -->
## LeaderF模糊搜索
* LeaderF模糊搜索

| 按键               | 作用                    |
|--------------------|-------------------------|
| `<leader>fr`       | 重置上次搜索            |
| `<leader>f<space>` | 搜索快捷键并执行        |
| `<leader>fp`       | 搜索插件信息            |
| `<leader>fh`       | 搜索vim帮助文档         |
| `<leader>fq`       | 搜索quickfix            |
| `<leader>fl`       | 搜索locationlist        |
| `<leader>fm`       | 搜索vim的输出信息并复制 |
| `<leader>fu`       | 搜索unicode并插入       |
| `<leader>fj`       | 搜索跳转表并跳转        |
| `<leader>fy`       | 搜索"寄存器历史并复制   |
| `<leader>fe`       | 搜索所有寄存器并复制    |
| `<leader>ff`       | 搜索函数(尾缀F全局)     |
| `<leader>ft`       | 搜寻符号(尾缀T全局)     |
| `<leader>fg`       | 利用gtags搜寻标识符     |
| `<leader>fb`       | 搜索打开的缓冲区        |
| `<leader>for`      | 搜索最近打开文件        |
| `<leader>fod`      | 搜索当前目录文件        |
| `<leader>fof`      | 搜索指定目录            |
| `<leader>fop`      | 搜索当时工程目录文件    |

## 代码符号跳转
* 代码符号搜索及跳转
> 前三个是基于`Leaderf gtags`，有时需要手动更新`Leaderf gtags --update`  
> 后面四个基于`YCM`语义

| 按键 | 作用                |
|------|---------------------|
| `gD` | 跳转gtags定义       |
| `gR` | 跳转gtags引用       |
| `gS` | 跳转gtags无定义引用 |
| `go` | 跳转定义或声明      |
| `gr` | 跳转引用            |
| `gt` | 获取对象类型        |
| `gc` | 更名对象            |
<!-- -->
## 语法错误检测
* 语法错误检测

| 按键        | 作用                   |
|-------------|------------------------|
| `<space>en` | 跳转下一个语法检测提示 |
| `<space>eb` | 跳转上一个语法检测提示 |
| `<space>el` | 打开语法检测提示列表   |
| `<space>ed` | 打开语法检测提示详情   |
<!-- -->
## 书签记号
* 书签记号

| 按键        | 作用                   |
|-------------|------------------------|
| `<space>mm` | 切换标签状态           |
| `<space>mi` | 为标签添加注释         |
| `<space>mn` | 跳转至下一个标签       |
| `<space>mb` | 跳转至上一个标签       |
| `<space>ml` | 列出所有标签           |
| `<space>mc` | 删除当前文件的所有标签 |
| `<space>mC` | 删除所有所有标签       |
<!-- -->
## lang#c
* lang#c

| 按键        | 作用                       |
|-------------|----------------------------|
| `<space>lr` | 快速运行程序               |
| `<space>li` | 快速打开输入窗口           |
| `<space>lc` | 关闭运行程序的终端         |
| `<space>ld` | 启动cgdb或gdb调试          |
<!-- -->

## lang#markdown
* lang#markdown

| 按键        | 作用                            |
|-------------|---------------------------------|
| `<space>lp` | 开启markdown预览                |
| `<space>lg` | 添加或删除GFM目录               |
| `<space>lk` | 利用系统剪切板的URL插入链接元素 |
<!--  -->

## 杂项
* 杂项
> Last but not least

| 按键        | 作用               |
|-------------|--------------------|
| `<space>xc` | 计算选中区域字符数 |
| `+或-`      | 加或减当前数字     |
| `<space>fC` | 转换文件格式       |
| `<leader>m` | 快速编辑宏         |
| `<space>se` | 多光标编辑         |
<!-- -->

# 基础概念
> 参考：[vim-galore-zh_cn](https://github.com/wsdjeg/vim-galore-zh_cn)  [ VIM中文文档 ](https://yianwillis.github.io/vimcdoc/doc/help.html)

## 命令模式
* 命令模式
 * 进入：`:`
 * 外部命令：!cmd
    > 利用`:r`与`:w`，将外部命令I/O重定向到该缓冲区  
 * 外部过滤：{范围}!cmd
    > 将外部命令的I/O同时重定向到目标指定区域  
 * 常用命令
    * `:g/pat/cmd`      ：`:g!`表示不匹配的行，默认范围%  
    * `:s/pat/rel/flag` ：默认范围.  
        > s_flags       ：e不报错，g全替换，i忽略大小写    
    * `:r/w`            ：范围表示read到范围行后，write指定范围  
    * `:X`              ：设置密码，为空解除  
    * `:profile`        ：调试  
<!--  -->

## 范围
* 范围
 * 先输入数字后再键入:冒号
 * `%`                  ：整个文件
 * `0`                  ：第一行行前
 * `$`                  ：最后一行
 * `.`                  ：当前行
 * `+n`                 ：当前行前/后n行
 * `'m`                 ：标签行
 * `/pattern/+1`        ：模式匹配行
 * `/foo//bar/`         ：多次模式匹配行
 * `?pattern?+1`        ：前向匹配行
<!-- -->

<!-- -->
## 寄存器
* 寄存器
 * 查看：:reg
 * 使用：" + □ + y/p
 * 寄存器：  
用户：a-z和A-Z（大写用来向寄存器添加）  
系统：`*`(选择区) 和 `+`(剪切板)  
只读：`%`文件、`.` 修改、`:` 命令、`/`搜索  
数字：0为最近一次复制，1-9最近1-9次删除  
<!-- -->

<!-- -->
## 宏录制
* 宏录制
 * 录制：q+□+操作+q
 * 使用：@+□，@@
 * 特殊：. 执行上次的单次修改操作
<!-- -->

<!-- -->
## 标记与跳转
* 标记与跳转
 * 查看：:marks 与 :jumps
 * 标记：m + 字母
 * 跳转：' + 标记
 * 标记：

| 意义           | 标记             |
|----------------|------------------|
| 用户           | 字母（大写全局） |
| 上次跳转       | `'`              |
| 上次修改       | `.`              |
| 上次修改或复制 | `[` `]`          |
| 上次插入       | `^`              |
| 上次关闭       | `"`              |
| 返回较旧跳转   | `<c-o>`（全局）  |
| 返回较新跳转   | `<c-i>`（全局）  |
<!-- -->

<!-- -->
## 临时文件
* 临时文件
 * swap文件
    > set noswapfile  
 * backup文件
    > set nobackup  
 * undo文件
    > set undofile  
    > set undodir=$HOME/.vim/undo  
 * viminfo文件
    > set viminfo='100,<50,s10,h,n$HOME/.vim/viminfo  
    > set history=1000  
    > 保存标记文件数、寄存器保存行数、寄存器最大字节、启动时关闭hlsearch、viminfo文件名、搜索/命令/输入历史  
 * session文件
    > :makesession mysession.vim  
    > :source mysession.vim  
<!-- -->

<!-- -->
## runtimepath目录结构
* runtimepath目录结构
 * 查看配置加载：:scriptnames
 * `:filetype plugin indent on`
    * 加载`filetype.vim`与`script.vim`，并加载`ftdetect/*.vim`
    * 加载`ftplugin.vim`，并加载`ftplugin/*.vim`
    * 加载`indent.vim`，并加载`indent/*.vim`
 * `:syntax enable`与`:syntax on`
    * 加载`syntax/*.vim`
 * `:set loadplugins`
    * 加载`plugin/*.vim`
 * `:set packpath=`与`:set runtimepath=`
    * `/pack/foo/start/bar/类vim目录/`
    * `/pack/foo/opt/bar/类vim目录/`
 * `/autoload/*.vim`
    > 存放自动载入的函数，调用时使用  
    > `:call (dirname#)*filename#funcname()`
 * `/ftplugin/`
    > 根据文件类型加载的配置
    * `<filetype>.vim`  
    * `<filetype>_<name>.vim`  
    * `<filetype>/<name>.vim`
<!-- -->

## 命令别名
* 命令别名
 * 命令别名
 * 形式：:command oldcmd Newcmd
 * 参数：`-nargs=0/1/*/?/+` 
`<args>`：用命令别名的参数代替该位置  
`<q-args>`："str \'str\' "  
`<f-args>`："str","str"  
 * 默认范围：-range/-range=%  
 * 自动命令
 * 形式：  
:autocmd [group] {events} {file_pattern} [nested] {command}
 * 查询：不加{command}
 * 键映射
 * 映射按键若局部冲突会导致vim等待
 * 映射`<leader>`：let mapleader="\\"
 * 禁用映射：映射到`<nop>`
 * `<silent>、<buffer>、<expr>`
 * `特殊字符`：
`<c-v>`{key}  
`<c-v>`{字符编码}：0，x，u，U  
`<c-k>`{二合字符}  
查看：:digraphs，ga，g8  
<!-- -->


 * 代码缩进
    * 配置：
    filetype indent on：自适应不同语言缩进  
    set autoindent：基于上行缩进  
    set expandtab：空格代替tab，:retab恢复本行tab  
    set tabstop=8：默认的tab宽，不足则为空格  
    set softtabstop=4：键入的tab宽  
    set shiftwidth=4：缩进的tab宽  
<!-- -->

 * 代码折叠
    * 配置  
set foldmethod=syntax|indent：基于语法折叠  
set nofoldenable：启动vim时不开启折叠
    * 常用命令：
za：切换折叠状态  
zM：折叠所有代码  
zR：取消所有折叠
<!-- -->

 * 基于Tags跳转
    * 配置：
set tags=./.tags;,.tags
    * 操作：
^}：直接本窗口跳转  
^W } ：打开preview窗口跳转  
g]：显示跳转选项

 * 基于Cscope跳转
    * 配置：
cs add ~/Projects/.cscope.out  
set nocst  
set cscopequickfix=  
set csre  
    * 操作
cs find s/g/d/c/a 符号

 * 文件跳转
    * 配置：
set path= ：vim搜寻文件名，\*\*表示递归搜索
    * 操作：
gf ：还可下载URL

<!-- -->
## 初步配置
* 初步配置
 * set nocompatibale ：vi不兼容模式
 * set ignorecase ：搜索时忽略大小写
 * set smartcase：搜索时有大写保证大小写敏感
 * set hlsearch ：搜索高亮
 * set incsearch ：键入搜索时即时跳转
 * set nowrapscan ：搜索到头时不折返回另一头
 * set number ：显示行号，rnu显示相对行号
 * set autochdir：自动改变工作目录
 * set noshowmod ：不显示模式，airline会显示
 * set showcmd ：显示普通模式指令
 * set cmdheight=2 ：底部信息显示需要的行数
 * set ruler ：状态栏显示光标位置
 * set laststatus=2 ：显示状态栏
 * set wildmenu ：命令行模式自动补全
 * set wildignorecase：命令行补全文件名igcase
 * set wrap ：长行回绕到下一行(gj，gk，g0，g$)
 * set linebreak：回绕避免断词
 * set scrolloff=N：保持N行始终在光标之下或之上
 * set whichwrap=<,>,[,] ：使<Left>和<Right>可在普通/插入模式中移动到上行尾,下行首
 * set list ：显示空白符
 * set listchar=tab: eol: ,trail: ：设置空白符符号
 * set backspace=indent,eol,start ：允许插入模式<BS>删除字符处，行首空白符、换行符、进入插入模式之前的字符
 * set showmatch：左括号匹配提示，无则响铃
 * set matchtime= ：左括号匹配提示时间(0.1s)
 * set hidden：自动隐藏缓冲区
 * set virtualedit=block,onemore：光标可出现在无字符的空间(设置all用于制表)
 * set previewheight=16：preview窗口高度
 * set ttimeoutlen=：

<!-- -->
## gvim配置
* gvim配置
 * behave xterm/mswin：鼠标行为模式
 * set guifont=\* ：gvim字体
 * set guioptions-=l/L/r/R：禁止显示滚动条
 * set guicursor=n:block，i:hor10：光标切换
 * set background=dark/light：背景颜色
 * colorscheme 主题：颜色主题

# 简单的vimscript语法
<!-- -->
## 变量
* 变量
 * 变量作用域
    * g:var ： 全局
    * a:var ： 函数参数
    * l:var ： 函数局部变量
    * b:var ： buffer 局部变量
    * w:var ： window 局部变量
    * t:var ： tab 局部变量
    * s:var ： 当前脚本内可见的局部变量
    * v:var ： Vim 预定义的内部变量
 * `$环境变量`，`&选项值`
 * 整数：32为有符型，支持八/十/十六进制
 * 浮点数：支持科学记数法
 * 字符串：
    * NULL结尾，支持转义序列，且有" 与 ' 形式
    * 用 . 连接字符串与变量替换
    * 非零数字开头的字符串会转换为非零子串对应的数值，否则为0
 * 函数引用：大写首字母
 * 有序列表：[00，'10'，[20，21]]
    > 引用：list[0]、list[1]
 * 无序字典：{'key':'value'，}
    > 引用：dict[key1]、dict[key2]

<!-- -->
## 函数
* 函数
 * 调用：
    * :call Func(args)
    * :echo Funcname(args)
    * let Myfunc=function("Func")
    * call(Myfunc，[args])
 * range：
a:firstline，a:lastline
 * dict：
self：将函数引用装入字典，self指代该字典

 * 语句
    * if语句
    * for语句
    * while语句
    * try-catch语句

 * 特性
    * foo_{val}_bar：先计算val后字符替换
