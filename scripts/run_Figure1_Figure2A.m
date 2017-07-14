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
ind_SSPOCoff = 1:2:64;
ind_SSPOCon = ind_SSPOCoff + 1;
% [ dataStructAll.varParList.theta_dist ; dataStructAll.varParList.phi_dist ]';
% ind_see = [ dataStruct.varParList_short.theta_dist ; dataStruct.varParList_short.phi_dist ]';
% ind_see(1:64,:);

%% Figure 2A
n_plots = 16; 
n_x = 4;
n_y = 4; 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

par.phi_dist = [0.01,0.1,1,10]*3.1;
par.theta_dist = [0.01,0.1,1,10];
fig2A=figure('Position', [100, 100, 950, 750]);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on

        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( sub_nr+16);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});

        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr+16);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        realNumbers = find(~isnan(meanVec));
        plot(realNumbers, meanVec(realNumbers),col{2})

        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

        err_loc = 38;
        errorbar(err_loc,meanval,stdval,'k','LineWidth',1)
        plot([-1,1]+err_loc,[meanval,meanval],'k','LineWidth',1)   

        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );

        errorbar(err_loc,meanval,stdval,'b','LineWidth',1)
        plot([-1,1]+err_loc,[meanval,meanval],'b','LineWidth',1)   

        %--------------------------------Figure cosmetics-------------------------    
        axis([0,err_loc+2,0.4,1])
        if sub_nr <=4
            title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
        end
        if rem(sub_nr-1,4) == 0
              ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
        end

        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')

        grid on 
        A{1} = 0:10:30;
        A{2} = 1326;
        A = {'0','10','20','30','\bf \it 1326'};
        set(gca,'xtick',[0:10:30,err_loc]);
        set(gca,'xticklabel',A);
        B = 0.4:0.2:1;
        set(gca,'ytick',B);
        set(gca,'yticklabel',B);

        if  sub_nr <13
            set(gca, 'XTicklabel', []);
        end
        if ~rem(sub_nr-1,4)== 0
            set(gca, 'YTicklabel', []);
        end
        drawnow
    end
end
saveas(fig2A,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters], 'png')
%      plot2svg(['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters] , fig3 ) 

%% Figure 2C, heatmap 
[X,Y] = meshgrid(par.phi_dist,par.theta_dist);
fig2C = figure();
ax1 = subplot(2,1,1);
%     contourf(thresholdMat(:,:,1))
    contourf(X,Y,thresholdMat(:,:,1))
    colormap(ax1,flipud(hot(8)))
    set(gca,'xscale','log');set(gca,'yscale','log')
%     colormap(flipud(colormap))
    caxis([5,20])
    colorbar
    title('randomly placed sensors')
ax1 = subplot(2,1,2);
%     contourf( real( thresholdMat(:,:,2)))
    contourf(X,Y,real( thresholdMat(:,:,2)) )
    
    set(gca,'xscale','log');set(gca,'yscale','log')
    colormap(ax1,flipud(hot(8)))
    caxis([5,20])
    h = colorbar;
ylabel(h, '# of sensors required for 75% accuracy')
%     clabel()
    title('Optimally placed sensors')
saveas(fig2C,['figs' filesep 'Figure2C_disturbanceHeatmap' par.saveNameParameters], 'png')

%%  Figure 1A   plot figure 1 as one of figure 2
legendlist = [];
fig1A=figure('Position', [500, 100, 500, 400]);
sub_nr = 10;
hold on
%---------------------------------SSPOCoff-------------------------
Dat_I = ind_SSPOCoff( sub_nr);
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
end
realNumbers = find(~isnan(meanVec_random));
a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});

legendlist = [legendlist,a.mainLine];

%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(sub_nr);
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
    scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
end

realNumbers = find(~isnan(meanVec));
b = plot(realNumbers, meanVec(realNumbers),col{2});
legendlist = [legendlist,b];

%--------------------------------Allsensors Neural filt-------------------------    
meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

err_loc = 35;
c = errorbar(err_loc,meanval,stdval,'k','LineWidth',1);
plot([-1,1]+err_loc,[meanval,meanval],'k','LineWidth',1)   

legendlist = [legendlist,c];
%--------------------------------Allsensors no NF-------------------------    
meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );

d = errorbar(err_loc,meanval,stdval,'b','LineWidth',1);
legendlist = [legendlist,d];

plot([-1,1]+err_loc,[meanval,meanval],'b','LineWidth',1)   

%--------------------------------Figure cosmetics-------------------------    
axis([0,err_loc+2,0.4,1])
ylabel('Cross validated accuracy [-]')
xlabel('number of sensors [-]')

ylh = get(gca,'ylabel');
gyl = get(ylh);                                                         % Object Information
ylp = get(ylh, 'Position');
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')

grid on 
A = {'0','10','20','30','\bf \it 1326'};
set(gca,'xtick',[0:10:30,err_loc]);
set(gca,'xticklabel',A);
B = 0.4:0.2:1;
set(gca,'ytick',B);
set(gca,'yticklabel',B);

saveas(fig1A,['figs' filesep 'Figure1_SSPOCvsRandom_01_312_' par.saveNameParameters], 'png')

%% Figure 1B Plot sensor locations 

q_select = 17;
n_iters= length(nonzeros(dataStruct.dataMatTot(Dat_I,q_select,:)));
binar = zeros(26*51,1);
for j = 1:n_iters
    binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) = binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) +1;
end
binar = binar/n_iters;

fig1B = figure();
plotSensorLocs(binar,dataStruct.par)
ylabel('base')
saveas(fig1B,['figs' filesep 'Figure1B_sensorLocations' par.saveNameParameters], 'png')




