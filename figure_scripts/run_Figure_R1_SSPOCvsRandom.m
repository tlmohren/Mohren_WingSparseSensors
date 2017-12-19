%------------------------------
% run_Figure1_Figure2A_ThetaDistVSPhiDist.m
%
% Plots figures 1 and 2A
%
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)
%------------------------------
clc;clear all; close all
addpathFolderStructure()
w = warning ('off','all');

% figure decisions 
width       = 4;     % Width in inches,   find column width in paper 
height      = 4.5;    % Height in inches
fsz         = 8;      % Fontsize
labels_on   = false;
% plot_on     = false;
sigmoid_fit = true;

%% Processing before plotting 
parameterSetName = 'R1_Iter100';
overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';

load( ['accuracyData' filesep 'parameterSet_' parameterSetName ] )
fixPar.data_loc = 'accuracyData';

fixPar.nIterFig = 100;
fixPar.nIterSim = 100; 

[dataStruct,paramStruct] = combineDataMat( fixPar, simulation_menu.R1_standard );
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,simulation_menu.R1_all_nofilt);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,simulation_menu.R1_all_filt);

%  R1_all_filt
ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);
%% setup figure
fig1 = figure();
subplot(5,3,4:15)
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size

errLocFig1A = 34;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A  ],'xticklabel',{'0','10','20','30', '\bf 1326'},...
    'ytick',0.5:0.25:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] ,...
    'LabelFontSizeMultiplier',1};

plotCol = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 
hold on

%% Figure 1
%---------------------------------SSPOCoff-------------------------
if any(ind_SSPOCoff)
    Dat_I = ind_SSPOCoff( 1);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
    realNumbers = find(~isnan(meanVec));
    
    pltSSPOCoff = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),plotCol{1});
end

sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show', false);
        
%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));

dotSize = 50;
%%
for k2 = 1:size(dataStruct.dataMatTot,2)
    y_data = nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)); 
    mv = mean(y_data);
    med(k2) = median(y_data);
    if ~isempty(y_data)
        data = nan(length(y_data),30);
        data(:,k2) = y_data;
        plotSpread( data ,'distributionMarker','.','distributionColors','r','spreadWidth',1)
    end
end

Dat_I = ind_SSPOCon( 1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));
sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',2);


%% plot the line? 
% pltSSPOCon = plot(realNumbers, meanVec(realNumbers),plotCol{2});
pltSSPOCon = plot(0,0);
%% 
%--------------------------------Allsensors Neural filt-------------------------    
meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(1,:)  ) );
stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(1,:)  ) );
scatter(errLocFig1A,meanval,50,'rd','filled')

%--------------------------------Allsensors no NF-------------------------    
meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(1,:)  ) );
stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(1,:)  ) );
scatter(errLocFig1A,meanval,50,'filled','kd')

%% Legend 
% legend_entries = { 'Random Sensors', 'SSPOC Sensors'};
legend_entries = { ['Random Sensors,' char(10) '$\phantom{.....}$ Encoded'],...
                    ['SSPOC Sensors,'  char(10) '$\phantom{.....}$ Encoded']};

legend_location = 'Best';
legVec = [pltSSPOCoff.mainLine, pltSSPOCon];
legOpts = {'FontSize',fsz,'Location',legend_location};

allText1 = ['All Sensors,' char(10) 'Raw Strain'];
allText2 = ['All Sensors,' char(10)  'Encoded'];

grid on 
axPlot = gca();
set(axPlot, axisOptsFig1A{:})
if labels_on == true
    [leg,lns] = legend(legVec,legend_entries, legOpts{:});

    tx1 = text(20,0.5,allText1,'FontSize',fsz);
    tx2 = text(20,0.7,allText2,'FontSize',fsz);  
    xlabel('Number of Sensors, $q$'); ylabel('Cross-Validated Accuracy')
    break_axis('axis','x','position',(errLocFig1A -30)/2+30, 'length',0.05)
    
end

%% Sensor locations 
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
        
    hold on
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
print(fig1, ['figs' filesep 'Figure_R1' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig1, 'PaperPosition', myfiguresize);

print(fig1, ['figs' filesep 'Figure_R1' ], '-dsvg');



