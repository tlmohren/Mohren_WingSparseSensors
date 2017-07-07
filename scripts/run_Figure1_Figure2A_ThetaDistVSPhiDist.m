
%% Find nonzero elements in matrix 
clc;clear all; close all 

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% load data
% par.saveNameParameters = 'elasticNet09_phiAll';
% par.saveNameParameters = 'elasticNet09';
par.saveNameParameters = 'elasticNet09_phiAll';
dataStruct = load(['results' filesep 'dataMatTot_' par.saveNameParameters])

% load allsensors 
% allSensors = load(['results' filesep 'tempDataMatTot_allSensors']);
par.saveNameAllSensors = 'elasticNet09_phiAllNFAll_allSensors';
dataStructAll = load(['results' filesep 'dataMatTot_', par.saveNameAllSensors '.mat'])

ind_SSPOCoff = 1:2:64;
ind_SSPOCon = 2:2:64;
% run('findSSPOCon');

[ dataStructAll.varParList.theta_dist ; dataStructAll.varParList.phi_dist ]';
ind_see = [ dataStruct.varParList_short.theta_dist ; dataStruct.varParList_short.phi_dist ]';
ind_see(1:64,:);

%% see which simulations belong to this parameter set 
par.phi_dist = [0,0.1,1,10];
par.theta_dist = [0,0.1,1,10];
n_plots = 16; 
n_x = 4;
n_y = 4; 
% col = {'-k','-r'};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

fig2=figure('Position', [100, 100, 950, 750]);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k
        subplot(n_y,n_x, sub_nr)
        hold on
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( sub_nr);
        for k2 = 1:size(dataStruct.dataMatTot,2)
            meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{1})
        end
        realNumbers = find(~isnan(meanVec_random));
        a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});
        
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        for k2 = 1:size(dataStruct.dataMatTot,2)
            meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        
        realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
        plot(realNumbers, meanVec(realNumbers),col{2})
        
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

        errorbar(38,meanval,stdval,'k','LineWidth',1)
        plot([37,39],[meanval,meanval],'k','LineWidth',1)   

        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+32,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+32,:)  ) );

        errorbar(38,meanval,stdval,'b','LineWidth',1)
        plot([37,39],[meanval,meanval],'b','LineWidth',1)   

        %--------------------------------Figure cosmetics-------------------------    
        axis([0,39,0.4,1])
        if sub_nr <=4
%             title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
            title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
        end
        if  rem(sub_nr-1,4) == 0
%             ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
            ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
        end
        
        xlhand = get(gca,'xlabel');
        set(xlhand,'string','X','fontsize',5)

        A{1} = 0:10:30;
        A{2} = 1326;
        set(gca,'xtick',[0:10:30,39]);
        set(gca,'xticklabel',A);
        
        %--------------------------------Heatmap prep-------------------------    
        limit = 0.75;
        if isempty(find(meanVec>limit,1))
            q_first(j,k) = 31;
        else
            q_first(j,k) = find(meanVec>limit,1);
        end
    end
end
saveas(fig2,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_10_' par.saveNameParameters], 'png')



























%% see which simulations belong to this parameter set 
par.phi_dist = [0,0.1,1,10]*3.12;
par.theta_dist = [0,0.1,1,10];

fig3=figure('Position', [100, 100, 950, 750]);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k
        subplot(n_y,n_x, sub_nr)
        hold on
        
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( sub_nr+16);
        for k2 = 1:size(dataStruct.dataMatTot,2)
            meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{1})
        end
        realNumbers = find(~isnan(meanVec_random));
        a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});
        
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr+16);
        for k2 = 1:size(dataStruct.dataMatTot,2)
            meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        
        realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
        plot(realNumbers, meanVec(realNumbers),col{2})
        
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );

        errorbar(38,meanval,stdval,'k','LineWidth',1)
        plot([37,39],[meanval,meanval],'k','LineWidth',1)   

        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+48,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+48,:)  ) );

        errorbar(38,meanval,stdval,'b','LineWidth',1)
        plot([37,39],[meanval,meanval],'b','LineWidth',1)   

        %--------------------------------Figure cosmetics-------------------------    
        axis([0,39,0.4,1])
        if sub_nr <=4
%             title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
            title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
        end
        if  rem(sub_nr-1,4) == 0
%             ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
            ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
        end
        
        xlhand = get(gca,'xlabel');
        set(xlhand,'string','X','fontsize',5)

        A{1} = 0:10:30;
        A{2} = 1326;
        set(gca,'xtick',[0:10:30,39]);
        set(gca,'xticklabel',A);
        
        %--------------------------------Heatmap prep-------------------------    
        limit = 0.75;
        if isempty(find(meanVec>limit,1))
            q_first(j,k) = 31;
        else
            q_first(j,k) = find(meanVec>limit,1);
        end
    end
end
saveas(fig3,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters], 'png')














%%    plot figure 1 as one of figure 2
fig1A = figure();
sub_nr = 7;
%         subplot(n_y,n_x, sub_nr)
hold on

%---------------------------------SSPOCoff-------------------------
Dat_I = ind_SSPOCoff( sub_nr);
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{1})
end
realNumbers = find(~isnan(meanVec_random));
a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});

%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(sub_nr);
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
    scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
end

realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
plot(realNumbers, meanVec(realNumbers),col{2})

%--------------------------------Allsensors Neural filt-------------------------    
meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

errorbar(38,meanval,stdval,'k','LineWidth',1)
plot([37,39],[meanval,meanval],'k','LineWidth',1)   

%--------------------------------Allsensors no NF-------------------------    
meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+32,:)  ) );
stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+32,:)  ) );

errorbar(38,meanval,stdval,'b','LineWidth',1)
plot([37,39],[meanval,meanval],'b','LineWidth',1)   

%--------------------------------Figure cosmetics-------------------------    
axis([0,39,0.4,1])
if sub_nr <=4
%             title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
    title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
end
if  rem(sub_nr-1,4) == 0
%             ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
    ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
end

xlhand = get(gca,'xlabel');
set(xlhand,'string','X','fontsize',5)

A{1} = 0:10:30;
A{2} = 1326;
set(gca,'xtick',[0:10:30,39]);
set(gca,'xticklabel',A);




saveas(fig1A,['figs' filesep 'Figure1_Figure1_SSPOCvsRandom_0.1_3.12_' par.saveNameParameters], 'png')









































%% heatmap part 
if 0 

    [x,y]=meshgrid(1:4,1:4);

    figure();
    pcolor(x,y,q_first)
    axis ij
    axis square
    caxis
    colorbar
    % shading faceted

    figure();
    HeatMap (q_first)
    %
    figure()
    clims = [6,16];
    imagesc(q_first,clims)

    aa = gca;
    aa.YTick = 1:4;
    aa.XTick = 1:4;
    aa.XTickLabel = [0,0.1,1,10];
    aa.YTickLabel = [0,0.1,1,10];
    xlabel('\phi disturbance')
    ylabel('\theta disturbance')
         set(gca,'xaxislocation','top');
    % xticks([-3*pi -2*pi -pi 0 pi 2*pi 3*pi])
    % xticklabels({'-3\pi','-2\pi','-\pi','0','\pi','2\pi','3\pi'})
    % yticks([-1 -0.8 -0.2 0 0.2 0.8 1])
    % colorbar
    % clabel('q past threshold')
    h = colorbar;
    ylabel(h, 'q past threshold')
end