using Gadfly
using DataFrames
using Dates
using RDatasets
using Cairo
c1 = color("darkgreen")
c2 = color("purple")
typestr = "Intel Indoor"
colorarr=[c1 c2]
x = readtable("i_avg",separator=' ')
fourtys = x[x[:MHz].== 40,:]
fourtys = sort(fourtys,cols= :location)
fourtysnb = fourtys[fourtys[:nobeamcnt].>0,:]
fourtysb = fourtys[fourtys[:beamct].>0,:]
eightys = x[x[:MHz].== 80,:]
eightys = sort(eightys,cols= :location)
eightysnb=eightys[eightys[:nobeamcnt].>0,:]
eightysb=eightys[eightys[:beamct].>0,:]

linethk = 1mm

function drawpng1(x1,y1,std1,name)
    draw(PNG("../"*replace(name," ","_")*".png", 8inch, 8inch),
         plot(
              layer(x=x1,
                    y=y1,
                    ymin=y1-std1,
                    ymax=y1+std1,
                    Theme(line_width=linethk,default_color=c1), Geom.point,Geom.errorbar,Geom.line),
    Guide.xlabel("Distance (ft)"),Guide.ylabel("Beamforming gain (dBm)"),Guide.title(name)))
end


function drawbar(x1,y1,lbl,name)
    draw(PNG("../"*replace(name," ","_")*".png", 8inch, 8inch),
         plot(
              x=x1,
              y=y1,
              Theme(panel_fill=color("#ffffff"), panel_stroke=color("#ffffff"), grid_color=color("#e1e3e5"),
                    minor_label_color=color("#4e5c67"), bar_spacing=0.5inch),
              Scale.x_discrete(labels=c->lbl[c+1]),
              Scale.y_continuous(minvalue=0),
#
#              Theme(default_color=c1,bar_spacing=0.5inch),
              Geom.bar,
              Guide.xlabel("Distance (ft)"),Guide.ylabel("Percentage of beamformed packets"),Guide.title(name)))
end

function drawpng2(x1,y1,std1,x2,y2,std2,t1,t2,name)
    draw(PNG("../"*replace(name," ","_")*".png", 8inch, 8inch),
         plot(
              layer(x=x1/12,
                    y=y1,
                    ymin=y1-std1,
                    ymax=y1+std1,
                    color=[t1],
                    Theme(line_width=linethk,default_color=c1), Geom.point,Geom.errorbar,Geom.line),
              layer(x=x2/12,
                    y=y2,
                    ymin=y2-std2,
                    ymax=y2+std2,
                    color=[t2],
                    Theme(line_width=linethk,default_color=c2), Geom.point,Geom.errorbar,Geom.line),

    Guide.xlabel("Distance (ft)"),Guide.ylabel("Reported Signal (dBm)"),Guide.title(name),Scale.color_discrete_manual(c1,c2)))
end


drawpng2(fourtysnb[:location],fourtysnb[:nobeamant1],fourtysnb[:nbt1std],eightysnb[:location],eightysnb[:nobeamant1],eightysnb[:nbt1std],"40MHz","80MHz",typestr*" Not Beamformed")
drawpng2(fourtysb[:location],fourtysb[:beamant1],fourtysb[:bt1std],eightysb[:location],eightysb[:beamant1],eightysb[:bt1std],"40MHz","80MHz",typestr*" Beamformed")
drawpng1(fourtysnb[:location],fourtysnb[:beamant1]-fourtysnb[:nobeamant1],fill(0,length(fourtysnb[:nbt1std])),typestr*" Beamforming Benefit 40MHz")
drawpng1(eightysnb[:location],eightysnb[:beamant1]-eightysnb[:nobeamant1],fill(0,length(eightysnb[:nbt1std])),typestr*" Beamforming Benefit 80MHz")

drawbar(0:length(fourtys[:location])-1,fourtys[:beamct]./(fourtys[:beamct]+fourtys[:nobeamcnt]),fourtys[:location],typestr*" Prevelance of Beamforming 40MHz")
drawbar(0:length(eightys[:location])-1,eightys[:beamct]./(eightys[:beamct]+eightys[:nobeamcnt]),eightys[:location],typestr*" Prevelance of Beamforming 80MHz")
