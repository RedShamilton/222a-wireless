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
            tmp = l.split()
            if len(tmp[0].split(',')) != 3:
                errs+=1
                continue
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
            a1,a2,_ = [float(a) for a in ants.strip().split(',')]
            if beamq2 == "1":
                beam.append([a1,a2])
            else:
                reg.append([a1,a2])
    reg = np.array(reg)
    beam = np.array(beam)

#    print "Errors:"+str(errs),
    return reg,beam

print "chip MHz location beamedpercent"
for root,dirs,files in os.walk("."):
    files.sort()
    for f in files:
        if "intel_" in f:
            fparts= f.split('.')[0].split('_')
            if "ft" in fparts[2]:
                fparts[2] = str(int(fparts[2].replace("ft",""))*12)
            print fparts[0]+" "+fparts[1].replace("MHz","")+" "+fparts[2].replace("wall","226.04645540242387").replace("water","277.90825824361536").replace("storage","617.1555719589672"),
            ra,ba = avg_file(f)
            print float(len(ba))/float(len(ba)+len(ra))

    break
