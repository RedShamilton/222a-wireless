#!/usr/bin/python
import sys
import os

if len(sys.argv) < 3:
    print "******Usage "+sys.argv[0]+" file \"filter\" fields*"
    print "Example: "+sys.argv[0]+" foo.pcap \"tcp and wlan.ra == 48:51:b7:a9:de:ef\" radiotap.vht.mcs.0"
    exit(1)

run="tshark -r "+sys.argv[1]+" -2 -R \""+sys.argv[2]+"\" -T fields"
fields=""
for f in sys.argv[3:]:
    fields+=" -e "+f

os.system(run+fields)
