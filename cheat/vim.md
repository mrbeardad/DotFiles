# SpaceVim定制版
* 界面与工具
    * `<F1>`        ：开关标签栏
    * `<F3>`        ：开关文件树
    * `<F5>`        ：开关撤销树
    * `<leader>q`   ：quickfix窗口操作前缀
    * `<space>ac`   ：计算器
    * `<space>al`   ：日历
    * `<space>bt`   ：从当前文件所在目录打开文件树
    * `<space>as`   ：Startify
    * `<space>wc`   ：阅读模式
* 制表与对齐
    * `<leader>tt`      ：快速自动制表
    * `<leader>tm`      ：切换制表模式
    * `<space>xa{char}` ：根据{char}对齐
    * `<space>xao`      ：根据运算符对齐
    * `<space>xj{c|l|r}`：居中|左|右对齐该段落
* 代码注释
    * `<space>cl`       ：切换该行注释状态
    * `<space>cL`       ：注释该行
    * `<space>cp`       ：切换该段落注释状态
    * `<space>cP`       ：注释该段落
* 补全与结对符
    * `<s-tab>`         ：ycm补全，不用`<cr>`因为与auto-pair冲突，不然在c++初始化器`{}`中按`<cr>`会被auto-pair当作函数体然后换行
    * `<m-\>`           ：ultisnips补全，`<M-M>`下一个，`<M-B>`上一个
    * `<m-e>`           ：auto-pair快速包围
    > 以下为[surround](https://github.com/tpope/vim-surround)，后接结对符，右括号不加空格
    * `cs`              ：改变surround
    * `ds`              ：删除surround
    * `ys`              ：添加surround
    * `yss`             ：添加surround，默认本行
* 其他编辑
    * `[e`              ：将该行上移
    * `]e`              ：将该行下移
    * `[<space>`        ：上方添加空行
    * `]<space>`        ：下方添加空行
    * `<space>xc`       ：计算选中区域字符数
    * `<space>xdw`      ：删除后缀空白符
    * `+或-`            ：加或减当前数字
    * `<space>fC`       ：转换文件格式
    * `<leader>m`       ：快速编辑宏(连按两次)
* g命令
    * `g,与g;`          ：新/旧更改表
    * `g+与g-`          ：新/旧撤销树
    * `g&`              ：重复上次:s更新
    * `gv`              ：重复上次可视选择
    * `g<c-g>`          ：光标位置
    * `g<`              ：上次命令输出
    * `g=`              ：格式化
    * `gd`              ：跳转定义
    * `ga`              ：查看ascii字符编码或unicode码点
    * `g8`              ：查看utf-8字符编码
    * `gm`              ：光标到屏幕中间
* z命令
    * `zs`              ：光标列移至屏幕左边
    * `zz`              ：光标行重绘至屏幕中央
    * `z<cr>`           ：光标行重绘至屏幕顶
    * `zb`              ：光标行重绘至屏幕底
    * `z<up>`           ：屏幕上移一行
    * `z<down>`         ：屏幕下移一行
    * `z<left>`         ：屏幕左移半屏
    * `z<right>`        ：屏幕右移半屏
    * `zF`              ：手动折叠N行
    * `za与zA`          ：切换折叠
    * `zc与zC`          ：关闭折叠
    * `zo与zO`          ：打开折叠
    * `zj与zJ`          ：下一个折叠
    * `zk与zK`          ：上一个折叠
    * `zR`              ：最高折叠级别
    * `zM`              ：最低折叠级别
    * `z=`              ：拼写建议
    * `zg与zG`          ：标记单词为good
    * `zw与zW`          ：标记单词为wrong
* Toggle命令
    * `<leader>l`       ：切换linebreak
    * `<leader>w`       ：切换wrap
    * `<leader>v`       ：切换virtualedit
    * `<leader>e`       ：切换expandtab
    * `<leader>s`       ：切换spell
    * `<leader>F`       ：切换foldmethod
* Git
    * `<space>gs`       ：git status
    * `<space>gd`       ：git diff
    * `<space>gV`       ：当前文件的git-log
    * `<space>gv`       ：当前仓库的git-log
    * `<space>gg`       ：GitGutterToggle
    * `<space>ghr`      ：undo cursor hunk
    * `<space>ghv`      ：preview cursor hunk
* EasyMotion
    * `<space>jw`       ：跳转至某单词
    * `<space>jl`       ：跳转至某行
    * `<space>ju`       ：跳转至某URL
    * `f{char}{char}`   ：跳转至指定字符处
* OpenBrowser搜索
    * `gsb`             ：baidu搜索引擎
    * `gsg`             ：google搜索引擎
    * `gsi`             ：iciba翻译
    * `gss`             ：智能搜索
* FlyGrep搜索
    * `<space>ss`       ：搜索当前缓冲区
    * `<space>sb`       ：搜索所有缓冲区
    * `<space>sd`       ：搜索当前目录
    * `<space>sf`       ：搜索指定目录
    * `<space>sp`       ：搜索工程目录
    > 注：以上模式搜索尾缀大写即快速搜索光标单词
    * `<space>sj`       ：后台搜索工程目录
    * `<space>lt`       ：打开上次后台搜索结果
* LeaderF搜索
    * `<leader>fr`      ：重置上次搜索
    * `<leader>f<space>`：搜索快捷键并执行
    * `<leader>fp`      ：搜索插件信息
    * `<leader>fh`      ：搜索vim帮助文档
    * `<leader>fq`      ：搜索quickfix
    * `<leader>fl`      ：搜索locationlist
    * `<leader>fm`      ：搜索vim的输出信息并复制
    * `<leader>fu`      ：搜索unicode并插入
    * `<leader>fj`      ：搜索跳转表并跳转
    * `<leader>fy`      ：搜索"寄存器历史并复制
    * `<leader>fe`      ：搜索所有寄存器并复制
    * `<leader>ff`      ：搜索函数(尾缀F全局)
    * `<leader>ft`      ：搜寻符号(尾缀T全局)
    * `<leader>fg`      ：利用gtags搜寻标识符
    * `<leader>fb`      ：搜索打开的缓冲区
    * `<leader>for`     ：搜索最近打开文件
    * `<leader>fod`     ：搜索当前目录文件
    * `<leader>fof`     ：搜索指定目录
    * `<leader>fop`     ：搜索当时工程目录文件
    * `gD`              ：跳转gtags定义
    * `gR`              ：跳转gtags引用
    * `gS`              ：跳转gtags无定义引用
* YCM
    * `go`              ：跳转定义或声明
    * `gr`              ：跳转引用
    * `gt`              ：获取对象类型
    * `gc`              ：重构对象
* ALE
    * `<space>en`       ：跳转下一个语法检测提示
    * `<space>eb`       ：跳转上一个语法检测提示
    * `<space>el`       ：打开语法检测提示列表
    * `<space>ed`       ：打开语法检测提示详情
* BookMark
    * `<space>mm`       ：切换标签状态
    * `<space>mi`       ：为标签添加注释
    * `<space>mn`       ：跳转至下一个标签
    * `<space>mb`       ：跳转至上一个标签
    * `<space>ma`       ：列出所有标签
* Defx
    * `<left>`          ：关闭目录
    * `<right>`         ：展开目录
    * `p`               ：预览文件，利用Guake与ranger
    * `f`               ：搜索文件，利用Leaderf搜索光标位置的目录
    * `yy`              ：复制文件路径
    * `yY`              ：复制文件内容
    * `K`               ：新建目录
    * `N`               ：新建文件
* lang#c
    * `<space>lr`       ：快速运行程序
    * `<space>li`       ：快速打开输入窗口
    * `<space>lt`       ：关闭运行程序的终端
    * `<space>ld`       ：只编译用于gdb调试
    * `<space>lc`       ：clang优化编译
* lang#markdown
    * `<space>lp`       ：开启markdown预览

# 基础概念
> 参考：[vim-galore-zh_cn](https://github.com/wsdjeg/vim-galore-zh_cn)  [ VIM中文文档 ](https://yianwillis.github.io/vimcdoc/doc/help.html)
* `窗口`：
    * 设置窗口：  
    所有窗口等高等宽：`<c-w>=`  
    减少/增加高度   ：`<c-w>-`/`<c-w>+`  
    减少/增加宽度   ：`<c-w><`/`<c-w>>`  
    设置高度/宽度   ：{高}`<c-w>_`/`{宽}<c-w>|`  
    * 操作窗口：
    `<c-w>c`：:close  
    `<c-w>o`：:only  
    `<c-w>s`：:sp  
    `<c-w>v`：:vs  
    * 扩展  
    `<space>{numr}` ：切换至第{numr}号窗口  
    `<tab>`         ：切换至下个窗口  
    `<s-tab>`       ：切换至上一次的窗口  
    `<c-right>`
    `<c-left>`
    `<c-up>`
    `<c-down>`      ：切换至指定方向上的窗口  
    `<C-L>`         ：刷新statusline
* `标签页`：
    * 常用命令  
    :tabe，:tabn，:tabp，:tabd  
    * 扩展  
    `[t`
    `]t`    ：切换至上/下一个tab
* `缓冲区`：
    * 类型概念  
    已激活、已列出、已载入、未命名  
    * 查看：:ls  
    %当前 / #轮换  
    a激活 / h隐藏/u未列  
    =只读 / +已更改  
    * 常用命令  
    :ene，:e，:bd，:qa，:wa，:wqa，:saveas  
    * 参数列表  
    :args，:arga，:argd，:argdo  
    * 扩展  
    `<leader>n`
    `<leader>b`         ：下/上个buffer  
    `<leader>{numr}`    ：第{numr}个buffer  
    `<c-s>`             ：保存buffer至硬盘  
    `<c-w>x`            ：安全删除该buffer
    `<c-w>X`            ：安全删除所有未激活buffer
    `<c-w>W`            ：sudo写入文件
    `<space>bY`         ：复制buffer至系统clipboard
    `<space>bP`         ：粘贴系统clipboard至整个buffer(覆盖原来的内容)
    `<space>bN`         ：新建空白buffer快捷键前缀
>

* 插入模式
    * 进入： i，a，I，A，o，O
    * 操作：  
    `<c-o>`     ：暂入普通模式  
    `<c-r>{reg}`：粘贴寄存器  
    `<c-c>`     ：退出插入模式且避免触发InsertLeave
    * 扩展
    `<c-a>`  `<c-e>`  
    `<c-d>`  `<c-b>`  
    `<c-u>`  `<c-k>`  
    `<c-w>`  `<c-y>`  
    `<c-]>`  
    `<c-o>`
* 可视模式：
    * 进入：
    v，V，`<c-v>`  
    * 移动：  
    o：到对角线端点  
    O：块选取模式下，到同行的另一个端点  
    * 全行插入：
    I/A：块选取模式下，插入到选取块的左/右  
    * 扩展
    `<leader>`y  
    `<leader>`p  
* 替换模式
    * 进入： R
    * 退出： `<Esc>`
    * 特殊： r
* 命令模式
    * 进入：:
    * 外部命令：!cmd
        > 利用:r与:w，将外部命令I/O重定向到该缓冲区  
    * 外部过滤：{范围}!cmd
        > 将外部命令的I/O同时重定向到目标指定区域  
    * 常用命令
        * `:g/pat/cmd`      ：:g!表示不匹配的行，默认范围%  
        * `:s/pat/rel/flag` ：默认范围.  
            > s_flags       ：e不报错，g全替换，i忽略大小写    
        * `:r/w`            ：范围表示read到范围行后，write指定范围  
        * `:X`              ：设置密码，为空解除  
        * `:profile`        ：调试  
* 普通模式
    * 复合操作：
    d，c，y  
    * 光标移动：
    0，^，$，w，W，b，B，e，f，F，%，)，}，gg，G  
    * 文本对象：前缀(i|a)  
    w，s，p，(，{，[，<，"，'，`  
    扩展：e，l，i，f，,  
    * 删除：
    x，s，D，C，dd，S
    * 其他：
    ~，gu，gU，p，P，J，u，`<c-r>`
    * 换页：
    ^F，^D，^E，^B，^U，^Y
    * 扩展：  
    复制：Y，`<c-y>，<leader>`y，,  
    粘贴：`<leader>p，<leader>`P  
>

* 范围
    * 先输入数字后再键入:冒号
    * %：整个文件
    * 0：第一行行前
    * $：最后一行
    *  .：当前行
    *  -/+n：当前行前/后n行
    *  'm：标签行
    * /^foo/+1：模式匹配行
    * /foo//bar//quux/：多次模式匹配行
    * ?^$?+1：前向匹配行
<!-- -->

* 寄存器
    * 查看：:reg
    * 使用：" + □ + y/p
    * 寄存器：
    用户：a-z和A-Z（大写用来向寄存器添加）  
    系统：*(选择区) 和 +(剪切板)  
    只读：%文件、. 修改、: 命令、/搜索  
    数字：0为最近一次复制，1-9最近1-9次删除  
<!-- -->

* 宏录制
    * 录制：q+□+操作+q
    * 使用：@+□，@@
    * 特殊：. 执行上次的单次修改操作
<!-- -->

* 标记与跳转
    * 查看：:marks 与 :jumps
    * 标记：m + 字母
    * 跳转：' + 标记
    * 标记：
    用户：字母（大写全局）  
    上次跳转：'  
    上次修改：.  
    上次修改或复制：[或]  
    上次插入：^  
    上次关闭："  
    返回较旧跳转：`<c-o>`（全局）  
    返回较新跳转：`<c-i>`（全局）  
        > `<c-i`有bug，设为`<c-p>`
<!-- -->

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

# runtimepath目录结构
* 查看配置加载：:scriptnames
* :filetype plugin indent on
    * 加载filetype.vim与script.vim：/ftdetect/*.vim
    * 加载ftplugin.vim：/ftplugin/
    * 加载indent.vim：/indent/*.vim
* :syntax enable，:syntax on
    * 加载/syntax/*.vim
* :set loadplugins
    * 加载/plugin/*.vim
* :set packpath=，:packadd，:helptags doc/
    * /pack/foo/start/bar/类vim目录/
    * /pack/foo/opt/bar/类vim目录/
* `/autoload/*.vim`
    > 存放自动载入的函数，调用时使用  
    > :call dirname(#.*)*#filename#funcname()
* /ftplugin/
    > `<filetype>.vim`  
    > `<filetype>_<name>.vim`  
    > `<filetype>/<name>.vim`

<!-- -->

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

> 从这开始，，，，，不想整理了:joy:
* 快速查找
    * *和#：当前单词，前向和后向
    * g*和g#：
    * /和?：正向和反向正则匹配
    * K：快速查找help
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

## 初步配置
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

## gvim配置
* behave xterm/mswin：鼠标行为模式
* set guifont=* ：gvim字体
* set guioptions-=l/L/r/R：禁止显示滚动条
* set guicursor=n:block，i:hor10：光标切换
* set background=dark/light：背景颜色
* colorscheme 主题：颜色主题

* 变量
    * 变量作用域
g:var - 全局
a:var - 函数参数
l:var - 函数局部变量
b:var - buffer 局部变量
w:var - window 局部变量
t:var   - tab 局部变量
s:var - 当前脚本内可见的局部变量
v:var - Vim 预定义的内部变量
    * $环境变量，&选项值
    * 整数：32为有符型，支持八/十/十六进制
    * 浮点数：支持科学记数法
    * 字符串：
NULL结尾，支持转义序列，且有" 与 ' 形式
用 . 连接字符串与变量替换
非零数字开头会转换为非零子串对应的数值，否则为0
    * 函数引用：大写首字母
    * 有序列表：[00，'10'，[20，21]]
    * 无序字典：{'key':'value'，}

* 函数
    * 调用：
:call Func(args)
:echo Funcname(args)
let My=function("Func")，call(Myfunc，[])
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
