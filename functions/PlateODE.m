function dy = PlateODE(t,y,v0,dv0,M,K,Ma,Ia,Q,cycles,frot)
 w =([[(1125899906842624*sin((3310723709841479*pi*t)/562949953421312 + 1145644602639615/281474976710656))/32712943802313645 + (1125899906842624*sin((8187953212063211*pi*t)/562949953421312 + 8905279122892415/18014398509481984))/32712943802313645 + (1125899906842624*sin((1240200240429411*pi*t)/70368744177664 + 8450247975545939/2251799813685248))/32712943802313645 + (1125899906842624*sin((2703024577765807*pi*t)/140737488355328 + 6691522117877123/4503599627370496))/32712943802313645 + (1125899906842624*sin((1284311610554593*pi*t)/70368744177664 + 2380336457138369/1125899906842624))/32712943802313645 + (1125899906842624*sin((6745476728337477*pi*t)/562949953421312 + 8714710635233445/4503599627370496))/32712943802313645 + (1125899906842624*sin((4764158708928745*pi*t)/562949953421312 + 4947283773405041/1125899906842624))/32712943802313645 + (1125899906842624*sin((1409536087923313*pi*t)/140737488355328 + 1433222931158869/281474976710656))/32712943802313645 + (1125899906842624*sin((2999378007807643*pi*t)/1125899906842624 + 941102206217215/4503599627370496))/32712943802313645 + (1125899906842624*sin((1641198371598049*pi*t)/562949953421312 + 6074674064477357/1125899906842624))/32712943802313645 + (1125899906842624*sin((491294326563977*pi*t)/70368744177664 + 1250838059230429/1125899906842624))/32712943802313645 + (1125899906842624*sin((87459661443813*pi*t)/17592186044416 + 1352809836088709/2251799813685248))/32712943802313645 + (1125899906842624*sin((7496950511276593*pi*t)/562949953421312 + 6673907156606995/1125899906842624))/32712943802313645 + (1125899906842624*sin((3802220032827285*pi*t)/281474976710656 + 4542300139533499/1125899906842624))/32712943802313645 + (1125899906842624*sin((2377508527917927*pi*t)/140737488355328 + 590988290280405/562949953421312))/32712943802313645 + (31250*pi^4*t^3*(50*pi*cos(50*pi*t) + 20*pi*cos(100*pi*t)))/(3*(125000*pi^3*t^3 + 10)) + (31250*pi^4*t^2*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10) - (3906250000*pi^7*t^5*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10)^2 - 5637000183942079/2093628403348073280], [0], [(2251799813685248*sin((293317448298945*pi*t)/17592186044416 + 282178287905105/70368744177664))/5556783481440075 + (2251799813685248*sin((8831280183953371*pi*t)/562949953421312 + 4693859792684319/2251799813685248))/5556783481440075 + (2251799813685248*sin((7037761911889069*pi*t)/1125899906842624 + 7070652002589825/4503599627370496))/5556783481440075 + (2251799813685248*sin((6293295529539473*pi*t)/562949953421312 + 3235606171702211/1125899906842624))/5556783481440075 + (2251799813685248*sin((2205595731149795*pi*t)/140737488355328 + 1562178687998143/281474976710656))/5556783481440075 + (2251799813685248*sin((549827930057703*pi*t)/70368744177664 + 1135231214331813/562949953421312))/5556783481440075 + (2251799813685248*sin((2718938127466001*pi*t)/562949953421312 + 2731566767670995/562949953421312))/5556783481440075 + (2251799813685248*sin((7550918354441073*pi*t)/562949953421312 + 4868587719364503/9007199254740992))/5556783481440075 + (2251799813685248*sin((2801105165001175*pi*t)/140737488355328 + 3467930435270297/1125899906842624))/5556783481440075 + (2251799813685248*sin((600943191613485*pi*t)/35184372088832 + 782597508958003/281474976710656))/5556783481440075 + (2251799813685248*sin((6441754225238191*pi*t)/1125899906842624 + 2887244407844359/9007199254740992))/5556783481440075 + (2251799813685248*sin((3505499000376471*pi*t)/281474976710656 + 8475981329179065/2251799813685248))/5556783481440075 + (2251799813685248*sin((1729493167329829*pi*t)/140737488355328 + 39031993939381/35184372088832))/5556783481440075 + (2251799813685248*sin((2590410313764621*pi*t)/140737488355328 + 8253200409057941/36028797018963968))/5556783481440075 + (2251799813685248*sin((5789806800350915*pi*t)/562949953421312 + 436314949410713/70368744177664))/5556783481440075 + (5000000*pi^3*t^3)/(125000*pi^3*t^3 + 10) - (468750000000*pi^6*t^6)/(125000*pi^3*t^3 + 10)^2 - 1563713852754587/118544714270721600]]);
 dw=([[(2999378007807643*pi*cos((2999378007807643*pi*t)/1125899906842624 + 941102206217215/4503599627370496))/32712943802313645 + (3282396743196098*pi*cos((1641198371598049*pi*t)/562949953421312 + 6074674064477357/1125899906842624))/32712943802313645 + (7860709225023632*pi*cos((491294326563977*pi*t)/70368744177664 + 1250838059230429/1125899906842624))/32712943802313645 + (1865806110801344*pi*cos((87459661443813*pi*t)/17592186044416 + 1352809836088709/2251799813685248))/10904314600771215 + (14993901022553186*pi*cos((7496950511276593*pi*t)/562949953421312 + 6673907156606995/1125899906842624))/32712943802313645 + (337975114029092*pi*cos((3802220032827285*pi*t)/281474976710656 + 4542300139533499/1125899906842624))/726954306718081 + (2113340913704824*pi*cos((2377508527917927*pi*t)/140737488355328 + 590988290280405/562949953421312))/3634771533590405 + (6621447419682958*pi*cos((3310723709841479*pi*t)/562949953421312 + 1145644602639615/281474976710656))/32712943802313645 + (16375906424126422*pi*cos((8187953212063211*pi*t)/562949953421312 + 8905279122892415/18014398509481984))/32712943802313645 + (2204800427430064*pi*cos((1240200240429411*pi*t)/70368744177664 + 8450247975545939/2251799813685248))/3634771533590405 + (21624196622126456*pi*cos((2703024577765807*pi*t)/140737488355328 + 6691522117877123/4503599627370496))/32712943802313645 + (20548985768873488*pi*cos((1284311610554593*pi*t)/70368744177664 + 2380336457138369/1125899906842624))/32712943802313645 + (345921883504486*pi*cos((6745476728337477*pi*t)/562949953421312 + 8714710635233445/4503599627370496))/838793430828555 + (1905663483571498*pi*cos((4764158708928745*pi*t)/562949953421312 + 4947283773405041/1125899906842624))/6542588760462729 + (11276288703386504*pi*cos((1409536087923313*pi*t)/140737488355328 + 1433222931158869/281474976710656))/32712943802313645 + (62500*pi^4*t*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10) - (31250*pi^4*t^3*(2500*pi^2*sin(50*pi*t) + 2000*pi^2*sin(100*pi*t)))/(3*(125000*pi^3*t^3 + 10)) + (62500*pi^4*t^2*(50*pi*cos(50*pi*t) + 20*pi*cos(100*pi*t)))/(125000*pi^3*t^3 + 10) - (7812500000*pi^7*t^5*(50*pi*cos(50*pi*t) + 20*pi*cos(100*pi*t)))/(125000*pi^3*t^3 + 10)^2 - (31250000000*pi^7*t^4*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10)^2 + (2929687500000000*pi^10*t^7*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10)^3], [0], [(10875752509864004*pi*cos((2718938127466001*pi*t)/562949953421312 + 2731566767670995/562949953421312))/5556783481440075 + (10067891139254764*pi*cos((7550918354441073*pi*t)/562949953421312 + 4868587719364503/9007199254740992))/1852261160480025 + (1792707305600752*pi*cos((2801105165001175*pi*t)/140737488355328 + 3467930435270297/1125899906842624))/222271339257603 + (2564024284217536*pi*cos((600943191613485*pi*t)/35184372088832 + 782597508958003/281474976710656))/370452232096005 + (12883508450476382*pi*cos((6441754225238191*pi*t)/1125899906842624 + 2887244407844359/9007199254740992))/5556783481440075 + (3115999111445752*pi*cos((3505499000376471*pi*t)/281474976710656 + 8475981329179065/2251799813685248))/617420386826675 + (27671890677277264*pi*cos((1729493167329829*pi*t)/140737488355328 + 39031993939381/35184372088832))/5556783481440075 + (4605173891137104*pi*cos((2590410313764621*pi*t)/140737488355328 + 8253200409057941/36028797018963968))/617420386826675 + (4631845440280732*pi*cos((5789806800350915*pi*t)/562949953421312 + 436314949410713/70368744177664))/1111356696288015 + (2502975558817664*pi*cos((293317448298945*pi*t)/17592186044416 + 282178287905105/70368744177664))/370452232096005 + (35325120735813484*pi*cos((8831280183953371*pi*t)/562949953421312 + 4693859792684319/2251799813685248))/5556783481440075 + (14075523823778138*pi*cos((7037761911889069*pi*t)/1125899906842624 + 7070652002589825/4503599627370496))/5556783481440075 + (25173182118157892*pi*cos((6293295529539473*pi*t)/562949953421312 + 3235606171702211/1125899906842624))/5556783481440075 + (7057906339679344*pi*cos((2205595731149795*pi*t)/140737488355328 + 1562178687998143/281474976710656))/1111356696288015 + (5864831253948832*pi*cos((549827930057703*pi*t)/70368744177664 + 1135231214331813/562949953421312))/1852261160480025 + (15000000*pi^3*t^2)/(125000*pi^3*t^3 + 10) - (4687500000000*pi^6*t^5)/(125000*pi^3*t^3 + 10)^2 + (351562500000000000*pi^9*t^8)/(125000*pi^3*t^3 + 10)^3]]);
 Q0 = w(2); 
 P0 = w(1); 
 Ca = funcCa(v0,w); 
 dy(1:6,1) = y(7:end); 
 dy(7:12,1) = mldivide(M,(-Q*dy(1:6) - K*y(1:6)+Ia*Ca*transpose(w)+(Q0^2+P0^2)*M*y(1:6)-Ma*[transpose(dv0);transpose(dw)]   )); 
 t;