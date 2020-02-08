#!/bin/bash

#配置pacman
function pacman_cfg() {

    grep -q -E '[^#]*XferCommand' /etc/pacman.conf
    if [ $? -ne 0 ] ;then
	XferCommand='/usr/bin/aria2c --allow-overwrite=true --continue=true --file-allocation=none --log-level=error --max-tries=2 --max-connection-per-server=2 --max-file-not-found=5 --min-split-size=5M --no-conf --remote-time=true --summary-interval=60 --timeout=5 --dir=/ --out %o %u'
	sudo sed -i "/#Color/s/#//; /\[options\]/aXferCommand = $XferCommand" /etc/pacman.conf
    fi

    grep -q '\[archlinuxcn\]' /etc/pacman.conf
    if [ $? -ne 0 ] ;then
	echo -e '[archlinuxcn]\nSigLevel = Optional TrustAll\nServer = https://chinanet.mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
    fi

    grep -E '[^#].*ustc.edu.cn' /etc/pacman.d/mirrorlist
    if [ $? -ne 0 ] ;then
	ustc='Server = https://mirrors.ustc.edu.cn/manjaro/stable/$repo/$arch'
	tsinghua='Server = https://mirrors.tuna.tsinghua.edu.cn/manjaro/stable/$repo/$arch'
	tencent='Server = https://mirrors.cloud.tencent.com/manjaro/stable/$repo/$arch'

	sed -i "/Generated/a## China\n\n$ustc\n\n$tsing\n\n$tencent" /etc/pacman.d/mirrorlist
    fi

    #安装pacman额外工具
    pacman -Qs aria2 | grep -q 'local/aria2'
    if [ $? -ne 0 ] ;then
        aria2='aria2'
    else
        aria2=''
    fi

    pacman -Qs yay | grep -q 'local/yay'
    if [ $? -ne 0 ] ;then
	yay='yay'
    else
	yay=''
    fi
    pacman -Qs expac | grep -q 'local/expac'
    if [ $? -ne 0 ] ;then
	expac='expac'
    else
	expac=''
    fi
    pacman -Qs pacman-contrib | grep -q 'local/pacman-contrib'
    if [ $? -ne 0 ] ;then
	pacman_contrib='pacman-contrib'
    else
	pacman_contrib=''
    fi

    pacman -S $aria2 $yay $expac $pacman_contrib base-devel

    #启动定时清理软件包
    if [ $? -ne 0 ] ;then
	sudo systemctl enable --now paccache.timer
    fi
}

#配置zsh
function zsh_cfg() {

    #下载oh-my-zsh
    yay -S oh-my-zsh-git  powerline-fonts zsh-syntax-highlighting zsh-autosuggestions autojump

    #修改.zshrc中ZSH_THEME HYPHEN_INSENSITIVE ENABLE_CORRECTION=  COMPLETION_WAITING_DOTS HIST_STAMPS plugins
    sed -r -i "/ZSH_THEME/s/=.*/=agnoster-time/;
    /HYPHEN_INSENSITIVE/s/#+//;
    /COMPLETION_WAITING_DOTS/s/#+//;
    /HIST_STAMPS/{s/#+//; s/=.*/=yyyy-mm-dd/};
    /[^#].*plugins=/s/=.*/=(git cp extract autojump)/" ~/.zshrc

    #添加alias和man() 
    cat zshrc >> ~/.zshrc
    cp zsh/*.zsh-theme ~/.oh-my-zsh/themes/
    chsh -s /bin/zsh
    #添加Linux笔记，用seec和seep查询
    if [ ! -e ~/.cheat ] ;then
	mkdir ~/.cheat
    cp Linux.note ~/.cheat
    fi
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

    cp -f vim/vimrc ~/.vim/vimrc
    cp -f vim/gvimrc ~/.vim/gvimrc

    yay -S gvim vim-plug cmake ctags gperf

    echo -e '\e[32m Note:\e[m The plugin "YouCompleteMe" can be download form your Arch/Manjaro mirrors. You may need to modify you vimrc if do so.'
     
    echo -e ' And the plugin "LeaderF" can work with gtags, you can download it at http://tamacom.com/global/global-6.6.4.tar.gz ,and you need to compile it in your machine.'
    echo -e ' How to do is written on the website, and donot forget to \e33m"sudo make install"'

    echo -e '\e[32mStartup your vim and run the command ":PlugInstall"'
}

function ssh_cfg() {

    mv /etc/ssh/sshd_config{,.bak}
    cp ssh/sshd_config /etc/ssh/sshd_config
    mv ~/.ssh/ssh_config{,.bak}
    cp  ssh/ssh_config ~/.ssh/ssh_config
    sudo systemctl enable --now sshd.socket
    echo -e "\e[33m Note:\e[m Now you need to push your ~/.ssh/id_ecdsa.pub to your github account"
    echo -e 'To generate public private key, run command: \e[32mssh-keygen -t ecdsa -b 512 -C "yourname@youremail"'

    #找不到好地方放，就放这儿吧，虽然跟ssh没多大关系
    sed -i '/\[Journal\]/a\SystemMaxUse=50M' /etc/systemd/journald.conf

}


#配置tmux
function tmux_cfg() {

    if [ ! -e ~/.tmux ] ;then
	mkdir ~/.tmux
    fi

    if [ -e ~/.tmux.conf ] ;then
	mv ~/.tmux.conf{,.bak}
    fi

    cp tmux/.tmux.conf ~/.tmux/.tmux.conf
    yay -S tmux-resurrect-git
}

#安装chfs
function chfs_cfg() {
    set -e
    cd /opt
    curl -o chfs-linux-amd64-2.0.zip https://iscute.cn/tar/chfs/2.0/chfs-linux-amd64-2.0.zip
    unzip chfs-linux-amd64-2.0.zip
    cp chfs-linux-amd64-2.0 /usr/local/bin

    cd -
    cp chfs/chfs.{service,socket} /etc/systemd/system/
    chmod 755 /usr/local/bin/chfs
    mkdir /srv/chfs
    chmod 755 /srv/chfs
    systemctl daemon-reload
    systemctl enable --now chfs.socket
    set +e
}

#安装额外的CLI工具、桌面软件、GNOME扩展
function extra() {

    #CLI工具
    yay -S sendemail htop iotop ncdu tldr cloc screenfetch ranger figlet cmatrix cheat dstat ntfs-3g

    #百度网盘，QQ，网易云音乐，搜狗拼音，WPS
    yay -S baidunetdisk-bin qq-linux netease-cloud-music fcitx-sogoupinyin fcitx-im fcitx-configtool wps-office ttf-wps-fonts flameshot google-chrome
    #搜狗拼音配置
    echo -e 'export GTK_IM_MODULE=fcitx\nexport GTK_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile
    #WPS配置
    sed -i '1a\export XMODIFIERS="@im=fcitx"\nexport QT_IM_MODULE="fcitx"\n' /usr/bin/wps

    #GNOME扩展
    yay -S majave-gtk-theme breeze-hacked-cursor-theme-bin papirus-icon-theme adapta-gtk-theme-bin adobe-source-han-sans-cn-fonts tela-icon-theme-git coverflow-alt-tab system-monitor gnome-shell-extension-coverflow-alt-tab gnome-shell-extension-system-monitor-git
    curl -o /usr/local/bin http://archibold.io/sh/archibold

}


#function main() {


#}