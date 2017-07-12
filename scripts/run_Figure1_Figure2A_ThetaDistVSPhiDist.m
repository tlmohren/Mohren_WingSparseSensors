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


fig2_0_10_on = 0;
fig2_0_32_on = 1;
fig1_on = 1;

ind_SSPOCoff = 1:2:64;
ind_SSPOCon = 2:2:64;
% run('findSSPOCon');

[ dataStructAll.varParList.theta_dist ; dataStructAll.varParList.phi_dist ]';
ind_see = [ dataStruct.varParList_short.theta_dist ; dataStruct.varParList_short.phi_dist ]';
ind_see(1:64,:);

%% see which simulations belong to this parameter set 
par.phi_dist = [0.01,0.1,1,10];
par.theta_dist = [0.01,0.1,1,10];
n_plots = 16; 
n_x = 4;
n_y = 4; 
% col = {'-k','-r'};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


if fig2_0_10_on == 1;
    fig2=figure('Position', [100, 100, 950, 750]);
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

            %--------------------------------Allsensors Neural filt-------------------------    
            meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
            stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

            errorbar(38,meanval,stdval,'k','LineWidth',1)
            plot([37,39],[meanval,meanval],'k','LineWidth',1)   

            %--------------------------------Allsensors no NF-------------------------    
            meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
            stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );

            errorbar(38,meanval,stdval,'b','LineWidth',1)
            plot([37,39],[meanval,meanval],'b','LineWidth',1)   

            %--------------------------------Figure cosmetics-------------------------    
            axis([0,39,0.4,1])
            if sub_nr <=4
                title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
    %             title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
            end
            if  rem(sub_nr-1,4) == 0
                ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
    %             ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
            end

    %         title( [ dataStruct.varParList_short(Dat_I).theta_dist , dataStruct.varParList_short(Dat_I).phi_dist ] )
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

end

























%% see which simulations belong to this parameter set 
par.phi_dist = [0.01,0.1,1,10]*3.1;
par.theta_dist = [0.01,0.1,1,10];

if fig2_0_32_on == 1
    fig3=figure('Position', [100, 100, 950, 750]);
    for j = 1:n_y
        for k = 1:n_x
            sub_nr = (j-1)*n_y + k;
            subplot(n_y,n_x, sub_nr)
            hold on

            %---------------------------------SSPOCoff-------------------------
            Dat_I = ind_SSPOCoff( sub_nr+16);
    %         Dat_I = ind_SSPOCoff( sub_nr+16)
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
    %         for k2 = 1:size(dataStruct.dataMatTot,2)
    %             meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    %             stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    %             iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
    % %             scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{1})
    %         end
            realNumbers = find(~isnan(meanVec));
            a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});

            %---------------------------------SSPOCon-------------------------
            Dat_I = ind_SSPOCon(sub_nr+16);
            [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
            for k2 = 1:size(dataStruct.dataMatTot,2)
    %             meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    %             stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
                iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
                scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
            end

            realNumbers = find(~isnan(meanVec));
    %         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
            plot(realNumbers, meanVec(realNumbers),col{2})


            %--------------------------------Allsensors Neural filt-------------------------    
            meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+32,:)  ) );
            stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+32,:)  ) );

            err_loc = 38;
            errorbar(err_loc,meanval,stdval,'k','LineWidth',1)
            plot([-1,1]+err_loc,[meanval,meanval],'k','LineWidth',1)   

            %--------------------------------Allsensors no NF-------------------------    
            meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+48,:)  ) );
            stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+48,:)  ) );


%             err_loc = 37;
            errorbar(err_loc,meanval,stdval,'b','LineWidth',1)
            plot([-1,1]+err_loc,[meanval,meanval],'b','LineWidth',1)   

            %--------------------------------Figure cosmetics-------------------------    
            axis([0,err_loc+2,0.4,1])
            if sub_nr <=4
                title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
    %             title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
            end
            if rem(sub_nr-1,4) == 0
                  ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
    %             ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
            end
           
            ylh = get(gca,'ylabel');
            gyl = get(ylh);                                                         % Object Information
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
                
            
            
            %--------------------------------Heatmap prep-------------------------    
            limit = 0.75;
            if isempty(find(meanVec>limit,1))
                q_first(j,k) = 31;
            else
                q_first(j,k) = find(meanVec>limit,1);
            end
        end
    end
%     tightfig;
    saveas(fig3,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters], 'png')
    
     plot2svg(['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters] , fig3 ) 
end












%%    plot figure 1 as one of figure 2


legendlist = [];
if fig1_on == 1;
%     fig1A = figure();
    
    fig1A=figure('Position', [500, 100, 500, 400]);
    sub_nr = 10;
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
    %         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
    b = plot(realNumbers, meanVec(realNumbers),col{2});
    legendlist = [legendlist,b];

    %--------------------------------Allsensors Neural filt-------------------------    
    meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
    stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

%     errorbar(38,meanval,stdval,'k','LineWidth',1)
%     plot([37,39],[meanval,meanval],'k','LineWidth',1)   

    err_loc = 35;
    c = errorbar(err_loc,meanval,stdval,'k','LineWidth',1);
    plot([-1,1]+err_loc,[meanval,meanval],'k','LineWidth',1)   
    
    legendlist = [legendlist,c];
    %--------------------------------Allsensors no NF-------------------------    
    meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
    stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );




%             err_loc = 37;
    d = errorbar(err_loc,meanval,stdval,'b','LineWidth',1);
    legendlist = [legendlist,d];
    
    
    plot([-1,1]+err_loc,[meanval,meanval],'b','LineWidth',1)   
    %--------------------------------Figure cosmetics-------------------------    
     axis([0,err_loc+2,0.4,1])
            
%     title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
%     ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
%     xlabel('
    ylabel('Cross validated accuracy [-]')
    xlabel('number of sensors [-]')
    
    ylh = get(gca,'ylabel');
    gyl = get(ylh);                                                         % Object Information
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

    
%     title(['\phi* = ',num2str(par.phi_dist(k)), ' rad/s, \theta* = ',num2str(par.theta_dist(j)), ' rad/s'],interpreter,'latex')
%     ylabel(['])

%     legend(legendlist,{'Random placement','Optimal placement', 'all sensors'},'Location','Best')

    plot2svg(['figs' filesep 'Figure1_SSPOCvsRandom_312_' par.saveNameParameters,'.svg'] , fig1A ) 
    saveas(fig1A,['figs' filesep 'Figure1_SSPOCvsRandom_01_312_' par.saveNameParameters], 'png')
end

%      plot2svg(['figs' filesep 'Figure2A_ThetaDistVSPhiDist_0_36_' par.saveNameParameters] , fig3 ) 

%% 
% dataStruct.dataMatTot(Dat_I,:,:,:)


% varParCase = 1;
q_select = 17;
n_iters= length(nonzeros(dataStruct.dataMatTot(Dat_I,q_select,:)))

binar = zeros(26*51,1);
for j = 1:n_iters
%             sensorMatTot(varParCase,q_select,:,j)
    binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) = binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) +1;
end
binar = binar/n_iters;
%         figure()
% subplot(3,3,3)
figure()
        plotSensorLocs(binar,dataStruct.par)
        

    ylabel('base')

































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