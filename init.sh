#!/bin/bash

function system_cfg() {
    # 开启ntp服务自动同步时间，并设置rtc让系统将主板时间当作本地时间(兼容windows)
    sudo timedatectl set-ntp 1 && timedatectl set-local-rtc 1
    sudo hwclock -w

    # 关闭蓝牙服务、打印服务，开启硬盘定时清理服务
    sudo systemctl disable --now bluetooth.service
    sudo systemctl disable --now org.cups.cupsd.service
    sudo systemctl enable --now fstrim.timer

    # 限制系统日志大小为100M
    sudo sed -i '/\[Journal\]/a\SystemMaxUse=100M' /etc/systemd/journald.conf

    # 笔记本电源，15%提醒电量过低，10%提醒即将耗尽电源，3%强制休眠(根据系统差异，也可能会关机)
    sudo sed -i '/^PercentageLow=/s/=.*$/=15/; /^PercentageCritical=/s/=.*$/=10/; /^PercentageAction=/s/=.*$/=3/' /etc/UPower/UPower.conf

    # 将/usr/local改为/opt的软链接，强迫症福音
    if [[ -d /usr/local ]] ;then
        sudo mv /usr/local/* /opt
        sudo rmdir /usr/local
        sudo ln -s /opt /usr/local
    fi
}

function pacman_cfg() {
    # 改用腾讯源
    echo "Server = https://mirrors.cloud.tencent.com/manjaro/stable/\$repo/\$arch" | sudo tee /etc/pacman.d/mirrorlist
    # 有时候更新系统会把mirrorlist覆盖了，备份一下，当发现下载速度奇慢无比时，检查此项
    sudo cp /etc/pacman.d/mirrorlist{,.bak}

    # pacman彩色输出
    sudo sed -i "/^#Color/s/#//" /etc/pacman.conf

    # 添加腾讯源的archlinuxcn源
    if ! grep -q archlinuxcn /etc/pacman.conf ; then
        echo -e '[archlinuxcn]\nServer = https://mirrors.cloud.tencent.com/archlinuxcn/$arch' | sudo tee -a /etc/pacman.conf
    fi
    sudo pacman -S archlinuxcn-keyring

    # 更新系统，并安装一些下载工具和开发工具
    sudo pacman -Syyu
    sudo pacman -S yay aria2 uget expac base-devel clang gdb cgdb

    # 启动定时清理软件包服务
    sudo systemctl enable --now paccache.timer
}

function grub_cfg() {
    # 来自fedora的grub配置：
    # 使用`grub-mkpasswd-pbkdf2`命令获取加密密码，
    # 并在/boot/grub/user.cfg中定义GRUB_PASSWORD变量为该密码(可仿照仓库中的文件grub/user.cfg进行设置)，
    # 即可设置grub超级用户：超级用户名为`root`
    sudo cp -v grub/01_users /etc/grub.d
    if ! grep -q '--unrestricted' /etc/grub.d/{10_linux,30_os-prober} ;then
        sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}
    fi

    # 安装grub主题，自选png图片替代/usr/share/grub/themes/manjaro/background.png即可替换背景图片
    yay -S grub-theme-manjaro
}

function ssh_cfg() {
    if [ ! -d ~/.ssh ] ;then
        mkdir ~/.ssh
    fi
    # 添加git push <remote>需要的ssh配置，提供了对github与gitee的配置
    # 可以将密钥改为自己喜欢的
    # cat ssh/ssh_config >> ~/.ssh/ssh_config

    # 仓库中的.gitconfig提供了将`git difftool`中vimdiff链接到nvim的配置
    # 需要的话，修改后拷贝到家目录下
    # 设置sshd用于连接到该主机
    sudo cp -v ssh/sshd_config /etc/ssh/sshd_config

    # 启动ssh服务
    sudo systemctl enable --now sshd.service
}

function zsh_cfg() {
    # 安装插件配置
    yay -S autojump oh-my-zsh-git powerline-fonts thefuck
    # yay -S zsh zsh-syntax-highlighting zsh-autosuggestions

    # 安装zshrc
    if [[ -e ~/.zshrc ]] ;then
        mv ~/.zshrc{,.bak}
    fi
    cp -v zsh/zshrc ~/.zshrc

    # 安装zsh主题
    sudo cp -v zsh/*.zsh-theme /usr/share/oh-my-zsh/themes/

    # 设置zsh为默认shell，需要输入密码
    chsh -s /bin/zsh
}


function tmux_cfg() {
    # 下载tmux和一个保存会话的插件
    yay -S tmux tmux-resurrect-git

    # 安装tmux.conf，tmux默认并只读取~/.tmux.conf，不过我在bin/terminal-tmux.sh中我设置了读取该位置
    if [[ ! -e ~/.tmux ]] ;then
        mkdir ~/.tmux
    fi
    cp -v tmux/tmux.conf ~/.tmux
    if [[ -e ~/.tmux.conf ]] ;then
        mv ~/.tmux.conf{,.bak}
    fi
    cp -v tmux/tmux.conf ~/.tmux.conf
}

function nvim_cfg() {
    # 安装neovim配置需要的所有软件包
    yay -S gvim neovim xsel python-pynvim cmake ctags global cppcheck  ripgrep npm php markdown2ctags
    # yay -S vim-youcompleteme-git

    # 安装neovim配置
    if [[ -d ~/.SpaceVim ]] ;then
        mv ~/.SpaceVim{,.bak}
    fi
    git clone https://gitee.com/mrbeardad/SpaceVim ~/.SpaceVim

    if [[ ! -d ~/.config ]] ;then
        mkdir ~/.config
    elif [[ -e ~/.config/nvim ]] ;then
        mv ~/.config/nvim{,.bak}
    fi
    ln -s ~/.SpaceVim ~/.config/nvim

    if [[ ! -d ~/.SpaceVim.d ]] ;then
        mkdir ~/.SpaceVim.d
    elif [[ -e ~/.SpaceVim.d/init.toml ]] ;then
        mv ~/.SpaceVim.d/init.toml{,bak}
    fi
    cp -v ~/.SpaceVim/mode/init.toml ~/.SpaceVim.d
    if [[ ! -d ~/.local/bin ]] ;then
        mkdir -p ~/.local/bin
    fi
    sudo g++ -O3 -o ~/.local/bin/quickrun_time ~/.SpaceVim/custom/quickrun_time.cpp
}

function rime_cfg() {
    # 下载fcitx5与rime
    yay -S fcitx5-git fcitx5-qt5-git fcitx5-qt4-git fcitx5-gtk kcm-fcitx5 fcitx5-rime rime-doublepinyin rime-emoji

    # 下载fcitx5皮肤
    if [[ ! -d ~/.local/share/fcitx5/themes ]] ;then
        mkdir -p ~/.local/share/fcitx5/themes
    fi
    git clone https://github.com/weearc/fcitx5-skin-simple-blue.git  ~/.local/share/fcitx5/themes/simple-blue
    git clone https://github.com/hosxy/fcitx5-dark-transparent.git ~/.local/share/fcitx5/themes/fcitx5-dark-transparent

    # 安装配置与词库
    if [[ ! -d ~/.local/share/fcitx5/rime ]] ;then
        mkdir -p ~/.local/share/fcitx5/rime
    fi
    git submodule update --init
    cp -rv rime-dict/* ~/.local/share/fcitx5/rime

    # 让桌面程序使用fcitx5输入框架
    echo -e 'export GTK_IM_MODULE=fcitx5\nexport QT_IM_MODULE=fcitx5\nexport XMODIFIERS="@im=fcitx5"\nfcitx5 > /dev/null &' > ~/.xprofile
}

#安装额外的CLI工具、桌面软件、GNOME扩展
function extra_cfg() {
    # CHFS
    cd /opt/bin
    sudo unzip ${dotfiles_dir}/chfs-linux-amd64-1.8.zip
    sudo chmod 755 chfs
    cd -
    sudo cp -v chfs/chfs.{service,socket} /etc/systemd/system/
    sudo mkdir --mode=777 /srv/chfs
    sudo systemctl daemon-reload
    sudo systemctl enable --now chfs.socket

    # CLI工具
    yay -S htop iotop dstat cloc screenfetch figlet cmatrix cppman-git
    # yay -S ncdu ranger

    # 桌面应用
    yay -S deepin.com.qq.office pepper-flash flashplugin vlc netease-cloud-music wps-office ttf-wps-fonts \
        flameshot google-chrome guake xfce4-terminal alacritty
    # yay -S octave gimp

    # GNOME扩展
    yay -S sweet-theme-git breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git tela-icon-theme-git \
        gnome-shell-extension-coverflow-alt-tab-git gnome-shell-extension-system-monitor-git \
        gnome-shell-extension-dash-to-panel-git gnome-shell-extension-lockkeys-git gnome-shell-extension-topicons-plus-git
    # yay -S gtk-theme-macos-mojave adapta-gtk-theme-bin gnome-shell-extension-dash-to-dock-git

    # 安装字体
    yay -S adobe-source-han-sans-cn-fonts ttf-hanazono ttf-joypexels unicode-emoji nerd-fonts-source-code-pro nerd-fonts-space-mono ttf-blex-nerd-font-git
    if [[ ! -d ~/.local/share/fonts/NerdCode ]] ;then
        mkdir -p ~/.local/share/fonts/NerdCode
    fi
    cd ~/.local/share/fonts/NerdCode
    tar -Jxvf ${dotfiles_dir}/fonts/NerdCode.tar.xz
    mkfontdir
    mkfontscale
    fc-cache -fv
    cd -

    # gdb与cgdb配置
    if [[ -e ~/.gdbinit ]] ;then
        mv ~/.gdbinit{,.bak}
    fi
    cp -v gdb/gdbinit ~/.gdbinit
    if [[ ! -e ~/.cgdb ]] ;then
        mkdir ~/.cgdb
    fi
    cp -v gdb/cgdbrc ~/.cgdb

    # xfce4-terminal配置
    if [[ ! -d ~/.config/xfce4/terminal ]] ;then
        mkdir -p ~/.config/xfce4/terminal
    elif [[ -e ~/.config/xfce4/terminal/terminalrc ]] ;then
        mv ~/.config/xfce4/terminal/terminalrc{,.bak}
    fi
    cp -v xfce4-terminal/terminalrc ~/.config/xfce4/terminal/terminalrc

    # alacritty配置
    # if [[ ! -d ~/.config/alacritty ]] ;then
    #     mkdir ~/.config/alacritty
    # elif [[ -e ~/.config/alacritty/alacritty.yml ]] ;then
    #     mv ~/.config/alacritty/alacritty.yml{,.bak}
    # fi
    # cp -v alacritty/alacritty.yml ~/.config/alacritty

    # 安装google-access-helper
    cd ~/.config/
    unzip $dotfiles_dir/chrome/google-access-helper-2.3.0.zip
    cd -

    # TIM配置，启动TIM时禁用ipv6，否则不显示图片
    sudo bash -c 'echo "net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1" >> /etc/sysctl.conf'
}

function bin_cfg() {
    if [[ ! -d ~/.local/bin ]] ;then
        mkdir -p ~/.local/bin
    fi
    cp -v bin/* ~/.local/bin

    # 修改desktop文件
    yay -S prime
    if [[ ! -d ~/.local/share/applications ]] ;then
        mkdir -p ~/.local/share/applications
    fi
    cp -v /usr/share/applications/{google-chrome,wps-office-*,nvim}.desktop ~/.local/share/applications
    sed -i '/^Exec=/s/=.*$/=xfce4-terminal -e neovim.sh/; /Terminal=/s/true/false/' ~/.local/share/applications/nvim.desktop
    sudo sed -i -e '$isudo sysctl -p /etc/sysctl.conf' -e '$s/^/prime /' /opt/deepinwine/apps/Deepin-TIM/run.sh
    sed -i '/Exec=/s/=/=prime /' ~/.local/share/applications/wps-office-*
    sed -i '/Exec=/s/=/=prime /' ~/.local/share/applications/google-chrome.desktop
}

function main() {
    export dotfiles_dir=$(pwd)
    system_cfg
    pacman_cfg
    grub_cfg
    ssh_cfg
    zsh_cfg
    tmux_cfg
    nvim_cfg
    rime_cfg
    extra_cfg
    bin_cfg

    echo -e '\e[32=====> Chrome\e[m
    Now, add google-access-helper to google-chrome in devloper mode'
    echo -e '\e[32=====> Neovim\e[m
    Now, launch neovim and type :SPInstall'
    echo -e '\e[32=====> Desktop\e[m
    Now, dconf org.gnome.desktop.wm.preferences.button-layout & setting & tweak & extension.'
}

# 安装完镜像后后就改个sudoer & fstab配置，其他啥也不用动
main

