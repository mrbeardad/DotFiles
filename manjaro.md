# 安装Manjaro

## 刻录镜像
* **Linux**
    ```bash
    # 注：manjaro.iso为你下载的manjaro镜像，/dev/sdb为你的移动硬盘设备
    $ dd -if=manjaro.iso of=/dev/sdb bs=8M oflag=sync status=progress
    ```
* **Windows**

## 启动
> 这对新手来说时最难的步骤吧。我第一次帮我同学装的时候因为主板型号不同，**UEFI BOIS**天差地别，
> 我俩通视频搞了好久才勉强装上🙈️

1. 重启电脑，启动过程中狂按 <kbd>F2</kbd>，进入UEFI BOIS
    > 没作用的话，就网上搜搜你的电脑应该按哪个键进入UEFI BOIS，一般都是 <kbd>F2</kbd>  
    > 当然还有一种可能是某个黑心修电脑的师傅把键盘给关了，开机后才能用。小时候就被这样搞过，  
    > 现在想来。。。。靠！
2. 进了UEFI BOIS后，把安全启动(Security Boot)给关了
3. 在开机选单(Boot menu)中选择你刻录的镜像。
    > 我的UEFI是图形界面的，很好操作。我同学的是文本界面，我们当时选了半天，屁用没有，
    > 结果发现右边解释了我们选的是启动顺序，我以为按回车就直接给我启动呢。。。  
    > 如果你也是文本界面，记得调整好顺序后，保存-退出-重启一气呵成
4. 然后就是一个烂大街的教程图片  
    选则`driver=nofree`后就Boot吧
    > 不选nofree的话，manjaro会使用开源Nvidia驱动，这玩意儿是逆向工程写出来的，
    > 不出意外。。。开机就卡死

![manjaro-startup](https://ywnz.com/uploads/allimg/18/1-1Q1062215334T.JPG)

5. 进去镜像系统后，先分区。
    > 注意：根分区别用LVM，`/usr`也别单独一个分区
6. 然后得先设置源
    > /etc/pacman.d/mirrorlist
7. 最后，插电，联网

## launch

1. 启动安装程序，就是刚进来就自己弹出来的那个窗口
2. 安装完成后，记得修改`/etc/sudoers`和`/etc/sudoers.d/10-installer`
    > 第二个文件需要root权限才看得见，而且里面的配置覆盖了我在前一个文件中写的配置，
    > 我就说我明明设置了`%wheel ALL=(ALL) NOPASSWD: ALL`怎么还要叫我输密码，害..
3. 检查一下`/etc/fstab`有没有问题，根据多次重装的经验，就这儿容易出问题，
    要是你想用swap分区，也可以在此加上


## config

然后，然后，当然就用我的配置喽，哈哈
```bash
# 国内gitee要快一些，当然也可以把gitee改为github
$ git clone --depth=1 https://gitee.com/mrbeardad/DotFiles ~/.local/DotFiles
$ cd ~/.local/DotFiles
$ ./init.sh

# 喝茶，溜了
```

