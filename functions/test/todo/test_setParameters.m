%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry throughout simulation

% set up fixed parameters 
par = setParameters_STAsweep();   % these are actually fixed par, change name later 
par.iter = 10;
par.wList = 1:30;
par.savename = 'test_varPar';
varParList = setVariableParameters(par);

% define what naes are on the parameter list 
% varPar = varParList(1);
varParNames = fieldnames(varParList);
errorCheckPar(par); % error check parameters given 
