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

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()
w = warning ('off','all');

% load data--------------------------------------------------------
par.saveNameParameters = 'elasticNet09_Fri';
dataStruct = load(['results' filesep 'dataMatTot_' par.saveNameParameters]);
% load allsensors ------------------------------------------------
par.saveNameAllSensors = 'elasticNet09_Fri_allSensors';
dataStructAll = load(['results' filesep 'dataMatTot_', par.saveNameAllSensors '.mat']);
% Set which indices you want --------------------------------------------------------
ind_SSPOCoff = 117:2:315;
ind_SSPOCon = ind_SSPOCoff + 1;
%% see which simulations belong to this parameter set 
n_x = 10;
n_y = 10; 
n_plots = n_x*n_y; 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


% Figure 3 settings 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
xh.String = 'STA shift ';
yh.String = 'STA width ';
axisOptsFig3 = {'xtick', [1:1:10],'ytick', [1:1:10],'xticklabel',[-1:-1:-10], ...
     'XLabel', xh, 'YLabel', yh,'clim',[4,30]};
 
 



%% 
fig3Z=figure('Position', [100, 100, 1200, 1000]);
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
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        realNumbers = find(~isnan(meanVec));
        plot(realNumbers, meanVec(realNumbers),col{2})

        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+74,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+74,:)  ) );
        errorbar(38,meanval,stdval,'k','LineWidth',1)
        plot([37,39],[meanval,meanval],'k','LineWidth',1)   
        axis([0,39,0.4,1])
        axis off 
        drawnow
    end
end

saveas(fig3Z,['figs' filesep 'Figure3Z_' par.saveNameParameters], 'png')
%% 

fig3= figure('Position', [300, 100, 800, 1000]);
par.STAwidthList = [1:1:10];
par.STAshiftList = [1:1:10];% 
figure()
[X,Y] = meshgrid( length(par.STAwidthList) ,length(par.STAwidthList));
ax1 = subplot(2,1,1);
    contourf(thresholdMat(:,:,1),30)
    colormap(ax1,flipud(hot(30)))
    title('randomly placed sensors')
    set(gca, axisOptsFig3{:})
    colorbar
ax1 = subplot(2,1,2);
    contourf( real( thresholdMat(:,:,2)),30)
    colormap(ax1,flipud(hot(30)))
    set(gca, axisOptsFig3{:})
    h = colorbar;
    ylabel(h, '# of sensors required for 75\% accuracy')
    title('Optimally placed sensors')

saveas(fig3,['figs' filesep 'Figure3_' par.saveNameParameters], 'png')
