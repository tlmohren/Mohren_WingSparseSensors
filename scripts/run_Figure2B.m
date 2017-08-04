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
% par.saveNameParameters = 'elasticNet09_Fri';
par.saveNameParameters = 'elasticNet09_Week';
dataStruct = load(['results' filesep 'dataMatTot_' par.saveNameParameters]);
% load allsensors ------------------------------------------------
par.saveNameAllSensors = [par.saveNameParameters '_allSensors'];
dataStructAll = load(['results' filesep 'dataMatTot_', par.saveNameAllSensors '.mat']);

% Set which indices you want --------------------------------------------------------
%Fri
% ind_SSPOCoff = [ 33:2:115];
%Week 
ind_SSPOCoff = [ 33:2:199];
ind_SSPOCon = ind_SSPOCoff +1;
n_sweep = 41;
%% see which simulations belong to this parameter set 

n_x = 5%n_sweep;
n_y = 2; 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

%% see which simulations belong to this parameter set 

% %Fri
% par.theta_distList = spa_sf( 10.^[-2:0.2:2] ,2);
% par.phi_distList = spa_sf( 10.^[-2:0.2:2] ,2)*3.12;

% Week 
par.theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);
par.phi_distList = spa_sf( 10.^[-2:0.1:2] ,2)*3.12;

fig2B=figure('Position', [100, 100, 1900, 250]);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_x + k;
        subplot(n_y,n_x, sub_nr)
        hold on

        sim_done = 1;
        if sim_done == 1;
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
            
            thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));
        end

        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+32,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+32,:)  ) );

        err_loc = 38;
        errorbar(err_loc,meanval,stdval,'k','LineWidth',1)
        plot([-1,1]+err_loc,[meanval,meanval],'k','LineWidth',1)

        if sub_nr <= n_sweep
           title( round( par.phi_distList(sub_nr) ,2 ) )
        else
           title( round( par.theta_distList(sub_nr-n_sweep),2) )
        end

        %--------------------------------Figure cosmetics-------------------------    
        axis([0,err_loc+2,0.4,1])
        axis off
        drawnow
    end
end
subplot(2,n_sweep,1)
    axis on
    ylabel('\phi^*-sweep, \theta^* = 0.01')
        ylh = get(gca,'ylabel');                                         % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')

subplot(2,n_sweep,n_sweep+1)
    axis on
    ylabel('\theta^*-sweep, \phi^* = 0.031')        
        ylh = get(gca,'ylabel');                                         % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')

set(fig2B,'PaperPositionMode','auto')
saveas(fig2B,['figs' filesep 'Figure2B_' par.saveNameParameters], 'png')

%%    plot figure 2C
fig2D = figure();
semilogx(par.phi_distList,thresholdMat(1,:),'*-');
hold on 
semilogx(par.theta_distList,thresholdMat(2,:),'*-');
legend('\phi', '\theta')
xlabel('disturbance');
ylabel('# sensors required')

saveas(fig2D,['figs' filesep 'Figure2D_' par.saveNameParameters], 'png')
