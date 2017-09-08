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
parameterSetName    = 'R3R4withExpFilterIter5';
load(['data' filesep 'parameterSet_', parameterSetName ])

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R4' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinations);
ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);


%% Figure settings

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


%% Figure 2B
n_x = length(varParCombinations.NLDshiftList);
n_y =  length(varParCombinations.NLDgradList);
n_plots = n_x*n_y;
fig2A=figure('Position', [100, 100, 950, 750]);

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on

        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoffB( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});

        thresholdMatB(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOConB(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStructB.dataMatTot,2)
            iters = length(nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMatB(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %--------------------------------Figure cosmetics-------------------------    
        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
        grid on 
        set(gca, axisOptsFig2A{:})
%         title( paramStructB(Dat_I).phi_dist)
        
        axis off 
        drawnow
    end
end


%% 
fig2A=figure('Position', [100, 100, 950, 750]);
% fixPar.STAdelay = 3;
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on
        varPar.STAwidth = varParCombinations.STAwidthList(1);
        varPar.STAfreq = varParCombinations.STAfreqList(1);
        varPar.NLDshift = varParCombinations.NLDshiftList(j);
        varPar.NLDgrad = varParCombinations.NLDgradList(k);
        [STAfunc,NLDfunc]= createNeuralFilt (fixPar,varPar);
        NLDs = -1:0.1:1;
        plot( NLDs,NLDfunc(NLDs))
        axis([-1,1,0,1])
        axis off
    end
end


%% Heatmap & Mask 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
axisOptsFig3_heatMap = {
    'xtick', 1:length(varParCombinations.NLDshiftList),'xticklabel',varParCombinations.NLDshiftList, ...
    'ytick', 1:length(varParCombinations.NLDgradList),'yticklabel',varParCombinations.NLDgradList,...
     'XLabel', xh, 'YLabel', yh, 'clim',[0,20]};
 
 
 
%  thresholdMatB  = l
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
% [X,Y] = meshgrid(par.phi_dist,par.theta_dist);
fig2C_V2 = figure('Position', [1000, 100, 400, 600]);
subplot(211);
%     mask2 = isnan(thresholdMatB(:,:,1));
    imagesc(thresholdMatB(:,:,2))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    title('optimal')
subplot(212)
    imagesc(thresholdMatB(:,:,1))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
    title('random')
fig2C_mark = figure('Position', [1000, 100, 400, 600]);
subplot(211);

    mask1 = isnan(thresholdMatB(:,:,2));
    Im(1) = imagesc( ones(size(mask1))*20 );
    
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

    title('optimal')
   set(Im(1),'alphadata',mask1);
subplot(212)    
    mask2 = isnan(thresholdMatB(:,:,1));
    Im(2) = imagesc(ones(size(mask2))*20);
    
    colormap(flipud(bone(3)))
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
    title('random')
   set(Im(2),'alphadata',mask2);
%    set(Im(3),'alphadata',mask2);
