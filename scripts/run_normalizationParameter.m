%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

% fixPar = struct with fixed parameters used throughout the simulation
% varParList = struct(1:5).xxx  contains lists of variable parameters 
% combinationStruct contains all required combinations specified in varParList
% varPar is one combination specified in combinationStruct
%------------------------------
clear all, close all, clc
addpathFolderStructure()

parameterSetName    = 'normalizationParam';
iter                = 10;
figuresToRun        = {'R1'};
% select any from {'R2A','R2B','R2C','R3','R4','R2allSensorsnoFilt','R2allSensorsFilt} 

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
fixPar.determineNorm = 1;
varParStruct(1).theta_dist = 0.1;
varParStruct(1).phi_dist = 0.312;
varParStruct(1).theta_dist = 0.1;
varParStruct(1).phi_dist = 0.312;
%% Run eulerLagrangeSimulation (optional) and sparse sensor placement algorithm

j=1;
varPar = varParStruct(j);
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
save(['results' filesep 'normalizationVal_th0_1ph0_312.mat'],'meanNorm','fixPar','varPar')