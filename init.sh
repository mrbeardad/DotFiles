#!/bin/bash

function backup() {
    if [[ -z "$1" ]] ;then
        echo -e "\033[31mError: backup() required one parameter\033[m"
        exit 1
    elif [[ -e "$1" ]] ;then
        mv "$1" "$1".bak
    fi
}

function makedir() {
    if [[ -z "$1" ]] ;then
        echo -e "\033[31mError: makedir() required one parameter\033[m"
        exit 1
    elif [[ ! -d "$1" ]] ;then
        if [[ -e "$1" ]] ;then
            mv "$1" "$1".bak
        fi
        mkdir -p "$1"
    fi
}

function system_cfg() {
    # 开启ntp服务自动同步时间，并设置rtc让系统将主板时间当作本地时间（兼容windows）
    sudo timedatectl set-ntp 1 && timedatectl set-local-rtc 1
    sudo hwclock -w

    # 关闭蓝牙服务、打印服务，开启硬盘定时清理服务
    sudo systemctl disable --now bluetooth.service
    sudo systemctl disable --now org.cups.cupsd.service
    sudo systemctl enable --now fstrim.timer

    # 限制系统日志大小为100M
    sudo sed -i '/\[Journal\]/a\SystemMaxUse=100M' /etc/systemd/journald.conf

    # 笔记本电源，15%提醒电量过低，10%提醒即将耗尽电源，4%强制休眠(根据系统差异，也可能会关机)
    sudo sed -i '/^PercentageLow=/s/=.*$/=15/; /^PercentageCritical=/s/=.*$/=10/; /^PercentageAction=/s/=.*$/=3/' /etc/UPower/UPower.conf
}

function pacman_cfg() {
    # 修改pacman源为腾讯源，有时候更新系统会把mirrorlist覆盖了，备份一下，当发现下载速度奇慢无比时检查此项
    echo 'Server = https://mirrors.cloud.tencent.com/manjaro/stable/$repo/$arch' | sudo tee /etc/pacman.d/mirrorlist
    sudo cp /etc/pacman.d/mirrorlist{,.bak}
    # 或者直接修改/etc/pacman.conf可以解决此问题，就像init-for-myself.sh一样
    # sudo sed -i '/^Include = /s/^.*$/Server = https:\/\/mirrors.cloud.tencent.com\/manjaro\/stable\/$repo\/$arch/' /etc/pacman.conf

    # pacman彩色输出
    sudo sed -i "/^#Color/s/#//" /etc/pacman.conf

    # 添加腾讯云的archlinuxcn源
    if ! grep -q archlinuxcn /etc/pacman.conf ; then
        echo -e '[archlinuxcn]\nServer = https://mirrors.cloud.tencent.com/archlinuxcn/$arch' | sudo tee -a /etc/pacman.conf
    fi

    # 更新系统，并安装一些下载工具
    sudo pacman -Syyu
    sudo pacman -S archlinuxcn-keyring yay aria2 uget expac

    # 启动定时清理软件包服务
    sudo systemctl enable --now paccache.timer
}

function nvim_cfg() {
    # 围绕NeoVim搭建IDE
    yay -S base-devel neovim gvim xsel python-pynvim cmake ctags global silver-searcher-git ripgrep npm php markdown2ctags shellcheck cppcheck clang gdb cgdb boost mariadb mysql++
    # yay -S vim-youcompleteme-git

    # 安装neovim配置
    backup ~/.SpaceVim
    git clone https://gitee.com/mrbeardad/SpaceVim ~/.SpaceVim

    makedir ~/.config
    backup ~/.config/nvim
    ln -s ~/.SpaceVim ~/.config/nvim

    makedir ~/.SpaceVim.d
    backup ~/.SpaceVim.d/init.toml
    cp -v ~/.SpaceVim/mode/init.toml ~/.SpaceVim.d

    makedir ~/.local/bin
    g++ -O3 -std=c++17 -o ~/.local/bin/quickrun_time ~/.SpaceVim/custom/quickrun_time.cpp
    cp ~/.SpaceVim/custom/{nop.sh,vim-quickrun.sh} ~/.local/bin
}

function grub_cfg() {
    # 来自fedora的grub配置：
    # 使用`grub-mkpasswd-pbkdf2`命令获取加密密码，
    # 并在/boot/grub/user.cfg中定义`GRUB_PASSWORD`变量为该密码(可仿照仓库中的文件grub/user.cfg进行设置)，
    # 即可设置grub超级用户：超级用户名为`root`
    sudo cp -v grub/01_users /etc/grub.d
    if ! grep -q '--unrestricted' /etc/grub.d/{10_linux,30_os-prober} ;then
        sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}
    fi

    # 安装grub主题，自选png图片替代/usr/share/grub/themes/manjaro/background.png即可替换背景图片
    yay -S grub-theme-manjaro
    sudo cp -v grub/DNA.png /usr/share/grub/themes/manjaro/background.png
}

function ssh_cfg() {
    # 仓库中的.gitconfig提供了将`git difftool`中vimdiff链接到nvim的配置
    # 需要的话，修改后拷贝到家目录下
    # cp .gitconfig ~

    # 配置sshd用于连接到该主机并启动sshd服务
    sudo cp -v ssh/sshd_config /etc/ssh/sshd_config
    sudo systemctl enable --now sshd.service
}

function zsh_cfg() {
    # 安装插件配置
    yay -S oh-my-zsh-git powerline-fonts thefuck autojump
    # yay -S zsh zsh-syntax-highlighting zsh-autosuggestions

    # 安装zshrc
    backup ~/.zshrc
    cp -v zsh/zshrc ~/.zshrc

    # 安装zsh主题
    sudo cp -v zsh/*.zsh-theme /usr/share/oh-my-zsh/themes/

    # 设置zsh为默认shell，需要输入密码
    chsh -s /bin/zsh
}


function tmux_cfg() {
    # 下载tmux和一个保存会话的插件
    yay -S tmux tmux-resurrect-git

    cp -v tmux/tmux.conf ~/.tmux.conf
}

function rime_cfg() {
    # 下载fcitx5与rime
    yay -S fcitx5-git fcitx5-qt5-git fcitx5-qt4-git fcitx5-gtk fcitx5-config-qt-git fcitx5-rime rime-double-pinyin rime-emoji

    # 下载fcitx5皮肤
    makedir ~/.local/share/fcitx5/themes
    git clone https://github.com/weearc/fcitx5-skin-simple-blue.git  ~/.local/share/fcitx5/themes/simple-blue
    git clone https://github.com/hosxy/fcitx5-dark-transparent.git ~/.local/share/fcitx5/themes/fcitx5-dark-transparent

    # 安装配置与词库
    makedir ~/.local/share/fcitx5/rime
    git submodule update --init
    cp -rv rime-dict/* ~/.local/share/fcitx5/rime

    # 安装fcitx5配置
    cp -rv fcitx5 ~/.config

    # 让桌面程序使用fcitx5输入框架
    echo -e 'export GTK_IM_MODULE=fcitx5\nexport QT_IM_MODULE=fcitx5\nexport XMODIFIERS="@im=fcitx5"\nfcitx5 > /dev/null &\ndevilspie &' > ~/.xprofile
}

function chfs_cfg() {
    # CHFS
    (
        sudo mkdir -p /opt/bin
        cd /opt/bin || exit 1
        sudo unzip "$dotfiles_dir"/chfs/chfs-linux-amd64-1.8.zip
        sudo chmod 755 chfs
    )
    sudo cp -v chfs/chfs.{service,socket} /etc/systemd/system/
    sudo mkdir --mode=777 /srv/chfs
    sudo systemctl daemon-reload
    sudo systemctl enable --now chfs.socket
}

function cli_cfg() {
    # 安装say, see, terminal-tmux.sh，以及用于say, see修改和查看的cheat-sheets
    cp -v bin/terminal-tmux.sh ~/.local/bin
    backup ~/.cheat
    git clone https://github.com/mrbeardad/learning-notes-and-cheat-sheets ~/.cheat
    g++ -std=c++17 -o ~/.local/bin/see ~/.cheat/see.cpp

    # CLI工具
    yay -S htop iotop dstat cloc screenfetch figlet cmatrix
    pip install pip -U
    pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple
    sudo pip install gdbgui
    sudo pip3 install cppman
    # yay -S ncdu ranger

    makedir ~/.cache/cppman/cplusplus.com
    (
        cd /tmp || exit 1
        tar -zxf "$dotfiles_dir"/cppman/cppman_db.tar.gz
        cp -vn cplusplus.com/* ~/.cache/cppman/cplusplus.com
    )

    # 修改Manjaro默认的ranger配置，用于fzf与vim-defx预览文件
    sed -i '/^set show_hidden/s/false/true/;
    /^#map cw console rename%space/s/^.*$/map rn console rename%space/;
    /^map dD console delete$/s/dD/rm/' ~/.config/ranger/rc.conf
    sed -i '/highlight_format=xterm256/s/xterm256/ansi/' ~/.config/ranger/scope.sh

    # gdb与cgdb配置
    backup ~/.gdbinit
    cp -v gdb/gdbinit ~/.gdbinit
    makedir ~/.cgdb
    backup ~/.cgdb/cgdbrc
    cp -v gdb/cgdbrc ~/.cgdb
}

function desktop_cfg() {
    # 桌面应用
    yay -S deepin.com.qq.office baidunetdisk-bin netease-cloud-music wps-office ttf-wps-fonts \
        flameshot google-chrome guake xfce4-terminal devilspie

    # 其它工具：多媒体播放、多媒体处理、多媒体录制、gif录制、字体修改、渗透、抓包
    yay -S vlc ffmpeg obs-studio peek fontforge nmap tcpdump wireshark-qt
    # yay -S pepper-flash flashplugin 

    # GNOME扩展
    yay -S mojave-gtk-theme-git sweet-theme-git adapta-gtk-theme breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git tela-icon-theme-git \
        gnome-shell-extension-coverflow-alt-tab-git gnome-shell-extension-system-monitor-git gnome-shell-extension-openweather \
        gnome-shell-extension-lockkeys-git gnome-shell-extension-topicons-plus-git
    # yay -S  gnome-shell-extension-dash-to-dock-git gnome-shell-extension-dash-to-panel-git

    # 安装字体
    yay -S ttf-google-fonts-git adobe-source-han-sans-cn-fonts ttf-hanazono ttf-joypixels unicode-emoji
    (
        makedir ~/.local/share/fonts/NerdCode
        cd ~/.local/share/fonts/NerdCode || exit 1
        tar -Jxvf "$dotfiles_dir"/fonts/NerdCode.tar.xz
        mkfontdir
        mkfontscale

        # makedir ~/.local/share/fonts/HandWrite
        # cd ~/.local/share/fonts/HandWrite || exit 1
        # git clone --depth=1 https://github.com/zjsxwc/handwrite-text ~/Downloads/handwrite-text
        # cp ~/Downloads/handwrite-text/font/* .
        # mkfontdir
        # mkfontscale

        fc-cache -fv
    )

    # xfce4-terminal配置
    makedir ~/.config/xfce4/terminal
    backup ~/.config/xfce4/terminal/terminalrc
    cp -v xfce4-terminal/terminalrc ~/.config/xfce4/terminal/terminalrc

    # alacritty配置
    # makedir ~/.config/alacritty
    # backup ~/.config/alacrittyalacritty.yml
    # cp -v alacritty/alacritty.yml ~/.config/alacritty

    # 安装google-chrome插件
    (
        cd ~/.config/ || exit 1
        unzip "$dotfiles_dir"/chrome/google-access-helper-2.3.0.zip
        git clone --depth=1 https://github.com/orsharir/github-mathjax.git
    )

    # 手动解析github域名
    cat hosts | sudo tee -a /etc/hosts

    # TIM配置，启动TIM时禁用ipv6，否则不显示图片
    echo "net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1" | sudo tee -a /etc/sysctl.conf

    # 修改desktop文件
    yay -S prime
    makedir ~/.local/share/applications
    makedir ~/.config/autostart
    cp -v /usr/share/applications/{wps-office-*,google-chrome,nvim}.desktop ~/.local/share/applications
    cp -v /usr/share/applications/guake.desktop ~/.config/autostart/guake-self.desktop
    sed -i '/^Exec=/s/=.*$/=xfce4-terminal --maximize -x terminal-tmux.sh NeoVim/; /Terminal=/s/true/false/' ~/.local/share/applications/nvim.desktop
    sed -i '/^Exec=/s/=.*$/=guake -e "terminal-tmux.sh Guake"/' ~/.config/autostart/guake-self.desktop
    sed -i '/Exec=/s/=/=prime /' ~/.local/share/applications/wps-office-*
    sudo sed -i -e '/wine.*run\.sh/isudo sysctl -p /etc/sysctl.conf' -e '/wine.*run\.sh/s/^/prime /' /opt/deepinwine/apps/Deepin-TIM/run.sh
    sed -i '/Exec=/s/=/=prime /' ~/.local/share/applications/google-chrome.desktop

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

    echo -e '\e[32m=====> Chrome\e[m
    Now, add google-access-helper and github-mathjax in directory ~/.config to google-chrome in devloper mode'
    echo -e '\e[32m=====> Neovim\e[m
    Now, launch nvim and type :SPInstall. Build YCM and fix ALE after all plugins are installed '
    echo -e '\e[33m=====> Gnome dconf has been installed, logout immediately and back-in will apply it.
If it does not wrok, copy gnome/user to ~/.config/dconf/user manually, and then logout immediately and back-in will work.'
    # sweet-theme:dark, tela-icon:place, hp-uiscan:icon,
    # ~/Downloads/Baidu_NetDisk_Downloads/ ~/Downloads/Google_Chrome_Downloads/ 
    # automaically-login, user-profile-photo
}

# 安装完镜像后后就改个sudoer & fstab配置，其他啥也不用动
main

