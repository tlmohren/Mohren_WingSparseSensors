%------------------------------
% run_ZnormalizationParameters
% This script is used to find the normalization parameter C for the neural
% encoding. 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all, close all, clc
addpathFolderStructure()

parameterSetName    = 'normalizationParam';
iter                = 10;
figuresToRun        = {'R1'};

% Build struct that specifies all parameter combinations to run 
addpathFolderStructure()
parameterSetName    = 'Example 1';
figuresToRun        = 'E1'; % run Example 1 
iter                = 1; % number of iterations 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 
varPar = varParStruct(1);
fixPar.determineNorm = 1;
%% Run eulerLagrangeSimulation (optional) and sparse sensor placement algorithm

% Run parameter combination for a set number of iterations ---------
for k = 1:fixPar.iter
    varPar.curIter = k; 
    % Generate strain with Euler-Lagrange simulation ----------
    strainSet = eulerLagrangeConcatenate( fixPar,varPar);
    % Apply neural filters to strain --------------------------
    [X,G] = neuralEncoding(strainSet, fixPar,varPar );

    normVals(k) = X.tempNorm;
    fprintf('tempNorm = %1.5f \n',[ X.tempNorm])
end
meanNorm = mean(normVals);
fprintf('Mean norm is = %1.5f \n',[ meanNorm])
save(['eulerLagrangeData' filesep 'normalizationVal_th0_1ph0_312.mat'],'meanNorm','fixPar','varPar')