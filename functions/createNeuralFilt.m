function [ STAFunc,NLDFunc] = createNeuralFilt( fixPar,varPar )
%createNeuralFilt creates functions for neural filters based on parameters
%in input
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
    STAFunc = @(t) cos( varPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varPar.STAwidth.^2);

    STAt = -39:0;   
    if (varPar.STAwidth <=0.2)  && ( max( STAFunc(STAt)) < 0.1) 
        STAFunc = @(t) cos( varPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varPar.STAwidth.^2) /  max(STAFunc(STAt));
     end 
    
    if (varPar.NLDgrad <=1) && (varPar.NLDgrad >=0)
        NLDFunc = @(s)  heaviside(0.5*s-varPar.NLDshift+0.5).*(0.5*s-varPar.NLDshift+0.5) ...
           -heaviside(0.5*s-varPar.NLDshift-1+0.5).*(0.5*s-varPar.NLDshift-1+0.5);
    elseif varPar.NLDgrad >= 25
        NLDFunc = @(s) heaviside( 0.5*s - 0.5*varPar.NLDshift) ;
    elseif varPar.NLDgrad == -1 
        NLDFunc = @(s) s;
    else
        NLDFunc = @(s) ( 1./ (1+ exp(-varPar.NLDgrad.*(s-varPar.NLDshift)) ) - 0.5) + 0.5; 
    end
    
    if  isfield(fixPar,'showFilt') == 1 
        STAt = -39:0;   
        s = -1:0.1:1;
        STAfilt = STAFunc( STAt ) ; 
        figure(101);
            subplot(121)
            plot(STAt,STAfilt,'o-');hold on;drawnow
            subplot(122)
            plot( s ,NLDFunc(s));hold on;drawnow; grid on
    end
end

