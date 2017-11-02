%% --------------------
% run_experimentalSTA
% Manually fit functions to experimentally discovered neural encoding
% 
% Experimental data from: Pratt B.W., Deora T., Mohren T.L., Daniel T.L, "Neural evidence supports a dual sensory-
% motor role for insect wings", Proc. R. Soc. B vol. 284, p. 20170969 (2017).
% 
%-------------------------
clc;clear all;close all
addpathFolderStructure()



% pre plot decisions 
width = 3.3;     % Width in inches,   find column width in paper 
height = 2.5;    % Height in inches
alw = 0.5;    % AxesLineWidth
fsz = 8;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize
xlab = '$\dot{\theta}$' ;
ylab = '$\frac{\partial \theta}{\partial t}$   ';
lnStl = {'-','-'};
legend_entries = {'sin','$\sin 4 \pi x$'};
legend_location = 'NorthEast';

%% axis adjustment
axisOptsSTA = {'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
    'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
     'FontSize', fsz, 'LineWidth', alw, 'box','off',...
    'xlim', [-40,0],'YLIM',[-1.4,1.4],...
     };

axisOptsNLD = {'xtick',-1:1:1,'xticklabel',{-1:1:1}, ...
    'xtick',-1:0.5:1,'xticklabel',{-1:0.5:1}, ...
    'ytick',0:1:1 ,'yticklabel',{0:1:1},...
    'ytick',0:0.5:1 ,'yticklabel',{0:0.5:1},...
     'FontSize', fsz, 'LineWidth', alw, 'box','off',...
    'xlim', [-1.1,1.1],'ylim',[-0.2,1.2],...
     };

% axisOptsSTA ={};
% axisOptsNLD ={'YLIM',[-0.2,1.2], 'YTick',[0,1],'YTickLabel',[0,1]};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

%% get the data out 
dataFolder = 'neuralData';
STAname = 'STA and StdM4 N2';
NLDname = 'NLDM4 N2';
% STA 
timeMS = -39:0.1:0;
freq = 1;
STAwidth = 4;
STAdelay = 5;
STAstruct = load([dataFolder filesep STAname ]);
func = @(t) cos( freq*(t+STAdelay )  ).*exp(-(t+STAdelay ).^2 / STAwidth.^2);

% NLD
eta = 20;
shift = 0.5;
s = - 1:0.01:1;
NLDstruct = load([dataFolder filesep NLDname ]);
funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; 


%% figure treatment
fig04 = figure();
set(fig04, 'Position', [fig04.Position(1:2) STAwidth*100, height*100]); %<- Set size


subplot(221)
    plot(linspace(-40,0,1600),STAstruct.STA,'k')
    xlabel('Time [ms]'); ylabel('Displacement [mm]')
    set(gca,axisOptsSTA{:})
    grid on
    title('Experiment')
subplot(222)
    plot(timeMS,func(timeMS)*1.2 ,':k')
    xlabel('Time [ms]'); %ylabel('displacement [mm]')
    grid on
%     legend('Experimental','Function','Location','Best')
    set(gca, axisOptsSTA{:})
    title('\textbf{Function}')
subplot(223)
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}),'k')
    xlabel('Projection');ylabel('Probability of Firing')
    set(gca, axisOptsNLD{:})
    grid on
subplot(224)
    plot(s,funNLD(s),':k')
    xlabel('Projection');%ylabel('Probability of firing')
    grid on
    set(gca, axisOptsNLD{:})
%     legend('Experimental','Function','Location','Best')

%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig04,'InvertHardcopy','on');
set(fig04,'PaperUnits', 'inches');
papersize = get(fig04, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig04, 'PaperPosition', myfiguresize);

    
% print(fig04,['figs' filesep 'fig04_expSTANLD' ],'-r500','-dpng')

%% 
print(fig04, ['figs' filesep 'fig04_expSTANLD' ], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig04, 'PaperPosition', myfiguresize);

print(fig04, ['figs' filesep 'fig04_expSTANLD' ], '-dsvg');

