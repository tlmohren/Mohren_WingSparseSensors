% -------------------------
% TLM 2017
% -----------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

set(0,'DefaultAxesFontSize',8)% .
set(0,'DefaultAxesLabelFontSize', 8/6)
% pre plot decisions 
width = 7;     % Width in inches,   find column width in paper 
height = 4;    % Height in inches
 legend_location = 'best';
 
 
%% figure treatment
fig03 = figure();
ax = gca();
set(fig03, 'Position', [fig03.Position(1:2) width*100, height*100]); %<- Set size

%%  Get data
N0= load(['introFigData' filesep 'noise0'],'strain');


parameterSetName    = ' ';
iter                = 1;
fontSize            = 7;
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
backColor = [254,232,200]/255;
% subplot(341)
edgeCol = 'none';
subplot(6,4,[1,5])
    x = [0 1 1 0];  y = [0 0 1 1]*0.7;
    pc = patch(x,y,backColor,'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'Strain $(x,y,t)$','FontSize',fontSize);
    axis off
    
subplot(642) 
    N0= load(['introFigData' filesep 'noise0'],'strain');
    dim_wing = [26,51,4000];
    t_inst = 3008;
    sensorSpec = [10,10];
    strain0 = reshape(N0.strain.strain_0,dim_wing);
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    pcOpts = {'FaceColor','flat'};
    colormap(parula)
    pc1 = pcolor(strain0(:,:,t_inst));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off

    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',1)
    
subplot(646)
    timeInd = 1000:1200;
    strain  = squeeze(strain0( sensorSpec(1),sensorSpec(2),timeInd ));
    lim = [min(strain),max(strain)];
    plot( strain )
    axis([-100,300,lim(1)*1.5,lim(2)*1.5])
    axis off
    
subplot(6,4,[3,7])
    x = [0 1 1 0];  y = [0 0 1 1]*0.7;
    pc = patch(x,y,backColor,'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'Classification','FontSize',fontSize);
    axis off
    
    %% 
subplot(6,4,[4,8])
    load(['introFigData' filesep  'LDAhistograms' ]);
    n_bins = 15;
    expo = round( - log10(max(abs(XclsStrain))));
    lims = [ round(min(XclsStrain),expo+1)-10^(-expo-1), ( round(max(XclsStrain),expo+1) +10^(-expo-1)) ];

    rangeBins = linspace(lims(1), lims(2), n_bins);
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

    col = linspecer(2);
    midWay = length(XclsStrain)/2;
    [aCounts] = histcounts(XclsStrain(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsStrain(midWay+1:end), rangeBins);

    yLims = [ max(aCounts),-max(bCounts)];
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
    
% subplot(3,4,5)
subplot(6,4,[9,13])
    x = [0 1 1 0];  y = [0 0 1 1]*0.7;
    pc = patch(x,y,backColor,'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'Neural Encoder','FontSize',fontSize);
    axis off
    
% subplot(6,3,17)
subplot(6,4,17)
    STAstruct = load( ['introFigData' filesep  'STA and StdM4 N2' ]);
    plot(linspace(-40,0,160),STAstruct.STA(1:10:1600),'k')
    axis([-50,10,-0.9,1.2])
    box off
    hold on 
    quiver(-40,-0.8,10,0,'k')
    quiver(-40,-0.8,0,1,'k')
    axis off    

subplot(6,4,21)
    
NLDstruct = load(['introFigData' filesep 'NLDM4 N2' ]);
% NLDname = 
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}),'k')
    xlabel('Strain Projection on Feature');ylabel('Probability of Firing')
    hold on
    axis([-1.1,1.1,-0.2,1])
    
    quiver(-0.7,-0.1,0.4,0,'k')
    quiver(-0.7,-0.1,0,0.6,'k')
    axis off
    
    
%% 
subplot(6,4,[10,14])
    x = [0 1 1 0];  y = [0 0 1 1]*0.7;
    pc = patch(x,y,backColor,'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'P$_{fire}(x,y,t)$','FontSize',fontSize);
    axis off
    
    
% subplot(338)
subplot(6,4,18)
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    Pfire = reshape(X_fire,dim_wing+[0,0,2000]);
    pc2 = pcolor( Pfire(:,:,t_inst) );
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc2,pcOpts{:})
    axis off
    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',1)
    
 subplot(6,4,22)
    timeInd = 1000:1200;
    PfireSensor  = squeeze(Pfire( sensorSpec(1),sensorSpec(2),timeInd ));
    lim = [min(PfireSensor),max(PfireSensor)];
    plot( PfireSensor)
    axis([-100,300,lim(1)*1.5,lim(2)*1.5])
    axis off
    
   
    
        %% 

subplot(6,4,[11,15])
    x = [0 1 1 0];  y = [0 0 1 1]*0.7;
    pc = patch(x,y,backColor,'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'Classification','FontSize',fontSize);
    axis off
    
    
    
subplot(6,4,[12,16])
     load(['introFigData' filesep  'LDAhistograms' ]);
    n_bins = 15;
    expo = round( - log10(max(abs(XclsEncoded))));
    lims = [ round(min(XclsEncoded),expo+1)-10^(-expo-1), ( round(max(XclsEncoded),expo+1) +10^(-expo-1)) ];
    
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
% subplot(339) 

subplot(6,4,[19,23])
    x = [0 1 1 0];  y = [0 0 1 1]*0.7;
    pc = patch(x,y,backColor,'EdgeColor',edgeCol);
    tx = text(0.1,0.3,['Sparse Sensor Placement', ...
        char(10),'for Optimal Classification'],'FontSize',7);
    axis off
   
    
subplot(6,4,[20,24])
    load(['introFigData' filesep  'LDAhistograms' ]);
    n_bins = 15;
    expo = round( - log10(max(abs(XclsEncodedSparse))));
    lims = [ round(min(XclsEncodedSparse),expo+1)-10^(-expo-1), ( round(max(XclsEncodedSparse),expo+1) +10^(-expo-1)) ];

    rangeBins = linspace(lims(1), lims(2), n_bins);
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

    col = linspecer(2);
    midWay = length(XclsStrain)/2;
    [aCounts] = histcounts(XclsEncodedSparse(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsEncodedSparse(midWay+1:end), rangeBins);

    yLims = [ max(aCounts),-max(bCounts)];

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

 
% saving of image
print(fig03, ['figs' filesep 'Figure_03_neuralEncoding'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig03, 'PaperPosition', myfiguresize);

print(fig03, ['figs' filesep 'Figure_03_neuralEncoding'], '-dsvg', '-r1000');



