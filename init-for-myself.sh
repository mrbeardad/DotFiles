#!/bin/bash

#配置ssh
function ssh_cfg() {
    # 添加git push <remote>需要的ssh配置
    cp -v ssh/ssh_config ~/.ssh/ssh_config
    cp -v /mnt/ASUS/backup/id_ecdsa ~/.ssh

    # 设置sshd用于连接到该主机
    sudo cp -v ssh/sshd_config /etc/ssh/sshd_config

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
    yay -S gvim neovim xsel python-pynvim cmake ctags global cppcheck nerd-fonts-complete ripgrep vim-instant-markdown
    git clone git@gitee.com:mrbeardad/SpaceVim ~/.local/SpaceVim
    if [[ -d ~/.config/nvim ]] ;then
        mv ~/.config/{nvim,nvim.bak}
    fi
    ln -s ~/.local/SpaceVim ~/.config/nvim
    if [[ ! -d ~/.SpaceVim.d ]] ;then
        mkdir ~/.SpaceVim.d
    elif [[ -e ~/.SpaceVim.d/init.toml ]] ;then
        mv ~/.SpaceVim.d/init.toml{,bak}
    fi
    cp -v ~/.local/SpaceVim/mod/init.toml ~/.SpaceVim.d
    sudo cp -v bin/vim-quickrun.sh /opt/bin
    sudo cp -v bin/alacritty-tmux.sh /opt/bin
}

#安装额外的CLI工具、桌面软件、GNOME扩展
function extra_cfg() {
    #CHFS
    cd /opt/bin
    sudo unzip /mnt/ASUS/packages/chfs-linux-amd64-1.8.zip
    sudo chmod 755 chfs
    cd -
    sudo cp chfs/chfs.{service,socket} /etc/systemd/system/
    sudo mkdir /srv/chfs
    sudo chmod 777 /srv/chfs
    sudo systemctl daemon-reload
    sudo systemctl enable --now chfs.socket

    #CLI工具
    yay -S htop iotop ncdu tldr cloc screenfetch ranger figlet cmatrix cheat dstat cppman-git clang gdb
    cp -v gdb/.gdbinit ~

    #百度网盘，QQ，网易云音乐，搜狗拼音，WPS
    yay -S baidunetdisk-bin deepin.com.qq.office papper-flash flashplugin vlc netease-cloud-music fcitx-sogoupinyin fcitx-im fcitx-configtool ssf2fcitx-git fcitx-skins pinyin-completion wps-office ttf-wps-fonts flameshot google-chrome gnome-terminal-fedora alacritty

    mkdir ~/.config/alacritty
    cp -v alacritty/alacritty.yml ~/.config/alacritty

    cd ~/.config/google-chrome/
    unzip /mnt/ASUS/packages/google-access-helper-2.3.0.zip
    cd -

    #搜狗拼音配置
    echo -e 'export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile

    #QQ配置，禁用ipv6，否则不显示图片
    sudo bash -c 'echo "net.ipv6.conf.all.disable_ipv6 =1
    net.ipv6.conf.default.disable_ipv6 =1
    net.ipv6.conf.lo.disable_ipv6 =1" >> /etc/sysctl.conf'

    #GNOME扩展
    yay -S gtk-theme-macos-mojave sweet-theme-git adapta-gtk-theme-bin breeze-hacked-cursor-theme breeze-adapta-cursor-theme-git ttf-google-fonts-git adobe-source-han-sans-cn-fonts gnome-shell-extension-coverflow-alt-tab-git gnome-shell-extension-system-monitor-git
}


# function main() { 安装完后就改个sudo & fstab配置，其他啥也不用动

# 系统配置
timedatectl set-ntp 1 && timedatectl set-local-rtc 1
sudo systemctl disable --now bluetooth.service
sudo systemctl disable --now org.cups.cupsd.service
sudo systemctl enable --now fstrim.timer
sudo sed -i '/\[Journal\]/a\SystemMaxUse=100M' /etc/systemd/journald.conf
sudo sed -i '/^PercentageLow=/s/=.*$/=15/; /^PercentageCritical=/s/=.*$/=10/; /^PercentageAction=/s/=.*$/=3/' /etc/UPower/UPower.conf
sudo bash -c "mv /usr/local/* /opt && rmdir /usr/local && ln -s /opt /usr/local"

# pacman配置
sudo bash -c 'echo "Server = https://mirrors.cloud.tencent.com/manjaro/stable/$repo/$arch"
 > /etc/pacman.d/mirrorlist'
sudo cp /etc/pacman.d/mirrorlist{,.bak} # 有时候更新系统会把这个也更新了，备份一下
sudo sed -i "/#Color/s/#//" /etc/pacman.conf
sudo bash -c 'echo "[archlinuxcn]
Server = https://mirrors.cloud.tencent.com/archlinuxcn/\$arch" >> /etc/pacman.conf'
sudo pacman -Sy archlinuxcn-keyring
sudo pacman -Su
pacman -S yay aria2 expac base-devel
sudo systemctl enable --now paccache.timer

# grub配置
sudo cp grub/01_users /etc/grub.d
sudo cp grub/user.cfg /boot/grub
sudo sed -i '/--class os/s/--class os/--class os --unrestricted /' /etc/grub.d/{10_linux,30_os-prober}
yay -S grub-theme-manjaro

ssh_cfg
zsh_cfg
nvim_cfg
tmux_cfg
extra_cfg

# 修改desktop文件
cp -v /usr/share/applications/{google-chrome,wps-office-*,nvim}.desktop ~/.local/share/applications
echo '
[Desktop Entry]
Type=Application
Name=Terminal with Tmux
Comment=Startup terminal with tmux
Icon=utilities-terminal
Terminal=true
Exec=/opt/bin/terminal-tmux.sh
Categories=System;TerminalEmulator;
Keywords=Tmux;Terminal' > ~/.local/share/applications/tmux.desktop
sed -i '/^Name=/s/=.*$/=Neovim on Alacritty/; /TryExec=/s/^/#/; /^Exec=/s/=.*$/=alacritty -e alacritty-tmux.sh/; /Terminal=/s/true/false/' ~/.local/share/applications/nvim.desktop
sed -i '/^Exec=/s/=/=optirun /' ~/.local/share/applications/wps-office-*
sed -i '/^Exec=/s/=/=optirun /' ~/.local/share/applications/google-chrome.desktop
sudo sed -i -e '$isudo sysctl -p /etc/sysctl.conf}' -e '$s/^/optirun /' /opt/deepinwine/apps/Deepin-TIM/run.sh

echo -e "\e[32m=====> GRUB\e[m
Now you may want to change your grub theme.Some version of Manjaro don't install grub-theme-manjaro.
And you can may like to change the default .png picture. https://www.yasuotu.com/mgeshi provide online picture converter"
echo -e '\e[32m=====> Patches\e[m
Now, you may want to apply patches in patches directory'
echo -e '\e[32m=====>  Shortcut \e[m
Now you need to bind the gnome shortcut for terminal-tmux & neovim-alacritty'
echo -e '\e[32=====> Chrome\e[m
Now, add google-access-helper to your google-chrome in devloper mode'
echo -e '\e[32=====> Neovim\e[m
Now config your neovim by using files in DotFiles/vim'
# }

