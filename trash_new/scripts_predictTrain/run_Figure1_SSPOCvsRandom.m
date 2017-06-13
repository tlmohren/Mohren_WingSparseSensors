% generate R1 figure, just 

clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()
%% 

% load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])


% load(['results' filesep 'analysis_FigR1toR4_XXYY_270Par'])

% load(['results' filesep 'tempDataMatTot'])

load(['results' filesep 'DataMatTot_MacPcCombined'])

Datamat = dataMatTot;





col = {'-k','-r'};
dotcol = {'.k','.r'}; 
fig1 = figure('Position', [100, 100, 1000, 800]);
% for j = 1:2
%% random 
    j = 1
    for k = 1:size(Datamat,2)
        meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
        stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );

        iters = length(nonzeros(Datamat(j,k,:)) );
%         scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
        hold on
    
    end
    realNumbers = find(~isnan(meanVec));
    a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
    
%% SSPOC
    j = 2
    for k = 1:size(Datamat,2)
        meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
        stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );

        iters = length(nonzeros(Datamat(j,k,:)) );
        scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
        hold on
    
    end
    realNumbers = find(~isnan(meanVec)); 
    a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);

% end
axis([0,30,0.4,1])
xlabel('\# sensors')
ylabel('Accuracy [-]')
grid on

saveas(fig1,['figs' filesep 'Figure1_SSPOCvsRandom'], 'png')

%% see which simulations belong to this parameter set 

% j_inlist = ( [varParList.STAwidth] == 3) & ...
%             ( [varParList.STAshift] == -10) & ...
%             ( [varParList.theta_dist] == 0) & ...
%             ( [varParList.phi_dist] == 0) & ...
%             ( [varParList.SSPOCon] == 0 |  [varParList.SSPOCon] == 1 ) & ...
%             ( [varParList.xInclude] == 1) & ...
%             ( [varParList.yInclude] == 1) & ...
%             ( [varParList.NLDshift] == 0.5) & ...
%             ( [varParList.NLDsharpness] == 10);
% figure();plot(j_inlist,'-o')


% j_inlist = ( [varParList.STAwidth] == 3) & ...
%             ( [varParList.STAshift] == -10) & ...
%             ( [varParList.theta_dist] == 0) & ...
%             ( [varParList.phi_dist] == 0) & ...
%             ( [varParList.SSPOCon] == 0 |  [varParList.SSPOCon] == 1 ) & ...
%             ( [varParList.xInclude] == 0) & ...
%             ( [varParList.yInclude] == 1) & ...
%             ( [varParList.NLDshift] == 0.5) & ...
%             ( [varParList.NLDsharpness] == 10);
% figure();plot(j_inlist,'-o')


j_inlist = ( [varParList_short.STAwidth] == 3) & ...
            ( [varParList_short.STAshift] == -10) & ...
            ( [varParList_short.theta_dist] == 0) & ...
            ( [varParList_short.phi_dist] == 0) & ...
            ( [varParList_short.SSPOCon] == 0 |  [varParList_short.SSPOCon] == 1 ) & ...
            ( [varParList_short.xInclude] == 0) & ...
            ( [varParList_short.yInclude] == 1) & ...
            ( [varParList_short.NLDshift] == 0.5) & ...
            ( [varParList_short.NLDsharpness] == 10);
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

%%



varParCase = 2;
q_select = 17;
        n_iters= length(nonzeros(Datamat(varParCase,q_select,:)))
        
%         length(nonzeros(sensorMatTot(varParCase,q_select,:,:)))
        binar = zeros(26*51,1);
        for j = 1:n_iters
%             sensorMatTot(varParCase,q_select,:,j)
            binar(sensorMatTot(varParCase,q_select,1:q_select,j)) = binar(sensorMatTot(varParCase,q_select,1:q_select,j)) +1;
        end
        binar = binar/n_iters;
        figure()
        plotSensorLocs(binar,par)
%         meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
%         stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );
% 
%         iters = length(nonzeros(Datamat(j,k,:)) );
% %         scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
%         hold on
%     
%     end









