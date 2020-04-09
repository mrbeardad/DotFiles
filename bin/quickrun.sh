#!/bin/bash -e

if [[ ! -d /tmp/QuickRun ]] ;then
    mkdir /tmp/QuickRun
fi

if [[ ! -d /sys/fs/cgroup/memory/test ]] ;then
    sudo mkdir /sys/fs/cgroup/memory/test
fi
echo $$ | sudo tee /sys/fs/cgroup/memory/test/cgroup.procs > /dev/null
echo 500M | sudo tee /sys/fs/cgroup/memory/test/memory.limit_in_bytes > /dev/null
echo 500M | sudo tee /sys/fs/cgroup/memory/test/memory.memsw.limit_in_bytes > /dev/null

# $1：-r直接运行，-c编译并运行
# $2：quickrun_time的参数
# $3：指定编译/运行的文件名以及参数
# $4：指定需要编译的文件
if [[ "$1" == "-r" ]] ;then
    echo -e "\e[33mNote: Rerunning last compiled program!\e[m"
elif [[ "$1" == "-c" ]] ;then
    g++ -std=c++11 -O2 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I. -o $2 $4
else
    echo -e "$0 Error: arguments error!"
    return 1
fi

quickrun_time $2 $3
