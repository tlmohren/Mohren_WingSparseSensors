
%% Find nonzero elements in matrix 



% not working yet, but should be easy once right simulations are done 














%%
clc;clear all; close all 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])

%% 

% Datamat = rand(size(Datamat))*0.2 + 0.6;

%% see which simulations belong to this parameter set 

bin_SSPOConXX = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.SSPOCon] == 1 ) & ...
            ( [varParList.xInclude] == 0) & ...
            ( [varParList.yInclude] == 1) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
bin_SSPOCoffXX = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.SSPOCon] == 0 ) & ...
            ( [varParList.xInclude] == 0) & ...
            ( [varParList.yInclude] == 1) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
        
        
bin_SSPOConYY = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.SSPOCon] == 1 ) & ...
            ( [varParList.xInclude] == 1) & ...
            ( [varParList.yInclude] == 0) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
bin_SSPOCoffYY = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.SSPOCon] == 0 ) & ...
            ( [varParList.xInclude] == 0) & ...
            ( [varParList.yInclude] == 1) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
% figure();plot(bin_SSPOCon,'-o')
hold on;plot(bin_SSPOCoffYY,'-o')

ind_SSPOConYY = find(bin_SSPOConYY);
ind_SSPOCoffYY = find(bin_SSPOCoffYY);

par.phi_dist = [0,0.1,1,10];
par.theta_dist = [0,0.1,1,10];
n_plots = 16; 
n_x = 4;
n_y = 4; 
col = {'-k','-r'};
dotcol = {'.k','.r'}; 
%% create subplot routine

color_vec = {'-r','-k'};
fig2=figure();
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on
        
        
   % plot sspoc off
        Dat_I = ind_SSPOCoffYY(sub_nr);
        for k2 = 1:size(Datamat,2)
            meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{1})
        end
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1},0.8);
        
    % plot sspoc on 
        Dat_I = ind_SSPOConYY(sub_nr);
        for k2 = 1:size(Datamat,2)
            meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
% 
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{2})
    
        end
        realNumbers = find(~isnan(meanVec));
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.8);
        
        axis([0,20,0.4,1])
        if sub_nr <=4
            title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
        end
        if  rem(sub_nr-1,4) == 0
            ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
        end
    end
end


saveas(fig2,['figs' filesep 'Figure2C_ThetaDistVSPhiDistXXYY'], 'png')

