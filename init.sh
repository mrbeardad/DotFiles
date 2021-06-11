#!/bin/bash
# Copyright (c) 2020-2021 Heachen Bear & Contributors
# File: init.sh
# License: GPLv3
# Author: Heachen Bear <mrbeardad@qq.com>
# Date: 20.02.2021
# Last Modified Date: 11.06.2021
# Last Modified By: Heachen Bear <mrbeardad@qq.com>

function backup() {
    if [[ -z "$1" ]] ;then
        echo -e "\033[31mError:backup(): required one parameter\033[m"
        exit 1
    elif [[ -e "$1" ]] ;then
        backFileName="$1"
        while [[ -e "$backFileName" ]] ;do
            backFileName+=$RANDOM
        done
        mv -v "$1" "$backFileName"
    fi
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
    # 启动时间同步服务，使用本地RTC时间（兼容Windows）
    timedatectl set-ntp 1
    timedatectl set-local-rtc 1
    sudo hwclock -w

    # 开启硬盘定时清理服务
    sudo systemctl enable --now fstrim.timer

    # 限制系统日志大小为100M
    sudo sed -i '/^#SystemMaxUse=/s/.*/SystemMaxUse=100M/' /etc/systemd/journald.conf

    # 笔记本电源，20%提醒电量过低，10%提醒即将耗尽电源，3%强制休眠(根据系统差异，也可能会关机)
    sudo sed -i '/^PercentageLow=/s/=.*$/=20/; /^PercentageCritical=/s/=.*$/=10/; /^PercentageAction=/s/=.*$/=3/' /etc/UPower/UPower.conf
}

function pacman_cfg() {
    # 修改pacman源为腾讯源，直接改/etc/pacman.conf而非/etc/pacman.d/mirrorlist，因为有时更新系统会覆盖后者
    sudo sed -i '/^Include = /s/^.*$/Server = https:\/\/mirrors.cloud.tencent.com\/manjaro\/stable\/$repo\/$arch/' /etc/pacman.conf

    # 添加腾讯云的archlinuxcn源
    if ! grep -q archlinuxcn /etc/pacman.conf ; then
        echo -e '[archlinuxcn]\nServer = https://mirrors.cloud.tencent.com/archlinuxcn/$arch' \
            | sudo tee -a /etc/pacman.conf
    fi

    # pacman配置彩色输出与使用系统日志
    sudo sed -i "/^#Color$/s/#//; /^#UseSyslog$/s/#//; /^#TotalDownload/s/#//" /etc/pacman.conf


    # 更新系统，并准备下载软件包
    sudo pacman -Syyu
    sudo pacman -S archlinuxcn-keyring yay expac
    # yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save

    # 启动定时清理软件包服务
    sudo systemctl enable --now paccache.timer
}

function grub_cfg() {
    # 设置grub密码，只需创建/boot/grub/user.cfg并写入适当格式的内容，密码内容由grub-mkpasswd-pbkdf2命令生成
    sudo cp -v grub/01_users /etc/grub.d/
    if [[ "$USER" == beardad ]] ;then
        sudo cp -v grub/user.cfg /boot/grub
    fi

    # 默认开机时不需要grub密码，让grub密码只在修改选单时生效
    sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}

    # 添加grub选单
    echo '
menuentry "Power Off" --class shutdown --unrestricted {
    echo "System shutting down..."
    halt
}

menuentry "Reboot" --class reboot --unrestricted {
    echo "System is rebooting..."
    reboot
}'  | sudo tee -a /etc/grub.d/40_custom

    # 安装grub主题
    sudo cp -r grub/breeze-timer /usr/share/grub/themes/
    sudo sed -i '/^GRUB_DEFAULT=saved/s/^/#/;
        /^GRUB_TIMEOUT_STYLE=/s/=.*/=menu/;
        /^GRUB_CMDLINE_LINUX_DEFAULT=/s/=.*/="quiet splash"/;
        /^GRUB_THEME=/s/=.*/="\/usr\/share\/grub\/themes\/breeze-timer\/theme.txt"/;
        /^#GRUB_DISABLE_OS_PROBER=false/s/^#//;' /etc/default/grub

    # 根据配置文件重新生成grub启动脚本
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

function ssh_cfg() {
    # 提供了对github与gitee的ssh配置
    makedir ~/.ssh
    if [[ "$USER" == beardad ]] ;then
        cat ssh/ssh_config >> ~/.ssh/ssh_config

        ##################################
        ## 安装我自己的ssh公私钥对。。。##
        ##################################

        # .gitconfig提供了将`git difftool`中vimdiff链接到nvim的配置
        cp -v .gitconfig ~
    fi

    # 自动启动sshd服务，端口号改为50000，并只能密钥验证
    sudo sed -i -e "/^#Port 22$/s/.*/Port 50000/" -e "/^#PasswordAuthentication yes$/s/.*/PasswordAuthentication no/" /etc/ssh/sshd_config
    sudo systemctl enable --now sshd.service
}

function zsh_cfg() {
    # 下载zsh插件，有些插件Manjaro系统已自带
    yay -S oh-my-zsh-git autojump

    # 安装zsh配置
    backup ~/.zshrc
    cp -v zsh/zshrc ~/.zshrc

    # 安装zsh主题
    #sudo cp -v zsh/agnoster.zsh-theme /usr/share/oh-my-zsh/themes/
}


function tmux_cfg() {
    # 下载tmux和一个保存会话的插件
    yay -S tmux tmux-resurrect-git

    # 安装tmux配置
    cp -v tmux/tmux.conf ~/.tmux.conf
}

function rime_cfg() {
    # 下载fcitx5输入法框架与rime输入法引擎
    yay -S fcitx5-git fcitx5-qt4-git fcitx5-qt5-git fcitx5-qt6-git fcitx5-gtk-git \
        fcitx5-configtool-git ssfconv \
        fcitx5-rime-git rime-double-pinyin rime-dict-yangshann-git rime-emoji \
        rime-easy-en-git librime wordninja-rs

    # 安装fcitx5皮肤，由ssfconv转换搜狗输入法皮肤得到
    makedir ~/.local/share/fcitx5/themes
    cp -vr ./fcitx5/themes/* ~/.local/share/fcitx5/themes

    # 安装fcitx5配置
    makedir ~/.config/fcitx5
    cp -vr ./fcitx5/{conf,config,profile} ~/.config/fcitx5/

    # 安装rime配置与词库
    makedir ~/.local/share/fcitx5/rime
    git submodule update --init
    cp -rv rime-dict/* ~/.local/share/fcitx5/rime

    # 自动启动fcitx5
    echo '
GTK_IM_MODULE DEFAULT=fcitx
QT_IM_MODULE  DEFAULT=fcitx
XMODIFIERS    DEFAULT=\@im=fcitx
SDL_IM_MODULE DEFAULT=fcitx' > ~/.pam_environment
    cp -v /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart
}

function chfs_cfg() {
    # 下载并安装CHFS，一个小型局域网web服务器，用于共享文件
    curl -Lo /tmp/chfs.zip http://iscute.cn/tar/chfs/2.0/chfs-linux-amd64-2.0.zip
    (
        cd /tmp || exit 1
        unzip /tmp/chfs.zip
        chmod 755 chfs
        sudo cp -v chfs ~/.local/bin
    )
    makedir ~/.local/share/applications

    # 通过桌面图标启动chfs，并共享~/Public目录
    sed '/\$HOME/s/\$HOME/\/home\/'"$USERNAME"'/' chfs/chfs.desktop > ~/.local/share/applications/chfs.desktop

    # cp -v ~/.local/share/applications/chfs.desktop ~/.config/autostart
    # sudo cp -v chfs/chfs.{service,socket} /etc/systemd/system/
    # sudo mkdir --mode=777 /srv/chfs
    # sudo systemctl daemon-reload
    # sudo systemctl enable --now chfs.socket
}

function nvim_cfg() {
    # 围绕NeoVim搭建IDE
    yay -S base-devel gvim neovim-qt xsel python-pynvim \
        ripgrep silver-searcher-git global ctags \
        npm php \
        vim-language-server vint \
        bash-language-server shellcheck \
        go \
        clang cmake cmake-language-server


    # 安装github.com/mrbeardad/SpaceVim配置
    backup ~/.SpaceVim
    git clone https://github.com/mrbeardad/SpaceVim ~/.SpaceVim

    makedir ~/.config
    backup ~/.config/nvim
    ln -sv ~/.SpaceVim ~/.config/nvim

    backup ~/.SpaceVim.d
    ln -sv ~/.SpaceVim/mode ~/.SpaceVim.d

    # 编译QuickRun插件依赖，程序计时更精准
    makedir ~/.local/bin
    g++ -O3 -DNDEBUG -std=c++11 -o ~/.local/bin/quickrun_time ~/.SpaceVim/custom/quickrun_time.cpp
}

function cli_cfg() {
    # show-tim.sh、terminal-tmux.sh
    cp -v bin/* ~/.local/bin

    # 终端查询各种手册知识点：如C++库、Linux命令等
    backup ~/.cheat
    git clone https://github.com/mrbeardad/SeeCheatSheets ~/.cheat
    (
        makedir ~/.cheat/build
        cd ~/.cheat/build || exit 1
        cmake -D CMAKE_BUILD_TYPE=Release ..
        cmake --build .
        cmake --install .
    )

    # CLI工具
    yay -S strace lsof socat nmap tcpdump docker gist \
        gdb cgdb conan graphviz cppcheck boost asio gtest gmock \
        tree lsd htop bashtop iotop iftop dstat cloc \
        screenfetch toilet cowfortune cmatrix sl asciiquarium

    go env -w GOPATH="$HOME"/.local/go/
    go env -w GOBIN="$HOME"/.local/bin/
    go env -w GOPROXY=https://mirrors.cloud.tencent.com/go/,direct
    go get -u github.com/google/pprof
    npm config set registry http://mirrors.cloud.tencent.com/npm/
    pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple
    pip install cppman gdbgui thefuck mycli pylint flake8 bandit pudb ipython

    # pudb配置
    cp -rv pudb ~/.config

    # cppman配置
    makedir ~/.cache/cppman
    cp -rv cppman/* ~/.cache/cppman

    # gdb与cgdb配置
    backup ~/.gdbinit
    cp -v gdb/gdbinit ~/.gdbinit
    makedir ~/.cgdb
    backup ~/.cgdb/cgdbrc
    cp -v gdb/cgdbrc ~/.cgdb

    # docker配置
    sudo mkdir /etc/docker
    echo -e "{\n    \"registry-mirrors\": [\"http://hub-mirror.c.163.com\"]\n}" | sudo tee /etc/docker/daemon.json
    sudo systemctl enable --now docker.socket
    sudo docker pull alpine
    sudo docker pull mysql
    sudo docker pull nginx
    sudo gpasswd -a "$USER" docker

    # 修改Manjaro默认的ranger配置，用于fzf与vim-defx预览文件
    # sed -i '/^set show_hidden/s/false/true/;
    # /^#map cw console rename%space/s/^.*$/map rn console rename%space/;
    # /^map dD console delete$/s/dD/rm/' ~/.config/ranger/rc.conf
    # sed -i '/highlight_format=xterm256/s/xterm256/ansi/' ~/.config/ranger/scope.sh

    # htop配置
    mkdir ~/.config/htop
    cp -v htop/htoprc ~/.config/htop

}

function desktop_cfg() {
    # 解决DNS污染
    # sudo mv -fv hosts /etc/hosts
    sudo mv -fv dnsmasq.conf /etc/dnsmasq.conf
    # 使NetworkManager的DHCP不再自动更改/etc/resolv.conf转而更新/etc/resolv-dnsmasq.conf
    echo -e '[main]\nrc-manager=resolvconf' | sudo tee -a /etc/NetworkManager/NetworkManager.conf
    sudo sed -i '/^resolv_conf=/s/=.*/=\/etc\/resolv-dnsmasq.conf/' /etc/resolvconf.conf
    # 让系统使用本地搭建的DNS服务器
    echo -e 'nameserver 127.0.0.1\noptions edns. trust-ad' | sudo tee /etc/resolv.conf
    sudo systemctl enable --now dnsmasq.server
    sudo systemctl restart NetworkManager.server

    # 桌面应用
    # wps-office已被移出archlinuxcn源
    yay -S deepin-wine-tim deepin-wine-wechat mailspring listen1-desktop-appimage \
        flameshot google-chrome guake xfce4-terminal uget \
        vlc ffmpeg obs-studio peek fontforge wireshark-qt visual-studio-code-bin lantern-bin

    # GNOME扩展
    yay -S mojave-gtk-theme-git sweet-theme-git adapta-gtk-theme \
        breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git \
        tela-icon-theme-git candy-icons-git \
        gnome-shell-extension-coverflow-alt-tab-git gnome-shell-extension-system-monitor-git gnome-shell-extension-openweather \
        gnome-shell-extension-lockkeys-git gnome-shell-extension-topicons-plus

    # 切换Tim到deepin-wine5
    /opt/apps/com.qq.office.deepin/files/run.sh -d
    /opt/apps/com.qq.weixin.deepin/files/run.sh -d
    # cp -v /usr/share/applications/com.qq.office.deepin.desktop ~/.config/autostart

    # Sweet-dark主题
    sudo cp -r /usr/share/themes/Sweet{,-dark}
    sudo cp -vf /usr/share/themes/Sweet-dark/gtk-3.0/gtk{-dark,}.css
    sudo cp -vf /usr/share/themes/Sweet-dark/gtk-3.0/gtk{-dark,}.scss

    # Tela-candy图标
    sudo cp -r /usr/share/icons/Tela{,-candy}
    sudo cp -f /usr/share/icons/candy-icons/places/48/* /usr/share/icons/Tela-candy/scalable/places

    # NerdCodePro字体
    yay -S adobe-source-han-sans-cn-fonts ttf-wps-fonts ttf-joypixels unicode-emoji
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

    # 自动启动guake并执行terminal-tmux.sh脚本
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
    grub_cfg
    ssh_cfg
    zsh_cfg
    tmux_cfg
    rime_cfg
    chfs_cfg
    nvim_cfg
    cli_cfg
    desktop_cfg
    echo -e '\e[33m=====> Gnome dconf has been installed, logout immediately and back-in will apply it.'
}

# 安装完镜像后后就改个sudoer & fstab配置，其他啥也不用动
main "$@"

# SSH: ~/.ssh
# Mail: mailspring
# Font: comici.ttf
# WPS: backgroud
# TIM: login
# BaiduNetDisk: login
# Listen1: PlayList
# Nvidia: disable
# docker: mysql
