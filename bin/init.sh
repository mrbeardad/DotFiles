#!/bin/bash

#配置pacman
function pacman_cfg() {
    pacman -Qs aria2 | grep -q 'local/aria2'
    if [ $? -ne 0 ] ;then
	pacman -S aria2
    fi

    grep -q -E '[^#].*XferCommand' /etc/pacman.conf
    if [ $? -ne 0 ] ;then
	XferCommand1='/usr/bin/aria2c --allow-overwrite=true --continue=true --file-allocation=none --log-level=error'
	XferCommand2=' --max-tries=2 --max-connection-per-server=2 --max-file-not-found=5 --min-split-size=5M --no-conf --remote-time=true --summary-interval=60 --timeout=5 --dir=/ --out %o %u'
	sed -i "/#Color/s/#//; /\[options\]/aXferCommand = $XferCommand1$XferCommand2" /etc/pacman.conf
    fi

    grep -q '\[archlinuxcn\]' /etc/pacman.conf
    if [ $? -ne 0 ] ;then
	echo '[archlinuxcn]
	SigLevel = Optional TrustAll
	Server = https://chinanet.mirrors.ustc.edu.cn/archlinuxcn/$arch
	' >> /etc/pacman.conf
    fi

    grep -E '[^#].*ustc.edu.cn' /etc/pacman.d/mirrorlist
    if [ $? -ne 0 ] ;then
	ustc='Server = https://mirrors.ustc.edu.cn/manjaro/stable/$repo/$arch'
	tsinghua='Server = https://mirrors.tuna.tsinghua.edu.cn/manjaro/stable/$repo/$arch'
	tencent='Server = https://mirrors.cloud.tencent.com/manjaro/stable/$repo/$arch'

	sed -i "/Generated/a## China\n\n$ustc\n\n$tsing\n\n$tencent" /etc/pacman.d/mirrorlist
    fi

    #安装pacman额外工具
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
    pacman -S $yay $expac $pacman_contrib base-devel

    #启动定时清理软件包
    systemctl status paccache.timer | grep -q 'active'
    if [ $? -ne 0 ] ;then
	systemctl enable --now paccache.timer
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
    mkdir ~/.vim/undo
    cp vim/vimrc ~/.vim/vimrc
    cp vim/gvimrc ~/.vim/gvimrc
}

#systemd edit sshd.socket
#/etc/ssh/sshd_config
#~/.ssh/{config,authorized_keys}
function ssh_cfg() {

    mv /etc/ssh/sshd_config{,.bak}
    cp ssh/sshd_config /etc/ssh/sshd_config
    mv ~/.ssh/ssh_config{,.bak}
    cp  ssh/ssh_config ~/.ssh/ssh_config
    echo -e "\e[31mNow you need to push your ~/.ssh/id_ecdsa.pub to your github account\e[0m"
}

#配置systemd-journald
function journal_cfg() {

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
    useradd -r -s/usr/bin/nologin chfs
    mkdir /srv/chfs
    chmod 755 /srv/chfs
    systemctl daemon-reload
    systemctl enable --now chfs.socket
    set +e
}

#安装额外工具
function extra_tool() {

#CLI工具
    yay -S sendemail htop iotop ncdu tldr cloc screenfetch ranger figlet cmatrix cheat dstat ntfs-3g
    if [ ! -e ~/.cheat ] ;then
	mkdir ~/.cheat
    cp Linux.note ~/.cheat
    fi
#搜狗拼音
    yay -S fcitx-sogoupinyin fcitx-im fcitx-configtool
    echo -e 'export GTK_IM_MODULE=fcitx\nexport GTK_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"' > ~/.xprofile
#WPS
    yay -S wps-office ttf-wps-fonts
    sed -i '1a\export XMODIFIERS="@im=fcitx"\nexport QT_IM_MODULE="fcitx"\n' /usr/bin/wps
#百度网盘
    yay -S baidunetdisk-bin
#QQ
    yay -S qq-linux
#网易云音乐
    yay -S netease-cloud-music
}


#function main() {


#}
