%------------------------------
% run_exampleScript
% Runs a single instance of the neurally encoded sparse sensor classification. 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all, close all, clc
addpathFolderStructure()
parameterSetName    = 'Example 1';
figuresToRun        = 'E1'; % run Example 1 
iter                = 1; % number of iterations 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 

%%%%%%%%%%%%%%% Choices to make %%%%%%%%%%%%%%%%%%%%%%%%
sparse_sensors_on           = 1; % choose 1 for sparse sensors ON, if 0 the sensors will be random 
desired_number_of_sensors   = 13; % choose an integer between 1 and 30
rerun_structural_simulation_on = 0; % choose to load structural euler-lagrange simulation results, or to rerun them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sparse_sensors_on
    varPar              = varParStruct(2);  % SSPOC on 
else
	varPar              = varParStruct(1);  % SSPOC off 
end
varPar.wTrunc           = desired_number_of_sensors;
if rerun_structural_simulation_on
    fixPar.runSim       = 1;
    fixPar.saveSim      = 0;
end
varPar.curIter      = 1;

%% Run the exampale simulation
strainSet       = eulerLagrangeConcatenate( fixPar,varPar);
[X,G]           = neuralEncoding(strainSet, fixPar,varPar );
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
sensors         = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varPar);
accuracy        = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );

if sparse_sensors_on
    fprintf('\nThe optimization gives %g sensors for the %g truncated modes, giving a classification accuracy of %g \n', length(sensors),varPar.wTrunc, accuracy)
else
    fprintf('\nThe %g randomly placed sensors give a classification accuracy of %g \n', length(sensors), accuracy)
end

    
%% Plot sensor locations on the wing 
binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
binar(sensors)  = 1;
sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 

colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
x               = [0 1 1 0]* (fixPar.spanElements+1);  
y               = [0 0 1 1]* (fixPar.chordElements+1);
[X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
I               = find( sensorloc_tot );    

figure()
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on   
    scatter(X(I) ,Y(I) , 100 ,'.','r');      
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off