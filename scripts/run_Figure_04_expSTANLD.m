%% --------------------
% run_experimentalSTA
% Manually fit functions to experimentally discovered neural encoding
% 
% Experimental data from: Pratt B.W., Deora T., Mohren T.L., Daniel T.L, "Neural evidence supports a dual sensory-
% motor role for insect wings", Proc. R. Soc. B vol. 284, p. 20170969 (2017).
% 
%-------------------------
clc;clear all;close all

dataFolder = 'neuralData';
STAname = 'STA and StdM4 N2';
NLDname = 'NLDM4 N2';

% STA 
timeMS = -39:0.1:0;
freq = 1;
width = 4;
STAdelay = 5;
STAstruct = load([dataFolder filesep STAname ]);
func = @(t) cos( freq*(t+STAdelay )  ).*exp(-(t+STAdelay ).^2 / width.^2);

% NLD
eta = 20;
shift = 0.5;
s = - 1:0.01:1;
NLDstruct = load([dataFolder filesep NLDname ]);
funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; 
%% 
axisOptsSTA ={'YLIM',[-1.4,1.4], 'YTick',-1:1:1,'YTickLabel',-1:1:1};
axisOptsNLD ={'YLIM',[-0.2,1.2], 'YTick',[0,1],'YTickLabel',[0,1]};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


%% 
fig04 = figure('Position',[100,600,500,300]);
% figureOpts = { 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 15 10] };
figureOpts = { 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 15 10] , 'PaperSize',[5,7] };
set(fig04,figureOpts{:})


subplot(211)
    plot(linspace(-40,0,1600),STAstruct.STA,'k')
    hold on
    plot(timeMS,func(timeMS)*1.2 ,':k')
    xlabel('Time [ms]'); ylabel('displacement [mm]')
    grid on
    legend('Experimental STA','Function form','Location','Best','Location', 'NorthEastOutside')
    
    set(gca, axisOptsSTA{:})
subplot(212)
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}),'k')
    hold on
    plot(s,funNLD(s),':k')
    xlabel('dot product [-]');ylabel('Probability of firing')
    grid on
    set(gca, axisOptsNLD{:})
    legend('Experimental NLD','Function form','Location','Best','Location', 'NorthEastOutside')

    
print(fig04,['figs' filesep 'fig04_expSTANLD' ],'-r500','-dpng')