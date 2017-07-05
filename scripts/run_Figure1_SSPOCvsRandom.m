% generate R1 figure, just 

clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

load(['results' filesep 'DataMatTot_MacPcCombined'])
allSensors = load(['results' filesep 'tempDataMatTot_allSensors']);

Datamat = dataMatTot;

col = {'-k','-r'};
dotcol = {'.k','.r'}; 
fig1 = figure('Position', [100, 100, 1200, 800]);

subplot(3,3,[1,2,4,5,7,8])
% for j = 1:2
%% random 

legendlist = [];
    j = 1;
    for k = 1:size(Datamat,2)
        meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
        stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );

        iters = length(nonzeros(Datamat(j,k,:)) );
%         scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
        hold on
    end
    
    realNumbers = find(~isnan(meanVec));
    a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
    legendlist = [legendlist,a.mainLine];
%% SSPOC
    j = 2;
    for k = 1:size(Datamat,2)
        meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
        stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );

        iters = length(nonzeros(Datamat(j,k,:)) );
        scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
        hold on
    
    end
    realNumbers = find(~isnan(meanVec)); 
%     a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
%     legendlist = [legendlist,a.mainLine];
    b = plot(realNumbers, meanVec(realNumbers),col{j});
    legendlist = [legendlist,b];

    
        meanval = mean( allSensors.dataMatTot(1,:) );
        stdval = std( allSensors.dataMatTot(1,:) );
        errorbar(35,meanval,stdval,'k','LineWidth',1)
        plot([34,36],[meanval,meanval],'k','LineWidth',1)
        
axis([0,36,0.4,1])
xlabel('\# sensors')
ylabel('Accuracy [-]')
grid on

% legend(legendlist,{'Random placement','Optimal placement'},'Location','Best')

saveas(fig1,['figs' filesep 'Figure1_SSPOCvsRandom'], 'png')

%%
varParCase = 2;
q_select = 13;
        n_iters= length(nonzeros(Datamat(varParCase,q_select,:)))
        
%         length(nonzeros(sensorMatTot(varParCase,q_select,:,:)))
        binar = zeros(26*51,1);
        for j = 1:n_iters
%             sensorMatTot(varParCase,q_select,:,j)
            binar(sensorMatTot(varParCase,q_select,1:q_select,j)) = binar(sensorMatTot(varParCase,q_select,1:q_select,j)) +1;
        end
        binar = binar/n_iters;
%         figure()

subplot(3,3,6)
        plotSensorLocs(binar,par)
        
        
subplot(3,3,9)
        plotSensorLocs(binar,par)







