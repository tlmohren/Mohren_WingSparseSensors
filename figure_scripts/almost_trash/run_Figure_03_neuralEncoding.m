% -------------------------
% TLM 2017
% -----------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

set(0,'DefaultAxesFontSize',6)% .
set(0,'DefaultAxesLabelFontSize', 8/6)
% pre plot decisions 
width = 1.8;     % Width in inches,   find column width in paper 
height = 1.8;    % Height in inches
 legend_location = 'best';
%  legend_location = 'NorthOutside';
%% Get data
N0= load(['introFigData' filesep 'noise0'],'strain');
N1=load(['introFigData' filesep 'noise1'],'strain');



%% figure treatment
fig03 = figure();
ax = gca();
set(fig03, 'Position', [fig03.Position(1:2) width*100, height*100]); %<- Set size

%% axis adjustment
axisOptsTheta = {'xtick',0:.5:1,'xticklabel',{0:.5:1},...
    'xlim', [0,1],'ylim',[-55,80],...
     'box','off',...
%     'ytick',{0:5:10},...
% %     'yticklabel',{-1:1:1},...
% %     'Position',tempPos2 +[0.1,0,0,0],...
     };
axisOptsPhi = {'xtick',0:.5:1,'xticklabel',{0:.5:1}, ...
      'box','off',...
    'xlim', [0,1],'ylim',[-2,12],...
%     'ytick',-1:1:1 ,'yticklabel',{-1:1:1},...
%     'Position',tempPos2 +[0.1,0,0,0],...
     };

 lw = 0.5;
C = linspecer(5);
plotOpts1a = {'Color','k','LineWidth',lw};
plotOpts1b = {'Color',C(3,:),'LineWidth',lw};

plotOpts2a = {'Color','k','LineWidth',lw};
plotOpts2b = {'Color','k','LineWidth',lw,'LineStyle','--'};
plotOpts2c = {'Color',C(1,:),'LineWidth',lw};
plotOpts2d = {'Color',C(4,:),'LineWidth',lw};

%% Filter data
tSTA = -40:0.1:0;
s = -1:0.01:1;

parameterSetName    = ' ';
iter                = 1;
figuresToRun        = {'R1_allSensorsFilt'};
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varPar = varParStruct(1);
[STAFunc, NLDFunc] = createNeuralFilt( fixPar,varPar );

%% strain modify
% X_strain = N0.strain.strain_10;


varPar = varParStruct(1);
varPar.NLDgrad = -1;
varPar.STAfreq = 1;
varPar.STAwidth = 0.01;


[X_strain, ~] = neuralEncoding( N0.strain,fixPar ,varPar);

varPar = varParStruct(1);
varPar.NLDgrad = -1;
[X_projection, ~] = neuralEncoding( N0.strain,fixPar ,varPar);

varPar = varParStruct(1);
[X_fire, ~] = neuralEncoding( N0.strain,fixPar ,varPar);

%% single out strain 
% t_inds = 1:size(N0.strain.strain_10,2);
t_inds = 1000:1200;
t = t_inds/1e3;
sensor_ind = 900;

single_strain = X_strain(sensor_ind, t_inds);
single_projection = X_projection(sensor_ind, t_inds);
single_pfire = X_fire(sensor_ind, t_inds);


%%%%
axisOptsStrain = {'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
      'box','off',...
    'ytick',-1:2:1 ,'yticklabel',{-1:2:1},...
        'YLIM',[-1.4,1.4],...
    'xlim', [min(t),max(t)].*[0.99,1],...
%     'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
         };
axisOptsProjection = {'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
      'box','off',...
    'ytick', (-1:2:1)*0.5 ,'yticklabel',(-1:2:1)*0.5,...
        'YLIM',[-1,1]*0.5,...
    'xlim', [min(t),max(t)].*[0.99,1],...
%     'xlim', [-40,0],
%     'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
         };
axisOptsPfire = {'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
      'box','off',...
    'ytick', (0:1:1)*0.5 ,'yticklabel',(0:1:1)*0.5,...
        'YLIM',[-0.05,1]*0.5,...
    'xlim', [min(t),max(t)].*[0.98,1],...
%     'xlim', [-40,0],
%     'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
         };
     
axisOptsSTA = {'YTick',-1:2:1,'YTickLabel',-1:2:1, ...
      'box','off',...
    'xlim', [-42,0],'YLIM',[-1.4,1.4],...
    'xtick',-40:20:0,'xticklabel',{(-40:20:0)/1e3}, ...
         };
% 
axisOptsNLD = {'xtick',-1:1:1,'xticklabel',{-1:1:1}, ...
    'ytick',0:1:1 ,'yticklabel',{0:1:1},...
    'box','off',...
    'xlim', [-1.1,1],'ylim',[-0.2,1.2],...
%     'ytick',0:0.5:1 ,'yticklabel',{0:0.5:1},...
     };
%% Plt data 
subplot(322)
    pltstrain = plot( t,single_strain);
    xlabel('Time [s]'); ylabel('Strain')
    set(gca,axisOptsStrain{:})
    
subplot(324)
    pltproj = plot( t,single_projection);
    xlabel('Time [s]'); ylabel('Projection')
    set(gca,axisOptsProjection{:})
    
subplot(326)
    pltpfire = plot( t,single_pfire);
    xlabel('Time [s]'); ylabel(['P' '$_{ \textnormal{fire} }$' ])
    set(gca,axisOptsPfire{:})
    
subplot(323)
    pltSTA = plot(tSTA, STAFunc(tSTA ) );
    xlabel('Time [s]'); ylabel('Strain')
    set(gca,axisOptsSTA{:})

subplot(325)
    pltNLD = plot(s, NLDFunc(s) );
    xlabel('Projection'); % ylabel('$P_{fire}$')
    ylabel(['P' '$_{ \textnormal{fire} }$' ])
    set(gca,axisOptsNLD{:})
% 
lw=0.3;
pltOptsStrain = {'Color','k','LineWidth',lw};
pltOptsProj = {'Color','k','LineWidth',lw};
pltOptsPfire = {'Color','k','LineWidth',lw};
pltOptsSTA = {'Color','k','LineWidth',lw};
pltOptsNLD = {'Color','k','LineWidth',lw};
set(pltstrain, pltOptsStrain{:});
set(pltproj, pltOptsProj{:});
set(pltpfire, pltOptsPfire{:});
set(pltSTA, pltOptsSTA{:});
set(pltNLD, pltOptsNLD{:});


%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;

% % % Here we preserve the size of the image when we save it.
set(fig03,'InvertHardcopy','on');
set(fig03,'PaperUnits', 'inches');
papersize = get(fig03, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig03, 'PaperPosition', myfiguresize);

 
%% saving of image
print(fig03, ['figs' filesep 'Figure_03_neuralEncoding'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig03, 'PaperPosition', myfiguresize);

print(fig03, ['figs' filesep 'Figure_03_neuralEncoding'], '-dsvg');




%% plot 
t_inst = 2001;
% 0.strain.strain_10,dim_wing);
% 
% t_inst = 3008;
dim_wing = [26,51,6000];
% strain0 = reshape(X_strain,dim_wing);
strain0 = reshape(X_fire,dim_wing);


% dim_wing = [26,51,4000];
% strain0 = reshape(N0.strain.strain_0,dim_wing);


% figure treatment
fig03b = figure();
ax = gca();
set(fig03b, 'Position', [fig03b.Position(1:2) width*100, 0.5*height*100]); %<- Set size

% colormap(summer )
% subplot(311)
    pcolor(strain0(:,:,t_inst))

shading flat
    axis equal
    axis off
    
colorbar
    
%%    
% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;

% % % Here we preserve the size of the image when we save it.
set(fig03b,'InvertHardcopy','on');
set(fig03b,'PaperUnits', 'inches');
papersize = get(fig03b, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig03b, 'PaperPosition', myfiguresize);

 
% saving of image
print(fig03b, ['figs' filesep 'Figure_03_neuralEncoding'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig03b, 'PaperPosition', myfiguresize);

print(fig03b, ['figs' filesep 'Figure_03b_neuralEncoding'], '-dsvg');


