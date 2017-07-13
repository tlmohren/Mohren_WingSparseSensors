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

% load data
par.saveNameParameters = 'elasticNet09_Fri';
dataStruct = load(['results' filesep 'dataMatTot_' par.saveNameParameters])
% par.saveNameParameters = 'elasticNet09_phiAll_Fri'



% load allsensors 
% allSensors = load(['results' filesep 'tempDataMatTot_allSensors']);
par.saveNameAllSensors = 'elasticNet09_Fri_allSensors';
dataStructAll = load(['results' filesep 'dataMatTot_', par.saveNameAllSensors '.mat'])
% par.saveNameAllSensors = 'elasticNet09_phiAllNFAll_Fri_allSensors';


fig3_on = 1;

ind_SSPOCoff = 117:2:315;
ind_SSPOCon = ind_SSPOCoff + 1;
% ind_SSPOCon = 2:2:64;
% % run('findSSPOCon');

[ dataStructAll.varParList.theta_dist ; dataStructAll.varParList.phi_dist ]';
ind_see = [1:length(dataStruct.varParList_short); dataStruct.varParList_short.theta_dist ; dataStruct.varParList_short.phi_dist ]';
ind_see(1:64,:);

%% see which simulations belong to this parameter set 
par.phi_dist = [0.01,0.1,1,10];
par.theta_dist = [0.01,0.1,1,10];
n_x = 10;
n_y = 10; 
n_plots = n_x*n_y; 
% col = {'-k','-r'};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
















thresholdMat= zeros(n_y,n_x,2);




fig3_on = 1;
if fig3_on == 1;
    fig3=figure('Position', [100, 100, 1200, 1000]);
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
    %         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
            plot(realNumbers, meanVec(realNumbers),col{2})

            thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));
            
            
            %--------------------------------Allsensors Neural filt-------------------------    
            meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+74,:)  ) );
            stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+74,:)  ) );

            errorbar(38,meanval,stdval,'k','LineWidth',1)
            plot([37,39],[meanval,meanval],'k','LineWidth',1)   

%             %--------------------------------Allsensors no NF-------------------------    
%             meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
%             stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );
% 
%             errorbar(38,meanval,stdval,'b','LineWidth',1)
%             plot([37,39],[meanval,meanval],'b','LineWidth',1)   

            %--------------------------------Figure cosmetics-------------------------    
            axis([0,39,0.4,1])
            drawnow
%             if sub_nr <=4
%                 title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
%     %             title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
%             end
%             if  rem(sub_nr-1,4) == 0
%                 ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
%     %             ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
%             end
% 
%     %         title( [ dataStruct.varParList_short(Dat_I).theta_dist , dataStruct.varParList_short(Dat_I).phi_dist ] )
%             xlhand = get(gca,'xlabel');
%             set(xlhand,'string','X','fontsize',5)
% 
%             A{1} = 0:10:30;
%             A{2} = 1326;
%             set(gca,'xtick',[0:10:30,39]);
%             set(gca,'xticklabel',A);
% 
%             %--------------------------------Heatmap prep-------------------------    
%             limit = 0.75;
%             if isempty(find(meanVec>limit,1))
%                 q_first(j,k) = 31;
%             else
%                 q_first(j,k) = find(meanVec>limit,1);
%             end
        end
    end
%     saveas(fig3,['figs' filesep 'Figure3_STA' par.saveNameParameters], 'png')

end







%%
figure()
sub_nr = 30
            hold on
            %---------------------------------SSPOCoff-------------------------

            Dat_I = ind_SSPOCoff( sub_nr);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );

            realNumbers = find(~isnan(meanVec));
            a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});

            %---------------------------------SSPOCon-------------------------
            Dat_I = ind_SSPOCon(sub_nr);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
            for k2 = 1:size(dataStruct.dataMatTot,2)
                iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
                scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
            end

            realNumbers = find(~isnan(meanVec));
    %         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
            plot(realNumbers, meanVec(realNumbers),col{2})
            
            xa = sigmFitParam(realNumbers,meanVec(realNumbers))

            %--------------------------------Allsensors Neural filt-------------------------    
            meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+74,:)  ) );
            stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+74,:)  ) );

            errorbar(38,meanval,stdval,'k','LineWidth',1)
            plot([37,39],[meanval,meanval],'k','LineWidth',1)   

%             %--------------------------------Allsensors no NF-------------------------    
%             meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
%             stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );
% 
%             errorbar(38,meanval,stdval,'b','LineWidth',1)
%             plot([37,39],[meanval,meanval],'b','LineWidth',1)   

            %--------------------------------Figure cosmetics-------------------------    
            axis([0,39,0.4,1])
            drawnow


%% 
% figure()
% surf(thresholdMat(:,:,1))
% hold on
% surf( real( thresholdMat(:,:,2)   ))



figure()
ax1 = subplot(2,1,1);
    contourf(thresholdMat(:,:,1))
    colormap(ax1,flipud(hot(8)))
%     colormap(flipud(colormap))
    caxis([5,20])
    colorbar
    title('randomly placed sensors')
ax1 = subplot(2,1,2);
    contourf( real( thresholdMat(:,:,2)))
    colormap(ax1,flipud(hot(8)))
    caxis([5,20])
    h = colorbar;
ylabel(h, '# of sensors required for 75\% accuracy')
%     clabel()
    title('Optimally placed sensors')


