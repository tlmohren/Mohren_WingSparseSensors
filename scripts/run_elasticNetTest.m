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
par.NF_on = 1;
par.theta_distList = 0.1;%[0.001] * 10;
par.phi_distList = 0.312;%[0.001] * 31.2 ;
par.xIncludeList = [0];
par.yIncludeList = [1];
par.SSPOConList = [0,1];
par.sensorMatOn =0;

par.STAwidthList = [8];
par.STAfreqList = 1;% 
par.STAshiftList = par.STAfreqList;
par.NLDshiftList = [0.5];
par.NLDgradList = [12];
par.NLDsharpnessList = par.NLDgradList;
par.elasticNetList = [0.99,0.9,0.8];
        
par.wTruncList = 1:30;
par.naming = {'elasticNetTest_Iter10'};




par.allSensors = 0; 
        
par.chordElements = 26;
par.spanElements = 51;
par
dataStruct = combineDataMat(par);
par.allSensors = 1; 
par.SSPOConList = 2;
par.NF_on = 1;
dataStructAll = combineDataMat(par);

% Set which indices you want --------------------------------------------------------
ind_SSPOCoff = 1:2:( length(par.elasticNetList)*2 );
ind_SSPOCon = ind_SSPOCoff + 1;

%% Figure settings

% Figure 1 settings 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
errLocFig1A = 35; 

% Figure 2A settings 
errLocFig2A = 38;
axisOptsFig_randonvsSSPOC = {'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
% Figure 2C settings 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
xh.String = '$\dot{\phi}^*$';
yh.String = '$\dot{\theta}^*$';

axisOptsFig3_heatMap = {
    'xtick', 1:length(par.STAshiftList),'xticklabel',par.STAshiftList, ...
    'ytick', 1:length(par.STAwidthList),'yticklabel',par.STAwidthList,...
     'XLabel', xh, 'YLabel', yh, 'clim',[0,20]};
 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

%% Figure 2A
% n_x = length(par.STAwidthList);
n_x = 1;
n_y =  length(par.elasticNetList); 
n_plots = n_x*n_y;
% par.phi_dist = [0.01,0.1,1,10]*3.1;
% par.theta_dist = [0.01,0.1,1,10];
fig2A=figure('Position', [100, 100, 950, 750]);
thresholdMat = zeros(n_y,n_x,2);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_x + k;
        subplot(n_y,n_x, sub_nr)
        hold on
%         [j,k,size(thresholdMat)]
        %---------------------------------SSPOCoff-------------------------
%         Dat_I = ind_SSPOCoff( sub_nr);
%         [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
%         realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
%         sigmFitParam(realNumbers,meanVec(realNumbers));
%         thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        sigmFitParam(realNumbers,meanVec(realNumbers))
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

        errorbar(errLocFig2A,meanval,stdval,'k','LineWidth',1)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'k','LineWidth',1)   
        %--------------------------------Figure cosmetics-------------------------    

        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
        grid on 
        set(gca, axisOptsFig_randonvsSSPOC{:})
        
        axis off 
        drawnow
    end
end


%%

save( ['results' filesep 'Figure3_thresholdMat' par.naming{:}],'thresholdMat')

% load( ['results' filesep 'Figure4_thresholdMat'])
%% Heatmap & Mask 
 
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
% [X,Y] = meshgrid(par.phi_dist,par.theta_dist);
fig2C_V2 = figure('Position', [1000, 100, 400, 600]);
subplot(211);
    Im(3) = imagesc(thresholdMat(:,:,2));
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

subplot(212)
    imagesc(thresholdMat(:,:,1))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
fig2C_mark = figure('Position', [1000, 100, 400, 600]);
subplot(211);

    mask1 = isnan(thresholdMat(:,:,2));
    Im(1) = imagesc( ones(size(mask1))*20 );
    
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

   set(Im(1),'alphadata',mask1);
subplot(212)    
    mask2 = isnan(thresholdMat(:,:,1));
    Im(2) = imagesc(ones(size(mask2))*20);
    
    colormap(flipud(bone(3)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
   set(Im(2),'alphadata',mask2);
%    set(Im(3),'alphadata',mask2);
   
%% 

close(1)
