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

set(0,'defaultLineLineWidth',0.3);   % set the default line width to lw
set(0,'defaultLineMarkerSize',2); % set the default line marker size to msz
% pre plot decisions 
width = 8;     % Width in inches,   find column width in paper 
height = 4;    % Height in inches
plot_on = false ;
collect_thresholdMat = false; 


pX = 46;
pY = 28;
staGrid = reshape(1:(pX*pY),pX,pY)';

staFunSub = staGrid( (1:11)     ,(1:12) );
nldFunSub = staGrid( (1:12)+16   ,(1:12) );

staGridSub = staGrid( (1:11)  ,   (1:11)+17 );
nldGridSub = staGrid( (1:12)+16  , (1:11)+17 );

staHeatSub = staGrid( (1:11)    , (1:17)+30 );
nldHeatSub = staGrid( (1:12)+16  , (1:17)+30 );





%% data collection
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

%% Collect STA thresholdMat

if collect_thresholdMat == true 
    figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R3' )));
    varParCombinations = varParCombinationsAll(figMatch);
    [dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinations);
    ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
    ind_SSPOConB = find([paramStructB.SSPOCon]);
    n_x = length(varParCombinations.STAwidthList);
    n_y =  length(varParCombinations.STAfreqList);
    n_plots = n_x*n_y;
    for j = 1:n_y
        for k = 1:n_x
            sub_nr = (j-1)*n_y + k;
            %---------------------------------SSPOCoff-------------------------
            Dat_I = ind_SSPOCoffB( sub_nr);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
            realNumbers = find(~isnan(meanVec));
            STAthresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
            %---------------------------------SSPOCon-------------------------
            Dat_I = ind_SSPOConB(sub_nr);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
            realNumbers = find(~isnan(meanVec));
            STAthresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        end
    end
    % Collect NLD thresholdMat
    figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R4' )));
    varParCombinations = varParCombinationsAll(figMatch);
    [dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinations);
    ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
    ind_SSPOConB = find([paramStructB.SSPOCon]);
    n_x =  length(varParCombinations.NLDgradList);
    n_y = length(varParCombinations.NLDshiftList);

    for j = 1:n_y
        for k = 1:n_x
            sub_nr = (j-1)*n_y + k;
            %---------------------------------SSPOCoff-------------------------
            Dat_I = ind_SSPOCoffB( sub_nr);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
            realNumbers = find(~isnan(meanVec));
            NLDthresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
            %--------------------------------SSPOCon-------------------------
            Dat_I = ind_SSPOConB(sub_nr);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
            realNumbers = find(~isnan(meanVec));        
            NLDthresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        end
    end
    % save('STANLDthresholdMat','STAthresholdMat','NLDthresholdMat')
else
    load(['introFigData' filesep 'STANLDthresholdMat'])
end 

%% Figure 3
fig3 = figure();
set(fig3, 'Position', [fig3.Position(1:2) width*100, height*100]); %<- Set size
plot_on = true ;
%% axis adjustment
fsz = 8;
alw = 0.5;
axisOptsSTA = {'xtick',-40:10:0,'xticklabel',{-40:10:0}, ...
    'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
     'FontSize', fsz, 'LineWidth', alw, 'box','off',...
    'xlim', [-40,0],'YLIM',[-1.4,1.4],...
     };

axisOptsNLD = {'xtick',-1:1:1,'xticklabel',{-1:1:1}, ...
    'xtick',-1:0.5:1,'xticklabel',{-1:0.5:1}, ...
    'ytick',0:1:1 ,'yticklabel',{0:1:1},...
    'ytick',0:0.5:1 ,'yticklabel',{0:0.5:1},...
     'FontSize', fsz, 'LineWidth', alw, 'box','off',...
    'xlim', [-1.1,1.1],'ylim',[-0.2,1.2],...
     };

%% STA / NLD 
% STA 
timeMS = -39:0.1:0;
freq = 1;
STAwidth = 4;
STAdelay = 5;
func = @(t) cos( freq*(t+STAdelay )  ).*exp(-(t+STAdelay ).^2 / STAwidth.^2);

% NLD
eta = 20;
shift = 0.5;
s = - 1:0.01:1;
funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; 

subplot(pY,pX,staFunSub(:))
    plot(timeMS,func(timeMS)*1.2 ,'k')
    xlabel('Time [ms]'); ylabel('Strain')
    grid on
    set(gca, axisOptsSTA{:})

subplot(pY,pX,nldFunSub(:))
    plot(s,funNLD(s),'k')
    xlabel('Strain Projection on Feature');ylabel('Probability of Firing')
    grid on
    set(gca, axisOptsNLD{:})


    
    
    
%% Axis makeup 
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R3' )));
varParCombinationsSTA = varParCombinationsAll(figMatch);

n_x = length(varParCombinationsSTA.STAwidthList);
n_y =  length(varParCombinationsSTA.STAfreqList);
d_x = n_x;
pltSTA = repmat(13:19, 5, 1)+ repmat( (0:4)', [1,7])*19;

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*d_x + k;
        plot_nr = staGridSub( j,k);
        subplot(pY,pX, plot_nr)
        hold on
        varPar.STAfreq = varParCombinationsSTA.STAfreqList(j);
        varPar.STAwidth = varParCombinationsSTA.STAwidthList(k);
        varPar.NLDshift = varParCombinationsSTA.NLDshiftList;
        varPar.NLDgrad = varParCombinationsSTA.NLDgradList;
        [STAfunc,NLDfunc]= createNeuralFilt (fixPar,varPar);
        if  isfield(fixPar,'subSamp') == 0 
            STAt = -39:1:0;
        else
            STAt = -39:1/fixPar.subSamp:0;
        end
        plot( STAt,STAfunc(STAt),'k')
        axis([-39,0,-1,1.2])
        axis off
        grid on 
        if (varPar.STAfreq == 1 && varPar.STAwidth == 4)
            plot( [-40,1,1,-40,-40],[-1,-1,1,1,-1]+0.2,'r','LineWidth',0.5)
        axis([-40,1,-1,1.2])
        end
    end
end

%% 
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R4' )));
varParCombinationsNLD = varParCombinationsAll(figMatch);

n_x = length(varParCombinationsNLD.NLDgradList);
n_y =  length(varParCombinationsNLD.NLDshiftList);

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_x + k;
        plot_nr = nldGridSub( j,k);
        subplot(pY,pX, plot_nr)
        hold on
        varPar.STAwidth = varParCombinationsNLD.STAwidthList(1);
        varPar.STAfreq = varParCombinationsNLD.STAfreqList(1);
        varPar.NLDshift = varParCombinationsNLD.NLDshiftList(j);
        varPar.NLDgrad = varParCombinationsNLD.NLDgradList(k);
        [STAfunc,NLDfunc]= createNeuralFilt (fixPar,varPar);
        NLDs = -1:0.1:1;
        plot( NLDs,NLDfunc(NLDs),'k')
        axis([-1,1,0,1])
        axis off
        if ( 0.45 <= varPar.NLDshift && varPar.NLDshift <= 0.55 && 9.8<= varPar.NLDgrad && varPar.NLDgrad <= 10.2)
            plot( [-1,1,1,-1,-1]*1.2,[-0.05,-0.05,1.05,1.05,-0.05]*1.1,'r','LineWidth',0.5)
            axis([ [-1,1]*1.2 ,-0.05,1.05]*1.1)
        end
    end
end

%% Heatmap cosmetics 
colorBarOpts = {'YDir', 'reverse', 'Ticks' ,[0:10:30], 'TickLabels', {0,10,20,'$>$ 30' }  ,'TickLabelInterpreter','latex'};
% axOptsSTA = {'CLim',[0,30]};

% xtickSTA = 1:2:length(varParCombinationsSTA.STAwidthList);
% ytickSTA = 1:5:length(varParCombinationsSTA.STAfreqList);
% xtickNLD = 1:2:length(varParCombinationsNLD.NLDgradList);
% ytickNLD = 1:5:length(varParCombinationsNLD.NLDshiftList);

xtickSTA = [1,6,11];
ytickSTA = [1,6,11];
xtickNLD = [1,6,11];
ytickNLD = [1,6,12];


% xtickList = 1:2:length(varParCombinations.NLDgradList);
% ytickList = 1:5:length(varParCombinations.NLDshiftList);

axisOptsSTA_heatMap = {
    'xtick', xtickSTA,...
    'xticklabel',varParCombinationsSTA.STAfreqList(xtickSTA),...
    'ytick', ytickSTA,...
    'yticklabel',varParCombinationsSTA.STAwidthList(ytickSTA), ...
     'clim',[0,30]};
 axisOptsNLD_heatMap = {'xtick', xtickNLD,...
    'xticklabel',varParCombinationsNLD.NLDgradList(xtickNLD),...
    'ytick', ytickNLD,...
    'yticklabel',varParCombinationsNLD.NLDshiftList(ytickNLD),...
     'clim',[0,30]};
 
% colorBarOpts = {};
colormap( flipud( parula(15)) );
STAthresholdMat( isnan(STAthresholdMat) ) = 30;
NLDthresholdMat( isnan(NLDthresholdMat) ) = 30;

%% 
subplot(pY,pX,staHeatSub(:))
    imagesc(STAthresholdMat(:,:,2))
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,2.5+ [1,1;1,0;0,0;0,1],'r')
    
    axSTA = gca();
    set(axSTA,axisOptsSTA_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    
    xlabel('Frequency [k rad/s]')
    ylabel('Width')
    
    ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
    
%     axis off
    
%% 
subplot(pY,pX,nldHeatSub(:))
    imagesc(NLDthresholdMat(:,:,2))
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,8.5+ [1,1;1,0;0,0;0,1],'r')
    axNLD = gca();
    set(axNLD,axisOptsNLD_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
%     axis off
    xlabel('Gradient'); ylabel('Half-Rise Location')
    
    
%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% % tightfig;
% % Here we preserve the size of the image when we save it.
set(fig3,'InvertHardcopy','on');
set(fig3,'PaperUnits', 'inches');
papersize = get(fig3, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig3, 'PaperPosition', myfiguresize);

%% Saving figure 
print(fig3, ['figs' filesep 'Figure_R3R4' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig3, 'PaperPosition', myfiguresize);

print(fig3, ['figs' filesep 'Figure_R3R4' ], '-dsvg');

