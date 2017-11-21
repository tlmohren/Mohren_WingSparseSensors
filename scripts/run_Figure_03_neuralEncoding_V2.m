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
width = 4;     % Width in inches,   find column width in paper 
height = 3;    % Height in inches
 legend_location = 'best';
%  legend_location = 'NorthOutside';
%% Get data
N0= load(['introFigData' filesep 'noise0'],'strain');
% N1=load(['introFigData' filesep 'noise1'],'strain');



%% figure treatment
fig03 = figure();
ax = gca();
set(fig03, 'Position', [fig03.Position(1:2) width*100, height*100]); %<- Set size

%% axis adjustment
% axisOptsTheta = {'xtick',0:.5:1,'xticklabel',{0:.5:1},...
%     'xlim', [0,1],'ylim',[-55,80],...
%      'box','off',...
% %     'ytick',{0:5:10},...
% % %     'yticklabel',{-1:1:1},...
% % %     'Position',tempPos2 +[0.1,0,0,0],...
%      };
% axisOptsPhi = {'xtick',0:.5:1,'xticklabel',{0:.5:1}, ...
%       'box','off',...
%     'xlim', [0,1],'ylim',[-2,12],...
% %     'ytick',-1:1:1 ,'yticklabel',{-1:1:1},...
% %     'Position',tempPos2 +[0.1,0,0,0],...
%      };
% 
%  lw = 0.5;
% C = linspecer(5);
% plotOpts1a = {'Color','k','LineWidth',lw};
% plotOpts1b = {'Color',C(3,:),'LineWidth',lw};
% 
% plotOpts2a = {'Color','k','LineWidth',lw};
% plotOpts2b = {'Color','k','LineWidth',lw,'LineStyle','--'};
% plotOpts2c = {'Color',C(1,:),'LineWidth',lw};
% plotOpts2d = {'Color',C(4,:),'LineWidth',lw};

%% Filter data

parameterSetName    = ' ';
iter                = 1;
fontSize            = 8;
figuresToRun        = {'R1_allSensorsFilt'};
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varPar = varParStruct(1);
[STAFunc, NLDFunc] = createNeuralFilt( fixPar,varPar );

%% strain modify
tSTA = -40:0.1:0;
s = -1:0.01:1;

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

t_inds = 1000:1200;
t = t_inds/1e3;
sensor_ind = 900;

single_strain = X_strain(sensor_ind, t_inds);
single_projection = X_projection(sensor_ind, t_inds);
single_pfire = X_fire(sensor_ind, t_inds);


%%

subplot(331)
    plot([0 1 1 0 0],[0 0 1 1 0]*0.7)
    tx = text(0.1,0.3,'Strain $(x,y,t)$','FontSize',fontSize);
    axis off
    
% subplot(332)
subplot(632) 
    N0= load(['introFigData' filesep 'noise0'],'strain');
    dim_wing = [26,51,4000];
    t_inst = 3008;
    sensorSpec = [10,10];
    strain0 = reshape(N0.strain.strain_0,dim_wing);

    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    pcOpts = {'EdgeColor',[1,1,1]*0,'LineWidth',0.1,'FaceColor','flat'};
    colormap(parula)
    pc1 = pcolor(strain0(:,:,t_inst));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off

    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',1)
    
subplot(635)
    timeInd = 1000:1200;
    
    strain  = squeeze(strain0( sensorSpec(1),sensorSpec(2),timeInd ));
    lim = [min(strain),max(strain)];
    plot( strain )
    axis([-100,300,lim(1)*1.5,lim(2)*1.5])
    axis off
    
    
    %% 
subplot(333) 
     load(['introFigData' filesep  'LDAhistograms' ]);
    n_bins = 15;
%     Xcls = XclsStrain;
    expo = round( - log10(max(abs(XclsStrain))));
    lims = [ round(min(XclsStrain),expo+1)-10^(-expo-1), ( round(max(XclsStrain),expo+1) +10^(-expo-1)) ];

%     rangeBins = lims(1):10^(-expo-1)*0.8 :lims(2);
    rangeBins = linspace(lims(1), lims(2), n_bins);
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

    col = linspecer(2);
    midWay = length(XclsStrain)/2;
    [aCounts] = histcounts(XclsStrain(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsStrain(midWay+1:end), rangeBins);

    yLims = [ max(aCounts),-max(bCounts)];

    % figure()
    bar1 = bar(binMids,aCounts);
    ax1 = gca();
    hold on
    bar2 = bar(binMids,-bCounts,'r');
    ax2 = gca();

    axOpts = {'XLim',lims};
    barOpts1 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(1,:)};
    barOpts2 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(2,:)};
    set(ax1,axOpts{:})
    set(ax2,axOpts{:})
    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})


    yLims = [ max(aCounts),-max(bCounts)];
    txt1 = 'No Rotation';
    txt2 = 'Rotation';
    text(binMids(end-5),yLims(1)*0.2,txt1,'FontSize',fontSize )
    text(binMids(end-5),yLims(2)*1.1,txt2,'FontSize',fontSize )
    axis off
    
%% 
    
subplot(3,3,4)
    plot([0 1 1 0 0],[0 0 1 1 0]*0.7)
    tx = text(0.1,0.3,'Neural Encoder','FontSize',fontSize);
    axis off
    
subplot(6,3,13)
    STAstruct = load( ['introFigData' filesep  'STA and StdM4 N2' ]);
    plot(linspace(-40,0,1600),STAstruct.STA,'k')
    axis([-50,10,-0.9,1.2])
%     xlabel('Time [ms]'); ylabel('Displacement [mm]')
%     set(gca,axisOptsSTA{:})
%     grid on
    box off
    hold on 
    quiver(-40,-0.8,10,0,'k')
    quiver(-40,-0.8,0,1,'k')
%     title('\textbf{Experiment}')
    axis off    

subplot(6,3,16)
    
NLDstruct = load(['introFigData' filesep 'NLDM4 N2' ]);
% NLDname = 
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}),'k')
    xlabel('Strain Projection on Feature');ylabel('Probability of Firing')
%     set(gca, axisOptsNLD{:})
%     grid on
    hold on
    axis([-1.1,1.1,-0.2,1])
    
    quiver(-0.7,-0.1,0.4,0,'k')
    quiver(-0.7,-0.1,0,0.6,'k')
    
    
    axis off
    
    
%% 
subplot(3,3,5)
    plot([0 1 1 0 0],[0 0 1 1 0]*0.7)
    tx = text(0.1,0.3,'P$_{fire}(x,y,t)$','FontSize',fontSize);
    axis off
    
    
% subplot(338)
subplot(6,3,14)
        axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    pcOpts = {'EdgeColor',[1,1,1]*0,'LineWidth',0.1,'FaceColor','flat'};
%     colormap(parula)
    Pfire = reshape(X_fire,dim_wing+[0,0,2000]);
    pc2 = pcolor( Pfire(:,:,t_inst) );
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc2,pcOpts{:})
    axis off

    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',1)
    
    
subplot(6,3,17)
    timeInd = 1000:1200;
%     X_fire_expand = reshape( X_
    PfireSensor  = squeeze(Pfire( sensorSpec(1),sensorSpec(2),timeInd ));
    lim = [min(PfireSensor),max(PfireSensor)];
    plot( PfireSensor)
    axis([-100,300,lim(1)*1.5,lim(2)*1.5])
    axis off
    
    
    
    
    
        %% 
subplot(336) 
     load(['introFigData' filesep  'LDAhistograms' ]);
    n_bins = 15;
%     Xcls = XclsStrain;
    expo = round( - log10(max(abs(XclsEncoded))));
    lims = [ round(min(XclsEncoded),expo+1)-10^(-expo-1), ( round(max(XclsEncoded),expo+1) +10^(-expo-1)) ];

%     rangeBins = lims(1):10^(-expo-1)*0.8 :lims(2);
    rangeBins = linspace(lims(1), lims(2), n_bins);
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

    col = linspecer(2);
    midWay = length(XclsStrain)/2;
    [aCounts] = histcounts(XclsEncoded(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsEncoded(midWay+1:end), rangeBins);

    yLims = [ max(aCounts),-max(bCounts)];

    % figure()
    bar1 = bar(binMids,aCounts);
    ax1 = gca();
    hold on
    bar2 = bar(binMids,-bCounts,'r');
    ax2 = gca();

    axOpts = {'XLim',lims};
    barOpts1 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(1,:)};
    barOpts2 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(2,:)};
    set(ax1,axOpts{:})
    set(ax2,axOpts{:})
    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})


    yLims = [ max(aCounts),-max(bCounts)];
    txt1 = 'No Rotation';
    txt2 = 'Rotation';
    text(binMids(end-5),yLims(1)*0.2,txt1,'FontSize',fontSize )
    text(binMids(end-5),yLims(2)*1.1,txt2,'FontSize',fontSize )
    axis off

    
    %% 
subplot(339) 
     load(['introFigData' filesep  'LDAhistograms' ]);
    n_bins = 15;
%     Xcls = XclsStrain;
    expo = round( - log10(max(abs(XclsEncodedSparse))));
    lims = [ round(min(XclsEncodedSparse),expo+1)-10^(-expo-1), ( round(max(XclsEncodedSparse),expo+1) +10^(-expo-1)) ];

%     rangeBins = lims(1):10^(-expo-1)*0.8 :lims(2);
    rangeBins = linspace(lims(1), lims(2), n_bins);
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

    col = linspecer(2);
    midWay = length(XclsStrain)/2;
    [aCounts] = histcounts(XclsEncodedSparse(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsEncodedSparse(midWay+1:end), rangeBins);

    yLims = [ max(aCounts),-max(bCounts)];

    % figure()
    bar1 = bar(binMids,aCounts);
    ax1 = gca();
    hold on
    bar2 = bar(binMids,-bCounts,'r');
    ax2 = gca();

    axOpts = {'XLim',lims};
    barOpts1 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(1,:)};
    barOpts2 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(2,:)};
    set(ax1,axOpts{:})
    set(ax2,axOpts{:})
    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})


    yLims = [ max(aCounts),-max(bCounts)];
    txt1 = 'No Rotation';
    txt2 = 'Rotation';
    text(binMids(end-5),yLims(1)*0.2,txt1,'FontSize',fontSize )
    text(binMids(end-5),yLims(2)*1.1,txt2,'FontSize',fontSize )
    axis off
    
    
% axisOptsStrain = {'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
%       'box','off',...
%     'ytick',-1:2:1 ,'yticklabel',{-1:2:1},...
%         'YLIM',[-1.4,1.4],...
%     'xlim', [min(t),max(t)].*[0.99,1],...
% %     'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
%          };
% % % axisOptsProjection = {'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
% % %       'box','off',...
% % %     'ytick', (-1:2:1)*0.5 ,'yticklabel',(-1:2:1)*0.5,...
% % %         'YLIM',[-1,1]*0.5,...
% % %     'xlim', [min(t),max(t)].*[0.99,1],...
% % % %     'xlim', [-40,0],
% % % %     'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
% % %          };
% % % axisOptsPfire = {'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
% % %       'box','off',...
% % %     'ytick', (0:1:1)*0.5 ,'yticklabel',(0:1:1)*0.5,...
% % %         'YLIM',[-0.05,1]*0.5,...
% % %     'xlim', [min(t),max(t)].*[0.98,1],...
% % % %     'xlim', [-40,0],
% % % %     'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
% % %          };
% % %      
% % % axisOptsSTA = {'YTick',-1:2:1,'YTickLabel',-1:2:1, ...
% % %       'box','off',...
% % %     'xlim', [-42,0],'YLIM',[-1.4,1.4],...
% % %     'xtick',-40:20:0,'xticklabel',{(-40:20:0)/1e3}, ...
% % %          };
% % % % 
% % % axisOptsNLD = {'xtick',-1:1:1,'xticklabel',{-1:1:1}, ...
% % %     'ytick',0:1:1 ,'yticklabel',{0:1:1},...
% % %     'box','off',...
% % %     'xlim', [-1.1,1],'ylim',[-0.2,1.2],...
% % % %     'ytick',0:0.5:1 ,'yticklabel',{0:0.5:1},...
% % %      };
%% Plt data 
% subplot(322)
%     pltstrain = plot( t,single_strain);
%     xlabel('Time [s]'); ylabel('Strain')
%     set(gca,axisOptsStrain{:})
%     
% subplot(324)
%     pltproj = plot( t,single_projection);
%     xlabel('Time [s]'); ylabel('Projection')
%     set(gca,axisOptsProjection{:})
%     
% subplot(326)
%     pltpfire = plot( t,single_pfire);
%     xlabel('Time [s]'); ylabel(['P' '$_{ \textnormal{fire} }$' ])
%     set(gca,axisOptsPfire{:})
%     
% subplot(323)
%     pltSTA = plot(tSTA, STAFunc(tSTA ) );
%     xlabel('Time [s]'); ylabel('Strain')
%     set(gca,axisOptsSTA{:})
% 
% subplot(325)
%     pltNLD = plot(s, NLDFunc(s) );
%     xlabel('Projection'); % ylabel('$P_{fire}$')
%     ylabel(['P' '$_{ \textnormal{fire} }$' ])
%     set(gca,axisOptsNLD{:})
% % 
% lw=0.3;
% pltOptsStrain = {'Color','k','LineWidth',lw};
% pltOptsProj = {'Color','k','LineWidth',lw};
% pltOptsPfire = {'Color','k','LineWidth',lw};
% pltOptsSTA = {'Color','k','LineWidth',lw};
% pltOptsNLD = {'Color','k','LineWidth',lw};
% set(pltstrain, pltOptsStrain{:});
% set(pltproj, pltOptsProj{:});
% set(pltpfire, pltOptsPfire{:});
% set(pltSTA, pltOptsSTA{:});
% set(pltNLD, pltOptsNLD{:});
% 
% 




%% Setting paper size for saving 
% % set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% % % tightfig;
% % 
% % % % % Here we preserve the size of the image when we save it.
% % set(fig03,'InvertHardcopy','on');
% % set(fig03,'PaperUnits', 'inches');
% % papersize = get(fig03, 'PaperSize');
% % left = (papersize(1)- width)/2;
% % bottom = (papersize(2)- height)/2;
% % myfiguresize = [left, bottom, width, height];
% % set(fig03, 'PaperPosition', myfiguresize);
% % 
% %  
% % % saving of image
% % print(fig03, ['figs' filesep 'Figure_03_neuralEncoding'], '-dpng', '-r300');
% % 
% % % total hack, why does saving to svg scale image up???
% % stupid_ratio = 15/16;
% % myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
% % set(fig03, 'PaperPosition', myfiguresize);
% % 
% % print(fig03, ['figs' filesep 'Figure_03_neuralEncoding'], '-dsvg');
% % 


