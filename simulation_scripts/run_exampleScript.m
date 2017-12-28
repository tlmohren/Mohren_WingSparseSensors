%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

%------------------------------
clear all, close all, clc
addpathFolderStructure()

iter                = 1; % number of iterations 
parameterSetName    = 'Example 1';
% figuresToRun        = {'E1'}; % run Example 1 
figuresToRun        = 'E1'; % run Example 1 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 

varPar              = varParStruct(1)  % SSPOC off 
% varPar            = varParStruct(2)  % SSPOC on 

%% Test neural encoding effert
strainSet       = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it2harm0.2.mat']);

[X,G]           = neuralEncoding(strainSet, fixPar,varPar );

[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);

sensors         = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varPar);

accuracy        = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest )


%% Plot sensor locations on the wing 
binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
binar(sensors)  = 1;
sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 

colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
x       = [0 1 1 0]* (fixPar.spanElements+1);  
y       = [0 0 1 1]* (fixPar.chordElements+1);
[X,Y]   = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
I       = find( sensorloc_tot );    

figure()
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on   
    scatter(X(I) ,Y(I) , 100 ,'.','r');      
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off