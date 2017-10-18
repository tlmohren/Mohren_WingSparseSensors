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
    
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2A' )));
varParCombinationsR2A = varParCombinationsAll(figMatch);
[dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinationsR2A);
ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);

display('added paths')
%% 
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsNoFilt' )));
varParCombinationsR2A_allNoFilt = varParCombinationsAll(figMatch);
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinationsR2A_allNoFilt);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsFilt' )));
varParCombinationsR2A_allFilt = varParCombinationsAll(figMatch);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinationsR2A_allFilt);

%% Figure settings

plot_on = true ;

%% Figure 2A
errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

n_plots = 16; 
n_x = length(varParCombinationsR2A.theta_distList);
n_y = length(varParCombinationsR2A.phi_distList);
fig2A=figure('Position', [100, 100, 950, 750]);

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(sub_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(sub_nr,:)  ) );
        errorbar(errLocFig2A,meanval,stdval,'b','LineWidth',1)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'b','LineWidth',1)   
        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(sub_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(sub_nr,:)  ) );
        errorbar(errLocFig2A,meanval,stdval,'k','LineWidth',1)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'k','LineWidth',1)   
        %--------------------------------Figure cosmetics-------------------------    
        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
        grid on 
        set(gca, axisOptsFig2A{:})
%         title('
        if  sub_nr <13
            set(gca, 'XTicklabel', []);
        end
        if ~rem(sub_nr-1,4)== 0
            set(gca, 'YTicklabel', []);
        end
        drawnow
    end
end

saveas(fig2A,['figs' filesep 'Figure2A_' parameterSetName '.png'])

print(fig2AB,['figs' filesep 'Figure2AB_' parameterSetName '.png'],'-r500','-dpng')
%% 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
thresholdMat( isnan(thresholdMat) ) = 35;
axisOptsFig3_heatMap = {
    'xtick', 1:length(varParCombinationsR2A.phi_distList),'xticklabel',varParCombinationsR2A.phi_distList, ...
    'ytick', 1:length(varParCombinationsR2A.theta_distList),'yticklabel',varParCombinationsR2A.theta_distList,...
     'XLabel', xh, 'YLabel', yh, 'clim',[0,35]};
colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,[0:10:30,34], 'TickLabels', {0,10,20,30,'> 40' }  };  
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');

figureOpts = { 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 10 15] };

summerWithBlack = flipud(summer(300));
summerWithBlack = [ summerWithBlack ; ones(50,3)*0.1];%     summerMa

fig2AB = figure('Position', [1000, 100, 400, 600]);
set(fig2AB,figureOpts{:})


subplot(211);
    imagesc(thresholdMat(:,:,2))
    colormap( summerWithBlack );
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, '# of sensors required for 75% accuracy')
    title('optimal')
subplot(212)
    imagesc(thresholdMat(:,:,1))
    colormap( summerWithBlack );
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, '# of sensors required for 75% accuracy')
    title('random')
   
% saveas(fig2AB,['figs' filesep 'Figure2AB_' parameterSetName '.png'])   


% print('5by3DimensionsFigure','-dpng','-r0')
print(fig2AB,['figs' filesep 'Figure2AB_' parameterSetName '.png'],'-r500','-dpng')
