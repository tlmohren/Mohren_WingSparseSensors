%% --------------------
% run_experimentalSTA
% Manually fit functions to experimentally discovered neural encoding
% 
% Experimental data from: Pratt B.W., Deora T., Mohren T.L., Daniel T.L, "Neural evidence supports a dual sensory-
% motor role for insect wings", Proc. R. Soc. B vol. 284, p. 20170969 (2017).
% 
%-------------------------
clc;clear all;close all

dataFolder = 'data';
STAname = 'STA and StdM4 N2';
NLDname = 'NLDM4 N2';

% STA 
timeMS = -39:0.1:0;
freq = 1;
width = 4;
STAdelay = 4;
STAstruct = load([dataFolder filesep STAname ]);
func = @(t) cos( freq*(t+STAdelay )  ).*exp(-(t+STAdelay ).^2 / width.^2);

% NLD
eta = 20;
shift = 0.5;
s = - 1:0.01:1;
NLDstruct = load([dataFolder filesep NLDname ]);
funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; 

figure('Position',[100,600,1000,300]);
subplot(121)
    plot(linspace(-40,0,1600),STAstruct.STA)
    hold on
    plot(timeMS,func(timeMS)*1.2 )
    xlabel('Time [ms]'); ylabel('displacement [mm]')
    grid on
subplot(122)
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}))
    hold on
    plot(s,funNLD(s))
    xlabel('dot product [-]');ylabel('Probability of firing')
    grid on
    legend('Experimental STA (Pratt, M4 N2)','Function form','Location','Best')
