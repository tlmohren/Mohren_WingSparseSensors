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
par.theta_distList = spa_sf( 10.^[-2:0.1:2] ,2); 
par.phi_distList =[0.001] * 31.2 ;
par.xIncludeList = [0];
par.yIncludeList = [1];
par.SSPOConList = [0,1];
par.STAwidthList = [3];
par.STAshiftList = [-10];% 
par.NLDsharpnessList = [10];
par.NLDshiftList = [0.5];
par.wTruncList = 1:30;
par.sensorMatOn = 0;
% par.naming = {'10iters'};

% par.naming = {'elasticNet09_Week'};
% par.STAwidthList = [3];
% par.STAshiftList = [-10];% 


par.naming = {'STANLD11_Iter20'};
par.STAwidthList = [4.5];
par.STAshiftList = [1];% 




par.allSensors = 0; 
par.chordElements = 26;
par.spanElements = 51;

%% Figure settings

% Figure 1 settings 
errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
axisOptsFig2A = {'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

%% Parameters for theta disturbance
par.SSPOConList = [0,1];
par.allSensors = 0; 
par.theta_distList = spa_sf( 10.^[-2:0.1:2] ,2); 
par.phi_distList =[0.001] * 31.2 ;
dataStruct = combineDataMat(par);

par.allSensors = 1; 
par.SSPOConList = 2;
par.NF_on = 1;
dataStructAll = combineDataMat(par);

% Set which indices you want --------------------------------------------------------
ind_SSPOCoff = 1:2:size(dataStruct.dataMatTot,1);
ind_SSPOCon = ind_SSPOCoff + 1;

%% Figure 2A
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
        Dat_I = ind_SSPOCoff( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});

        thresholdMat(1,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(2,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

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
        set(gca, axisOptsFig2A{:})
        title( par.theta_distList(sub_nr))
        
        axis off 
        drawnow
    end
end

%% Parameters for phi disturbance
par.SSPOConList = [0,1];
par.allSensors = 0; 
par.theta_distList = 0.01 ; 
par.phi_distList =spa_sf( 10.^[-2:0.1:2] ,2)* 3.12 ;
dataStruct = combineDataMat(par);

par.allSensors = 1; 
par.SSPOConList = 2;
par.NF_on = 1;
dataStructAll = combineDataMat(par);

% Set which indices you want --------------------------------------------------------
ind_SSPOCoff = 1:2:size(dataStruct.dataMatTot,1);
ind_SSPOCon = ind_SSPOCoff + 1;

% Figure 2A
n_x = 7;
n_y =  6; 
n_plots = n_x*n_y;
par.phi_dist = [0.01,0.1,1,10]*3.1;
par.theta_dist = [0.01,0.1,1,10];
fig2B=figure('Position', [100, 100, 950, 750]);

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

        thresholdMat(3,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(4,sub_nr) = sigmFitParam(realNumbers,meanVec(realNumbers));

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
        set(gca, axisOptsFig2A{:})
        
        title( par.phi_distList(sub_nr))
        axis off 
        drawnow
    end
end



%% Figure 2C, heatmap 

x_axis = spa_sf( 10.^[-2:0.1:2] ,2)/10;


figure();
subplot(211)
semilogx(  x_axis(1:sum(~isnan(thresholdMat( 1,:))) ),thresholdMat( 1 ,~isnan(thresholdMat( 1,:))),'-ro','LineWidth',0.1)
hold on
plot(  x_axis(1:sum(~isnan(thresholdMat( 3,:)))),thresholdMat( 3 ,~isnan(thresholdMat( 3,:))),'-bd','LineWidth',0.1)
subplot(211)
plot(  x_axis(1:sum(~isnan(thresholdMat( 2,:)))),thresholdMat( 2 ,~isnan(thresholdMat( 2,:))),'-gs','LineWidth',0.1)
hold on
plot(  x_axis(1:sum(~isnan(thresholdMat( 4,:)))),thresholdMat( 4 ,~isnan(thresholdMat( 4,:))),'-m.','LineWidth',0.1)

grid on
xlabel('disturbance fraction')
ylabel('sensors for 75 %')
legend('\theta Random','\phi Random','\theta optimal','\phi optimal','Location','NorthEastOutside')