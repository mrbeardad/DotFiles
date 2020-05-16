> * [BASH基础](#bash基础)
> * [特殊字符](#特殊字符)
> * [正则表达式](#正则表达式)
> * [变量](#变量)
> * [BASH脚本](#bash脚本)
> * [流处理](#流处理)

# BASH基础
* bash：
    > 也可通过`set`设置
    * -u            ：不存在变量报错并停止
    * -e            ：出错就停止
    * -o pipefail   ：管道命令中有一个出错也停止，默认管道命令行的返回值为最后一个命令的返回值
    * -x            ：调试
    * -n            ：语法检测
    * -c            ：模拟命令行
<!-- -->

* shell常见快捷键
    * ^A：行首
    * ^E：行尾
    * ^U：删除前面字符
    * ^K：删除后面字符
    * ^W：删除前面单词
    * ^Y：粘贴前面删除
    * ^D：删除光标前的字符，或者触发`EOF`，这也会导致shell退出
    * ^C：结束当前命令(SIGINT)
    * ^Z：暂停当前命令(SIGTSTP)
    * ^L：清屏并重新显示
    * ^R：历史命令反向搜索
    * ^S：历史命令正向搜索
    * ^G：退出当前编辑或搜索
    * ^T：交换前后两个字符
    * ^V：输入字符字面量
    * ^X ^X：光标在当前位置和行首来回跳转 
<!-- -->

* bash内建命令
    * :
    * exit
    * wait
    * sleep
    * exec
    * source
    * history *N*
    * alias/unalias
    * stty size：显示终端size
    * reset：重置因读取二进制文件导致的乱码
<!-- -->

# 特殊字符
* 通配符：
    * `*`       ：任意长度的任意字符
    * `**`      ：递归目录(zsh)
    * `?`       ：一个任意字符
    * `[^ - ]`  ：序列中一个可能的字符
    * `{ , }`   ：序列中的字符展开
    * `{ .. }`  ：序列中的字符展开
<!-- -->

* 括号
    * `(cmd;cmd)`     ：子shell中执行，
    * `{cmd;cmd}`     ：当前shell中执行
    * `[ ]`           ：test命令别名[，最后一个参数为]
    * `[[ ]]`         ：shell关键字，支持=~模糊字符匹配，通配符字符匹配(关闭对文件的通配符扩展)，逻辑运算符
    * `((expr,expr))` ：C风格表达式
<!-- -->

* ~扩展
    * `~` ：家目录
    * `~+`：当前目录
    * `~-`：上次目录
<!-- -->

* !扩展：
    * `!{char}`：上条以*char*开头的命令
    * `!-n`   ：上n条命令
    * `!#`    ：当前命令
    * `!!`    ：上一条命令
    * `!^`    ：上一条命令的第一个单词
    * `!$`    ：上一条命令的最后一个单词
    * `!:n`   ：上一条命令的第n个单词
    * `!:n-$` ：上一条命令的第n个单词到最后一个单词
<!-- -->

* $扩展：
    * `$$`                            ：当前shell的PID
    * `$!`                            ：上次后台进程的进程号
    * `$?`                            ：上次命令返回值
    * `$*`                            ：所有参数(聚合)字符串
    * `$@`                            ：所有参数(分离)数组
    * `$#`                            ：参数个数
    * `$N`                            ：第N个参数，从0开始
    * `$(<file)`                      ：扩展为file文件的内容
    * `$(cmd)`                        ：扩展为cmd的标准输出，同`cmd`
    * `$((expr,expr))、$[expr,expr]`  ：C风格表达式
    * `$'escap'`                      ：输出转义字符
    * `$varname、${varname}`          ：变量扩展
<!-- -->

* 其他特殊符号
    * `空白符`：参数分隔符，**\n**为执行命令行
    * `!`     ：将后面的命令返回结果逻辑非
    * `#`     ：注释
    * 命令间：
        * `;`     ：顺序执行
        * `&&`    ：逻辑与执行
        * `||`    ：逻辑或执行
        * `|`     ：管道才能连接命令成一个进程组
        * `&`     ：后台执行，只能在命令行最后，且对于上述前3个分隔的命令行，只有最后一个命令为后台执行，
        使用(cmd;cmd)与{cmd;cmd}可将其整体放入后台
        > 重定向属于命令尾部(命令的一部分)
<!-- -->

* I/O重定向
    * `< file`    ：重定向标准输入到file
    * `<< EOF`    ：从标准输入读取直到EOF(不含EOF)
    * `<<< string`：将string作用标准输入内容
    * `<(cmd)`    ：将cmd的标准输出的fd作为参数
    * `> file`    ：重定向标准输出到file(截断)
    * `>> file`   ：同上(追加)
    * `1>&2`      ：脚本用echo输出标准错误
    * `2>&1`      ：将标准错误也纳入管道
    * `2> file`   ：重定向标准错误到file
    * `&> file`   ：重定向标准错误与标准输出到file
    * 注：倒数1、2与倒数3、4不能合用
<!-- -->

* 转义字符
    * `\`   ：转义所有特殊字符
    * `" "` ：只保留$扩展、!扩展、" 的功能
    * `' '` ：只保留 ' 的功能
<!-- -->

* test
    * 逻辑运算符：
        * `!`
        * `&&`
        * `||`
    * 字符串比较：
        * `=~` `==` `!=`
        * `<` `>`
        * `\<` `\>`  ：比较长度而非字典序
        * -n：不为空
        * -z：为空
    * 算术比较
        * -eq、-ne、-gt、-ge、-lt、-le
    * 文件判断
        * -e：存在
        * -s：大小不为0
        * -f：普通文件
        * -d：目录
        * -L：符号链接
        * -b：块文件
        * -c：字符文件
        * -S：socket
        * -p：pipe
        * -r：可读
        * -w：可写
        * -x：可执行
        * -u：SUID
        * -g：SGID
        * -k：SBIT
        * -O：onwer为EUID
        * -G：group为EGID
        * -nt：file1比file2新(mtime)
        * -ef：两文件为同一文件的硬连接
<!-- -->

# 正则表达式
* 正则表达式regex
    > 正则表达式的标准并不统一，此处为大多数标准都支持的，具体还得查看使用的正则引擎的文档
    * 零宽断言：
        * `^`           ：行首(零宽)
        * `$`           ：行尾(零宽)
        * `\b`          ：单词边界
        * `\B`          ：非单词边界
        * `(?=pattern)` ：前瞻匹配
        * `(?!pattern)` ：前瞻不匹配
    * 实体模式：
        * `.`           ：除`<CR>`外任意字符
        * `[^ - ]`      ：匹配序列中的一个字符
        * `*`           ：前一个字符匹配0-∞次，`*?`
        * `+`           ：前一个字符匹配1-∞次，`+?`
        * `?`           ：前一个字符匹配0/1次
        * `{n}`         ：前一个字符匹配n次
        * `{n,m}`       ：前一个字符匹配n-m次
        * `{n,}`        ：前一个字符匹配至少n次
        * `(...)`       ：匹配组
        * `...|...`     ：匹配左或右的模式，用`(...|...)`将其限制在局部
        * `\1, ..., \n` ：第n个匹配组
    * 字符类：
        * 数字：\d、\D、[[:digit:]]、[[:xdigit:]]
        * 字母：[[alpha]]、[[upper]]、[[lower]]
        * 空白：\s、\S、[[:space:]]
        * 标签：\w、\W
        * 可视：[[:graph:]]，等同[[:alnum:][:punct:]]
        * 打印：[[:print:]]，等同[[:alnum:][:punct:] ]
        * 所有：[[:alnum:]]、[[:punct:]]、[[:space:]]
    * 转义字符：
        * `\n`  `\r`  `\t`  `\v`  `\f`
        * `\xhh`  `\uhhhh`
<!-- -->

# 变量
* 定义变量
    * var=val
    * array[0]=valA
    * array=([0]=valA [1]=valB [2]=valC)
    * array=(valA valB valC)
* 读取变量
    * $#var                     ：字符串长度
    * $+var                     ：变量存在为1，否则为0
    * ${array[i]}               ：取得数组中的元素
    * ${array[@]}               ：取得数组中所有元素
    * ${#array[@]}              ：取得数组的长度
    * ${#array[i]}              ：取得数组中某个变量的长度
    * ${varname:-word}          ：若不为空则返回变量，否则返回 word
    * ${varname:=word}          ：若不为空则返回变量，否则赋值成 word 并返回
    * ${varname:?message}       ：若不为空则返回变量，否则打印错误信息并退出
    * ${varname:+word}          ：若不为空则返回 word，否则返回 null
    * ${varname:offset:len}     ：取得字符串的子字符串
* 修改变量
    * ${variable#pattern}       ： 如果变量头部匹配 pattern，则删除最小匹配部分返回剩下的
    * ${variable##pattern}      ： 如果变量头部匹配 pattern，则删除最大匹配部分返回剩下的
    * ${variable%pattern}       ： 如果变量尾部匹配 pattern，则删除最小匹配部分返回剩下的
    * ${variable%%pattern}      ： 如果变量尾部匹配 pattern，则删除最大匹配部分返回剩下的
    * ${variable/pattern/str}   ： 将变量中第一个匹配 pattern 的替换成 str，并返回
    * ${variable//pattern/str}  ： 将变量中所有匹配 pattern 的地方替换成 str 并返回
> 注：zsh中数组下标从1开始，且无需${arr[i]}中的花括号  
> 注：shell变量默认都是字符串  
> 注：字符串变量所有空白符等特殊字符，使用时应该用双引号包含
<!-- -->

* env
* export
* declare
    * -r：设置变量为只读，+r取消
    * -p：查看变量
* shell环境变量
    * HOME
    * USER
    * LOGNAME
    * UID、EUID、GID、EGID
    * PATH
    * MAIL
    * PWD
    * SHELL
    * TERM
    * HISTSIZE
    * HOSTNAME：zsh中为HOST
    * RANDOM：0 ~ 32767
    * FUNCNAME
    * LINENO
<!-- -->

# BASH脚本
* 函数
    * 定义
    ```bash
    function  funcname()
    {
        statements
        return val
    }
    ```
    * 调用
    ```bash
        funcname  arg1  arg2
    ```
<!-- -->

* 语句
    * 分支
    ```bash
        if cmd ;then
            statement
        elif [[ test ]] ;then
            statement
        else
            statement
        fi
    ```
    * 循环
    ```bash
    for i in List ;do
        statement
    done

    for (( ; ; )) ;do
        statement
    done

    while cmd ;do
        statement
    done

    until [[ test ]] ;do
        statement
    done
    ```
    * 选择
    ```bash
    select i in List ;do
        statement
    done
    # 输出PS3，死循环选择，一般嵌套case语句，选择数字并将对应List中字符串赋值给i
    ```
    * 多分支
    ```bash
    case $i in
    v1)     statement ;&
    v2|v3)  statement ;|
    *)      statement ;;
    esac
    ```
    * 控制跳转
        * continue
        * break
<!-- -->

# 流处理
* eval var1=\$$var2
    > eval为关键字，整个表达式会替换成最终的${$val}
<!-- -->

* getopts optstring name [args]
    > 选项应该在命令参数之前：`$ cmd <options>... <parameters>...`  
    > 遇到<parameter>时结束(即不以`-`开头又不是某个选项的参数)，不管后面还有没有参数
    * optstring
        * "xy:"     ：表示识别选项`-x`与`-y`，且后者需要一个参数
        * ":xy"     ：第一个`:`表示开启silent-mode，即不自动打印错误，与设置OPTERR=0等同
    * print-mode
        * name      ：存储*optstring*中的选项，无效则为`?`
            > 无效参数：选项字符不在*optstring*中，或本该需要参数的选项却没有参数
        * OPTARG    ：存储当前选项的参数，无则为`空`
        * OPTIND    ：存储下一次getopts应该要解析的*参数*索引，即脚本的$1, $2, ...
    * silent-mode
        * name      ：存储*optstring*中的选项，不存在于*optstring*则为`?`，需参选项无参则为`:`
        * OPTARG    ：存储当前选项的参数，无则为`空`；name为`?`或`:`时存储该选项
        * OPTIND    ：同上
<!-- -->

* read  *VAR*
    * -p：提示符
    * -t：限时
    * -n：读取字符数
    * -s：关闭回显
<!-- -->

* trap
    * `cmd sig1 sig2`：在脚本中设置信号处理命令
    * `"" sig1 sig2` ：在脚本中屏蔽某信号
    * `- sig1 sig2`  ：恢复默认信号处理行为
<!-- -->

* xargs  CMD
    > 原理：将管道中的字符串的分隔符替换为空格后，作为CMD的参数
    * -0：保留空白符不被替换，空白符前有\时也会保留
    * -e：直到遇到此单词停止
    * -p：每个单词都提醒用户
    * -n：一次给予多少个参数
<!-- -->

* tee  *FILE*
    * -a：追加而非截断
<!-- -->

* sort
    * -f：忽略大小写
    * -b：忽略行前空白
    * -M：月份名称排序
    * -n：数值排序
    * -r：反向排位(降序)
    * -u：删除相同行
    * -t：指定分隔符
    * -k n,m：指定比较第n-m域
    > field定义：blank开始到non-blank尾结束，从行首到分割符算1
<!-- -->

* uniq
    * -i：忽略大小写
    * -c：计数
    * -f：指定从哪个域开始比较(从0开始)
<!-- -->

* join  -1 N1 FILE1 -2 N2 FILE2
    > N1、N2：指定两文件比较的域
    > FILE1或FILE2可以为-，代表此文件从管道读取
    * -i：忽略大小写
    * -t：指定分隔符
<!-- -->

* paste *FILE1*  *FILE2*
    * -t：指定分隔符
<!-- -->

* cut
    * -d：指定分隔符
    * -f：指定截取的域，可使用逗号与减号
    * -c n-m：指定取出第n-m个字符
<!-- -->

* wc
    * -l：行数
    * -w：单词数
    * -m：字符数
<!-- -->

* grep
    * -E：扩展正则表达式
    * -A：显示之后几行
    * -B：显示之前几行
    * -C：显示之前和之后几行
    * -i：忽略大小写
    * -n：显示行号
    * -c：计数
    * -v：反向，显示不匹配的
    * -q：静默模式
<!-- -->

* awk
    * -F    ：分隔符，支持[]正则
    * -f    ：读取脚本文件
    * -v  var=val
    * 例：
    ```bash
    awk '模式{语句块;} 模式{语句块;}' FILE
    ```
    * 模式：
        * BEGIN
        * END
        * /pattern/
        * !/pattern/
        * /pattern1/&&/pattern2/
        * /pattern1/||/pattern2/
        * $N~/pattern/
        * 关系表达式
    * 变量：C风格变量
        * 定义：
        ```awk
        var=val
        arr[i]=val
        map[key]=val
        ```
        * 内置变量
            * ARGC
            * ARGV
            * RS        ：行分隔符(默认`<CR>`)
            * FS        ：字段分隔符(默认`<Space>`)
            * ORS       ：输出的行分隔符(默认`<CR>`)
            * OFS       ：输出的字段分隔符(默认`,`)
            * NR        ：总行数
            * FNR       ：在当前文件中的行数
            * NF        ：字段数
            * OFMT      ：数字输出格式(默认%.6g)
            * IGNORECASE：为true则忽略大小写
            * $N        ：第N个字段，0为整行
    * 运算符
        * `+` `-` `*` `/` `%`
        * `^`         ：求幂
        * `~`         ：模糊匹配
        * `~!`        ：模糊不匹配
        * `空格`      ：字符连接
        * `in`        ：确认数组键值
        * `|`         ：管道
    * 关键字
        * `print var1,var2"str"`  ：逗号替换为OFS，默认带\n
        * `printf "$1:%s\n",$1`   ：类似C中的printf()函数
        > 注意：`>`与`>>`可在这两个关键字最后作重定向，若需要关系运算，应该用圆括号包围
        * `next`                  ：读取下一行并回到脚本开始处重新执行
        * `delete`                ：删除数组元素
        * `break`
        * `continue`
        * `getline`
        * `"cmd" | getline var`   ：若不加变量则直接赋值给$0
        * `getline var < "file"`  ：同上
    * 语句
        * C风格语句
        * for( i in arr )
    * 函数
        * srand(); rand()
            > 前者默认以时间作种，后者返回0-1的浮点数
        * length(string); length(array)
            > 检查字符串与数组的长度
        * sub(/pattern/, "string", var); gsub(...)
            > 将var中匹配的pattern替换为string，后者全部替换
        * index(var, "string")
            > string在var中出现的位置(1开始)，无则返回0
        * substr(var, pos, length)
            > 截取子串，从pos开始的length个字符(1开始)，无length则到结尾
        * tolower(s); toupper(s)
    * 注意
        * 变量无需声明，初值为空，参与运算时置0；
        * 数组下标从1开始；
        * 数组键值为字符串时需引号，否则键值in替换当做变量
        * 参与运算时数组下标自动建立，故检查下标是否存在用in；
        * 关系运算符要两边都是数字才进行数值比较；
<!-- -->

* sed
    * -f：指定脚本文件
    * -i：修改原文件
    * -n：仅显示处理结果，只有a i c r p操作才输出
    * -r：支持扩展正则表达式
    * 例：
    ```bash
    sed '模式{语句块;}; 模式{语句块;}' FILE
    sed -e '模式 语句块' -e '模式 语句块' FILE
    ```
    * 模式
        * /pattern/
            > 支持\<与\>元字符  
            > 支持/pattern/I忽略大小写
        * !/pattern/
        * n,m
        * /pattern/,m
    * 语句块
        * 块内操作用分号分隔，块间也需要分号分隔
        * a; i; c; r; w;操作只能单独存在，不能在块中，故它们只能用`-e`选项
    * 替换模式：
        * 支持转义字符
        * &代表match，\N代表match[N]
        * 替换标记：无g全部，Ng第N个
    * 操作
        * a与i：行后与行前添加字符串
        * c：会把所有匹配行转换成只有一个字符串
        * s/pattern/replace/g
        * d：删除匹配行
        * r/w file：读取file到行后，写入匹配行到file
        * n：跳转到下一行，执行后续操作
        * =：行前打印行号
        * q：退出
        * N：读取下一行至模板块，形成多行组，并将行号改为新加行的行号
        * P/D操作：分别用于多行组，打印与删除第一行
        * h：拷贝模板块到缓冲区(模板块即当前处理的行)
        * H：追加模板块到缓冲区
        * g：获得内存缓冲区的内容替代当前行
        * G：获得内存缓冲区的内容追加到当前行后
<!-- -->

