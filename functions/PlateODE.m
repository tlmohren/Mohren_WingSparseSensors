function dy = PlateODE(t,y,v0,dv0,M,K,Ma,Ia,Q,cycles,frot)
 w =([[(31250*pi^4*t^3*(50*pi*cos(50*pi*t) + 20*pi*cos(100*pi*t)))/(3*(125000*pi^3*t^3 + 10)) + (31250*pi^4*t^2*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10) - (3906250000*pi^7*t^5*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10)^2], [0], [0]]);
 dw=([[(62500*pi^4*t*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10) - (31250*pi^4*t^3*(2500*pi^2*sin(50*pi*t) + 2000*pi^2*sin(100*pi*t)))/(3*(125000*pi^3*t^3 + 10)) + (62500*pi^4*t^2*(50*pi*cos(50*pi*t) + 20*pi*cos(100*pi*t)))/(125000*pi^3*t^3 + 10) - (7812500000*pi^7*t^5*(50*pi*cos(50*pi*t) + 20*pi*cos(100*pi*t)))/(125000*pi^3*t^3 + 10)^2 - (31250000000*pi^7*t^4*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10)^2 + (2929687500000000*pi^10*t^7*(sin(50*pi*t) + sin(100*pi*t)/5))/(125000*pi^3*t^3 + 10)^3], [0], [0]]);
 Q0 = w(2); 
 P0 = w(1); 
 Ca = funcCa(v0,w); 
 dy(1:6,1) = y(7:end); 
 dy(7:12,1) = mldivide(M,(-Q*dy(1:6) - K*y(1:6)+Ia*Ca*transpose(w)+(Q0^2+P0^2)*M*y(1:6)-Ma*[transpose(dv0);transpose(dw)]   )); 
 t;