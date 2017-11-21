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
width = 7;     % Width in inches,   find column width in paper 
height = 2.5;    % Height in inches
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
subplot(1,2,1)
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size

errLocFig1A = 32;
axisOptsFig1A = {'xtick',[0:10:30  ],'xticklabel',{'0','10','20','30'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] ,...
    'LabelFontSizeMultiplier',1};

col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
hold on

%% Figure 1
%---------------------------------SSPOCoff-------------------------
if any(ind_SSPOCoff)
    Dat_I = ind_SSPOCoff( 1);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
    realNumbers = find(~isnan(meanVec));
    
    pltSSPOCoff = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
end
sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));

for k2 = 1:size(dataStruct.dataMatTot,2)
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
    
    a = scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)),30 , dotcol{2});
end
pltSSPOCon = plot(realNumbers, meanVec(realNumbers),col{2});
sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
%--------------------------------Allsensors Neural filt-------------------------    
meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(1,:)  ) );
stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(1,:)  ) );

eBarNF = errorbar(errLocFig1A,meanval,stdval,'b','LineWidth',1);
plot([-1,1]+errLocFig1A,[meanval,meanval],'b','LineWidth',1)   

%--------------------------------Allsensors no NF-------------------------    
meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(1,:)  ) );
stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(1,:)  ) );

eBar = errorbar(errLocFig1A, meanval, stdval,'k','LineWidth',1);
plot([-1,1]+errLocFig1A, [meanval, meanval],'k','LineWidth',1)   

%% Legend 
legend_entries = {'Random Sensors', 'SSPOC Sensors'};


legVec = [pltSSPOCoff.mainLine, pltSSPOCon];
legOpts = {'FontSize',fsz};
[leg,lns] = legend(legVec,legend_entries, legOpts{:});


tx1 = text(20,0.5,'All Sensors, Strain','FontSize',fsz)
tx2 = text(20,0.7,'All Sensors, Encoded','FontSize',fsz)

%% --------------------------------Figure cosmetics-------------------------    
xlabel('Number of Sensors'); ylabel('Cross-Validated Accuracy')
grid on 
axPlot = gca();
set(axPlot, axisOptsFig1A{:})
drawnow
% break_axis('axis','x','position',(errLocFig1A -30)/2+30, 'length',0.05)


%% Sensor locations 

q = 13;
binar = get_pdf( dataStruct.sensorMatTot(2,q,1:q,:));
sensorloc_tot = reshape(binar,fixPar.chordElements,fixPar.spanElements); 
colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
% imOpts = {'FaceColor','flat','EdgeColor','k','Clipping','off'};
 
redColBrew = [
    255,255,204;...
%     255,237,160;...
%     254,217,118;...
    254,178,76;...
%     253,141,60;...
    252,78,42;...
%     227,26,28;...
    189,0,38;...
    128,0,38 ]/255;
greenBlueColBrew = [
%             255,255,217;...
            237,248,177;...
%             199,233,180;...
%             127,205,187;...
            65,182,196;...
            29,145,192;...
            34,94,168;...
            37,52,148;...
            8,29,88]/255;
purpColBrew = [
        252,251,253;...
%         239,237,245;...
%         218,218,235;...
%         188,189,220;...
%         158,154,200;...
        128,125,186;...
        106,81,163;...
        84,39,143;...
        63,0,125]/255;
    
newColBrew = redColBrew;
% newColBrew = greenBlueColBrew;
% newColBrew = purpColBrew

subplot(122)
im = imagesc(  (sensorloc_tot));
    colormap(newColBrew)
    ax = gca(); 
    set(ax,axOpts{:})
        rectangle('Position',[0.5,0.5,fixPar.spanElements,fixPar.chordElements])
        axis off
    hold on
    scatter(0.5,13,30,'filled','k')
    plot([1,1]*0.5,[0.5,26.5],'k','LineWidth',2)


%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
tightfig;
% % Here we preserve the size of the image when we save it.


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



