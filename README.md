# How to install
## Manjaro and Arch Linux
<font color=red>Note:</font>I had changed my archlinux into manjaro already before I built this repository, so there may be some problems to run the shell script on your archlinux.

First, enter your cloned repository directory  
```
$ cd DotFiles
```
Then run the shell script  
```
$ ./bin/init.sh {option}
```
`{option}` can be as follows
* `--help` list all options
* `--all` install all configurations
* `pacman` download some packages and modify ***pacman.conf*** and ***mirrorlist***
* `zsh` install zsh, oh-my-zsh, and my ***.zshrc*** and two zsh-theme
* `tmux` install tmux, a small tmux plugin, and my ***.tmux.conf***
* `ssh` it provide a ***ssh_config*** template to use github ssh key when you run `git push`, and modify sshd_config  on your host
* `chfs` download and install chfs (Cute Http File Server)
* `vim` configure your vim like IDE for C/C++
* `extra` download a lot of packages that I want (maybe you think the same?)
## Other Linux
Ok, you can't use *pacman* or *yay*, so copy the configuration files to your host and download these packages manully.
Anyway, the most important to you may be the files in vim directory.


