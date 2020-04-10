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

# $1 为 "-r" 时直接运行，剩余参数为quickrun_time的参数
# $1 为 "-c" 时编译并运行，且 $2 为需要编译的源文件，$3 为编译的目标文件，$4 为编译选项
if [[ "$1" == "-r" ]] ;then
    echo -e "\e[33mNote: Buffer was not changed. Rerunning last compiled program!\e[m"
    shift 1
elif [[ "$1" == "-c" ]] ;then
    echo -e "\e[1;32m[Compile]g++ $4 -O2 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I. -o $3 $2"
    g++ $4 -O2 -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC -I. -o $3 $2
    shift 4
fi

quickrun_time $@

