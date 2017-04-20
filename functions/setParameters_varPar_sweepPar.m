function [ par] = setParameters_varPar_sweepPar(par)
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017
%  unsorted



par.theta_distList = [0,0.1,1];
par.phi_distList = [0,0.1,1];
par.xIncludeList = [0];
par.yIncludeList = [1];
par.SSPOConList = [1];
par.STAwidthList = [3];
par.STAshiftList = [-10];% 
par.NLDshiftList = [0.5];
par.NLDsharpnessList = [10];