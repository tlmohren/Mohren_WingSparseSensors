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
width = 3.3;     % Width in inches,   find column width in paper 
height = 1.7;    % Height in inches
fsz = 7;      % Fontsize
legend_entries = {'All Sensors, Strain','All Sensors, Encoded','Random Sensors, Encoded', 'Optimal Sensors, Encoded'};
legend_location = 'NorthEast';

%% Processing before plotting 
% parameterSetName = 'R1R4_Iter3_delay5_eNet09';
parameterSetName = 'R1R4_Iter5_delay5_eNet09';

overflow_loc = 'D:\Mijn_documenten\Dropbox\A. PhD\C. Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
github_loc = 'accuracyData';
try
    load([github_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = github_loc;
catch
    display('not on github, looking at old data')
    load([overflow_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = overflow_loc;
end 

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
% subplot(1,2,1)
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size

errLocFig1A = 35;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A ],'xticklabel',{'0','10','20','30','\textbf{ {1326}}'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] };

col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
hold on


%% Sensor locations 


q = 17;
binar = get_pdf( dataStruct.sensorMatTot(1,q,1:q,1));
sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 
colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};

subplot(211)
    imshow((1-sensorloc_tot), 'InitialMagnification', 'fit')
    rectangle('Position',[0.5,0.5,fixPar.spanElements,fixPar.chordElements])
    
    set(gca,'YDir','normal')
    hold on 
%     h = gca;  % Handle to currently active axes
    set(gca, 'YDir', 'reverse');
    hb = colorbar;
    set(hb,colorBarOpts{:});
    %     set( h, colorBarOpts{:})
    hold on
    plot( [1,1]*0.5,[-1,27],'k','LineWidth',1)
    scatter(0.5,14,40,'k','filled')
    title('Sensor Locations for \#17')
    
    
q = 17;
binar = get_pdf( dataStruct.sensorMatTot(2,q,1:q,1));
sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 
colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};

subplot(212)
    imshow((1-sensorloc_tot), 'InitialMagnification', 'fit')
    rectangle('Position',[0.5,0.5,fixPar.spanElements,fixPar.chordElements])
    
    set(gca,'YDir','normal')
    hold on 
%     h = gca;  % Handle to currently active axes
    set(gca, 'YDir', 'reverse');
    hb = colorbar;
    set(hb,colorBarOpts{:});
    %     set( h, colorBarOpts{:})
    hold on
    plot( [1,1]*0.5,[-1,27],'k','LineWidth',1)
    scatter(0.5,14,40,'k','filled')
    title('Sensor Locations for \#17')

%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig1,'InvertHardcopy','on');
set(fig1,'PaperUnits', 'inches');
papersize = get(fig1, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig1, 'PaperPosition', myfiguresize);

% Saving figure 
print(fig1, ['figs' filesep 'Figure_03_randomOptimal' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig1, 'PaperPosition', myfiguresize);

print(fig1, ['figs' filesep 'Figure_03_randomOptimal' ], '-dsvg');



