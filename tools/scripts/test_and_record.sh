#!/bin/sh
if [ $# -lt 1  ]; then
    echo "****FATAL****"
    echo "Usage $0 run_type(can be non-unique) port[if not 5201]"
    exit 1
fi
./tcpdump_capture.sh $1 &
sleep 1
echo "****** TCP Capture Started *********"
./iperf_run_server.sh $1
echo "****** Stopping Capture ********"
killall tcpdump
echo "****** Done ********"

