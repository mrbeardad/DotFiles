* UEFI BOIS
    * CPU加载主板上固件
    * 读取硬件，上电自检
    * 加载boot-loader(GRUB)
* GRUB
    * 加载bootx64(core.img)
    * 定义变量`cmdpath` `prefix` `root`
    * 加载normal.mod
        > 失败则进入救援模式
    * 执行$prefix/grub.cfg
        > 无grub.cfg则进入命令模式
    * 进入普通模式
        * 选单  
        * 编辑`e`  
        * 命令`c`
    * 加载initramfs
    * 加载内核
        > 并为内核设置参数
* Kernel
    * 挂载initramfs模拟的`/ (根目录设备)`
    * 加载Modules
        > initramfs中的
    * 启动init程序(systemd)
    * 启动initrd.target
    * 挂载硬盘中真正`/ (根目录设备)`
    * 释放initramfs
    * 准备启动磁盘上的Systemd-Units
* Systemd
    > 启动default.target并递归检查依赖：
    * sysinit.target：
        * 特殊文件系统的挂载与启动
            > 如：LVM, RAID
        * 启动plymouthd
            > 开机动画
        * 启动systemd-journald
            > 系统日志
        * 载入额外的内核模块
            > /etc/modules-load.d/*.conf
        * 载入额外的内核参数
            > /etc/sysctl.conf 与 /etc/sysctl.d/*.conf
        * 启动乱数产生器
        * 设置终端字体
        * 启动systemd-udevd
            > 动态设备管理器
        * 加载本地文件系统与swap
            > 读取/etc/fstab
    * basic.target
        * SELlinux
        * FireWall
        * pathes.target
        * slices.target
        * `sysinit.target`
        * sockets.target
        * timers.target
    * multi-user.target
    * graphical.target
* 用户登录
    > 图形界面通过gdm之类的显示管理器  
    > 文本界面通过logind
    * 通过PAM模块进行认证
        > 通过/etc/pam.d/${daemon-name}进行配置
    * 开启会话
<!-- -->

