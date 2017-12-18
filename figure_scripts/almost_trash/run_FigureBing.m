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


% set(groot, 'defaultAxesTickLabelInterpreter', 'factory');
addpathFolderStructure()
w = warning ('off','all');

% pre plot decisions 
width = 3.5;     % Width in inches,   find column width in paper 
height = 1.5;    % Height in inches
fsz = 8;      % Fontsize
% legend_entries = {'All Sensors, Strain','All Sensors, Encoded','Random Sensors, Encoded', 'Optimal Sensors, Encoded'};
legend_location = 'NorthEast';
plot_on = false;

%% Processing before plotting 
% parameterSetName = 'R1R4_Iter3_delay5_eNet09';
parameterSetName = 'R1R4_Iter5_delay5_eNet09';

overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
github_loc = 'accuracyData';
try
    load([github_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = github_loc;
catch
    display('not on github, looking at old data')
    load([overflow_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = overflow_loc;
end 

fixPar.nIterFig = 50;
fixPar.nIterSim = 5; 

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_disturbance' )));
varParCombinations_R1 = varParCombinationsAll(figMatch);
[dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinations_R1);

ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_allSensorsNoFilt' )));
varParCombinations_allNoFilt = varParCombinationsAll(figMatch);
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinations_allNoFilt);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_allSensorsFilt' )));
varParCombinations_allFilt = varParCombinationsAll(figMatch);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinations_allFilt);


%% setup figure
fig1 = figure();
subplot(5,3,4:15)
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size


col = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 
hold on


%% Sensor locations 

q = 13;
binar = get_pdf( dataStruct.sensorMatTot(2,q,1:q,1));
sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 
colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};

% newColBrew = greenBlueColBrew;

x = [0 1 1 0]* (fixPar.spanElements+1);  y = [0 0 1 1]* (fixPar.chordElements+1);
hold on 
[X,Y] = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
I = find( (sensorloc_tot) );

scatter(X(I) ,Y(I) , 100,'.');

ax = gca(); 
set(ax,axOpts{:})
axis off
hold on
scatter(0,13,100,'.k')
plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
plot(x,y,'k','LineWidth',0.5)


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
print(fig1, ['figs' filesep 'Figure_singleSensorInstance' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig1, 'PaperPosition', myfiguresize);

print(fig1, ['figs' filesep 'Figure_singleSensorInstance' ], '-dsvg');

