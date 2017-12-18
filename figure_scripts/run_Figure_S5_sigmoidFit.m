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

% pre plot decisions 
width = 6;     % Width in inches,   find column width in paper 
height = 4;    % Height in inches
fsz = 8;      % Fontsize
legend_location = 'Best';
plot_on = false;

%% Processing before plotting 
% % parameterSetName = 'R1R4_Iter3_delay5_eNet09';
% % parameterSetName = 'R1_Iter100';
% % 
% % overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
% % github_loc = 'accuracyData';
% % try
% %     load([github_loc filesep 'parameterSet_' parameterSetName ])
% %     fixPar.data_loc = github_loc;
% % catch
% %     display('not on github, looking at old data')
% %     load([overflow_loc filesep 'parameterSet_' parameterSetName ])
% %     fixPar.data_loc = overflow_loc;
% % end 
% % 
% % fixPar.nIterFig = 100;
% % fixPar.nIterSim = 100; 
% % 
% % figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_disturbance' )));
% % varParCombinations_R1 = varParCombinationsAll(figMatch);
% % [dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinations_R1);
% % 
% % ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
% % ind_SSPOCon = find([paramStruct.SSPOCon]);
% % 
% % figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_allSensorsNoFilt' )));
% % varParCombinations_allNoFilt = varParCombinationsAll(figMatch);
% % [dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinations_allNoFilt);
% % 
% % figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_allSensorsFilt' )));
% % varParCombinations_allFilt = varParCombinationsAll(figMatch);
% % [dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinations_allFilt);


% parameterSetName = 'R1R4_Iter3_delay5_eNet09';
parameterSetName = 'R1_Iter100';
% parameterSetName = 'R1_Iter1';


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

fixPar.nIterFig = 100;
fixPar.nIterSim = 100; 

[dataStruct,paramStruct] = combineDataMat( fixPar, simulation_menu.R1_standard );
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,simulation_menu.R1_all_nofilt);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,simulation_menu.R1_all_filt);

%  R1_all_filt
ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);


%% setup figure
fig_S6 = figure();
% subplot(5,3,4:15)
set(fig_S6, 'Position', [fig_S6.Position(1:2) width*100, height*100]); %<- Set size

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
sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));

dotSize = 50;
% break
%%
colNew = [0 0.4470 0.7410;...
    0.8500 0.3250 0.0980];
%
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

pltSSPOCon = plot(realNumbers, meanVec(realNumbers),plotCol{2});
plot_on = true;
q = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

text(q+0.5,0.45,['q = ',num2str( round(q,2) )] )

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
legend_entries = { ['Random Sensors, Encoded'],...
                    ['SSPOC Sensors, Encoded'],...
                    'Sigmoidal Fit',...
                    'Intersection 75\%'};
a = plot([1,2],[1,2],'k:')
b = plot([1,2],[1,2],'k--')

legVec = [pltSSPOCoff.mainLine, pltSSPOCon, a,b];
legOpts = {'FontSize',fsz,'Location',legend_location};
[leg,lns] = legend(legVec,legend_entries, legOpts{:});

allText1 = ['All Sensors,' char(10) 'Raw Strain'];
allText2 = ['All Sensors,' char(10)  'Encoded'];
tx1 = text(20,0.5,allText1,'FontSize',fsz);
tx2 = text(20,0.7,allText2,'FontSize',fsz);

%% ----------
% ----------------------Figure cosmetics-------------------------    
xlabel('Number of Sensors, $q$'); ylabel('Cross-Validated Accuracy')
grid on 
axPlot = gca();
set(axPlot, axisOptsFig1A{:})
drawnow
break_axis('axis','x','position',(errLocFig1A -30)/2+30, 'length',0.05)




%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
tightfig;

set(fig_S6,'InvertHardcopy','on');
set(fig_S6,'PaperUnits', 'inches');
papersize = get(fig_S6, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig_S6, 'PaperPosition', myfiguresize);

% Saving figure 
print(fig_S6, ['figs' filesep 'Figure_S6' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig_S6, 'PaperPosition', myfiguresize);

print(fig_S6, ['figs' filesep 'Figure_S6' ], '-dsvg');



