#!/usr/bin/python
import os

fltr="intel_"
dest="48:51:b7:a9:de:ef"
dtowalk="/home/twotwotwo/data/office/captures/"
for root,dirs,files in os.walk(dtowalk):
    for f in files:
        if fltr in f:
            os.system("../../project/tools/tshark_extract.py "+dtowalk+f+" \"wlan.da == "+dest+"\" radiotap.dbm_antsignal radiotap.vht.have_beamformed radiotap.vht.beamformed radiotap.vht.nss.0 > "+f+".dbm_beamq_beam_nss")
    break
