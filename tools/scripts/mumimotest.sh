#!/bin/sh
./tcpdump_capture.sh $1 &
./iperf_run_client.sh $1
killall tcpdump

