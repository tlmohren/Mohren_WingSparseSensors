
%% Find nonzero elements in matrix 
clc;clear all; close all 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])

% load(['results' filesep 'analysis_FigR1toR4_XXYY_270Par'])

load(['results' filesep 'DataMatTot_norm101'])
allSensors = load(['results' filesep 'tempDataMatTot_allSensors']);


Datamat = dataMatTot;


%% see which simulations belong to this parameter set 
% 
% bin_SSPOCon = ( [varParList.STAwidth] == 3) & ...
%             ( [varParList.STAshift] == -10) & ...
%             ( [varParList.SSPOCon] == 1 ) & ...
%             ( [varParList.xInclude] == 1) & ...
%             ( [varParList.yInclude] == 1) & ...
%             ( [varParList.NLDshift] == 0.5) & ...
%             ( [varParList.NLDsharpness] == 10);
% bin_SSPOCoff = ( [varParList.STAwidth] == 3) & ...
%             ( [varParList.STAshift] == -10) & ...
%             ( [varParList.SSPOCon] == 0 ) & ...
%             ( [varParList.xInclude] == 1) & ...
%             ( [varParList.yInclude] == 1) & ...
%             ( [varParList.NLDshift] == 0.5) & ...
%             ( [varParList.NLDsharpness] == 10);
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
% bin_SSPOC2 = ( [varParList_short.STAwidth] == 3) & ...
%             ( [varParList_short.STAshift] == -10) & ...
%             ( [varParList_short.SSPOCon] == 2 ) & ...
%             ( [varParList_short.xInclude] == 0) & ...
%             ( [varParList_short.yInclude] == 1) & ...
%             ( [varParList_short.NLDshift] == 0.5) & ...
%             ( [varParList_short.NLDsharpness] == 10);
% figure();plot(bin_SSPOCon,'-o')
hold on;plot(bin_SSPOCoff,'-o')

ind_SSPOCon = find(bin_SSPOCon);
ind_SSPOCoff = find(bin_SSPOCoff);

% par.phi_dist = [0,0.1,1,10];
% par.theta_dist = [0,0.1,1,10];
% n_plots = 16; 
% n_x = 4;
% n_y = 4; 


par.phi_dist = [0,1];
par.theta_dist = [0,1];
n_plots =4; 
n_x = 2;
n_y = 2; 


col = {'-k','-r'};
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
%% create subplot routine

color_vec = {'-r','-k'};
fig2=figure('Position', [100, 100, 1000, 800]);
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on
        
   % plot sspoc off
        Dat_I = ind_SSPOCoff(sub_nr);
        for k2 = 1:size(Datamat,2)
            meanVec_random(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec_random(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{1})
        end
        realNumbers = find(~isnan(meanVec_random));
        a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});
        
        
        for k2 = 1:size(Datamat,2)
            meanVec_random(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec_random(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{1})
        end
        
        
        
        
    % plot sspoc on 
        Dat_I = ind_SSPOCon(sub_nr);
        for k2 = 1:size(Datamat,2)
            meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
% 
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{2})
    
        end
        realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.9);
%          a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.8);
        plot(realNumbers, meanVec(realNumbers),col{2})
        
        
        % plot std 
        meanval = mean( allSensors.dataMatTot(sub_nr,:) );
        stdval = std( allSensors.dataMatTot(sub_nr,:) );
        errorbar(32,meanval,stdval,'k','LineWidth',1)
        plot([31,33],[meanval,meanval],'k','LineWidth',1)
        
        axis([0,33,0.4,1])
        if sub_nr <=4
            title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
        end
        if  rem(sub_nr-1,4) == 0
            ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
        end
        
        
        
        % for heatmap 
        limit = (meanval - meanVec(1))*0.5 + meanVec(1);
        plot([1,30],[limit,limit])
        
        if isempty(find(meanVec>limit,1))
            q_first(j,k) = 31;
        else
            q_first(j,k) = find(meanVec>limit,1);
        end
        
    end
end


saveas(fig2,['figs' filesep 'Figure2A_ThetaDistVSPhiDist_SSPOCdotsOnly'], 'png')

%% 

[x,y]=meshgrid(1:4,1:4)

figure();
pcolor(x,y,q_first)
axis ij
axis square
caxis
colorbar
% shading faceted

figure();
HeatMap (q_first)
%%
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