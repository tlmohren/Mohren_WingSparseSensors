% generate R1 figure, just 

clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% load(['results' filesep 'DataMatTot_MacPcCombined'])
par.saveNameParameters = 'elasticNet09';
% par.saveNameParameters = 'elasticNet09_phiCorrect';
load(['results' filesep 'dataMatTot_' par.saveNameParameters],'dataMatTot','sensorMatTot','par')

% allSensors = load(['results' filesep 'tempDataMatTot_allSensors']);
par.saveNameAllSensors = 'elasticNet09_phiCorrect_allSensors';
allSensors = load(['results' filesep , 'dataMatTot_' par.saveNameAllSensors,'.mat']);
% _phiCorrect_allSensors
% datamatTot = dataMatTot;
col = {'-k','-r'};
dotcol = {'.k','.r'}; 
fig1 = figure('Position', [100, 100, 900, 450]);

subplot(3,3,[1,2,4,5,7,8])
%% random 
legendlist = [];
j = 1;
for k = 1:size(dataMatTot,2)
    meanVec(k) = mean(  nonzeros(dataMatTot(j,k,:))   );
    stdVec(k) = std(  nonzeros(dataMatTot(j,k,:))   );
    iters = length(nonzeros(dataMatTot(j,k,:)) );
%         scatter( ones(iters,1)*k,nonzeros(Datamat(j,k,:)) , dotcol{j})
    hold on
end

realNumbers = find(~isnan(meanVec));
a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
legendlist = [legendlist,a.mainLine];

%% SSPOC
j = 2;
for k = 1:size(dataMatTot,2)
    meanVec(k) = mean(  nonzeros(dataMatTot(j,k,:))   );
    stdVec(k) = std(  nonzeros(dataMatTot(j,k,:))   );
    iters = length(nonzeros(dataMatTot(j,k,:)) );
    scatter( ones(iters,1)*k,nonzeros(dataMatTot(j,k,:)) , dotcol{j})
    hold on
end
realNumbers = find(~isnan(meanVec)); 
%     a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
%     legendlist = [legendlist,a.mainLine];
b = plot(realNumbers, meanVec(realNumbers),col{j});
legendlist = [legendlist,b];

meanval = mean( allSensors.dataMatTot(1,:) );
stdval = std( allSensors.dataMatTot(1,:) );

% plot errorbar 
c = errorbar(34,meanval,stdval,'b','LineWidth',2);
plot([33,35],[meanval,meanval],'b','LineWidth',2)
legendlist = [legendlist,c];
        
axis([0,36,0.45,1])
xlabel('# sensors')
ylabel('Accuracy [-]')
grid on

A{1} = 0:5:30;
A{2} = 1326;
set(gca,'xtick',[0:5:30,34]);
set(gca,'xticklabel',A);
legend(legendlist,{'Random placement','Optimal placement', 'all sensors'},'Location','Best')





%%

varParCase = 1;
q_select = 13;
n_iters= length(nonzeros(dataMatTot(varParCase,q_select,:)))

binar = zeros(26*51,1);
for j = 1:n_iters
%             sensorMatTot(varParCase,q_select,:,j)
    binar(sensorMatTot(varParCase,q_select,1:q_select,j)) = binar(sensorMatTot(varParCase,q_select,1:q_select,j)) +1;
end
binar = binar/n_iters;
%         figure()
subplot(3,3,3)
        plotSensorLocs(binar,par)
        

    ylabel('base')
%%
varParCase = 2;
q_select = 13;
n_iters= length(nonzeros(dataMatTot(varParCase,q_select,:)))

binar = zeros(26*51,1);
for j = 1:n_iters
%             sensorMatTot(varParCase,q_select,:,j)
    binar(sensorMatTot(varParCase,q_select,1:q_select,j)) = binar(sensorMatTot(varParCase,q_select,1:q_select,j)) +1;
end
binar = binar/n_iters;
%         figure()
subplot(3,3,6)
        plotSensorLocs(binar,par)
        
    ylabel('base')
%%
subplot(3,3,9)
    plotSensorLocs(ones(1326,1),par)

ylabel('base')

set(fig1,'PaperPositionMode','auto')

par.saveNameParameters = 'elasticNet09';
% saveas(fig1,['figs' filesep 'Figure1_SSPOCvsRandom'], 'png')
saveas(fig1,['figs' filesep 'Figure1_SSPOCvsRandom_' par.saveNameParameters], 'png')
saveas(fig1,['figs' filesep 'Figure1_SSPOCvsRandom_' par.saveNameParameters], 'eps')


