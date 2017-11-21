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
height = 2.5;    % Height in inches

set(0,'DefaultAxesFontSize',8)% .
% set(0,'DefaultAxesLabelFontSize', 8/6)

%% Data collection 
% parameterSetName    = 'R1R2withExpFilterIter5';
% parameterSetName    = 'R1toR4Iter10_delay4';
% parameterSetName    = 'R1R2Iter5_delay3_6_normval377';
% parameterSetName = 'R1R2Iter5_delay4_newNormalization'
% parameterSetName    = 'R1R4Iter10_delay3_6_fixSTAwidth';
% parameterSetName    = 'R1R2Iter10_delay4_singValsMult0';
% parameterSetName   = 'R1R2Iter10_delay5_singValsMult1_eNet09'
% parameterSetName    = 'subPartPaperR1Iter3_delay5_singValsMult1_eNet085';
% parameterSetName    = 'R1R2Iter7_delay5_singValsMult1_eNet095';
% parameterSetName = 'R1R2Iter5_delay5_singValsMult1_eNet085';gith
% parameterSetName   = 'R1R2Iter7_delay3_singValsMult1_eNet09'
% parameterSetName = 'R1R2AIter5_delay4_singValsMult1_eNet09'
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
    
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2A' )));
varParCombinationsR2A = varParCombinationsAll(figMatch);
[dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinationsR2A);
ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);

display('added paths')
%
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsNoFilt' )));
varParCombinationsR2A_allNoFilt = varParCombinationsAll(figMatch);
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinationsR2A_allNoFilt);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsFilt' )));
varParCombinationsR2A_allFilt = varParCombinationsAll(figMatch);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinationsR2A_allFilt);












%% Figure settings
fig2 = figure();
set(fig2, 'Position', [fig2.Position(1:2) width*100, height*100]); %<- Set size
plot_on = false;

%% Axis makeup 
errLocFig2A = 34;
axisOptsFig2Out = {...    
     'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
    'xtick',[0:10:30 ],'xticklabel',{[0:10:30] },...   
%         'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
%     'xtick',[0:15:30,errLocFig2A ],'xticklabel',{'0','15','30','\textbf{ {1326}}'},...
    };
axisOptsFig2In = {...    
     'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
    'xtick',[0:10:30],'xticklabel',{'','','','',''},...   
%         'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
%     'xtick',[0:15:30,errLocFig2A ],'xticklabel',{'0','15','30','\textbf{ {1326}}'},...
    };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

n_plots = 16; 
n_x = length(varParCombinationsR2A.theta_distList);
n_y = length(varParCombinationsR2A.phi_distList);
d_x = 4;

%% 
ebar_linewidth = 0.3;
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*d_x + k;
        plot_nr = (j-1)*n_x + k;
        
        subplot(n_y,d_x, sub_nr)
        hold on
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( plot_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(plot_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(plot_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(plot_nr,:)  ) );
        errorbar(errLocFig2A,meanval,stdval,'b','LineWidth',ebar_linewidth)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'b','LineWidth',ebar_linewidth)   
        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(plot_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(plot_nr,:)  ) );
        errorbar(errLocFig2A,meanval,stdval,'k','LineWidth',ebar_linewidth)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'k','LineWidth',ebar_linewidth)   
         

        %--------------------------------Figure cosmetics-------------------------    
        grid on 
        
        if  plot_nr <13
            set(gca, 'Xtick',[],'XTicklabel', []);
            set(gca, axisOptsFig2In{:})
        else
            set(gca, axisOptsFig2Out{:})
%             break_axisSubPlot('axis','x','position',38, 'length',0.02)
        end
        if ~rem(plot_nr-1,4)== 0
            set(gca, 'YTicklabel', []);
        end
        drawnow
    end
end

set(fig2,'InvertHardcopy','on');
set(fig2,'PaperUnits', 'inches');
papersize = get(fig2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig2, 'PaperPosition', myfiguresize);

print(fig2, ['figs' filesep 'Figure_R2png' ], '-dpng', '-r1000');
print(fig2, ['figs' filesep 'Figure_R2pdf' ], '-dpdf');
print(fig2, ['figs' filesep 'Figure_R2plotsvg' ], '-dsvg');
print(fig2, ['figs' filesep 'Figure_R2ploteps' ], '-deps');


%% 
% thresholdMat( isnan(thresholdMat) ) = 35;
% axisOptsFig2B_heatMap = {
%     'xtick', 1:length(varParCombinationsR2A.phi_distList),'xticklabel',varParCombinationsR2A.phi_distList, ...
%     'ytick', 1:length(varParCombinationsR2A.theta_distList),'yticklabel',varParCombinationsR2A.theta_distList,...
%       'clim',[0,35]};
% % colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,[0:10:30,34], 'TickLabels', {0,10,20,30,'> 30' }  };  
% colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,[0:10:30,34], 'TickLabels', {0,10,20,30,'$>$ 30' }  ,'TickLabelInterpreter','latex'};
% 
% summerWithBlack = flipud(summer(300));
% summerWithBlack = [ summerWithBlack ; ones(50,3)*0.1];%     summerMa
% 
% % subplot(n_y,d_x,[5:7,12:14])
% subplot(6,8,[6:8,14:16,22:24])
% % subplot(6,8,[15:16,23:24])
% 
%     imagesc(thresholdMat(:,:,2))
%     colormap( summerWithBlack );
%     set(gca, axisOptsFig2B_heatMap{:})
%     h = colorbar;
%     set( h, colorBarOpts{:})
%     ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
%     title('Optimal Sensors')
%     
% pbaspect([1 1 1])
% subplot(6,8,[6:8,14:16,22:24]+24)
% % subplot(n_y,d_x,[19:21,26:28])
%     imagesc(thresholdMat(:,:,1))
%     colormap( summerWithBlack );
%     set(gca, axisOptsFig2B_heatMap{:})
%     h = colorbar;
%     set( h, colorBarOpts{:})
%     ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
%     title('Random Sensors ')
%     pbaspect([1 1 1])

%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig2,'InvertHardcopy','on');
set(fig2,'PaperUnits', 'inches');
papersize = get(fig2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig2, 'PaperPosition', myfiguresize);

%% Saving figure 
print(fig2, ['figs' filesep 'Figure_R2' ], '-dpng', '-r600');
% print(fig2, ['figs' filesep 'Figure_R2pdf' ], '-dpdf');

%% 







% %% Figure heatmap part repeat 
% fig2_heatmap = figure();
% set(fig2_heatmap, 'Position', [fig2_heatmap.Position(1:2) width*100, height*100]); %<- Set size
% plot_on = true ;
% 
% 
% subplot(6,8,[6:8,14:16,22:24])
% % subplot(6,8,[15:16,23:24])
% 
%     imagesc(thresholdMat(:,:,2))
%     colormap( summerWithBlack );
%     set(gca, axisOptsFig2B_heatMap{:})
%     h = colorbar;
%     set( h, colorBarOpts{:})
%     ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
%     title('Optimal Sensors')
%     
% pbaspect([1 1 1])
% subplot(6,8,[6:8,14:16,22:24]+24)
% % subplot(n_y,d_x,[19:21,26:28])
%     imagesc(thresholdMat(:,:,1))
%     colormap( summerWithBlack );
%     set(gca, axisOptsFig2B_heatMap{:})
%     h = colorbar;
%     set( h, colorBarOpts{:})
%     ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
%     title('Random Sensors ')
%     pbaspect([1 1 1])
% 
% 
% 
% 
% print(fig2_heatmap, ['figs' filesep 'Figure_R2heatmap' ], '-dpng', '-r600');
% % total hack, why does saving to svg scale image up???
% stupid_ratio = 15/16;
% myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
% set(fig2_heatmap, 'PaperPosition', myfiguresize);
% 
% print(fig2_heatmap, ['figs' filesep 'Figure_R2heatmap' ], '-dsvg');
% 
% 
% set(0,'DefaultAxesFontSize',8)% .





