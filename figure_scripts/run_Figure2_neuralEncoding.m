%------------------------------
% run_Figure_02_neuralEncoding
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpathFolderStructure()
%% 
set(0,'DefaultAxesFontSize',8)% .
set(0,'DefaultAxesLabelFontSize', 8)
load(['figData' filesep  'LDAhistograms' ]);

% pre plot decisions 
width = 9.5;     % Width in inches,   find column width in paper 
height = 4.5;    % Height in inches

% general plotting options 
n_bins = 15;
edgeCol = 'none';
col = linspecer(2);
barOpts1 = {'BarWidth',0.7,'EdgeColor','none','FaceColor',col(1,:)}
barOpts2 = {'BarWidth',0.7,...
        'FaceColor',col(2,:),...
        'EdgeColor','none',...
        };

% define color schemes 
colScheme = [255,245,239
    227, 214, 244
    255,246,213
    255,230,213]/255;

inoffensiveBlue =[247,252,240
224,243,219
204,235,197
168,221,181
123,204,196
78,179,211
43,140,190
8,104,172
8,64,129];
strainScheme = colorSchemeInterp(inoffensiveBlue/255, 500);

fireRed = [255,247,236
254,232,200
253,212,158
253,187,132
252,141,89
239,101,72
215,48,31
179,0,0
127,0,0];
fireScheme = colorSchemeInterp(fireRed/255, 500);
    
    
% subplot madness 
pX = 38;
pY = 14;
subGrid = reshape(1:(pX*pY),pX,pY)';

dx = 1;
dt = 5;
dn = 6;
dy = 4;

Row1S = 1;
Row1E = 3;

Row2S = Row1E+2;
Row2E = Row2S+2;

Row3S = Row2E+1;
Row3E = Row3S+2;

Col1S = 1;
Col1E = 6;

Col2S = Col1E+1;
Col2E = Col2S+5;

Col3S = Col2E + 2;
Col3E = Col3S +4;

Col4S = Col3E + 2;
Col4E = Col4S + 5;

Col5S = Col4E + 2;
Col5E = Col5S + 5;

Col6S = Col5E + 1;
Col6E = Col6S + 4;

strainTitle = subGrid( 	  Row1S:Row1E , (Col1S:Col1E ) );
neuralTitle = subGrid( 	  Row2S:Row3E , (Col1S:Col1E ) );

strainTextSub = subGrid( 	  Row1S:Row1E , (Col2S:Col2E ) );
strainHeatMapSub = subGrid( Row1S:Row1S+1         ,(Col3S+1:Col3E-1)   );
strainTraceSub = subGrid(    Row1E:Row1E           ,  (Col3S+1:Col3E-1)   );

neuralTextSub = subGrid(     Row2S:Row2E     ,  (Col2S:Col2E ) );
STASub  = subGrid(          Row3S:Row3S         ,  (Col2S:Col2E-1 ) );
NLDSub = subGrid(          Row3E:Row3E         ,  (Col2S:Col2E-1 ) );

pfireTextSub = subGrid(      Row2S:Row2E   , (Col3S:Col3E)   );
pfireHeatMapSub = subGrid(  Row3S:Row3S+1   , (Col3S+1:Col3E-1)   );
pfireTraceSub = subGrid(     Row3E:Row3E      , (Col3S+1:Col3E-1)   );

strainClassSub = subGrid(   Row1S:Row1E          , Col4S:Col4E  );
pfireClassSub = subGrid(    Row2S:Row2E     , Col4S:Col4E );
sspocClassSub = subGrid(     Row3S:Row3E      , Col4S:Col4E ); 

strainHistSub = subGrid(     Row1S:Row1E         , Col5S:Col5E );
pfireHistSub = subGrid(      Row2S:Row2E     , Col5S:Col5E ); 
sspocHistSub = subGrid(     Row3S:Row3E     ,Col5S:Col5E ); 

strainNoteSub = subGrid(     Row1S:Row1E         , Col6S:Col6E );
pfireNoteSub = subGrid(      Row2S:Row2E     , Col6S:Col6E ); 
sspocNoteSub = subGrid(     Row3S:Row3E     ,Col6S:Col6E ); 

%% figure treatment
fig03 = figure();
ax = gca();
set(fig03, 'Position', [fig03.Position(1:2) width*100, height*100]); %<- Set size

%%  Get data
N0= load(['figData' filesep 'noise0'],'strain');

parameterSetName = 'R1_Iter100';
load(['accuracyData' filesep 'parameterSet_' parameterSetName ])
parameterSetName    = ' ';
iter                = 1;
fontSize            = 7;
figuresToRun        = {'R1_allSensorsFilt'};

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


%% Title row plots 
titleFont = 11;
subplot(pY,pX,strainTitle(:) );
    x = [0 1 1 0];  y = [0 0 1 1];
    tx = text(0.1,0.4,'\bf{Raw Strain}','FontSize',titleFont,'fontweight','bold');
    axis off
    
    subplot(pY,pX,neuralTitle(:) );
    x = [0 1 1 0];  y = [0 0 1 1];
    tx = text(0.1,0.45,['\bf{Neurally}' char(10) '\bf{Encoded}' char(10) '$\phantom{.}$  \bf{Strain}'],'FontSize',titleFont,'fontweight','bold');
    axis off
    
%%  First row plots 
subplot(pY,pX,strainTextSub(:) );
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,colScheme(1,:),'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'\bf{Strain}$\mathbf{(x,y,t)}$','FontSize',fontSize,'fontweight','bold');
    axis off
    
subplot(pY,pX,strainHeatMapSub(:) )
    N0= load(['figData' filesep 'noise0'],'strain');
    dim_wing = [26,51,4000];
    t_inst = 3008;
    sensorSpec = [10,10];
    strain0 = reshape(N0.strain.strain_0,dim_wing);
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    pcOpts = {'FaceColor','flat'};
    colormap(strainScheme)
    pc1 = pcolor(strain0(:,:,t_inst));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off
    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',1)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',0.5)
    
subplot(pY,pX,strainTraceSub(:) )
    timeInd = 1000:1200;
    strain  = squeeze(strain0( sensorSpec(1),sensorSpec(2),timeInd ));
    lim = [min(strain),max(strain)];
    plot( strain,'k' )
    axis([1,length(timeInd),lim(1)*1,lim(2)*1 ])
    axis off
%
subplot(pY,pX,strainClassSub(:) )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,colScheme(1,:),'EdgeColor',edgeCol);
    textIn = ['$\phantom{.}$ All Sensor' char(10) 'Classification'];
    tx = text(0.1,0.3,textIn,'FontSize',fontSize);
    axis off
    
subplot(pY,pX,strainHistSub(:) )
    expo = round( - log10(max(abs(XclsStrain))));
    xLims = [ round(min(XclsStrain),expo+1)-10^(-expo-1), ( round(max(XclsStrain),expo+1) +10^(-expo-1)) ];

    rangeBins = linspace(xLims(1), xLims(2), n_bins);
    xstep = (xLims(2)-xLims(1))/n_bins; 
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

    midWay = length(XclsStrain)/2;
    [aCounts] = histcounts(XclsStrain(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsStrain(midWay+1:end), rangeBins);

    yLims = [ max(aCounts),-max(bCounts)];
    ystep = (yLims(1)-yLims(2))/n_bins;
    
    xLimsBase = xLims +[-1,1]*xstep*1;
    yLimsMid = yLims +[1,-1]*ystep*2;
    
    xLimsPatch = xLims +[-xstep*2.5,xstep*4];
    yLimsPatch = yLims+[1,-1]*ystep*3;
    
    x = [xLimsPatch(1) xLimsPatch(2) xLimsPatch(2) xLimsPatch(1)];
    y = [yLimsPatch(2),yLimsPatch(2),yLimsPatch(1),yLimsPatch(1)];
    pc = patch(x,y,colScheme(1,:),'EdgeColor',edgeCol);
        hold on
%     
    bar1 = bar(binMids,aCounts );
    bar2 = bar(binMids,-bCounts,'r');
    
    % baseline and midline 
    plot(xLimsBase,[0,0],'k','LineWidth',0.5)
    plot([1,1]*strainMidLine,yLimsMid,'k-','LineWidth',0.5)
  
    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})
    set( bar1.BaseLine,'Visible','off')
    
    axis([xLimsPatch(1),xLimsPatch(2),yLimsPatch(2),yLimsPatch(1)])
    axis off
    
    text( xLimsBase(2),0,'$\mathbf{w}$','FontSize',fontSize)
    txtcol = linspecer(2); 
    
    text( binMids(end-2),200,...
        ['Flapping' char(10) '$\phantom{..}$Only'],'Color',...
        txtcol(1,:),'FontSize',fontSize)
    text( binMids(end-2),-300,...
        ['$\phantom{..}$ With' char(10) 'Rotation'],'Color',...
        txtcol(2,:),'FontSize',fontSize)

    


    
    
%% Neural box plots 
   
subplot(pY,pX,neuralTextSub(:) )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,colScheme(2,:),'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'\bf{Neural Encoder}','FontSize',fontSize);
    tx = text(0.1,0.6,'Campaniform Sensilla','FontSize',fontSize);
    axis off
    
subplot(pY,pX,STASub(:) )
    STAstruct = load( ['figData' filesep  'STA and StdM4 N2' ]);
    plot(linspace(-40,0,160),STAstruct.STA(1:10:1600),'k')
    axis([-50,10,-0.9,1.2])
    box off
    hold on 
    axis off    
    tx = text(0,0, 'STA($t$)','FontSize',fontSize);
subplot(pY,pX,NLDSub(:) )
    NLDstruct = load(['figData' filesep 'NLDM4 N2' ]);
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}),'k')
    xlabel('Strain Projection on Feature');ylabel('Probability of Firing')
    hold on
    axis([-1.1,1.1,-0.2,1])
    text(0.733,0.3, 'NLD($\xi$)','FontSize',fontSize)
    axis off
    
    
    
    
    
    
%% Pfire box plots 
subplot(pY,pX,pfireTextSub(:) )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,colScheme(2,:),'EdgeColor',edgeCol);
    tx = text(0.1,0.3,'\bf{Pfire}($\mathbf{x,y,t}$)','FontSize',fontSize);
    axis off
    
t_inst = 3035;

spFire = subplot(pY,pX,pfireHeatMapSub(:) );
    colormap(spFire,fireScheme)
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    Pfire = reshape(X_fire,dim_wing+[0,0,2000]);
    pc2 = pcolor( Pfire(:,:,t_inst) );
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc2,pcOpts{:})
    axis off
    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',1)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',0.5)
%     colorbar
subplot(pY,pX,pfireTraceSub(:) )
    timeInd = 1000:1200;
    PfireSensor  = squeeze(Pfire( sensorSpec(1),sensorSpec(2),timeInd ));
    lim = [min(PfireSensor),max(PfireSensor)];
    plot( PfireSensor,'k')
    axis([1,length(timeInd),lim(1)*1,lim(2)*1 ])
    axis off
    
   

    
%% Second row plots 
subplot(pY,pX,pfireClassSub(:) )
    x = [0 1 1 0];  y = [0 0 1 1] ;
    pc = patch(x,y, colScheme(3,:),'EdgeColor',edgeCol);
    tx = text(0.1,0.3,textIn,'FontSize',fontSize);
    axis off
    if mean(XclsEncoded(1:end/2)) > 0 
        XclsEncoded = -XclsEncoded;
    end
    
subplot(pY,pX,pfireHistSub(:) )
    barPlots(XclsEncoded,encodedMidLine, n_bins, colScheme(3,:), edgeCol, barOpts1, barOpts2)


    
%% Third row plots 
fixPar.nIterFig = 100;
fixPar.data_loc = 'accuracyData';
[dataStruct,paramStruct] = combineDataMat(fixPar,simulation_menu.R1_standard);
q = 13;
binar = get_pdf( dataStruct.sensorMatTot(2,q,1:q,:));
sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 
        
subplot(pY,pX,sspocClassSub(:) )
    x = [0 1 1 0];  y = [0 0 1 1] ;
    pc = patch(x,y,colScheme(4,:),'EdgeColor',edgeCol);
    hold on 
    textIn = ['Sparse Sensor Placement', ...
        char(10),'for Optimal Classification'];
    textIn = [' \bf{ Sparse Sensor}' char(10),...
        '$\phantom{.}$ \bf{Locations}'];
    im = imagesc(  (sensorloc_tot));
    tx = text(0.1,0.8,textIn,'FontSize',7,'Interpreter','latex');
    ax = gca(); 
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
    set(ax,axOpts{:})
    axis off
    
    
subplot(pY,pX,sspocHistSub(:) )
    if mean(XclsEncodedSparse(1:end/2)) > 0 
        XclsEncodedSparse = -XclsEncodedSparse;
    end
    barPlots(XclsEncodedSparse, encodedSparseMidLine, n_bins, colScheme(4,:), edgeCol, barOpts1, barOpts2)

    
subplot(pY,pX,strainNoteSub(:) )
    textIn = ['$\phantom{.}q = 1326$' char(10),...
                'Poor Classification'];
    tx = text(0.1,0.3,textIn,'FontSize',fontSize);
    axis off
    
    
subplot(pY,pX,pfireNoteSub(:) )
    textIn = ['$\phantom{.}q = 1326$' char(10),...
                'Good Classification'];
    tx = text(0.1,0.3,textIn,'FontSize',fontSize);
    axis off
    
subplot(pY,pX,sspocNoteSub(:) )
    textIn = ['$\phantom{.}{\boldmath q = 13}$' char(10),...
                '\bf{Good Classification}' char(10),...
                '\bf{Efficient}'];
    tx = text(0.1,0.3,textIn,'FontSize',fontSize);
    axis off
    
    
    
%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure

% % % Here we preserve the size of the image when we save it.
set(fig03,'InvertHardcopy','on');
set(fig03,'PaperUnits', 'inches');
papersize = get(fig03, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig03, 'PaperPosition', myfiguresize);
 
% saving of image
print(fig03, ['figs' filesep 'Figure2_neuralEncoding'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig03, 'PaperPosition', myfiguresize);

print(fig03, ['figs' filesep 'Figure2_neuralEncoding'], '-dsvg', '-r1000');



