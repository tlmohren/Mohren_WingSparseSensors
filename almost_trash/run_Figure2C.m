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

% load data--------------------------------------------------------
% par.saveNameParameters = 'elasticNet09_Fri';
par.saveNameParameters = 'elasticNet09_Week';
dataStruct = load(['results' filesep 'dataMatTot_' par.saveNameParameters]);
% load allsensors ------------------------------------------------
par.saveNameAllSensors = [par.saveNameParameters '_allSensors'];
dataStructAll = load(['results' filesep 'dataMatTot_', par.saveNameAllSensors '.mat']);

% Set which indices you want --------------------------------------------------------
ind_SSPOCoff = 1641:2:2522;
ind_SSPOCon = ind_SSPOCoff + 1;
% [ dataStructAll.varParList.theta_dist ; dataStructAll.varParList.phi_dist ]';
% ind_see = [ dataStruct.varParList_short.theta_dist ; dataStruct.varParList_short.phi_dist ]';
% ind_see(1:64,:);

%% Figure settings

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };

%% Figure 2A
n_x = 21;
n_y = 21; 
n_plots = n_x*n_y; 
        par.phi_dist = [0:5:100] ;
        par.theta_dist = [0:5:100]  ;
        
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

        
fig2A=figure('Position', [100, 100, 950, 750]);

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on

        %---------------------------------SSPOCoff-------------------------
%         Dat_I = ind_SSPOCoff( sub_nr);
%         [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
%         realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
% 
%         thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));

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
        meanval = mean( nonzeros(  dataStructAll.dataMatTot( 1277+ sub_nr*2 ,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot( 1277+ sub_nr*2 ,:)  ) );

        errorbar(errLocFig2A,meanval,stdval,'k','LineWidth',1)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'k','LineWidth',1)   

%         errorbar(errLocFig2A,meanval,stdval,'b','LineWidth',1)
%         plot([-1,1]+errLocFig2A,[meanval,meanval],'b','LineWidth',1)   
%     title(sub_nr)
        %--------------------------------Figure cosmetics-------------------------    
%         axis([0,errLocFig2A+2,0.4,1])
%         if sub_nr <=4
%             title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
%         end
%         if rem(sub_nr-1,4) == 0
%               ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
%         end

%         ylh = get(gca,'ylabel');                                            % Object Information
%         ylp = get(ylh, 'Position');
%         set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
%         grid on 
        set(gca, axisOptsFig2A{:})
%         
%         if  sub_nr <13
%             set(gca, 'XTicklabel', []);
%         end
%         if ~rem(sub_nr-1,4)== 0
%             set(gca, 'YTicklabel', []);
%         end
        axis off
        drawnow
    end
end
saveas(fig2A,['figs' filesep 'Figure2A_' par.saveNameParameters], 'png')
%      plot2svg(['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters] , fig3 ) 

%% Figure 2C, heatmap 
% set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
% [X,Y] = meshgrid(par.phi_dist,par.theta_dist);
% fig2C = figure('Position', [500, 100, 950, 750]);
% subplot(211);
%     contourf(X,Y,real(thresholdMat(:,:,1)),30)
%     colormap(flipud(hot(8)))
%     set(gca, axisOptsFig2C{:})
%     colorbar
%     title('randomly placed sensors')
% subplot(212)
%     contourf(X,Y,real( thresholdMat(:,:,2)) ,30)
%     set(gca, axisOptsFig2C{:})
%     colormap(flipud(hot(30)))
%     h = colorbar;
%     ylabel(h, '# of sensors required for 75% accuracy')
%     title('Optimally placed sensors')
%     set(gca, axisOptsFig2C{:})
%     
% saveas(fig2C,['figs' filesep 'Figure2C_disturbanceHeatmap' par.saveNameParameters], 'png')
% set(groot,'defaultAxesTickLabelInterpreter','factory')
% 
% close(1)

%%  Figure 1A   plot figure 1 as one of figure 2
% legendlist = [];
% fig1A=figure('Position', [500, 100, 500, 400]);
% sub_nr = 10;
% hold on
% %---------------------------------SSPOCoff-------------------------
% Dat_I = ind_SSPOCoff( sub_nr);
% for k2 = 1:size(dataStruct.dataMatTot,2)
%     meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
%     stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
%     iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
% end
% realNumbers = find(~isnan(meanVec_random));
% a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});
% legendlist = [legendlist,a.mainLine];
% 
% %---------------------------------SSPOCon-------------------------
% Dat_I = ind_SSPOCon(sub_nr);
% for k2 = 1:size(dataStruct.dataMatTot,2)
%     meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
%     stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
%     
%     iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
%     scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
% end
% 
% realNumbers = find(~isnan(meanVec));
% b = plot(realNumbers, meanVec(realNumbers),col{2});
% legendlist = [legendlist,b];
% 
% %--------------------------------Allsensors Neural filt-------------------------    
% meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
% stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );
% 
% c = errorbar(errLocFig1A,meanval,stdval,'k','LineWidth',1);
% plot([-1,1]+errLocFig1A,[meanval,meanval],'k','LineWidth',1)   
% 
% legendlist = [legendlist,c];
% %--------------------------------Allsensors no NF-------------------------    
% meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
% stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );
% d = errorbar(errLocFig1A,meanval,stdval,'b','LineWidth',1);
% 
% legendlist = [legendlist,d];
% 
% plot([-1,1]+errLocFig1A,[meanval,meanval],'b','LineWidth',1)   
% 
% %--------------------------------Figure cosmetics-------------------------    
% ylabel('Cross validated accuracy [-]')
% xlabel('number of sensors [-]')
% 
% ylh = get(gca,'ylabel');
% gyl = get(ylh);                                                         % Object Information
% ylp = get(ylh, 'Position');
% set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
% 
% grid on 
% set(gca, axisOptsFig1A{:}) 
% saveas(fig1A,['figs' filesep 'Figure1A_' par.saveNameParameters], 'png')
% 
% %% Figure 1B Plot sensor locations 
% 
% q_select = 17;
% n_iters= length(nonzeros(dataStruct.dataMatTot(Dat_I,q_select,:)));
% binar = zeros(26*51,1);
% for j = 1:n_iters
%     binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) = binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) +1;
% end
% binar = binar/n_iters;
% 
% fig1B = figure();
% plotSensorLocs(binar,dataStruct.par)
% ylabel('base')
% saveas(fig1B,['figs' filesep 'Figure1B_sensorLocations' par.saveNameParameters], 'png')
% 