
%% Find nonzero elements in matrix 
clc;clear all; close all 

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% load data
par.saveNameParameters = 'elasticNet09';
load(['results' filesep 'dataMatTot_' par.saveNameParameters])

% load allsensors 
allSensors = load(['results' filesep 'tempDataMatTot_allSensors']);

% load no Neural filter
% STANLD0 = load('');

% allSensors = load(['results' filesep   par.saveNameParameters '_allSensors']);

%% see which simulations belong to this parameter set 
% 
bin_SSPOCon = ( [varParList_short.STAwidth] == 3) & ...
            ( [varParList_short.STAshift] == -10) & ...
            ( [varParList_short.SSPOCon] == 1 ) & ...
            ( [varParList_short.xInclude] == 0) & ...
            ( [varParList_short.yInclude] == 1) & ...
            ( [varParList_short.NLDshift] == 0.5) & ...
            ( [varParList_short.NLDsharpness] == 10);
bin_SSPOCoff = ( [varParList_short.STAwidth] == 3) & ...
            ( [varParList_short.STAshift] == -10) & ...
            ( [varParList_short.SSPOCon] == 0 ) & ...
            ( [varParList_short.xInclude] == 0) & ...
            ( [varParList_short.yInclude] == 1) & ...
            ( [varParList_short.NLDshift] == 0.5) & ...
            ( [varParList_short.NLDsharpness] == 10);
        
ind_SSPOCon = find(bin_SSPOCon);
ind_SSPOCoff = find(bin_SSPOCoff);
    figure();
        plot(bin_SSPOCon,'-o')
        hold on;
        plot(bin_SSPOCoff,'-o')

%% create subplot routine

par.phi_dist = [0,0.1,1,10];
par.theta_dist = [0,0.1,1,10];
n_plots = 16; 
n_x = 4;
n_y = 4; 

% col = {'-k','-r'};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
color_vec = {'-r','-k'};

%% 
fig2=figure('Position', [100, 100, 950, 750]);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        sub_nr_all = (k-1)*n_y + j;
        subplot(n_y,n_x, sub_nr)
        hold on
        
        Dat_I = ind_SSPOCoff( sub_nr);
        for k2 = 1:size(dataMatTot,2)
            meanVec_random(k2) = mean(  nonzeros(dataMatTot(Dat_I,k2,:))   );
            stdVec_random(k2) = std(  nonzeros(dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataMatTot(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{1})
        end
        realNumbers = find(~isnan(meanVec_random));
        a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});
        
    % plot sspoc on 
        Dat_I = ind_SSPOCon(sub_nr);
        for k2 = 1:size(dataMatTot,2)
            meanVec(k2) = mean(  nonzeros(dataMatTot(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        
        realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
%          a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.8);
            plot(realNumbers, meanVec(realNumbers),col{2})
        
        
        meanval = mean( allSensors.dataMatTot(sub_nr_all,:) );
        stdval = std( allSensors.dataMatTot(sub_nr_all,:) );
        % plot allsensors
            errorbar(38,meanval,stdval,'k','LineWidth',1)
            plot([37,39],[meanval,meanval],'k','LineWidth',1)   
%             title( varParList_short(Dat_I).phi_dist)
            axis([0,39,0.4,1])
            
        if sub_nr <=4
%             title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
            title(['$\theta$* = ',num2str(par.theta_dist(k)), ' rad/s'])
        end
        if  rem(sub_nr-1,4) == 0
%             ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
            ylabel(['\phi* = ',num2str(par.phi_dist(j)), ' rad/s'] )
        end
        
        % heatmap preparation
        limit = 0.75;
%         plot([1,30],[limit,limit])
        

    
xlhand = get(gca,'xlabel');
set(xlhand,'string','X','fontsize',5)

        A{1} = 0:10:30;
        A{2} = 1326;
        set(gca,'xtick',[0:10:30,39]);
        set(gca,'xticklabel',A);



        if isempty(find(meanVec>limit,1))
            q_first(j,k) = 31;
        else
            q_first(j,k) = find(meanVec>limit,1);
        end
    end
end

% saveas(fig2,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_SSPOCdotsonly], 'png')
saveas(fig2,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_' par.saveNameParameters], 'png')

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