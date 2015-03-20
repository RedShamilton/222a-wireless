using Gadfly
using DataFrames
using Dates
using RDatasets
using Cairo
c1 = color("darkgreen")
c2 = color("purple")
wallcolor=color("blue")

analysis="/home/dkohlbre/class/222a/analysis/"
figures="/home/dkohlbre/class/222a/project/paper/final/figures/"

function getmhz(x,v)
    ys = x[x[:MHz].== v,:]
    ys = sort(ys,cols= :location)
    return ys
end

linethk = 0.1mm
xinch=6inch
yinch=5inch

thm1 = Theme(line_width=linethk,
            default_color=c1,
            bar_spacing=0.5inch)

thm2 = Theme(line_width=linethk,
            default_color=c2,
            bar_spacing=0.5inch)


function drawlines1(x1,y1,std1,xl,yl,name)
    draw(PDF(figures*replace(name," ","_")*".pdf", xinch,yinch),
         plot(
              layer(x=x1,
                    y=y1,
                    ymin=y1-std1,
                    ymax=y1+std1,
                    thm1, Geom.point,Geom.errorbar,Geom.line),
              Guide.xlabel(xl),Guide.ylabel(yl)))
end

function drawbar(x1,y1,lbl,xl,yl,name)
    draw(PDF(figures*replace(name," ","_")*".pdf", xinch,yinch),
         plot(
              x=x1,
              y=y1,
              thm1,
              Scale.x_discrete(labels=c->lbl[c+1]),
              Scale.y_continuous(minvalue=0),
              Geom.bar,
              Guide.xlabel(xl),Guide.ylabel("Percentage of beamformed packets")))
end

function drawlines2walls(x1,y1,std1,x2,y2,std2,t1,t2,xl,yl,name)
    draw(PDF(figures*replace(name," ","_")*".pdf", xinch,yinch),
         plot(
              layer(x=x1,
                    y=y1,
                    ymin=y1-std1,
                    ymax=y1+std1,
                    color=[t1],
                    Theme(line_width=linethk,default_color=c1), Geom.point,Geom.errorbar,Geom.line),
              layer(x=x2,
                    y=y2,
                    ymin=y2-std2,
                    ymax=y2+std2,
                    color=[t2],
                    Theme(line_width=linethk,default_color=c2), Geom.point,Geom.errorbar,Geom.line),
              layer(
                    xintercept=[18.0, 22.0,30.0,50.0],
                    Geom.vline(color=wallcolor, size=0.1mm),
                    color=["Walls"]
                    ),
    Guide.xlabel(xl),Guide.ylabel(yl),Scale.color_discrete_manual(c1,c2,wallcolor)))
end

function drawlines2(x1,y1,std1,x2,y2,std2,t1,t2,xl,yl,name)
    draw(PDF(figures*replace(name," ","_")*".pdf", xinch,yinch),
         plot(
              layer(x=x1,
                    y=y1,
                    ymin=y1-std1,
                    ymax=y1+std1,
                    color=[t1],
                    thm1, Geom.point,Geom.errorbar,Geom.line),
              layer(x=x2,
                    y=y2,
                    ymin=y2-std2,
                    ymax=y2+std2,
                    color=[t2],
                    thm2, Geom.point,Geom.errorbar,Geom.line),
    Guide.xlabel(xl),Guide.ylabel(yl),Guide.title(name),Scale.color_discrete_manual(c1,c2)))
end

function drawlines4(x1,y1,std1,x2,y2,std2,x3,y3,std3,x4,y4,std4,t1,t2,t3,t4,xl,yl,name)
    draw(PDF(figures*replace(name," ","_")*".pdf", xinch,yinch),
         plot(
              layer(x=x1,
                    y=y1,
                    ymin=y1-std1,
                    ymax=y1+std1,
                    color=[t1],
                    thm1, Geom.point,Geom.errorbar,Geom.line),
              layer(x=x2,
                    y=y2,
                    ymin=y2-std2,
                    ymax=y2+std2,
                    color=[t2],
                    thm1, Geom.point,Geom.errorbar,Geom.line),
              layer(x=x3,
                    y=y3,
                    ymin=y3-std3,
                    ymax=y3+std3,
                    color=[t3],
                    thm1, Geom.point,Geom.errorbar,Geom.line),
              layer(x=x4,
                    y=y4,
                    ymin=y4-std4,
                    ymax=y4+std4,
                    color=[t4],
                    thm1, Geom.point,Geom.errorbar,Geom.line),
    Guide.xlabel(xl),Guide.ylabel(yl),Guide.title(name),Scale.color_discrete_manual(c1,c2,c3,c4)))
end



function iperf_general(x,chipn,typestr)
    chipdata = x[x[:card].== chipn,:]
    fourtys = getmhz(chipdata,40)
    eightys = getmhz(chipdata,80)

    drawlines2(fourtys[:location],fourtys[:avg],fourtys[:std],eightys[:location],eightys[:avg],eightys[:std],
             "40MHz","80MHz","Distance (ft)","Throughput (Mbits/sec)",chipn*typestr*" TCP Throughput")
end

function signal_and_beam(x,divisor,typestr,walls)
    fourtys = getmhz(x,40)
    eightys = getmhz(x,80)
    fourtys[:location] = round(fourtys[:location]./divisor)
    fnb = fourtys[fourtys[:nobeamcnt].>0,:]
    fb = fourtys[fourtys[:beamct].>0,:]
    eightys[:location] = round(eightys[:location]./divisor)
    enb=eightys[eightys[:nobeamcnt].>0,:]
    eb=eightys[eightys[:beamct].>0,:]


    if walls
        drawlines2walls(fnb[:location],fnb[:nobeamant1],fnb[:nbt1std],enb[:location],enb[:nobeamant1],enb[:nbt1std],
                      "40MHz","80MHz","Distance (ft)","Signal Strength (dBm)",typestr*" Not Beamformed")
        drawlines2walls(fb[:location],fb[:beamant1],fb[:bt1std],eb[:location],eb[:beamant1],eb[:bt1std],
                      "40MHz","80MHz","Distance (ft)","Signal Strength (dBm)",typestr*" Beamformed")
    else
        drawlines2(fnb[:location],fnb[:nobeamant1],fnb[:nbt1std],enb[:location],enb[:nobeamant1],enb[:nbt1std],
                 "40MHz","80MHz","Distance (ft)","Signal Strength (dBm)",typestr*" Not Beamformed")
        drawlines2(fb[:location],fb[:beamant1],fb[:bt1std],eb[:location],eb[:beamant1],eb[:bt1std],
                 "40MHz","80MHz","Distance (ft)","Signal Strength (dBm)",typestr*" Beamformed")
    end
    if length(fnb[:location])>0
        drawlines1(fnb[:location],fnb[:beamant1]-fnb[:nobeamant1],fill(0,length(fnb[:nbt1std])),
                   "Distance (ft)","Signal Gain (dBm)",typestr*" Beamforming Benefit 40MHz")
    end
    if length(enb[:location])>0
        drawlines1(enb[:location],enb[:beamant1]-enb[:nobeamant1],fill(0,length(enb[:nbt1std])),
                   "Distance (ft)","Signal Gain (dBm)",typestr*" Beamforming Benefit 80MHz")
    end
    drawbar(0:length(fourtys[:location])-1,fourtys[:beamct]./(fourtys[:beamct]+fourtys[:nobeamcnt]),fourtys[:location],
            "Distance (ft)","Percentage of packets Beamformed",typestr*" Prevelance of Beamforming 40MHz")
    drawbar(0:length(eightys[:location])-1,eightys[:beamct]./(eightys[:beamct]+eightys[:nobeamcnt]),eightys[:location],
            "Distance (ft)","Percentage of packets Beamformed",typestr*" Prevelance of Beamforming 80MHz")


end

#get data
rd_i_inside = readtable(analysis*"inside/i_avg",separator=' ')
#rd_mac_inside = readtable(analysis*"inside/m_avg",separator=' ')
rd_i_outside = readtable(analysis*"outside/i_avg",separator=' ')
rd_mac_outside = readtable(analysis*"outside/m_avg",separator=' ')
rd_iperf_inside = readtable(analysis*"inside/ipf/data_fixed",separator=' ')
rd_iperf_outside = readtable(analysis*"outside/ipf/data_fixed",separator=' ')


#Runs
iperf_general(rd_iperf_outside,"intel","Outside")
iperf_general(rd_iperf_outside,"mac","Outside")
iperf_general(rd_iperf_outside,"surface","Outside")

signal_and_beam(rd_i_inside,12,"Intel Inside",true)
#signal_and_beam(rd_mac_inside,12,"Mac Inside",true)
signal_and_beam(rd_i_inside,1,"Intel Outside",false)
signal_and_beam(rd_mac_outside,1,"Mac Outside",false)
