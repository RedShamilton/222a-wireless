#!/bin/bash
# Where is iperf3?
iperf_path=./iperf3
#1 gigabyte to send before done
size=1G
#Server to connect to
server=172.16.0.22
#set to -R to turn on server sends to client
reverse=-R
#default port
port=5201

########End Config###########
if [ $# -lt 1  ]; then
    echo "Usage $0 run_type(can be non-unique) port[if not 5201]"
    exit 1
fi

if [ $# -eq 2 ]; then
    port=$2
fi

mkdir -p results

mkdir -p ram_results

sudo mount -t tmpfs -o size=512M tmpfs ram_results/

name=results/$1
i=1
if [[ -e $name.$i ]] ; then
    while [[ -e $name.$i ]] ; do
        let i++
    done
fi
name=$name.$i
if hash unbuffer 2>/dev/null; then
    header=unbuffer
else
    header=
    echo "You don't have unbuffer, but this is running"
fi

run="$header $iperf_path -V -n $size -c $server -p $port $reverse | tee -a ram_$name"

date | tee $name
echo $run | tee -a $name
eval $run
mv ram_results/* results/
sudo umount ram_results