% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 
run('link_folders_SSPOC.m')
clc;clear all;close all

%% Run testcases
% load required parameters 
par = setParameters();

% Specify testcase 
testCase =1;

if testCase == 1
    % load 26 x 51 strain wing data 
%     strainSet = load(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata2651.mat']);
    strainSet = load(['data' filesep 'strainSet_th0ph0chElem26spElem51.mat']);
%     strain = loadSingleVariableMATFile(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata2651.mat']);
    
elseif testCase == 2
    % load 10 x 10 strain wing data 
%     strainSet = load(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata2651.mat']
    strainSet = load(['data' filesep 'strainSet_th0ph0chElem12spElem12.mat']);
    
else
    error('Invalid testcase entry    TLM 2017')
    
end

[X,G] = neuralEncoding(strainSet, par); 
parSort = orderfields(par)

%% check output here, size, content 
display('Output diagnostics')
% [m,n] = size(strain)
% [mx,nx] = size(X)
% figure(); plot(strain(50,:))