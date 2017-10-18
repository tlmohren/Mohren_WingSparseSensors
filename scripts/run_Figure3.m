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

set(groot, 'defaultAxesTickLabelInterpreter', 'factory');
addpathFolderStructure()
w = warning ('off','all');

%% 
% parameterSetName    = 'R3R4withExpFilterIter5';
% parameterSetName    = 'R1toR4Iter10_delay4';
% parameterSetName    = 'R1R4Iter10_delay3_6_fixSTAwidth';
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

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R3' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinations);
ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);

%% Figure settings
plot_on = true ;


% plot_on = plas;
%% Figure 2B

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


n_x = length(varParCombinations.STAwidthList);
n_y =  length(varParCombinations.STAfreqList);
n_plots = n_x*n_y;
if plot_on == true
    fig4plots=figure('Position', [50, 50, 1200, 1000]);
end
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoffB( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        
        if plot_on 
            subplot(n_y,n_x, sub_nr)
            hold on
            a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        end
        thresholdMatB(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOConB(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        
        
        if plot_on == 1
            for k2 = 1:size(dataStructB.dataMatTot,2)
                iters = length(nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) );
                scatter( ones(iters,1)*k2,nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) , dotcol{2})
                plot(realNumbers, meanVec(realNumbers),col{2})
            end
        end
        thresholdMatB(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        if plot_on == 1
        %--------------------------------Figure cosmetics-------------------------    
            ylh = get(gca,'ylabel');                                            % Object Information
            ylp = get(ylh, 'Position');
            set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
            grid on 
            set(gca, axisOptsFig2A{:})
            axis off 
            drawnow
        end
    end
end
tightfig
% if plot_on == true
%     saveas(fig3plots,['figs' filesep 'Figure3plots_' parameterSetName '.png'])
% end
%% 
fig3STA=figure('Position', [100, 100, 950, 750]);

figureOpts = { 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 10 15] };
set(fig3STA,figureOpts{:})


% fixPar.STAdelay = 3;
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on
        varPar.STAfreq = varParCombinations.STAfreqList(k);
        varPar.STAwidth = varParCombinations.STAwidthList(j);
        varPar.NLDshift = varParCombinations.NLDshiftList;
        varPar.NLDgrad = varParCombinations.NLDgradList;
        [STAfunc,NLDfunc]= createNeuralFilt (fixPar,varPar);
        if  isfield(fixPar,'subSamp') == 0 
            STAt = -39:1:0;
        else
            STAt = -39:1/fixPar.subSamp:0;
        end
        plot( STAt,STAfunc(STAt),'','Linewidth',1)
        axis([-39,0,-1,1])
        axis off
        grid on 
        if (varPar.STAfreq == 1 && varPar.STAwidth == 4)
            plot( STAt,STAfunc(STAt),'r','Linewidth',2)
        end
        scatter(STAt,STAfunc(STAt),'.','b')
    end
            
end
tightfig;

% saveas(fig3STA,['figs' filesep 'Figure3STA_' parameterSetName '.png'])
print(fig3STA,['figs' filesep 'Figure3STA_' parameterSetName] ,'-r500','-dpng')


%% Heatmap & Mask 
figure(1);
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
axisOptsFig3_heatMap = {
    'xtick', 1:length(varParCombinations.STAwidthList),'xticklabel',varParCombinations.STAwidthList, ...
    'ytick', 1:length(varParCombinations.STAfreqList),'yticklabel',varParCombinations.STAfreqList,...
     'XLabel', xh, 'YLabel', yh, 'clim',[0,35]};
% axisOptsFig3_heatMap = {
%     'xtick', 1:length(varParCombinationsR2A.phi_distList),'xticklabel',varParCombinationsR2A.phi_distList, ...
%     'ytick', 1:length(varParCombinationsR2A.theta_distList),'yticklabel',varParCombinationsR2A.theta_distList,...
%      'XLabel', xh, 'YLabel', yh, 'clim',[0,35]};
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');


colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,[0:10:30,34], 'TickLabels', {0,10,20,30,'> 40' }  };  
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');

summerWithBlack = flipud(summer(300));
summerWithBlack = [ summerWithBlack ; ones(50,3)*0.1];%     summerMa


thresholdMatB( isnan(thresholdMatB) ) = 35;

fig3heatmap = figure('Position', [1000, 100, 400, 600]);
figureOpts = { 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 10 15] };
set(fig3heatmap,figureOpts{:})


subplot(211);
%     mask2 = isnan(thresholdMatB(:,:,1));
    imagesc(thresholdMatB(:,:,2))
%     colormap(flipud(summer(500)))
    colormap( summerWithBlack );
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, '# of sensors required for 75% accuracy')
    title('optimal')
subplot(212)
    imagesc(thresholdMatB(:,:,1))
%     colormap(flipud(summer(500)))
    colormap( summerWithBlack );
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, '# of sensors required for 75% accuracy')
    
    title('random')
    
% saveas(fig3heatmap,['figs' filesep 'Figure3_' parameterSetName '.png'])
print(fig3heatmap,['figs' filesep 'Figure3_' parameterSetName] ,'-r500','-dpng')