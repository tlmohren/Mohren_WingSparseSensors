function [ STAFunc,NLD] = createNeuralFilt( fixPar,varPar )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    STAt = -39:0;   
    s = -1:0.1:1;
    STAFunc = @(t) cos( varPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varPar.STAwidth.^2);
    STAfilt = STAFunc( STAt ) ; 

    if varPar.NLDgrad <=1
        NLD = @(s)  heaviside(0.5*s-varPar.NLDshift+0.5).*(0.5*s-varPar.NLDshift+0.5) ...
           -heaviside(0.5*s-varPar.NLDshift-1+0.5).*(0.5*s-varPar.NLDshift-1+0.5);
    elseif varPar.NLDgrad >= 25
        NLD = @(s) heaviside( 0.5*s - 0.5*varPar.NLDshift) ;
    else
        NLD = @(s) ( 1./ (1+ exp(-varPar.NLDgrad.*(s-varPar.NLDshift)) ) - 0.5) + 0.5; 
    end
end

