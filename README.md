# 写在前面
ArchLinux早换成Manjaro了，所以没测试过前者，所以朋友，看源码自己装啦:smile:

[README-en.md](README-en.md)  
[学习资源](learning-resource.md)  
***
![ocean misses dreams and night](ocean-3605547_1920.jpg)

# 安装
> 提供了shell脚本用于安装配置

1. 首先进入克隆的本仓库目录
```shell
$ cd DotFiles
```
2. 然后执行
```shell
$ ./init.sh
```

# 详细

## pacman
* 修改源为国内源，并添加archlinuxcn源
* 下载yay(AUR助手)和一些其他工具
* 下载基础开发包
* 更新系统

## zsh
* 下载**oh-my-zsh**并修改其提供的默认配置
### 使用方法：
* <kbd>Esc</kbd>或<kbd>Ctrl</kbd>+<kbd>[</kbd>：进入vi-mode，可以更方便的修改命令
* <kbd>v</kbd>：在vi-mode中，按快捷键v可打开`$EDITOR`编辑命令
* `x`：该命令可以智能解压各种压缩包
* `j`：该命令会根据你`cd`的频率，智能、模糊化地跳转到目标目录  
> 例如：你去过目录`DotFiles`，你执行
> ``````shell
> $ j do
> ``````
> 就可能直接跳转到`DotFiles`目录，当然如果之前有去过其他名字含`do`的目录就会跳转到频率高的目录

## tmux
* 下载tmux，与一个小插件用于保存与回复会话

* **使用简述：**
    * <kbd>Alt</kbd>+<kbd>w</kbd> 为快捷键前缀，<u>以下快捷键会省略写出前缀</u>
    * <kbd>s</kbd> 水平切分panes
    * <kbd>v</kbd> 竖直切分panes
    * <kbd>r</kbd> 重载配置
    * <kbd>b</kbd> 上一个window
    * <kbd>n</kbd> 下一个window
    * <kbd>Ctrl</kbd>+<kbd>S</kbd> 保存会话
    * <kbd>Ctrl</kbd>+<kbd>R</kbd> 恢复会话
    * 其他按键都为**前缀** + **默认按键**

***

#### ssh
* 修改 */etc/sshd/sshd_conf* 更改sshd的端口号为50000，本来想设置为只允许私钥登录，
结果手机上的JuiceSSH总是没法识别我笔记本上生成的私钥，JuiceSSH上生成的公钥在电脑上也不识别。
要是有朋友知道提个issue，thanks  
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
看一下应该就知道咋改就不多说来，不会的话装了我的zsh配置然后`see 'unit|service|socket'`

***

#### extra
* 这个选项提供了许多我需要的软件，或许你也需要？包括QQ、网易云音乐、WPS等等桌面应用和
CLI工具

***

#### ~~vim~~ 现在已经把配置融合到SpaceVim上了，[传送门](https://github.com/mrbeardad/SpaceVim)
* 这才是重头戏嘛，这配置搞了好久的。此配置是用来写C++的，
其他语言的话得自己改配置了，主要就是我让一些插件 只在C++文件中工作。
<u>插件的详情 ~~可以~~ 最好 直接打开vimrc看，我写了注释，文档就懒得更新啦</u>；

* 仓库中的vim目录里面还有3个文件，**cppcheck.vim**和**clangtidy.vim**是ALE插件的脚本，
我修改了内容让它们俩能正常的进行语法检测报错，**.ycm_extra_conf.py**是youcompleteme的C++配置，
移到工程目录下起作用；
* <font color=red> NOTE: </font>这套配置依赖vim-plug插件管理器
* <font color=red> NOTE: </font>Leaderf插件的运行还需要[gtags](https://www.gnu.org/software/global/download.html)
* <font color=red> NOTE: </font>QuickRun配置的即时编译并运行C++代码，依赖仓库里的vim/time.cpp  
执行`g++ -O3 -o ~/.local/bin/quickrun_time vim/time.cpp`编译即可
* **自定义命令**：
    * Rcmd：读取vim-cmd-output到当前buffer
    * Csh：查看cscope简短帮助，容易忘记嘛
    * Lfh：Leaderf快捷键帮助
    * QuickrunArgs：设置<kbd>space</kbd>+<kbd>l</kbd>+<kbd>r</kbd>运行时传给你的程序的参数
    * QuickrunRedirect：设置<kbd>space</kbd>+<kbd>l</kbd>+<kbd>r</kbd>运行时的I/O重定向  
例：`:QuickrunRedirect -o <filename1> -i <filename2>`表示将stdout重定向到filename1并将stdin重定向到filename2
* **快捷键**
    * buffer, window, tab切换
        * \<leader>n：下一个tab
        * \<leader>b：上一个tab
        * \<space>n：下一个buffer
        * \<space>b：上一个buffer
        * \<c-w>W：sudo写入文件
        * \<c-w>x：删除当前buffer
        * \<tab>：切换窗口
        * \<space>数字：切换窗口
    * 插入模式：
        * \<c-a>：行首
        * \<c-e>：行尾
        * \<c-u>：删除至行首
        * \<c-k>：删除至行尾
        * \<c-d>：下滚10行
        * \<c-b>：上滚10行
        * \<c-]>：匹配括号
    * 可视模式：
        * \<c-a>：行首
        * \<c-e>：行尾
        * \<y>：复制选中区域到系统剪切板
    * 普通模式
        * \<c-d>：下滚10行
        * \<c-b>：上滚10行
        * \<c-a>：行首
        * \<c-e>：行尾
        * ,：复制光标下一个字符
        * Y：复制光标到行尾的字符
        * \<space>o：在该行下添加一空行
        * \<space>O：在该行上添加一空行
        * \<leader>h：关闭搜索高亮
        * \<leader>m：快速编辑宏，连按两次
        * \<leader>w：切换&wrap，长行是否回绕
        * \<leader>l：切换&breakline，回绕是否断词
        * \<leader>v：切换&virtualedit，光标是否可出现在无字符区域
        * \<leader>t：切换&expandtab，是否用空格代替tab
        * \<leader>a：切换&ambiwidth，字符的宽度
    * 插件相关
        * \<F2>：开关Tagbar
        * \<F3>：开关NERDTree
        * \<F4>：开关UndoTree
        * \<c-c>：触发UltiSnips
        * \<m-m>：到下一个UltiSnips的替换位置
        * \<m-b>：到上一个UltiSnips的替换位置
        * {range}\<leader>cc：注释或取消注释代码
        * \<leader>ca：在尾部添加注释
        * 提供额外文本对象：`f`函数，`i`缩进，`,`函数参数
    * 搜索工程
        * \<space>fz：搜寻文件
        * \<space>ff：在所有缓冲区中搜寻函数
        * \<space>ft：在所有缓冲区中搜寻标识符
        * \<space>fg：利用gtags搜寻标识符
        * \<space>fc：利用gtags搜寻内容
        * \<space>fu：手动更新gtags
    * 跳转标识符
        * gd：跳转定义，基于gtags的标签
        * gr：跳转引用，基于gtags的标签
        * gs：跳转无定义的引用，基于gtags的标签
        * go：跳转声明或定义，基于ycm的语义
        * gt：获取对象类型，基于ycm的语义
        * gn：跳转下一个ALE语法提示
        * gb：跳转上一个ALE语法提示
    * 编译运行
        * \<space>lr：quickrun快速编译并执行该c++程序，quickrun会限制运行程序的内存使用最大为100M
        * \<space>ld：只编译用于gdb调试
        * \<space>lc：用clang优化编译

