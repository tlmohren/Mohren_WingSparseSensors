function [ STAFunc,NLDFunc] = createNeuralFilt( fixPar,varPar )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    STAt = -39:0;   
    s = -1:0.1:1;
    STAFunc = @(t) cos( varPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varPar.STAwidth.^2);
    STAfilt = STAFunc( STAt ) ; 

    if varPar.NLDgrad <=1
        NLDFunc = @(s)  heaviside(0.5*s-varPar.NLDshift+0.5).*(0.5*s-varPar.NLDshift+0.5) ...
           -heaviside(0.5*s-varPar.NLDshift-1+0.5).*(0.5*s-varPar.NLDshift-1+0.5);
    elseif varPar.NLDgrad >= 25
        NLDFunc = @(s) heaviside( 0.5*s - 0.5*varPar.NLDshift) ;
    else
        NLDFunc = @(s) ( 1./ (1+ exp(-varPar.NLDgrad.*(s-varPar.NLDshift)) ) - 0.5) + 0.5; 
    end
    
    if  isfield(fixPar,'showFilt') == 1 
    figure(101);
        subplot(121)
        plot(STAt,STAfilt);hold on;drawnow
        subplot(122)
        plot( s ,NLDFunc(s));hold on;drawnow; grid on
    end
end

