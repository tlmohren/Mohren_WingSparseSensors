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
ind_SSPOCoff = 317:2:515;
ind_SSPOCon = ind_SSPOCoff + 1;

%% see which simulations belong to this parameter set 
n_x = 10;
n_y = 10; 
n_plots = n_x*n_y; 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


par.NLDshiftList = [-0.2:0.1:0.7];
par.NLDsharpnessList = [5:1:14];
% Figure 3 settings 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
xh.String = 'NLD sharpness ';
yh.String = 'NLD shift';
axisOptsFig4 = {'xtick', [1:1:length(par.NLDsharpnessList)],'xticklabel', par.NLDsharpnessList,...
    'ytick', [1:1:length(par.NLDshiftList)],'yticklabel',par.NLDshiftList, ...
     'XLabel', xh, 'YLabel', yh,'clim',[0,30]};
 
 %% 

fig4Z=figure('Position', [100, 100, 1200, 1000]);
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
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+174,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+174,:)  ) );

        errorbar(38,meanval,stdval,'k','LineWidth',1)
        plot([37,39],[meanval,meanval],'k','LineWidth',1)   

        %--------------------------------Figure cosmetics-------------------------    
        axis([0,39,0.4,1])
        axis off 
        drawnow

    end
end

% saveas(fig4Z,['figs' filesep 'Figure4Z_' par.saveNameParameters], 'png')

save( ['results' filesep 'Figure4_thresholdMat'],'thresholdMat')

%%

% load( ['results' filesep 'Figure4_thresholdMat'])


figure()
% ax1 = subplot(2,1,1);
%     contourf(real( thresholdMat(:,:,1)   ))
%     colormap(ax1,flipud(hot(8)))
% %     colormap(flipud(colormap))
%     caxis([4,20])
%     colorbar
%     title('randomly placed sensors')
% ax1 = subplot(2,1,2);
%     contourf( real( thresholdMat(:,:,2)))
%     colormap(ax1,flipud(hot(8)))
%     caxis([4,20])
%     h = colorbar;
% ylabel(h, '# of sensors required for 75\% accuracy')
% %     clabel()
%     title('Optimally placed sensors')

    %
    

% par.NLDshiftList = [-0.2:0.05:0.7];
% par.NLDsharpnessList = [5:0.5:14];
% fig4=figure('Position', [300, 100, 800, 1000]);
% [X,Y] = meshgrid( 1:par.NLDsharpnessList ,1:length(par.NLDsharpnessList) );
% 
% subplot(211);
%     colormap(flipud(hot(30)))
%     contourf(thresholdMat(:,:,1),30)
%     title('randomly placed sensors')
%     set(gca, axisOptsFig4{:})
%     h = colorbar;
%     
% subplot(212);
%     contourf( real( thresholdMat(:,:,2)),30)
%     colormap(flipud(hot(30)))
%     set(gca, axisOptsFig4{:})
%     h = colorbar;
%     ylabel(h, '# of sensors required for 75\% accuracy')
%     title('Optimally placed sensors')
% 
%     
% saveas(fig4,['figs' filesep 'Figure4_' par.saveNameParameters], 'png')




par.NLDshiftList = [-0.2:0.1:0.7];
par.NLDsharpnessList = [5:1:14];
% fig4=figure('Position', [300, 100, 800, 1000]);
[X,Y] = meshgrid( 1:par.NLDsharpnessList ,1:length(par.NLDsharpnessList) );
% 



par.NLDshiftList = [-0.2:0.1:0.7];
par.NLDsharpnessList = [5:1:14];

axisOptsFig3H = {'xtick', 1:10,'ytick',1:10, ...
    'xticklabel', par.NLDshiftList,'yticklabel',par.NLDsharpnessList, ...
     'XLabel', xh, 'YLabel', yh,'clim',[5,20]};
% axisOptsFig3H = {      'XLabel', xh, 'YLabel', yh,'clim',[5,20]};
 
 

par.NLDshiftList = [-0.2:0.1:0.7];
par.NLDsharpnessList = [5:1:14];
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
[X,Y] = meshgrid( 1:10,1:10 );
fig2C_V2 = figure('Position', [1000, 100, 400, 600]);
subplot(211);
    imagesc(thresholdMat(:,:,2))
%     colormap(flipud(hot(100)))
%     colormap(flipud(bone(500)))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3H{:})
    h = colorbar;
%     set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    title('optimal placement')

subplot(212)
    imagesc(thresholdMat(:,:,1))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3H{:})
    h = colorbar;
%     set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    title('Random placement')

    
    
    
    