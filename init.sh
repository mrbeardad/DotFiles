#!/bin/bash

# 
function ssh_cfg() {
    sudo cp -f ssh/sshd_config /etc/ssh/sshd_config
    cp -f ssh/ssh_config ~/.ssh/ssh_config
    sudo systemctl enable --now sshd.socket
    echo -e "\e[33m Note:\e[m Now you need to push your ~/.ssh/id_ecdsa.pub to your github account"
    echo -e 'To generate public private key, run command: \e[32mssh-keygen -t ecdsa -b 521 -C "yourname@youremail"'
}


#配置zsh
function zsh_cfg() {
    #下载oh-my-zsh
    yay -S oh-my-zsh-git powerline-fonts zsh-syntax-highlighting zsh-autosuggestions autojump

    #修改.zshrc中ZSH_THEME HYPHEN_INSENSITIVE ENABLE_CORRECTION=  COMPLETION_WAITING_DOTS HIST_STAMPS plugins
    sed -r -i "/ZSH_THEME/s/=.*/=\"agnoster-time\"/;
    /HYPHEN_INSENSITIVE/s/# //;
    /COMPLETION_WAITING_DOTS/s/# //;
    /HIST_STAMPS/{s/# //; s/=.*/=\"yyyy-mm-dd\"/};
    /^plugins=/s/=.*/=(git cp extract autojump)/;
    /Preferred editor/a export EDITOR='vim'" ~/.zshrc

    #添加alias和man()
    cp -f zsh/.zshrc ~/.zshrc
    sudo cp -f zsh/.zshrc ~/.zshrc
    sudo cp zsh/*.zsh-theme /usr/share/oh-my-zsh/themes/
    chsh -s /bin/zsh
    sudo chsh -s /bin/zsh

    #添加Linux笔记，用see查询
    if [ ! -e ~/.cheat ] ;then
        mkdir ~/.cheat
    fi
    cp cheat/* ~/.cheat
}


#配置tmux
function tmux_cfg() {
    if [ ! -e ~/.tmux ] ;then
        mkdir ~/.tmux
    fi

    if [ -e ~/.tmux.conf ] ;then
        mv ~/.tmux.conf{,.bak}
    fi
    cp tmux/.tmux.conf ~/.tmux.conf
    yay -S tmux tmux-resurrect-git
}


#配置vim
function vim_cfg() {
    if [ ! -e ~/.vim ] ;then
        mkdir ~/.vim
    fi

    if [ -e ~/.vim/vimrc ] ;then
        mv ~/.vim/vimrc{,.bak}
    elif [ -e ~/.vimrc ] ;then
        mv ~/.vimrc{,.bak}
    fi

    if [ -e ~/.vim/gvimrc ] ;then
        mv ~/.vim/gvimrc{,.bak}
    elif [ -e ~/.gvimrc ] ;then
        mv ~/.gvimrc{,.bak}
    fi

    if [ ! -e ~/.local/bin ] ;then
        mkdir ~/.local/bin
    fi
    cp  vim/vimrc ~/.vim/vimrc
    cp  vim/gvimrc ~/.vim/gvimrc
    g++ -O3 -o ~/.local/bin vim/time.cpp

    yay -S gvim vim-plug cmake ctags gperf vim-instant-markdown vim-youcompleteme-git cppcheck

    echo -e 'The plugin "LeaderF" can work with gtags, you can download it at http://tamacom.com/global/global-6.6.4.tar.gz ,and you need to compile it in your machine.'
    echo -e ' How to do is written on the website, and donot forget to \e33m"sudo make install"'
    echo -e '\e[32mStartup your vim and run the command ":PlugInstall"'
}


#安装额外的CLI工具、桌面软件、GNOME扩展
function extra_cfg() {
    #CHFS
    curl -o ~/Downloads/chfs-linux-amd64-1.8.zip https://iscute.cn/tar/chfs/1.8/chfs-linux-amd64-1.8.zip
    cd /opt
    sudo unzip ~/Downloads/chfs-linux-amd64-1.8.zip
    chmod 755 chfs-linux-amd64-1.8/chfs
    ln -s /opt/chfs-linux-amd64-1.8/chfs bin/chfs
    cd -
    sudo cp chfs/chfs.{service,socket} /etc/systemd/system/
    sudo mkdir /srv/chfs
    sudo chmod 755 /srv/chfs
    sudo systemctl daemon-reload
    sudo systemctl enable --now chfs.socket

    #archibold
    sudo curl -o /opt/bin http://archibold.io/sh/archibold
    sudo chmod 755 /opt/bin

    #CLI工具
    yay -S sendemail htop iotop ncdu tldr cloc screenfetch ranger figlet cmatrix cheat dstat ntfs-3g archlinuxcn/cppman-git

    #百度网盘，QQ，网易云音乐，搜狗拼音，WPS
    yay -S baidunetdisk-bin deepin.com.qq.im wqy-microhei netease-cloud-music vlc fcitx-sogoupinyin fcitx-im fcitx-configtool wps-office ttf-wps-fonts flameshot google-chrome
    #搜狗拼音配置
    echo -e 'export GTK_IM_MODULE=fcitx\nexport GTK_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile
    #WPS配置
    sed -i '1a\export XMODIFIERS="@im=fcitx"\nexport QT_IM_MODULE="fcitx"\n' /usr/bin/wps

    #GNOME扩展
    yay -S gtk-theme-macos-mojave adapta-gtk-theme-bin breeze-hacked-cursor-theme ttf-google-fonts-git tela-icon-theme-git gnome-shell-extension-coverflow-alt-tab gnome-shell-extension-system-monitor-git
}


# function main() {

# Basic configuration
timedatectl set-ntp 1 && timedatectl set-local-rtc 1
sudo systemctl disable --now bluetooth.target
sudo systemctl disable --now bluetooth.service
sudo systemctl disable --now  org.cups.cupsd.service
sudo systemctl disable --now  org.cups.cupsd.socket
sudo systemctl enable --now fstrim.timer
sudo sed -i '/\[Journal\]/a\SystemMaxUse=50M' /etc/systemd/journald.conf
sudo bash -c "mv /usr/local/* /opt && rmdir /usr/local && ln -s /usr/local /opt"
echo -e "\e[33mNow you may need to edit your /etc/fstab to add a swap filesystem and change both <dump> and <pass> filed to 0 for all filesystem\e[m"

# pacman configuration
sudo bash -c "echo 'Server = https://mirrors.cloud.tencent.com/manjaro/stable/\$repo/\$arch
Server = https://mirrors.ustc.edu.cn/manjaro/stable/\$repo/\$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/manjaro/stable/\$repo/\$arch' > /etc/pacman.d/mirrorlist"
sudo cp /etc/pacman.d/mirrorlist{,.bak} # Sometimes your mirrorlist will be changed after update your system
sudo sed -i "/#Color/s/#//" /etc/pacman.conf
sudo bash -c "echo '[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.cloud.tencent.com/archlinuxcn/\$arch' >> /etc/pacman.conf"
sudo pacman -S yay
yay -S aria2 expac pacman-contrib-git base-devel
sudo systemctl enable --now paccache.timer

# grub
sudo cp grub/01_users /etc/grub.d
echo "Please type a password 2 times for grub..."
sudo bash -c "grub-mkpasswd-pbkdf2 > /boot/grub/user.cfg"
sudo sed -i '1,2d; 3s/.*is /GRUB_PASSWORD=/;' /boot/grub/user.cfg
sudo sed -i '/--class os /s/--class os /--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\e[33mNow you may need to change your grub theme"
echo "\e[33mNow you may need to change your X-server to wayland"

ssh_cfg
zsh_cfg
vim_cfg
tmux_cfg
extra_cfg
# }

