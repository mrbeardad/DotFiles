# 写在前面
整个仓库的建立都是一个我个人在学习的过程，这些也都为我自己所需所用所愿而写，
故有些东西不会尽如人意

[README-en.md](README-en.md)  
[学习资源](learning-resource.md)  
***
![ocean misses dreams and night](ocean-3605547_1920.jpg)


# 安装
## Manjaro and Arch Linux
提供了*shell*脚本用于安装配置与一些软件包  

首先进入克隆的本仓库目录
```
$ cd DotFiles
```
然后执行
```
$ ./bin/init.sh {options}
```
其中，`{options}`选项可以是：  
* `--help` ：列出此列表
* `--all` ：应用所有选项
* `pacman`： 配置pacman，会更改 */etc/pacman.conf* 和 */etc/pacman.d/mirrorlist*
* `zsh` ：安装oh-my-zsh，并提供了函数 *see* 用于我平时查笔记，-l选项列出所有知识点(命令与概念，输出那是相当不人性化 :cry: )，-e选项精准查询
* `tmux` ：安装tmux
* `ssh` ：修改 */etc/sshd/sshd_config* 和 *~/.ssh/ssh_config*
* `chfs` ：下载并安装chfs(Cute Http File Server)
* `vim` ：修改 *~/.vim/vimrc* 和 *~/.vim/gvimrc*
* `extra` ：一些我需要为额外的软件包

***

#### pacman
* 下载yay以使用AUR；
* 联用aria2c；
* 修改源为腾讯云，并添加腾讯云的archlinuxcn源

***

#### zsh
* 下载**oh-my-zsh**并修改其提供的默认配置
* 下载一些很有用的zsh插件
* 安装仓库里的zsh-theme，其中agnoster-time是由原**oh-my-zsh**主题修改而来

***

#### tmux
* 下载tmux，与一个小插件用于保存与回复会话

* **使用：**
    * <kbd>Alt</kbd>+<kbd>w</kbd> 为快捷键前缀，<u>以下快捷键会省略写出前缀</u>
    * <kbd>s</kbd> 水平切分panes
    * <kbd>v</kbd> 竖直切分panes
    * <kbd>r</kbd> 重载配置
    * <kbd>b</kbd> 上一个window
    * <kbd>Ctrl</kbd>+<kbd>S</kbd> 保存会话
    * <kbd>Ctrl</kbd>+<kbd>R</kbd> 恢复会话
    * 其他按键都为**前缀** + **默认按键**

***

#### ssh
* 修改 */etc/sshd/sshd_conf* 更改sshd的端口号为50000，本来想设置为只允许私钥登录，
结果手机上的JuiceSSH总是没法识别我笔记本上生成的私钥，JuiceSSH上生成的公钥在电脑上也不识别。
要是有朋友知道提个issue嘛  
<br>脚本会自动启动*sshd.socket*

* 修改 *~/.ssh/ssh_config*，这是个用于github SSH 的配置模板，这样你把仓库URL协议改为
git@github.com:*Username/Repository* 就可以直接直接`git push`而无需输入密码  
<br>当然，你需要把把私钥放到 *~/.ssh/id_ecdsa* ，若想用其他文件则修改前面提到的那个文件  
若是没有公私钥对，那就生成一对吧：  
```
  $ ssh-keygen -t ecdsa -b 512 -C "注释"
```

***

#### chfs
* 这是一个简单的局域网web，我一般用于手机与电脑传传文件啥的，当然能也可以用QQ，不过装wine
的话听说有点卡(没试过0.0)，QQ for Linux功能又太少(具体多少呢?你下个看看0.0)
* 直接用手机访问电脑的ip就行，端口是默认的，要改的话需要修改chfs.service和chfs.socket，
看一下应该就知道咋改就不多说来，不会的话装了我的zsh配置然后`seep 'unit|service|socket'`

***

#### extra
* 这个选项提供了许多我需要的软件，或许你也需要？包括QQ、网易云音乐、WPS等等桌面应用和
CLI工具

***

#### vim
* 这才是重头戏嘛，这配置搞了好久的。各个插件总是这样那样的问题，不过最后还是调教的顺手啦。
不过我这配置是用来写C++和Markdown的，其他语言的话得自己改配置了，主要就是我让一些插件
只在C++文件中工作。插件的详情可以直接打开vimrc看，我写了注释；

* 仓库中的vim目录里面还有3个文件，**cppcheck.vim**和**clangtidy**是ALE插件的脚本，我修改
了内容让它们俩能正常的进行语法检测报错，**.ycm_extra_conf.py**是youcompleteme的C++配置，
移到工程目录下起作用；
* <font color=red> NOTE: </font>这套配置依赖vim-plug插件管理器
* <font color=red> NOTE: </font>Leaderf插件的运行还需要[gtags](https://www.gnu.org/software/global/download.html)
* <font color=red> NOTE: </font>vim-instant-markdown插件依赖有点麻烦，我用的AUR里的
* <font color=red> NOTE: </font>我配置的即时编译并运行C++代码的快捷键，依赖仓库里的
bin/quickrun_time，其实就是time命令，不过shell的time输出难看我就重新写了一个，有彩蛋哦
（●。●）～
* **自定义命令**：
    * Rcmd：读取vim-cmd-output到当前buffer
    * W：sudo写回文件，解决权限问题
    * Csh：查看cscope简短帮助，容易忘记嘛
    * QuickrunArgs：设置<kbd>space</kbd>+<kbd>l</kbd>+<kbd>r</kbd>运行时传给你的程序的参数，在<font color=green>参数最后</font>可以添加额外参数来I/O重定向，`-o`同`>`，`-i`同`<`
* **自定义快捷键**
    * 插入模式：
        * \<c-a>：行首
        * \<c-e>：行尾
        * \<c-u>：删除至行首
        * \<c-k>：删除至行尾
        * \<c-d>：下滚10行
        * \<c-b>：上滚10行
    * 可视模式：
        * <c-c>：复制选中区域到系统剪切板
    * 普通模式
        * \<space>n：下一个buffer
        * \<space>b：上一个buffer
        * \<space>n：切换到第n个window，n为1-6
        * \<c-d>：下滚10行
        * \<c-b>：上滚10行
        * \<c-a>：行首
        * \<c-e>：行尾
        * ,：复制光标下一个字符
        * Y：复制光标到行尾的字符
        * \<space>o：在该行下添加一空行
        * \<space>O：在该行上添加一空行
        * \<leader>w：切换wrap(长行是否回绕)
        * \<leader>v：切换virtualedit(光标是否可出现在无字符区域)
    * 插件相关
        * \<leader>ap：开关Auto-Pairs
        * \<leader>il：开关Indentline
        * \<F2>：开关Tagbar
        * \<F3>：开关NERDTree
        * \<F4>：开关UndoTree
        * \<c-c>：触发UltiSnips
        * \<m-n>：到下一个UltiSnips的替换位置
        * \<m-p>：到上一个UltiSnips的替换位置
        * \<leader>cc：快速注释代码
        * \<leader>cu：快速取消注释
        * 提供额外文本对象：`f`函数，`i`缩进，`,`函数参数
    * 搜索工程
        * \<leader>fz：搜寻文件
        * \<leader>ff：在所有缓冲区中搜寻函数
        * \<leader>ft：在所有缓冲区中搜寻标识符
        * \<leader>fg：利用gtags搜寻标识符
        * \<leader>fc：利用gtags搜寻内容
        * \<leader>fu：手动更新gtags
    * 跳转标识符
        * gd：跳转定义，基于gtags的标签
        * gr：跳转引用，基于gtags的标签
        * gs：跳转无定义的引用，基于gtags的标签
        * go：跳转声明或定义，基于ycm的语义
        * gt：获取对象类型，基于ycm的语义
        * jn：跳转下一个ALE语法提示
        * jb：跳转上一个ALE语法提示
    * 编译运行
        * \<space>lr：快速编译并执行该c++程序
        * \<space>ld：只编译用于gdb调试
        * \<space>lc：用clang优化编译
    * NERDTree
        * p：父目录
        * P：顶目录
        * I：显示隐藏文件
        * \<cr>：打开文件/目录
        * t：新tab打开文件
        * x：关闭目录
        * u：切换顶目录为其父目录
        * C：切换顶目录为此目录

