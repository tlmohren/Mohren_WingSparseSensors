%------------------------------
% run_eulerLagrangeOnly
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all,clc;close all
% close all, clc
addpathFolderStructure()
parameterSetName    = 'Example 1';
figuresToRun        = 'E1'; % run Example 1 
iter                = 3; % number of iterations 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 

varPar              = varParStruct(1);
fixPar.runSim       = 1;
fixPar.saveSim      = 1;

for j = 1:5
    varPar.curIter      = j;
    strainSet       = eulerLagrangeConcatenate( fixPar,varPar);
end