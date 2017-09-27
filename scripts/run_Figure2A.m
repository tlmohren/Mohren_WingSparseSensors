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
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
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
parameterSetName    = 'subPartPaperR1Iter3_delay5_singValsMult1_eNet085';
% parameterSetName   = 'R1R2Iter7_delay3_singValsMult1_eNet09'

% load(['data' filesep 'parameterSet_', parameterSetName ])
overflow_loc = 'D:\Mijn_documenten\Dropbox\A. PhD\C. Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
addpath(overflow_loc)
addpath( 'data')
load(['parameterSet_' parameterSetName ])

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2A' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinations);
ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);

%% 
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsNoFilt' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinations);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsFilt' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinations);

%% Figure settings

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

%% Figure 2A
n_plots = 16; 
n_x = length(varParCombinations.theta_distList);
n_y = length(varParCombinations.phi_distList);
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
        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));
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

%% 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
axisOptsFig3_heatMap = {
    'xtick', 1:length(varParCombinations.phi_distList),'xticklabel',varParCombinations.phi_distList, ...
    'ytick', 1:length(varParCombinations.theta_distList),'yticklabel',varParCombinations.theta_distList,...
     'XLabel', xh, 'YLabel', yh, 'clim',[0,20]};
%  thresholdMatB  = l
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
fig2AB = figure('Position', [1000, 100, 400, 600]);
subplot(211);
%     mask2 = isnan(thresholdMatB(:,:,1));
    imagesc(thresholdMat(:,:,2))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    title('optimal')
subplot(212)
    imagesc(thresholdMat(:,:,1))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
    title('random')
    
    
saveas(fig2AB,['figs' filesep 'Figure2AB_' parameterSetName '.png'])
%% 
fig2AB_mask = figure('Position', [1400, 100, 400, 600]);
subplot(211);

    mask1 = isnan(thresholdMat(:,:,2));
    Im(1) = imagesc( ones(size(mask1))*20 );
    
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

    title('optimal')
   set(Im(1),'alphadata',mask1);
subplot(212)    
    mask2 = isnan(thresholdMat(:,:,1));
    Im(2) = imagesc(ones(size(mask2))*20);
    
    colormap(flipud(bone(3)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
    title('random')
   set(Im(2),'alphadata',mask2);
   
   
saveas(fig2AB_mask,['figs' filesep 'Figure2ABmask_' parameterSetName '.png'])
