#!/usr/bin/python
import os
import numpy as np
def avg_file(fname):
    reg=[]
    regcnt=0.0
    beam=[]
    beamcnt=0.0
    errs = 0
    with open(fname,'r') as f:
        for l in f:
            if l[0] != '-':
                continue
            tmp = l.split()
            ants = tmp[0]
            if len(tmp) == 1:
                beamq = "0"
                beamq2 = "0"
            elif len(tmp) == 2:
                beamq = tmp[1]
                beamq2 = "0"
            else:
                beamq = tmp[1]
                beamq2 = tmp[2]
            a1 = ants
            a2 = 0
            if beamq2 == "1":
                beam.append([a1,a2])
            else:
                reg.append([a1,a2])
    reg = np.array(reg)
    beam = np.array(beam)

#    print "Errors:"+str(errs),
    return reg,beam

print "chip MHz location nobeamcnt nobeamant1 nobeamant2 nbt1std nbt2std beamct beamant1 beamant2 bt1std bt2std"
for root,dirs,files in os.walk("."):
    files.sort()
    for f in files:
        if "mac_" in f:
            fparts= f.split('.')[0].split('_')
            if "ft" in fparts[2]:
                fparts[2] = str(int(fparts[2].replace("ft",""))*12)
            print fparts[0]+" "+fparts[1].replace("MHz","")+" "+fparts[2].replace("wall","226.04645540242387").replace("water","277.90825824361536").replace("storage","617.1555719589672"),
            ra,ba = avg_file(f)
            print len(ra),
            if len(ra) > 0:
                av = np.average(ra,axis=0)
                print av[0],
                print av[1],
                sa = np.std(ra,axis=0)
                print sa[0],
                print sa[1],
            else:
                print "0 0 0 0",
            print len(ba),
            if len(ba) > 0:
                av = np.average(ba,axis=0)
                print av[0],
                print av[1],
                sa = np.std(ba,axis=0)
                print sa[0],
                print sa[1]
            else:
                print "0 0 0 0"

    break
