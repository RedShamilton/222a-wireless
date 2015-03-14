#!/bin/bash

#set ramfs size here
ramsize=4G

mkdir -p captures
 
mkdir -p ram_captures

sudo mount -t tmpfs -o size=3G tmpfs ram_captures/

name=captures/$1
i=1
if [[ -e $name.$i ]] ; then
    while [[ -e $name.$i ]] ; do
        let i++
    done
fi
name=ram_$name.$i


run="tcpdump -I -i mon0 -w $name"
#run="tshark -F pcapng -W n -w $name"
echo $run
eval $run

cp ram_captures/* captures/
umount ram_captures
