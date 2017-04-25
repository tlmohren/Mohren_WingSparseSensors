
%% Find nonzero elements in matrix 
clc;clear all; close all 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])
load(['results' filesep 'analysis_FigR1toR4_XXYY_270Par'])
%% 

% Datamat = rand(size(Datamat))*0.2 + 0.6;

%% see which simulations belong to this parameter set 

bin_SSPOCon = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.SSPOCon] == 1 ) & ...
            ( [varParList.xInclude] == 1) & ...
            ( [varParList.yInclude] == 1) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
bin_SSPOCoff = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.SSPOCon] == 0 ) & ...
            ( [varParList.xInclude] == 1) & ...
            ( [varParList.yInclude] == 1) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
figure();plot(bin_SSPOCon,'-o')
hold on;plot(bin_SSPOCoff,'-o')

ind_SSPOCon = find(bin_SSPOCon);
ind_SSPOCoff = find(bin_SSPOCoff);

% par.phi_dist = [0,0.1,1,10];
% par.phi_distList = spa_sf( 10.^[-3:0.4:2] ,2);
% par.theta_distList = spa_sf( 10.^[-3:0.4:2] ,2);
par.phi_distList = spa_sf( 10.^[-3:0.4:2] ,2);
par.theta_distList = spa_sf( 10.^[-3:0.4:2] ,2);


total_humpsim = ind_SSPOCon(17:end);
total_humpsimoff = ind_SSPOCoff(17:end);
ind_SSPOCon_phi = ind_SSPOCon(17: 17+ length(total_humpsim)/2 -1)
ind_SSPOCon_theta = ind_SSPOCon(17+ length(total_humpsim)/2 :end)
ind_SSPOCoff_phi = ind_SSPOCoff(17: 17+ length(total_humpsimoff)/2 -1)
ind_SSPOCoff_theta = ind_SSPOCoff(17+ length(total_humpsimoff)/2 :end)

col = {'-k','-r'};
dotcol = {'.k','.r'}; 


Datamat(:,[1:10,15:40],:) = 0;

%% create subplot routine
% 
color_vec = {'-r','-k'};
fig2=figure();

subplot(211)
for j = 1:size(Datamat,2)
%     for k2 = 1:size(Datamat,2)
    for k = 1:length(ind_SSPOCon_phi)
        meanVec(j,k) = mean(nonzeros(Datamat(  ind_SSPOCon_phi(k)  ,j,:)));
        stdVec(j,k) = std(nonzeros(Datamat(ind_SSPOCon_phi(k)  ,j,:)));
    end
    
     if ~any(isnan(meanVec(j,:)))
%          display('semilog x')
%          meanVec(j,:)
% figure() 
        hold on
         semilogx(par.phi_distList,meanVec(j,:),'r','Linewidth',0.8)
         hold on
     end
%     hold on
end

%      set(gca,'xscale','log');
%
for j = 1:size(Datamat,2)
%     for k2 = 1:size(Datamat,2)
    for k = 1:length(ind_SSPOCoff_phi)
        meanVec(j,k) = mean(nonzeros(Datamat(ind_SSPOCoff_phi(k)  ,j,:)));
        stdVec(j,k) = std(nonzeros(Datamat(ind_SSPOCoff_phi(k)  ,j,:)));
    end
    if ~any(isnan(meanVec(j,:)))
        semilogx( par.phi_distList,meanVec(j,:),'k','Linewidth',0.8)
         hold on
    end
%     hold on
end
     set(gca,'xscale','log');
%      title('$\phi$-disturbance
     xlabel('\phi-disturbance [rad/s]')
     ylabel('accuracy')


subplot(212)
for j = 1:size(Datamat,2)
%     for k2 = 1:size(Datamat,2)
    for k = 1:length(ind_SSPOCon_theta)
        meanVec(j,k) = mean(nonzeros(Datamat(ind_SSPOCon_theta(k)  ,j,:)));
        stdVec(j,k) = std(nonzeros(Datamat(ind_SSPOCon_theta(k)  ,j,:)));
    end
    
     if ~any(isnan(meanVec(j,:)))
        semilogx(par.phi_distList,meanVec(j,:),'r','Linewidth',0.8)
         hold on
     end
%     hold on
end

for j = 1:size(Datamat,2)
%     for k2 = 1:size(Datamat,2)
    for k = 1:length(ind_SSPOCoff_theta)
        meanVec(j,k) = mean(nonzeros(Datamat(ind_SSPOCoff_theta(k)  ,j,:)));
        stdVec(j,k) = std(nonzeros(Datamat(ind_SSPOCoff_theta(k)  ,j,:)));
    end
    if ~any(isnan(meanVec(j,:)))
        semilogx(par.phi_distList,meanVec(j,:),'k','Linewidth',0.8)
         hold on
    end
%     hold on
end
     set(gca,'xscale','log');
     xlabel('\theta-disturbance [rad/s]')
     ylabel('accuracy')


saveas(fig2,['figs' filesep 'Figure2B_PhiTheta_hump'], 'png')

% plot(meanVec)
% for j = 1:
%         
%    % plot sspoc off
%         Dat_I = ind_SSPOCoff(sub_nr);
%         for k2 = 1:size(Datamat,2)
%             meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
%             stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
%             iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{1})
%         end
%         realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1},0.8);
%         
%     % plot sspoc on 
%         Dat_I = ind_SSPOCon(sub_nr);
%         for k2 = 1:size(Datamat,2)
%             meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
%             stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
% % 
%             iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{2})
%     
%         end
%         realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.8);
%         
%         axis([0,40,0.4,1])
%         if sub_nr <=4
%             title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
%         end
%         if  rem(sub_nr-1,4) == 0
%             ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
%         end
%     end
% end
% 

% saveas(fig2,['figs' filesep 'Figure2_ThetaDistVSPhiDist'], 'png')

