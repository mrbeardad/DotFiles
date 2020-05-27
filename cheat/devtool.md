* gcc
    * 优化级别          ：-O1  -O2  -O3
    * 编译程度          ：-E(.i)  -S(.s)  -c(.o)  -o
    * 指定标准          ：-std=c11
    * 使用AVX指令       ：-mavx2
    * 并发库            ：-lpthread
    * 制作动态库        ：-shared  -fpic
    * 调用链接器        ：-rdynamic  -ldl
    * 链接库打桩        ：-Wl,--wrap,func
    * 定义宏            ：-Dmacros_define
    * 指定inclide目录   ：-I
    * 指定lib目录       ：-L -lxxx（库名省略lib、.a、.so）
    * GPROF剖析         ：-pg（最好也加下述参数）
    * 调试              ：-Og  -g3  -fno-inline
    * 指定机器          ：-m32  -m64
    * 指定程序规模      ：-mcmodel= medium | large
        > 代码数据段默认32位跳转
    * 开启标准库debug模式：-D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC
    * 报错： -Werror  -Wall  -Wextra -Wconversion -Wfloat-equal
<!-- -->

* gdb  *exec-file* *core-dump* *PID*
    * coredump设置
        ```bash
        $ ulimit -c unlimited
        $ echo '/path/to/coredir/core.%e.%p' | sudo tee /proc/sys/kernel/core_pattern
        ```
    * 断点：
        * b/break     ：`func`，`linenum`，`if CONDITION`
        * tb/tbreak   ：`func`，`linenum`
        * condition   ：`break-id expr`
        * w/watch     ：`expr`
        * catch       ：`syscall|signal|exception`
        * d/delete    ：`break-id`
        * ignore      ：`break-id N`
        * disable     ：`break-id`
        * enable      ：`break-id`
        * i b
        * save b FILE
        * source FILE
    * 运行：
        * set|show    ：`args|path|env`
        * r/run       ：`shell-like-cmd`
        * c/continue
        * k/kill
        * q/quit
    * 跟踪：
        * s/step      ：`N`
        * n/next      ：`N`
        * u/until     ：`line-num`
        * f/finish
        * return      ：`ret-val`
        * bt
        * frame
    * 打印：
        * i locals
        * p/print     ：`val`，`expr`，`"%s",addr`
        * whatis      ：`value`
        * display     ：每次单步后打印变量
    * 代码：
        * la/layout   ：src|asm|reg|sp
        * l/list      ：`lineno`，`funcname`
        * update
        * search      ：{regexpr}
        * reverse-search ：{regexp}
    * 调试子进程：
        * set follow-fork-mode child
    * 调试多线程：
        * i thread
        * thread <thread-num>
<!-- -->

* cgdb
    * `i`：进入GDB模式
    * `Esc`：进入CGDB模式
    * `s`：进入滚动模式，可以滚动GDB窗口，`i`退出
    * `<space>`：切换设置断点
    * `o`：打开文件
<!--  -->
```bash
* lldb <exe> [-c <core>] [-p <pid>]
    > lldb现在确实没有gdb好用
    * 断点：
        b：<查看>  <linenum>  <function>  0x<address>  <filename>:<linenum>  <module>`<function>  /regex/
        br：disable|enable|delete|read|write
        w：set var <var>
        w：modify -c '<condition>'
    * 设置：
        env：<查看>  <env-var>=<value>
        settings： set|show  target.run-args|target.run-input-path|target.run-output-path
    * 运行：
        r：<以/bin/sh的语法格式启动程序>
        c：
        s：[-e <linenum>]
        n：
        j：0x<address>
        finish：
        kill：
        q：
    * 调试：
        p：打印
        e：赋值
        l：源码
        bt：调用栈
        f：[framenum]
        thread info
        t [threadnum]
        dis：反汇编
        reg：寄存器
```
<!-- -->

* ar：
    * r：替换，d：删除，t：显示
    * c：创建，s：符号，u：更新，v：详述
    * 创建：rscv
    * 显示：tv
    * 追加：rsv
    * 更新：rsuv
    * 删除：dsv
    * 提取：xv
    > 注：BSD风格：`cmd  opts  lib.a  a.o`
<!-- -->

* objdump -dx
* readelf
* gprof
* ldd -V
* strace
* pmap
<!-- -->

* tmux
    * tl    ：`tmux list-session`
    * ts    ：`tmux new-session -s <session-name>`
    * ta    ：`tmux attach -t <session-name>`
    * tad   ：`tmux attach -d -t <session-name>`
    * tkss  ：`tmux kill-session -t <session-name>`
    * tksv  ：`tmux kill-server`
    * -S socketfile
    * -S socketfile attach
    * 快捷键： `Alt`+`w` 为快捷键前缀
        * meta操作：
            * `R`：重载配置
            * `:`：命令模式
        * pane操作：
            * `s`：水平切分panes
            * `v`：竖直切分panes
            * `x`：关闭当前pane
            * `z`：最大化该pane或恢复大小
            * `方向键`：跳转到该方向的pane
            * `q`：选择一个pane
            * `Ctrl`+`o`：交换pane
            * `!`：新窗口打开该pane
        * window操作：
            * `b`：上一个window
            * `n`：下一个window
        * session操作：
            * `d`：卸离会话(可通过`tmux a -t session-name`重新恢复)
            * `w`：预览整个会话窗口
            * `Ctrl`+`S`：保存会话到磁盘文件
            * `Ctrl`+`R`：从磁盘文件恢复会话
        * 其他操作：
            * `h`：打开htop
            * `r`：打开ranger
            * `n`：打开ncdu
<!-- -->

* SSH
    * `ssh -p Port User@Host`
    * `ssh-keygen -t ecdsa -b 512 -C "注释"`
        > 交互时可添加密码短语对私钥加密，每次用时需输入密码短语
    * `ssh-keygen -f ~/.ssh/id_ecdsa -p`
        > 更改密码短语
    * `ssh-copy-id -i KEY.pub -p port user@host`
<!-- -->

* *ssh_config*
    > 配置一次连接所需要的信息  
    > Host  
    > HostName  
    > Port  
    > User  
    > IdentitiesOnly  
    > IdentityFile
* *sshd_config*
    > 改port  
    > 限root  
    > 强pub  
<!-- -->

# git概念
* 管理目录
    > 工作区`W`相对暂存区`S`：untraced，deleted，rename，modified  
    > 暂存区`S`相对仓库区`R`：traced，new，deleted，rename，modified  
    > 仓库区`R`             ：各种对象  
    > 注：不管git底层是如何实现的，我们需要知道git给我们的抽象模型是每次提交历史都是**全量备份**的，这一点很重要
* 基本操作
    * 初始化仓库    ：`git init`
    * 跟踪文件      ：`git add`
    * `W->S`暂存`W` ：`git add|rm|mv|`
    * `S->W`撤销`S` ：`git restore`
    * `R->S`撤销`S` ：`git restore --staged`
    * `W|S->R`提交  ：`git commit`
    * `R->RR`推送   ：`git push`
* 分支模型
    * 分支指针：
        > 分支指针指向某个**commit**
        * HEAD          ：指向本地当前分支
        * branch        ：指向本地已存在的分支
        * remote/branch ：指向远程仓库的分支
            > 远程分支只读，通过创建本地分支来跟踪并修改
    * commit信息：
        * 作者、提交者、日期、校验、描述、父指针、"快照"
            > 父指针指向上次**commit**，可能有多个
    * tree对象：
        > 为每个commit管理"快照"，指向各个data对象
    * data对象：
        > 这就是每个文件的每次历史的数据文件实体，每次提交其实并不会备份未改动的文件，
        > 由tree对象负责指向那个未改动的文件，而只要一个文件改动的，就会被全量备份而创建一个新的data对象  
        > 注：其实git会在每次push时整理data对象，将一些小改动改为增量备份而非全量备份

![图片来自网络](../images/git-branch.png)

* 工作流程
    * 贡献者
        * 将目标项目仓库fork到自己的远程仓库
        * 从自己站点clone项目到本地进行线下开发修改
        * 本地master分支跟踪origin/master
        * 设置upstream/master连接项目发布点
        * 完成后push到自己的公开站点
        * 向发布点发送pull request
        * 若冲突则拉取upstream再合并、修改、推送
    * 维护者
        * 若贡献者提交的PR没有问题，则直接合并即可
        * 若有问题且需要自己修改，则：
            * 添加贡献者的仓库到remote并fetch到本地
            * 若贡献太多，则配置remote仓库的[refs](#refs)
            * 审查、修改、合并后push到项目发布点
<!-- -->

* git config
    * git config --system
        > /etc/gitconfig
    * git config --global
        > ~/.gitconfig
    * git config --local
        > ~/.git/config
    * 选项
        * user.name
        * user.email
        * core.editor
        * credential.helper cache ：托管私钥的密码短语
        * core.excludesfile ~/.gitignore
    * 配置<span id="refs">refs</span>
    
    ```toml
    [remote "RPO"]
    url = URL
    fetch = +refs/heads/*:refs/remote/origin/*
    fetch = +refs/pull/*/head:refs/remote/origin/pr/*
    ```
<!-- -->

* .gitignore
    * `#`作为注释符号
    * 可以使用标准的`global模式`匹配
    * 以`/`开头防止递归
    * 以`/`结尾指定目录
    * 以`!`开头**取消之前已被忽略的文件**
        > 注：若该文件的父目录已被忽略，则无效  
<!-- -->

* .gitmodules
    * 引用一个项目作为该项目的子模块，以子目录的形式存在
    * git并不会展示子模块的信息，进入子模块的目录后便相当于进入一个独立的新项目
    * 提交时git会记录每个引用子模块的检出的HEAD，故需要手动更新子模块而非由git自动拉取上游更新

* .git目录
    * description：gitweb程序使用
    * config：仓库配置
    * objects：所有对象(数据、树、提交、标签)
    * HEAD：当前checkout的指针
    * index：暂存区
    * refs/：指向分支的提交对象的指针
        * refs/heads/       ：本地分支引用
        * refs/tags/        ：本地标签引用
        * refs/remote/RR/   ：远程仓库的分支引用
<!-- -->

* git add
    * ga    ：更新`W->S`
    * gaa   ：更新所有管理目录下为被忽略的文件
<!-- -->

* git rm
    * grm   ：删除文件并更新`W->S`
<!-- -->

* git mv
    * gmv   ：移动文件并更新`W->S`
    > 注：若通过`mv`来移动文件，git会将其当作删除一个文件又新建一个文件
<!-- -->

* git restore *Path*
    * grs   ：撤销W
    * grst  ：撤销S
* git reset *Commit*
    * grh   ：撤销commit历史
    * grhh  ：完全撤销，不保留撤销commit的改动
    > 通过reset可以后移分支指针，merge可以前移
<!-- -->

* git status
    * gst   ：查看`W`与`S`状态
    * gss   ：左`W`右`S`
<!-- -->

* git diff
    * gd    ：查看`W-S`的diff
    * gds   ：查看`S-R`的diff
    * gdt   ：利用vim查看gd
    * gdts  ：利用vim查看gds
    * gdi   ：精简的展示diff
    * 例：
    ```
    [<path>]                    ：比较W-S或S-H
    <commit> [<path>]           ：比较W-C或S-C
    <commit> <commit> [<path>]  ：比较C-C
    ```
<!-- -->

* git commit
    * gc
    * gc!
    * gca
    * gca!
    > 注：  
    > `a`代表直接W->H提交  
    > `!`代表覆盖上次提交
<!-- -->

* git tag
    * gt
    * gtl
    * gtv
    * gsh TAG   ：`git show TAG`
    > 例：
    > ```bash
    > $ git tag -a <TAG> -m 'discription'   ：强标签
    > $ git tag <TAG-lw>                    ：轻量标签
    > $ git tag -d <TAG>                    ：删除标签
    > ```
<!-- -->

* git log [file|branch|commit]
    * glg
    * glgga     ：可视化
    * glola     ：精简可视化
<!-- -->

* git checkout
    * gco       ：切换分支
    * gcm，gcd  ：切换到master、develop分支
    * gcb，gct  ：如下示例
    > 例：
    > ```
    > $ git checkout -b <branch> <remote>/<branch>：创建、检出并跟踪
    > $ git checkout --track <remote>/<branch>    ：本分支直接跟踪
    > ```
    > 注：切换分支时，先`git stash`工作区改动
<!-- -->

* git branch
    * gb    ：在当前commit(HEAD)创建分支
    * gbav  ：查看分支信息，以及跟踪分支与远程分支的对比
    * gbda  ：删除已合并的分支
    * gbnm  ：查看未合并的分支
<!-- -- >

* git merge
    * gm        ：合并分支
    * gmt       ：启动vim解决分支冲突
    * gma       ：打断合并
    * gmc       ：继续合并
    > 合并形式  ：快进，递归  
    > 原理      ：将两分支相对共同祖先的变更合并，若对同一个文件均有变更则冲突  
    > 选项      ：--allow-unrelated-histories，在`merge` `pull`等出现无关分支时使用
<!-- -->

* git rebase
    * grb
    * grba  ：打断
    * grbs  ：跳过
    * grbc  ：继续
    > 例：
    ```bash
    $ git rebase <主branch>   ：本分支变基到<branch>
    $ git rebase <主branch> <被branch>
    $ git rebase -i HEAD~n    ：压缩前n次commit，pick为主，squash为辅
    ```
    > 变基操作：将分支完全并入以简化commit历史  
    > 原理：将本分支相对共同祖先的各个变更作用于目标分支而形成各个commit，并删除该分支历史  
    > 注意：因为删除历史的缘故，不要rebase已经发布了的分支commit  
    > rebase分支的分支应该使用--onto选项，以免将分支上的另一个子分支的历史改变
<!-- -->

* git clone URL  Dirname [--depth=1]
* git clone --recurse-submodules
<!-- -->

* git submodule
    * git submodule add `URL` [Dir] ：添加子模块信息
    * `gsi`：git submodule init                 ：根据本地记载的子模块信息，初始化子模块
    * `gsu`：git submodule update               ：上次提交时记录的子模块的“快照”可能并不是最新的，需要更新
    > git submodule update --init               ：相当于上两步一起  
    > git submodule update --init --recursive   ：递归
<!-- -->

* git remote
    * gr
    * grv
    * gra
    * grrm
    * grmv
    * glr   ：查看ref
    > 例：
    ```bash
    $ git remote add <remote> URL
    ```
    > 流程：
gra -> gcb|gct -> gf|gl -> gco -> gc -> gm|grb -> gp
<!-- -->

* git fetch
    * gf
<!-- -->

* git pull
    * gl
<!-- -->

* git push [-f]
    * gp
    * 例：
    ```bash
    $ git push <remote> <本地branch>      ：推送本地分支<branch>到远程同名分支
    $ git push <remote> <本地branch>:<远程branch>
    $ git push <remote> <本地ref>:<远程ref>
    $ git push <remote> --delete <branch> ：销毁远程仓库某分支
    $ git push <remote> <tag>
    $ git push --tags
    $ git push <remote> :refs/tags/tagname
    ```
<!-- -->

* git stash
    > 隐藏暂存区，方便跳转分支，记得先`git add --all`哦
    * gsta
    * gstp
    * gstl
<!-- -->

* git cherry-pick Commit
    > 复制(合并)目标commit相对其前一次的修改到当前分支
    * gcp
    * gcpa
    * gcpc
<!-- -->

* git bundle create TargetFile HEAD Branch
    > 打包  
    > 注： 最好带上HEAD自动checkout  
    > 可用`git clone <file> [<dirname>]`重建目录
<!-- -->

* git format-patch
    > 制作补丁
    > 例：
    ```bash
    $ git format-patch <branch> -n            ：目标分支最近n次更新
    $ git format-patch <commit>               ：本分支自目标commit(不含)之后的更新
    $ git format-patch <commit1>..<commit2>   ：两个commit(包含)之间的更新
    ```
<!-- -->

* git apply
    > 引用补丁
    * gap
    * 例：
    ```bash
    $ git apply [|--check|--stat] ：直接更新|确认是否冲突|确认哪些更改
    ```
<!-- -->

* git filter-branch：彻底删除文件历史
```bash
$ git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch path-to-your-remove-file' --prune-empty --tag-name-filter cat -- --all
```
<!-- -->

* Makefile
    * 规则：
        * 格式：
        ```makefile
        <target>：<prerequisites>
        <tab> <command>
        ```
        * 前置条件与命令至少要有一个存在
    * 目标：默认执行第一个目标
        * 文件(默认)：
    依赖前置条件(也是一系列目标)生成目标文件
        * 伪目标(用`.PHONY:<target>`指定)：
    用于表示该目标不是文件，无条件执行
    * 前置条件：用空格分隔
        * 依赖文件：
    若依赖文件存在且时间戳晚于目标文件，则不生成目标文件
        * 依赖伪目标：
    直接执行伪目标
    * 命令：
        * 前导符用`.RECIPEPREFIX = {char}`指定，默认<tab>
        * 每行命令在单独shell中，用`.ONESHELL:`则在同一个shell中
    * 语法
        * `#`：注释
        * `@`：关闭回响，默认回响每行命令与注释
        * 支持通配符
        * 支持变量：用$(var)引用，shell变量用$$var
        * 内置变量：$(CC)代指编译器
<!-- -->

* CMake：CMakeLists.txt
    * CMake 最低版本号要求  
    `cmake_minimum_required (VERSION 2.8)`
    * 项目信息  
    `project (Demo1)`
    * 指定生成目标  
    `add_executable(Demo main.cc)`
    * 查找当前目录下的所有源文件，并将名称保存到变量  
    `aux_source_directory(. DIR_SRCS)`
    * 指定生成目标  
    `add_executable(Demo ${DIR_SRCS})`
    * 把当前文件夹下的源码列表存到变量 SRCS 中  
    `file( GLOB SRCS `*.c *.cpp *.cc *.h *.hpp )  
    * 把源码编译成一个二进制这里的 ${PROJECT_NAME} 就是 CPP，是在第一行设置的  
    `add_executable( ${PROJECT_NAME} ${SRCS} )`
    * 添加 math 子目录，在子目录执行cmake  
    `add_subdirectory(math)`
    * 指定生成目标  
    `add_executable(Demo main.cc)`
    * 添加链接库  
    `target_link_libraries(Demo MathFunctions)`
    * 制作链接库  
    `add_library( 动态链接库名称  SHARED  源码列表 )  `
    `add_library( 静态链接库名称  STATIC  源码列表 )  `
    `add_executable( 二进制文件名  源码列表 )  `
    `target_link_libraries( 二进制文件名  动静态库名 )`
<!-- -->

