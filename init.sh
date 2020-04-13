#!/bin/bash

#配置ssh
function ssh_cfg() {
    # 添加git push <remote>需要的ssh配置
    cp -v ssh/ssh_config ~/.ssh/ssh_config

    # 设置sshd用于连接到该主机
    sudo cp -v ssh/sshd_config /etc/ssh/sshd_config
    sudo cp -v ssh/motd /etc/motd

    sudo systemctl enable --now sshd.service
}

#配置zsh
function zsh_cfg() {
    #下载zsh相关包
    yay -S powerline-fonts autojump oh-my-zsh-git
    # yay -S zsh zsh-syntax-highlighting zsh-autosuggestions 

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
    sudo cp -v bin/terminal-tumx.sh /opt/bin
    yay -S tmux tmux-resurrect-git
}

#安装定制的SpaceVim for NeoVim
function nvim_cfg() {
    yay -S gvim neovim xsel python-pynvim cmake ctags global cppcheck archlinuxcn/nerd-fonts-complete ripgrep vim-instant-markdown
    # I have forked SpaceVim that do some modification. You can clone it on repo: mrbeardad/SpaceVim
    sudo sed -i '/set runtimepath/s/$/,\/usr\/share\/vim\/vimfiles\/after/' /usr/share/vim/vimfiles/after
    git clone https://gitee.com/SpaceVim/SpaceVim ~/.local/SpaceVim
    if [[ -d ~/.config/nvim ]] ;then
        mv ~/.config/{nvim,nvim.bak}
    fi
    ln -s ~/.local/SpaceVim ~/.config/nvim
}

#安装额外的CLI工具、桌面软件、GNOME扩展
function extra_cfg() {
    #CHFS
    # curl -o ~/Downloads/chfs-linux-amd64-1.8.zip https://iscute.cn/tar/chfs/1.8/chfs-linux-amd64-1.8.zip
    # cd /tmp
    # unzip ~/Downloads/chfs-linux-amd64-1.8.zip
    # chmod 755 chfs
    # sudo cp -v /opt/chfs /opt/bin/chfs
    # cd -
    # sudo cp chfs/chfs.{service,socket} /etc/systemd/system/
    # sudo mkdir /srv/chfs
    # sudo chmod 777 /srv/chfs
    # sudo systemctl daemon-reload
    # sudo systemctl enable --now chfs.socket

    #archibold
    #sudo curl -o /opt/bin http://archibold.io/sh/archibold
    #sudo chmod 755 /opt/bin
    #echo -e "\e[32m=====> GDB
    #Now, you can change your gdm background by run 'archibold login-backgroud /path/to/your/picture'"

    #CLI工具
    yay -S htop iotop ncdu tldr cloc screenfetch ranger figlet cmatrix cheat dstat cppman clang gdb
    cp -v gdb/.gdbinit ~

    #百度网盘，QQ，网易云音乐，搜狗拼音，WPS
    yay -S baidunetdisk-bin deepin.com.qq.office pepper-falsh papper-flash vlc netease-cloud-music fcitx-sogoupinyin fcitx-im fcitx-configtool ssf2fcitx-git pinyin-completion wps-office ttf-wps-fonts flameshot google-chrome gnome-terminal-fedora alacritty
    mkdir ~/.config/alacritty
    cp -v alacritty/alacritty.yml ~/.config/alacritty
    # git clone --depth=1 https://github.com/haotian-wang/google-access-helper ~/Downloads/google-access-helper


    #搜狗拼音配置
    echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile

    #QQ配置，禁用ipv6，否则不显示图片
    sudo bash -c 'echo "net.ipv6.conf.all.disable_ipv6 =1
    net.ipv6.conf.default.disable_ipv6 =1
    net.ipv6.conf.lo.disable_ipv6 =1" >> /etc/sysctl.conf'
    sudo sysctl -p /etc/sysctl.conf
    sudo sed -i '/run.sh/isysctl -p /etc/sysctl.conf' /opt/deepinwine/apps/Deepin-TIM/run.sh

    #GNOME扩展
    yay -S gtk-theme-macos-mojave adapta-gtk-theme-bin breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git ttf-google-fonts-git gnome-shell-extension-coverflow-alt-tab gnome-shell-extension-system-monitor-git
}


# function main() { 安装完后就改个sudo & fstab配置，其他啥也不用动

# 系统配置
timedatectl set-ntp 1 && timedatectl set-local-rtc 1
sudo systemctl disable --now bluetooth.service
sudo systemctl disable --now org.cups.cupsd.service
sudo systemctl enable --now fstrim.timer
sudo sed -i '/\[Journal\]/a\SystemMaxUse=100M' /etc/systemd/journald.conf
sudo bash -c "mv /usr/local/* /opt && rmdir /usr/local && ln -s /opt /usr/local"

# pacman配置
sudo bash -c 'echo "Server = https://mirrors.cloud.tencent.com/manjaro/stable/$repo/$arch"
 > /etc/pacman.d/mirrorlist'
sudo cp /etc/pacman.d/mirrorlist{,.bak} # 有时候更新系统会把这个也更新了，备份一下
sudo sed -i "/#Color/s/#//" /etc/pacman.conf
sudo bash -c 'echo "[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.163.com/archlinux-cn/\$arch" >> /etc/pacman.conf'
sudo pacman -Syu
pacman -S yay aria2 expac base-devel
sudo systemctl enable --now paccache.timer

# grub配置
sudo cp grub/01_users /etc/grub.d
sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}
yay -S grub-theme-manjaro

# Nvidia配置
# yay -S bumblebee virtualgl lib32-virtualgl lib32-primus primu linux54-bbswitch
# sudo systemctl enable --now bumblebee
# sudo gpasswd -A beardad bumblebee

ssh_cfg
zsh_cfg
nvim_cfg
tmux_cfg
extra_cfg

echo -e "\e[32m=====> GRUB\e[m
Now you may want to change your grub theme.Some version of Manjaro don't install grub-theme-manjaro.
And you can may like to change the default .png picture. https://www.yasuotu.com/mgeshi provide online picture converter"
echo -e '\e[32m=====> Patches\e[m
Now, you may want to apply patches in patches directory'
echo -e '\e[32m=====>  Shortcut Wrappers\e[m
Now you need to bind the gnome shortcut for terminal-tmux & neovim-alacritty'
echo -e "\e[32m=====> GDM\e[m
Now, you can change your gdm background by run 'archibold login-backgroud /path/to/your/picture'"
echo -e '\e[32=====> Chrome\e[m
Now, add google-access-helper to your google-chrome in devloper mode'
echo -e '\e[32=====> Neovim\e[m
Now config your neovim by using files in DotFiles/vim'
# }

