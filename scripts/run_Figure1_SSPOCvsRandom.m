% generate R1 figure, just 

clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()
%% 

% load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])
load(['results' filesep 'analysis_FigR1toR4_XXYY_270Par'])


% analysis_FigR1toR4_XXYY_270Par

col = {'-k','-r'};
dotcol = {'.k','.r'}; 
fig1 = figure('Position', [100, 100, 1000, 800]);
for j = 1:2
    for k = 1:size(Datamat,2)
        meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
        stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );

        iters = length(nonzeros(Datamat(j,k,:)) );
        scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
        hold on
    
    end
    realNumbers = find(~isnan(meanVec));
    a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
    

end
axis([0,40,0.4,1])

saveas(fig1,['figs' filesep 'Figure1_SSPOCvsRandom'], 'png')

%% see which simulations belong to this parameter set 

j_inlist = ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10) & ...
            ( [varParList.theta_dist] == 0) & ...
            ( [varParList.phi_dist] == 0) & ...
            ( [varParList.SSPOCon] == 0 |  [varParList.SSPOCon] == 1 ) & ...
            ( [varParList.xInclude] == 1) & ...
            ( [varParList.yInclude] == 1) & ...
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
figure();plot(j_inlist,'-o')
%     figure(); plot( ( [varParList.STAwidth] == 3))
%     hold on; plot( ([varParList.STAshift] == -10) + 0.01)
%     hold on; plot( ( [varParList.theta_dist] == 0) + 0.02)
%     hold on; plot( ( [varParList.phi_dist] == 0) + 0.03)
%     hold on; plot(  ( [varParList.SSPOCon] == 0 |  [varParList.SSPOCon] == 1 ) + 0.04)
%     hold on; plot(   ( [varParList.xInclude] == 0)  + 0.05)
%     hold on; plot(  ( [varParList.yInclude] == 1)  + 0.06)
%     hold on; plot(  ( [varParList.NLDshift] == 0.5) + 0.07)
%     hold on; plot(   ( [varParList.NLDsharpness] == 10) + 0.08)
%     legend('STAwdith','STAshift','theta_dist','phi_dist','SSPOCon','xinclude','ylinclude','NLDShift','NLDsharpness')