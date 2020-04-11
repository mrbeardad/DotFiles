#!/bin/bash

#配置ssh
function ssh_cfg() {
    # 添加git push <remote>需要的ssh配置
    cp -v ssh/ssh_config ~/.ssh/ssh_config
    cp -v /mnt/AUSU/backup/id_ecdsa ~/.ssh

    # 设置sshd用于连接到该主机
    sudo cp -v ssh/sshd_config /etc/ssh/sshd_config
    sudo cp -v ssh/motd /etc/motd

    sudo systemctl enable --now sshd.socket
}

#配置zsh
function zsh_cfg() {
    #下载zsh相关包
    yay -S zsh powerline-fonts zsh-syntax-highlighting zsh-autosuggestions autojump archlinuxcn/oh-my-zsh-git

    # 安装.zshrc
    cp -v zsh/.zshrc ~/.zshrc
    sudo cp -v zsh/*.zsh-theme /usr/share/oh-my-zsh/themes/
    chsh -s /bin/zsh

    #添加Linux笔记，用see查询
    if [ ! -e ~/.cheat ] ;then
        mkdir ~/.cheat
    fi
    cp -v cheat/* ~/.cheat
}


#配置tmux
function tmux_cfg() {
    if [ ! -e ~/.tmux ] ;then
        mkdir ~/.tmux
    fi
    cp -v tmux/.tmux.conf ~/.tmux.conf
    yay -S tmux tmux-resurrect-git
}

#安装定制的SpaceVim for NeoVim
function nvim_cfg() {
    yay -S nvim xsel python-pynvim cmake ctags global cppcheck archlinuxcn/nerd-fonts-complete ripgrep
    git clone git@gitee.com:mrbeardad/SpaceVim ~/.local/SpaceVim
    if [[ -d ~/.config/nvim ]] ;then
        mv ~/.config/{nvim,nvim.bak}
    fi
    ln -s ~/.local/SpaceVim ~/.config/nvim
    if [[ ! -d ~/.SpaceVim.d ]] ;then
        mkdir ~/.SpaceVim.d
    fi
    if [[ -e ~/.SpaceVim.d/init.toml ]] ;then
        mv ~/.SpaceVim.d/init.toml{,bak}
    fi
    cp -v ~/.local/SpaceVim/mod/init.toml ~/.SpaceVim.d
    if [[ ! -d ~/.local/bin ]] ;then
        mkdir ~/.local/bin
    fi
    cp -v bin/vim ~/.local/bin
}

#安装额外的CLI工具、桌面软件、GNOME扩展
function extra_cfg() {
    #CHFS
    cd /tmp
    unzip /mnt/AUSU/packages/chfs-linux-amd64-1.8.zip
    chmod 755 chfs-linux-amd64-1.8/chfs
    sudo cp -v /opt/chfs-linux-amd64-1.8/chfs /opt/bin/chfs
    cd -
    sudo cp chfs/chfs.{service,socket} /etc/systemd/system/
    sudo mkdir /srv/chfs
    sudo chmod 755 /srv/chfs
    sudo systemctl daemon-reload
    sudo systemctl enable --now chfs.socket

    #archibold
    sudo cp -v /mnt/AUSU/packages/archibold /opt
    echo -e "\e[32m=====> GDB
    Now, you can change your gdm background by run 'archibold login-backgroud /path/to/your/picture'"

    #CLI工具
    yay -S htop iotop ncdu tldr cloc screenfetch ranger figlet cmatrix cheat dstat ntfs-3g cppman clang gdb
    cp -v gdb/.gdbinit ~

    #百度网盘，QQ，网易云音乐，搜狗拼音，WPS
    yay -S baidunetdisk-bin deepin.com.qq.office vlc netease-cloud-music fcitx-sogoupinyin fcitx-im fcitx-configtool ssf2fcitx-git pinyin-completion wps-office ttf-wps-fonts flameshot google-chrome gnome-terminal-fedora alacritty
    cp -v alacritty/alacritty.yml ~/.config/alacritty
    # git clone --depth=1 https://github.com/haotian-wang/google-access-helper ~/Downloads/google-access-helper

    echo -e '\e[32=====> Chrome
    Now, add google-access-helper to your google-chrome in devloper mode'

    #搜狗拼音配置
    echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile

    #WPS配置，现在好像不需要了。。
    #sudo sed -i '1a\export XMODIFIERS="@im=fcitx"\nexport QT_IM_MODULE="fcitx"\n' /usr/bin/wps

    #QQ配置，禁用ipv6，否则不显示图片
    sudo echo "net.ipv6.conf.all.disable_ipv6 =1
    net.ipv6.conf.default.disable_ipv6 =1
    net.ipv6.conf.lo.disable_ipv6 =1" >> /etc/sysctl.conf
    sudo sysctl -p /etc/sysctl.conf
    # 修改/opt/deepinwine/apps/Deepin-TIM/deepin.com.qq.office.desktop 禁用ipv6并使用optirun

    #GNOME扩展
    yay -S gtk-theme-macos-mojave adapta-gtk-theme-bin breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git ttf-google-fonts-git gnome-shell-extension-coverflow-alt-tab gnome-shell-extension-system-monitor-git
}


# function main() { 安装完后就改个sudo配置，其他啥也不用动

# 系统配置
timedatectl set-ntp 1 && timedatectl set-local-rtc 1
sudo systemctl disable --now bluetooth.service
sudo systemctl disable --now org.cups.cupsd.service
sudo systemctl enable --now fstrim.timer
sudo sed -i '/\[Journal\]/a\SystemMaxUse=100M' /etc/systemd/journald.conf
# sudo bash -c "mv /usr/local/* /opt && rmdir /usr/local && ln -s /opt /usr/local"
echo -e "\e[32m=====> /etc/fstab\e[m
Now you may want to edit your /etc/fstab to add a swap filesystem
and change both <dump> and <pass> filed to 0 for all filesystem"

# pacman配置
sudo bash -c "echo 'Server = https://mirrors.cloud.tencent.com/manjaro/stable/\$repo/\$arch
Server = https://mirrors.ustc.edu.cn/manjaro/stable/\$repo/\$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/manjaro/stable/\$repo/\$arch' > /etc/pacman.d/mirrorlist"
sudo cp /etc/pacman.d/mirrorlist{,.bak} # 有时候更新系统会把这个也更新了，备份一下
sudo sed -i "/#Color/s/#//" /etc/pacman.conf
sudo bash -c "echo '[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.163.com/archlinux-cn/\$arch' >> /etc/pacman.conf"
sudo pacman -Syu
yay -S yay pacman-contrib-git aria2 expac base-devel
sudo systemctl enable --now paccache.timer

# grub配置
sudo cp grub/01_users /etc/grub.d
sudo cp grub/user.cfg /boot/grub
sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}
# sudo grub-mkconfig -o /boot/grub/grub.cfg
yay -S grub-theme-manjaro
echo -e "\e[32m=====> GRUB\e[m
Now you may want to change your grub theme.Some version of Manjaro don't install grub-theme-manjaro.
And you can may like to change the default .png picture. https://www.yasuotu.com/mgeshi provide online picture converter"

# Nvidia配置
# yay -S bumblebee virtualgl lib32-virtualgl lib32-primus primu linux54-bbswitch
# sudo systemctl enable --now bumblebee
# sudo gpasswd -A beardad bumblebee
echo -e '\e[32m=====> patches
Now, you may want to apply patches in patches directory'

ssh_cfg
zsh_cfg
vim_cfg
tmux_cfg
extra_cfg
# }

