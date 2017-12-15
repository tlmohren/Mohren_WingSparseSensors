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
width = 9.5;     % Width in inches,   find column width in paper 
height = 4.5;    % Height in inches
plot_on = false ;
collect_thresholdMat = false; 

fsz = 8;
fszL = 10; 

pX = 50;
pY = 28;
subGrid = reshape(1:(pX*pY),pX,pY)';

staFunSub = subGrid( (1:11)     ,(1:12) );
nldFunSub = subGrid( (1:12)+16   ,(1:12) );

staGridSub = subGrid( (1:11)  ,   (1:11)+15 );
nldGridSub = subGrid( (1:12)+16  , (1:11)+15 );

staHeatSub = subGrid( (1:11)    , (1:17)+30 );
nldHeatSub = subGrid( (1:12)+16  , (1:17)+30 );





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

fixPar.nIterFig = 10;
fixPar.nIterSim = 5; 
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
            sub_nr = (j-1)*n_x + k;
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
alw = 0.5;
axisOptsSTA = {'xtick',-40:10:0,'xticklabel',{'-40',' ','-20','','0'}, ...
    'YTick',-1:1:1,'YTickLabel',-1:1:1, ...
     'FontSize', fsz, 'LineWidth', alw, 'box','on',...
    'xlim', [-40,0],'YLIM',[-1.2,1.4],...
     };

axisOptsNLD = {'xtick',-1:1:1,'xticklabel',{-1:1:1}, ...
    'xtick',-1:0.5:1,'xticklabel',{'-1',' ','0','','1'}, ...
    'ytick',0:1:1 ,'yticklabel',{0:1:1},...
    'ytick',0:0.5:1 ,'yticklabel',{0:0.5:1},...
     'FontSize', fsz, 'LineWidth', alw, 'box','on',...
    'xlim', [-1,1],'ylim',[-0.2,1.2],...
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
%     axis off

    plot(timeMS,func(timeMS)*1.2 ,'k')
    xlabel('Time (ms)'); ylabel('Strain')
    grid on
    set(gca, axisOptsSTA{:})

    hold on
    xt = -8:0.1:-3;
    plot( xt+0.5,sin(1.3*(xt+8) )*0.1-0.88,'k')
    plot( [-7.5,-7.5,-2.5,-2.5],[-1.02,-1.1,-1.1,-1.02]-0.02,'k')
    
    tx1 = 'Frequency';
    tx2 = 'Width';
    text(-24,-0.88,tx1,'Fontsize',fsz)
    text(-24,-1.08,tx2,'Fontsize',fsz)
    tx = ['Spike Triggered',char(10) '$\phantom{..}$ Average'];
%     'STA(t)'
    text( -35,1.1,tx,'FontSize',fsz)
    
%     x = -[0 1 1 0]*20;  y = [0 0 1 1];
%     pc = patch(x,y, [ 227, 214, 244],'EdgeColor','none');
    
    tx = ['\bf{ Neural Encoder }'];
    tx1 =  text( -30,0.5,tx,'FontSize',fszL);
    tx = ['\bf{ Variations }'];
    tx1 =  text( -30,0.6,tx,'FontSize',fszL);
    tx = ['\bf{Number of Sensors, $q$ }' char(10) '\bf{for 75\% Accuracy}'];
    tx1 =  text( -30,0.7,tx,'FontSize',fszL);
    
    
    
subplot(pY,pX,nldFunSub(:))
    plot(s,funNLD(s),'k')
    xlabel('Feature Projection $\xi$');ylabel('Probability of Firing')
    grid on
    set(gca, axisOptsNLD{:})
    
    hold on
    plot( [0.4,0.6],[0,1],'k')
    plot([0.5,0.5], [0.5,-0.2],'k')
    
    tx = ['Non-Linear' char(10) 'Decision Function'];
%     'NLD($\xi$)'
    text( -0.7,1.05,tx,'FontSize',fsz)
%     xt = -8:0.1:-3;
%     plot( xt+0.5,sin(1.3*(xt+8) )*0.1-0.9,'k')
%     plot( [-7.5,-7.5,-2.5,-2.5],[-1.02,-1.1,-1.1,-1.02],'k')
    
    tx1 = 'Slope';
    tx2 = 'Half Max';
    text(0.3,1.05,tx1,'Fontsize',fsz)
    text(0.2,-0.1,tx2,'Fontsize',fsz)


    
    
    
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
%         varPar.STAfreq = varParCombinationsSTA.STAfreqList(j);
%         varPar.STAwidth = varParCombinationsSTA.STAwidthList(k);
        varPar.STAfreq = varParCombinationsSTA.STAfreqList(k);
        varPar.STAwidth = varParCombinationsSTA.STAwidthList(j);
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
colorBarOpts = {'YDir', 'reverse', 'Ticks' ,[5:5:30], 'TickLabels', {5,10,15,20,25,'$>$30' }  ,'TickLabelInterpreter','latex'};
% axOptsSTA = {'CLim',[0,30]};

% xtickSTA = [1,6,11];
% ytickSTA = [1,6,11];
% xtickNLD = [1,6,11];
% ytickNLD = [1,6,12];
%  
 axisOptsSTA_heatMap = {'XTick',[],'YTick',[],     'clim',[5,30]};
 axisOptsNLD_heatMap = { 'XTick',[],'YTick',[],       'clim',[5,30]};
 
 
% colormap( flipud( parula(15)) );
STAthresholdMat( isnan(STAthresholdMat) ) = 30;
NLDthresholdMat( isnan(NLDthresholdMat) ) = 30;
% 
% mask_vec = [ ones(1,5),linspace(1,0.8,10)];
% mask = ([1,1,1]'* mask_vec)';
% mask_vec2 = [ zeros(1,3),linspace(0,0.7,12)];
% maskMult = ([1,1,1]'* mask_vec2)';


mask_vec = [ ones(1,5),linspace(1,0.7,10)];
mask = ([1,1,1]'* mask_vec)';
mask_vec2 = [ linspace(0,0.4,15)];
maskMult = ([1,1,1]'* mask_vec2)';





a = flipud( parula(100) );
b = a(1:6:60,:);
c = a(67:8:100,:);
d = [b;c];
%
meanV = mean(d,2);
dev = d - ( meanV)*[1,1,1];
d = d - dev.*maskMult;
parula_adjust = d;
%
% mask = ([1,1,1]'*linspace(1,0.5,30) )';
% mask = ([1,1,1]'* [ linspace(1.1,1,5),linspace(1,0.5,10)])';
% colormap( flipud( parula(30)) )
% colormap( flipud( parula(30)) .* mask  )
%  flipud( parula_adjust) .* mask
 
 
colormap(  parula_adjust .* mask  )
% 

%

subplot(pY,pX,staHeatSub(:))
    imagesc(STAthresholdMat(:,:,2))
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,2.5+ [1,1;1,0;0,0;0,1],'r')
    
    axSTA = gca();
    set(axSTA,axisOptsSTA_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    
    xlabel('Frequency')
    ylabel('Width')
    
    tx1 = ['$\phantom{.}$ Number of' char(10) '$\phantom{.}$Sensors, $q$, for' char(10) '75\% Accuracy'];
    ylabel(h, tx1, 'Interpreter', 'latex')
    
    
%     axis off
    
%
subplot(pY,pX,nldHeatSub(:))
    imagesc(NLDthresholdMat(:,:,2))
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,8.5+ [1,1;1,0;0,0;0,1],'r')
    axNLD = gca();
    set(axNLD,axisOptsNLD_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
%     axis off
    xlabel('Slope'); ylabel('Half-Max')
    
    
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
print(fig3, ['figs' filesep 'Figure_R3' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig3, 'PaperPosition', myfiguresize);

print(fig3, ['figs' filesep 'Figure_R3' ], '-dsvg');

