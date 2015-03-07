#!/bin/bash
if [ $# -ne 2 ]; then
	echo "Usage: ./stripcap.sh infile outfile"
	exit
fi
editcap -s 78 "$@"
