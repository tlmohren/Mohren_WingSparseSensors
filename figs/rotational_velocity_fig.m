



t=0:0.001:4;
figure()


subplot(221)
        phi = sin(2*pi*25*t);
    plot(t,phi);hold on
    plot(t,phi+0.2*randn(1,length(t)),'Linewidth',1)
%     plot(t,phi);hold on
    axis([0,0.200,min(phi)*1.1,max(phi)*1.1])
    ylabel('\phi')
subplot(222)
    dphi = cos(2*pi*25*t)*2*pi*25;   
    plot(t,dphi);hold on
    plot(t,dphi+0.2*randn(1,length(t)),'Linewidth',1)
%     plot(t,dphi);hold on
    axis([0,0.200,min(dphi)*1.1,max(dphi)*1.1])
    ylabel('\partial \phi / \partial t')

subplot(223)
    theta = t*10;
    plot(t,theta);hold on
    plot(t,theta+0.2*randn(1,length(t)),'Linewidth',1)
%     plot(t,theta);hold on
    axis([0,0.2,0,0.2*11])
    ylabel('\theta')
subplot(224)
    dtheta = t*0+10;
    plot(t,dtheta);hold on
    plot(t,dtheta+0.2*randn(1,length(t)),'Linewidth',1)
%     plot(t,dtheta);hold on
    axis([0,0.2,0,11])
    ylabel('\partial \theta / \partial t')
    
    legend('disturbance = 0','disturbance = 0.2','Location','Best')