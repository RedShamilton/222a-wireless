#!/bin/bash
if [ $# -lt 3  ]; then
    echo "******Usage $0 file \"filter\" fields*"
    echo "Example: $0 foo.pcap \"tcp and wlan.ra == 48:51:b7:a9:de:ef\" radiotap.vht.mcs.0"
    exit 1
fi

run="tshark -r $1 -2 -R $2 -T fields"
shift
shift
for var in $@; do
run=$run" -e $var"
done
echo $run
$run
