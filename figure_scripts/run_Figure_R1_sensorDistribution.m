%------------------------------
% run_Figure_R1_sensorDistribution
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clc;clear all; close all
addpathFolderStructure()
w = warning ('off','all');

% figure decisions 
width       = 3;     % Width in inches,   find column width in paper 
height      = 2.5;    % Height in inches
fsz         = 8;      % Fontsize
labels_on   = false;
sigmoid_fit = true;

%% Processing before plotting 
parameterSetName = 'R1_Iter100';
overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
load( ['accuracyData' filesep 'parameterSet_' parameterSetName ] )
fixPar.data_loc = 'accuracyData';
fixPar.nIterFig = 100;
fixPar.nIterSim = 100; 

[dataStruct,paramStruct] = combineDataMat( fixPar, simulation_menu.R1_standard );

%% Sensor locations 
fig1 = figure();
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size

q = 13;

binar           = get_pdf( dataStruct.sensorMatTot(2,q,1:q,:));
sensorloc_tot   = reshape(binar,fixPar.chordElements,fixPar.spanElements); 

colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};

subplot(5,3,[1,2])
    x   = [0 1 1 0]* (fixPar.spanElements+1);  
    y   = [0 0 1 1]* (fixPar.chordElements+1);
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on 
    [X,Y] = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
    I = find( sensorloc_tot );      
    sc  = scatter(X(I) ,Y(I) , 100 ,'.','r');      
    
    % create black frame 
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    plot(x,y,'k','LineWidth',0.5)
    
    ax = gca(); 
    set(ax,axOpts{:})
    axis off

%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
tightfig;

set(fig1,'InvertHardcopy','on');
set(fig1,'PaperUnits', 'inches');
papersize = get(fig1, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig1, 'PaperPosition', myfiguresize);

% Saving figure 
print(fig1, ['figs' filesep 'Figure_R1_sensorDistrubtion' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig1, 'PaperPosition', myfiguresize);

print(fig1, ['figs' filesep 'Figure_R1_sensorDistrubtion' ], '-dsvg');
