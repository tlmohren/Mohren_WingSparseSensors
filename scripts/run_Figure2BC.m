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
parameterSetName    = 'R1toR4Iter10_delay4';
load(['data' filesep 'parameterSet_', parameterSetName ])

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2B' )));
varParCombinationsB = varParCombinationsAll(figMatch);
[dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinationsB);
ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2C' )));
varParCombinationsC = varParCombinationsAll(figMatch);
[dataStructC,paramStructC] = combineDataMat(fixPar,varParCombinationsC);
ind_SSPOCoffC = find( ~[paramStructC.SSPOCon]);
ind_SSPOConC = find([paramStructC.SSPOCon]);

%% Figure settings

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


%% Figure 2B
n_x = 7;
n_y =  6; 
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

        thresholdMatB(1,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOConB(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStructB.dataMatTot,2)
            iters = length(nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMatB(2,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %--------------------------------Figure cosmetics-------------------------    
        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
        grid on 
        set(gca, axisOptsFig2A{:})
        title( paramStructB(Dat_I).theta_dist)
        
        axis off 
        drawnow
    end
end



%% Figure 2C
n_x = 7;
n_y =  6; 
n_plots = n_x*n_y;
fig2A=figure('Position', [100, 100, 950, 750]);

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on

        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoffC( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});

        thresholdMatC(1,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOConC(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStructC.dataMatTot,2)
            iters = length(nonzeros(dataStructC.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStructC.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMatC(2,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %--------------------------------Figure cosmetics-------------------------    
        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
        grid on 
        set(gca, axisOptsFig2A{:})
        title( paramStructC(Dat_I).phi_dist)
        
        axis off 
        drawnow
    end
end
%% 

x_axisB = varParCombinationsB.theta_distList;
x_axisC = varParCombinationsC.phi_distList;

figure();
subplot(211)
    nonz_vals = find( ~isnan(thresholdMatB( 1,:)) );
    B1= semilogx(  x_axisB(nonz_vals ),thresholdMatB( 1 ,nonz_vals),'LineWidth',0.1);
    hold on
    B2=semilogx(  x_axisB(nonz_vals) ,thresholdMatB( 2,nonz_vals),'LineWidth',0.1);
% subplot(212)
    nonz_vals = find( ~isnan(thresholdMatC( 1,:)) );
    B3= semilogx(  x_axisC(nonz_vals ),thresholdMatC( 1 ,nonz_vals),'LineWidth',0.1);
    hold on
    B4=semilogx(  x_axisC(nonz_vals) ,thresholdMatC( 2,nonz_vals),'LineWidth',0.1);
    
grid on
xlabel('disturbance fraction')
ylabel('sensors for 75 %')
legend('\theta Random','\theta optimal' ,'\phi Random','\phi optimal','Location','NorthEastOutside')

B1_makeup = {'Color',[1,1,1]*0.3,'Marker','d','MarkerEdgeColor','k','MarkerSize',4};
B2_makeup = {'Color','r' ,'Marker','d','MarkerSize',4};
B3_makeup = {'Color',[1,1,1]*0.3 ,'Marker','o','MarkerEdgeColor','k','MarkerSize',4};
B4_makeup = {'Color','r' ,'Marker','o','MarkerSize',4};
% set(B1,'Color',[1,1,1]*0.9)
set(B1,B1_makeup{:})
set(B2,B2_makeup{:})
set(B3,B3_makeup{:})
set(B4,B4_makeup{:})

