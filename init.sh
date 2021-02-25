#!/bin/bash
# Copyright (c) 2020-2021 Heachen Bear & Contributors
# File: init-for-myself.sh
# License: GPLv3
# Author: Heachen Bear <mrbeardad@qq.com>
# Date: 20.02.2021
# Last Modified Date: 20.02.2021
# Last Modified By: Heachen Bear <mrbeardad@qq.com>

function backup() {
    if [[ -z "$1" ]] ;then
        echo -e "\033[31mError:backup(): required one parameter\033[m"
        exit 1
    elif [[ ! -e "$1" ]] ;then
        echo -e "\033[31mError:backup(): file $1 does not exist\033[m"
        exit 1
    fi
    backFileName="$1"
    while [[ -e "$backFileName" ]] ;do
        backFileName+=$RANDOM
    done
    mv -v "$1" "$backFileName"
}

function makedir() {
    if [[ -z "$1" ]] ;then
        echo -e "\033[31mError: makedir() required one parameter\033[m"
        exit 1
    elif [[ ! -d "$1" ]] ;then
        if [[ -e "$1" ]] ;then
            backup "$1"
        fi
        mkdir -p "$1"
    fi
}

function system_cfg() {
    # 开启硬盘定时清理服务
    sudo systemctl enable --now fstrim.timer

    # 限制系统日志大小为100M
    sudo sed -i '/^#SystemMaxUse=/s/.*/SystemMaxUse=100M' /etc/systemd/journald.conf

    # 笔记本电源，20%提醒电量过低，10%提醒即将耗尽电源，3%强制休眠(根据系统差异，也可能会关机)
    sudo sed -i '/^PercentageLow=/s/=.*$/=20/; /^PercentageCritical=/s/=.*$/=10/; /^PercentageAction=/s/=.*$/=3/' /etc/UPower/UPower.conf
}

function pacman_cfg() {
    # 修改pacman源为腾讯源，直接改/etc/pacman.conf而非/etc/pacman.d/mirrorlist，因为有时更新系统会覆盖后者
    sudo sed -i '/^Include = /s/^.*$/Server = https:\/\/mirrors.cloud.tencent.com\/manjaro\/stable\/$repo\/$arch/' /etc/pacman.conf

    # pacman配置彩色输出与使用系统日志
    sudo sed -i -e "/^#Color$/s/#//" -e "/^#UseSyslog$/s/#//" /etc/pacman.conf

    # 添加腾讯云的archlinuxcn源
    if ! grep -q archlinuxcn /etc/pacman.conf ; then
        echo -e '[archlinuxcn]\nServer = https://mirrors.cloud.tencent.com/archlinuxcn/$arch' \
            | sudo tee -a /etc/pacman.conf
    fi
    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save

    # 更新系统，并准备下载软件包
    sudo pacman -Syyu
    sudo pacman -S archlinuxcn-keyring yay expac

    # 启动定时清理软件包服务
    sudo systemctl enable --now paccache.timer
}

function nvim_cfg() {
    # 围绕NeoVim搭建IDE
    yay -S base-devel gvim neovim-qt xsel python-pynvim cmake ctags global silver-searcher-git ripgrep \
        npm php shellcheck cppcheck clang gdb cgdb boost gtest gmock asio

    # 安装neovim配置
    backup ~/.SpaceVim
    git clone https://gitee.com/mrbeardad/SpaceVim ~/.SpaceVim

    makedir ~/.config
    backup ~/.config/nvim
    ln -s ~/.SpaceVim ~/.config/nvim

    backup ~/.SpaceVim.d
    ln -sfv ~/.SpaceVim/mode ~/.SpaceVim.d

    makedir ~/.local/bin
    g++ -O3 -DNDEBUG -std=c++17 -o ~/.local/bin/quickrun_time ~/.SpaceVim/custom/quickrun_time.cpp
}

function grub_cfg() {
    # 设置grub密码
    sudo cp -v grub/01_users /etc/grub.d
    sudo cp -v grub/user.cfg /boot/grub
    sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}

    yay -S grub-theme-tela-whitesur-1080p-git
    sudo cp -v grub/DNA.jpg /usr/share/grub/themes/tela-whitesur-1080p/background.jpg
    # 安装grub主题，自选png图片替代/usr/share/grub/themes/manjaro/background.png即可替换背景图片
    sudo sed -i '/^GRUB_DEFAULT=saved/s/^/#/; /^GRUB_THEME="\/usr\/share\/grub\/themes\/manjaro\/theme.txt"/s/manjaro/tela-whitesur-1080p/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

function ssh_cfg() {
    # 添加git push <remote>需要的ssh配置，提供了对github与gitee的配置
    makedir ~/.ssh
    cat ssh/ssh_config >> ~/.ssh/ssh_config

    # 安装我自己的ssh公私钥对。。。

    # 仓库中的.gitconfig提供了将`git difftool`中vimdiff链接到nvim的配置
    # 需要的话，修改后拷贝到家目录下
    cp -v .gitconfig ~

    # 配置sshd用于连接到该主机并启动sshd服务
    sudo sed -i -e "/^#Port 22$/s/.*/Port 50000/" -e "/^#PasswordAuthentication yes$/s/.*/PasswordAuthentication no/" /etc/ssh/sshd_config
    sudo systemctl enable --now sshd.service
}

function zsh_cfg() {
    # 安装插件配置
    yay -S oh-my-zsh-git autojump

    # 安装zshrc
    backup ~/.zshrc
    cp -v zsh/zshrc ~/.zshrc

    # 安装zsh主题
    sudo cp -v zsh/agnoster.zsh-theme /usr/share/oh-my-zsh/themes/
}


function tmux_cfg() {
    # 下载tmux和一个保存会话的插件
    yay -S tmux tmux-resurrect-git

    cp -v tmux/tmux.conf ~/.tmux.conf
}

function rime_cfg() {
    if [[ "$1" == fcitx5-rime ]] ;then
        # 下载fcitx5与rime
        yay -S fcitx5-git fcitx5-qt4-git fcitx5-qt5-git fcitx5-qt6-git fcitx5-gtk-git fcitx5-configtool-git \
            fcitx5-rime-git rime-double-pinyin rime-easy-en-git rime-emoji ssfconv

        # 下载fcitx5皮肤
        yay -S fcitx5-skin-simple-blue fcitx5-skin-base16-material-darker fcitx5-skin-dark-transparent \
            fcitx5-skin-dark-numix fcitx5-skin-materia-exp fcitx5-skin-arc
        makedir ~/.local/share/fcitx5/themes
        cp -vr ./fcitx5/themes/* ~/.local/share/fcitx5/themes

        # 安装fcitx5配置
        cp -vr ./fcitx5/{conf,config,profile} ~/.config/fcitx5/

        # 安装配置与词库
        makedir ~/.local/share/fcitx5/rime
        git submodule update --init
        ln -sv "$PWD"/rime-dict/ ~/.local/share/fcitx5/rime

        # 自动启动fcitx5
        cp -v /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
        echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile
    else
        yay -S fcitx-sogoupinyin fcitx-qt4 fcitx-configtool
        backup ~/.config/fcitx
        cp -rv fcitx ~/.config/fcitx
        echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx\nfcitx &"' > ~/.xprofile
    fi
}

function chfs_cfg() {
    # CHFS
    curl -Lo /tmp/chfs.zip http://iscute.cn/tar/chfs/2.0/chfs-linux-amd64-2.0.zip
    (
        cd /tmp || exit 1
        unzip /tmp/chfs.zip
        chmod 755 chfs
        sudo cp -v chfs /usr/local/bin
    )
    sudo cp -v chfs/chfs.{service,socket} /etc/systemd/system/
    sudo mkdir --mode=777 /srv/chfs
    sudo systemctl daemon-reload
    sudo systemctl enable --now chfs.socket
}

function cli_cfg() {
    cp -v bin/* ~/.local/bin
    backup ~/.cheat
    git clone https://github.com/mrbeardad/SeeCheatSheets ~/.cheat
    (
        cd ~/.cheat || exit 1
        ./src/install.sh
    )

    # CLI工具
    yay -S strace lsof tree lsd htop gtop iotop iftop dstat cloc screenfetch figlet cmatrix docker
    npm config set registry http://mirrors.cloud.tencent.com/npm/
    pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple
    pip install cppman gdbgui thefuck mycli
    cp -rv cppman ~/.cache/

    # 更改docker源
    sudo mkdir /etc/docker
    echo -e "{\n    \"registry-mirrors\": [\"http://hub-mirror.c.163.com\"]\n}" | sudo tee /etc/docker/daemon.json

    # 修改Manjaro默认的ranger配置，用于fzf与vim-defx预览文件
    sed -i '/^set show_hidden/s/false/true/;
    /^#map cw console rename%space/s/^.*$/map rn console rename%space/;
    /^map dD console delete$/s/dD/rm/' ~/.config/ranger/rc.conf
    sed -i '/highlight_format=xterm256/s/xterm256/ansi/' ~/.config/ranger/scope.sh

    # htop
    mkdir ~/.config/htop
    cp -v htop/htoprc ~/.config/htop

    # gdb与cgdb配置
    backup ~/.gdbinit
    cp -v gdb/gdbinit ~/.gdbinit
    makedir ~/.cgdb
    backup ~/.cgdb/cgdbrc
    cp -v gdb/cgdbrc ~/.cgdb
}

function desktop_cfg() {
    # 手动解析github域名
    cat hosts | sudo tee -a /etc/hosts

    # 桌面应用
    # wps-office ttf-wps-fonts
    yay -S deepin-wine-tim baidunetdisk-electron listen1-desktop-appimage \
        flameshot google-chrome guake gnome-terminal-transparency xfce4-terminal uget \
        vlc ffmpeg obs-studio peek fontforge nmap tcpdump wireshark-qt visual-studio-code-bin lantern-bin

    # GNOME扩展
    yay -S mojave-gtk-theme-git sweet-theme-git adapta-gtk-theme \
        breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git \
        tela-icon-theme-git candy-icons-git \
        gnome-shell-extension-coverflow-alt-tab-git gnome-shell-extension-system-monitor-git gnome-shell-extension-openweather \
        gnome-shell-extension-lockkeys-git gnome-shell-extension-topicons-plus-git

    # 切换Tim到deepin-wine5
    /opt/apps/com.qq.office.deepin/files/run.sh -d
    cp -v /usr/share/applications/com.qq.office.deepin.desktop ~/.config/autostart

    # Sweet-dark
    sudo cp -r /usr/share/themes/Sweet{,-dark}
    sudo cp -f /usr/share/themes/Sweet-dark/gtk-3.0/gtk{,-dark}.css
    sudo cp -f /usr/share/themes/Sweet-dark/gtk-3.0/gtk{,-dark}.scss

    # Tela-candy
    sudo cp -r /usr/share/icons/Tela{,-candy}
    sudo cp -f /usr/share/icons/candy-icons/places/48/* /usr/share/icons/Tela-candy/scalable/places

    # 安装字体
    yay -S ttf-google-fonts-git adobe-source-han-sans-cn-fonts ttf-hanazono ttf-joypixels unicode-emoji
    (
        makedir ~/.local/share/fonts/NerdCodePro
        cp fonts/*.ttf ~/.local/share/fonts/NerdCodePro
        cd ~/.local/share/fonts/NerdCodePro || exit 1
        mkfontdir && mkfontscale && fc-cache -fv .

        # makedir ~/.local/share/fonts/HandWrite
        # cd ~/.local/share/fonts/HandWrite || exit 1
        # git clone --depth=1 https://github.com/zjsxwc/handwrite-text ~/Downloads/handwrite-text
        # cp ~/Downloads/handwrite-text/font/* .
        # mkfontdir
        # mkfontscale
    )

    # xfce4-terminal配置
    makedir ~/.config/xfce4/terminal
    backup ~/.config/xfce4/terminal/terminalrc
    cp -v xfce4-terminal/terminalrc ~/.config/xfce4/terminal/terminalrc

    # TIM配置，启动TIM时禁用ipv6，否则不显示图片
    # echo "net.ipv6.conf.all.disable_ipv6 =1
# net.ipv6.conf.default.disable_ipv6 =1
# net.ipv6.conf.lo.disable_ipv6 =1" | sudo tee -a /etc/sysctl.conf

    cp -v /usr/share/applications/guake.desktop ~/.config/autostart/guake-tmux.desktop
    sed -i '/^Exec=guake/s/guake/guake -e "terminal-tmux.sh"/' ~/.config/autostart/guake-tmux.desktop

    # 安装gnome配置
    makedir ~/.config/dconf
    cp -v gnome/user ~/.config/dconf
}

function main() {
    dotfiles_dir=$PWD
    export dotfiles_dir
    system_cfg
    pacman_cfg
    nvim_cfg
    grub_cfg
    ssh_cfg
    zsh_cfg
    tmux_cfg
    rime_cfg
    chfs_cfg
    cli_cfg
    desktop_cfg
    echo -e '\e[33m=====> Install your ssh key for github'
    echo -e '\e[33m=====> Gnome dconf has been installed, logout immediately and back-in will apply it.
If it does not wrok, copy gnome/user to ~/.config/dconf/user manually, and then logout immediately and back-in will work.'
}

# 安装完镜像后后就改个sudoer & fstab配置，其他啥也不用动
main

