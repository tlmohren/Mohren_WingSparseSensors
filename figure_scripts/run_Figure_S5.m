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
width = 6;     % Width in inches,   find column width in paper 
height =6;    % Height in inches

set(0,'DefaultAxesFontSize',7)% .
% set(0,'DefaultAxesLabelFontSize', 8/6)

%% Data collection 
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
    
fixPar.nIterFig = 10;
fixPar.nIterSim = 5; 

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2B' )));
varParCombinationsR2B = varParCombinationsAll(figMatch);
[dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinationsR2B);
ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2C' )));
varParCombinationsR2C = varParCombinationsAll(figMatch);
[dataStructC,paramStructC] = combineDataMat(fixPar,varParCombinationsR2C);
ind_SSPOCoffC = find( ~[paramStructC.SSPOCon]);
ind_SSPOConC = find([paramStructC.SSPOCon]);


%% Figure settings
fig_S5 = figure();
set(fig_S5, 'Position', [fig_S5.Position(1:2) width*100, height*100]); %<- Set size
plot_on = false;

fszL = 8;  
fszM = 7;
fszS = 6; 
%% Axis makeup 
col = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 

%% 
n_x = length(varParCombinationsR2B.theta_distList);
for k = 1:n_x
    %---------------------------------SSPOCoff-------------------------
    Dat_I = ind_SSPOCoffB( k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
    realNumbers = find(~isnan(meanVec));
    thresholdMatB(k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

    %---------------------------------SSPOCon-------------------------
    Dat_I = ind_SSPOConB(k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
    realNumbers = find(~isnan(meanVec));
    thresholdMatB(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
end

n_x = length(varParCombinationsR2C.phi_distList);
for k = 1:n_x
    %---------------------------------SSPOCoff-------------------------
    Dat_I = ind_SSPOCoffC( k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
    realNumbers = find(~isnan(meanVec));
    thresholdMatC(k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

    %---------------------------------SSPOCon-------------------------
    Dat_I = ind_SSPOConC(k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
    realNumbers = find(~isnan(meanVec));
    thresholdMatC(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
end

%% 
cols = [ [1,1,1]*0.5 ; 
            1,0,0 ];
        
fig2SimsC = mod(log10(varParCombinationsR2C.phi_distList/0.00312) ,1) == 0;
fig2SimsB = mod(log10(varParCombinationsR2B.theta_distList/0.01) ,1) == 0;

% figure()
subplot(211)
    semilogx(varParCombinationsR2C.phi_distList, thresholdMatC(:,1),'Color',cols(1,:))
    hold on
    semilogx(varParCombinationsR2C.phi_distList, thresholdMatC(:,2),'Color',cols(2,:))


    plot(varParCombinationsR2C.phi_distList(fig2SimsC ), thresholdMatC(fig2SimsC ,1)','o','Color',cols(1,:))
    plot(varParCombinationsR2C.phi_distList(fig2SimsC ), thresholdMatC(fig2SimsC ,2),'o','Color',cols(2,:))


    xlabel('Disturbance $\dot{\phi}^*$ [rad/s]'); ylabel(['Number of Sensors, q,' char(10) 'Required for 75\% Accuracy'],'Rotation',0)
    legend('Random Sensors','SSPOC Sensors','Location','Best')

subplot(212)
    semilogx(varParCombinationsR2B.theta_distList, thresholdMatB(:,1),'Color',cols(1,:))
    hold on
    semilogx(varParCombinationsR2B.theta_distList, thresholdMatB(:,2),'Color',cols(2,:))
    xlabel('Disturbance $\dot{\theta}^*$ [rad/s]'); ylabel(['Number of Sensors, q,' char(10) 'Required for 75\% Accuracy'],'Rotation',0)
    legend('Random Sensors','SSPOC Sensors','Location','Best')

    plot(varParCombinationsR2B.theta_distList(fig2SimsC ), thresholdMatB(fig2SimsB ,1)','o','Color',cols(1,:))
    plot(varParCombinationsR2B.theta_distList(fig2SimsC ), thresholdMatB(fig2SimsB ,2),'o','Color',cols(2,:))


%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig_S5,'InvertHardcopy','on');
set(fig_S5,'PaperUnits', 'inches');
papersize = get(fig_S5, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig_S5, 'PaperPosition', myfiguresize);

%% Saving figure 
print(fig_S5, ['figs' filesep 'Figure_S5' ], '-dpng', '-r600'); 


stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig_S5, 'PaperPosition', myfiguresize);

print(fig_S5, ['figs' filesep 'Figure_S5'], '-dsvg', '-r600');


