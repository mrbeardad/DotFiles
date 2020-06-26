# 开机启动
## UEFI BOIS
> 需要掌握：
> * 进入UEFI BIOS界面
> * 设置开机启动项
> * 设置安全启动模式
> * 为BIOS界面加密

1. 接通电源

2. CPU加载主板上固件
3. 读取硬件信息并检查
4. 读取并加载硬盘ESP中的boot-loader(GRUB)

## GRUB
> 需要掌握：
> * 简单了解选单制作
> * 修改选单中内核参数以进行系统救援

1. 加载bootx64(core.img)

2. 定义变量`cmdpath` `prefix` `root`
3. 加载normal.mod
    > 失败则进入救援模式
4. 执行$prefix/grub.cfg
    > 无grub.cfg则进入命令模式
5. 进入普通模式
    * 选单界面  
    * 按`e`进入编辑模式  
    * 按`c`进入命令模式
6. 加载initramfs
7. 加载kernel

## Kernel
1. 挂载initramfs模拟的`/ (根目录设备)`
    1. 加载Modules
    2. 启动init程序(systemd)
    3. 启动initrd.target

2. 挂载硬盘中真正`/ (根目录设备)`
3. 释放initramfs
4. 准备启动磁盘上的default.target

## Systemd
> 需要掌握：
> * 掌握Systemd-Unit的配置，自动启动或关闭服务
> * systemctl工具管理daemon
> * journalctl工具查看日志

1. 启动default.target并递归检查依赖

2. sysinit.target：
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
3. basic.target
    * SELlinux
    * FireWall
    * pathes.target
    * slices.target
    * sysinit.target
    * sockets.target
    * timers.target
4. multi-user.target
5. graphical.target

## Login
* 启动登录程序
    > 文本界面通过logind  
    > 图形界面通过GDM之类的display-manager
* 通过PAM模块进行认证
    > 通过/etc/pam.d/${daemon-name}进行配置
* 开启会话
<!-- -->

# 系统结构
## 硬件组成
* 电源
* 主板（包括固件、时钟）
* CPU（包括I/O桥）
* 内存
* 显卡与显示屏
* 总线
* 南桥芯片

* 外设：键盘、鼠标、硬盘、网卡、声卡等

## 操作系统
* **本地化配置**
    * 日期时间与时区（timedatectl）

    * 语系与字符集（localectl）
    * 主机名称（hostnamectl）
    * 字体（fc-cache）
* **系统日志**
    * 主机运行记录

    * 用户登录记录
    * 进程服务日志
    * 内核处理日志
* **网络协议栈**
    * 应用层：socket接口

    * 传输层：协议类型、端口号
    * 网络层：协议类型、IP/mask、路由表
    * 链路层：混杂模式、MAC地址、ARP表
    * NetFilter
* **虚拟文件系统**
    * 标准输入输出
    * 本地文件系统
    * 网络文件系统
    * 硬件设备文件

    * 内核接口文件
* **进程管理**
    * 加载与链接

    * 进程上下文切换
    * 进程优先级
    * 进程间通讯
        > signal, pipe, socket, dbus
    * 自动启动、重启、终止进程
    * 限制进程组的资源使用
* **进程模型**
    * 进程状态
        * 运行、睡眠、暂停、僵尸、终止
    * 环境变量
        > uid, euid, gid, egid  
        > pid, ppid, pgid, psid, tpgid,  
        > 等等
    * 线程上下文切换
    * 多线程同步机制
* **虚拟内存**
    * 地址翻译

    * 内存映射（页）
    * 共享内存（段）
    * 内存分布
        * 内核保留
        * 物理内存映射
        * 硬件寄存器映射
        * 进程内存映射
            * 栈
            * 共享段
            * 堆
            * 数据段
            * 代码段

