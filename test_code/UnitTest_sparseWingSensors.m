% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 
clc;clear all;close all
% 
% addpath('scripts')
% addpathFolderStruture()
pwd
addpath('scripts')
addpathFolderStructure()
%% Run testcases
% load parameters 
% par = setParameters();

% Specify testcase 
testCase =2;

if testCase == 1
    % load 26 x 51 strain wing data 
    testData = load(['test_code' filesep 'UnitTest_sparseWingSensors_2651strainy.mat']);
    par = testData.par;
elseif testCase == 2
    % load 26 x 51 strain wing data 
    testData = load(['test_code' filesep 'UnitTest_sparseWingSensors_2651strainy.mat']);
    par = testData.par;
    par.SSPOC_on = 0;
else
    error('Invalid testcase entry    TLM 2017')
    
end
par.showFigure =1 ;
par 
[accuracy, sensors] = sparseWingSensors(testData.X,testData.G,par)

%% check output here, size, content 
display('Output diagnostics')
% [m,n] = size(strain)
% [mx,nx] = size(X)
% figure(); plot(strain(50,:))

binar = zeros(    par.chordElements * par.spanElements * (par.xInclude + par.yInclude) ,1);
binar( sensors ) =1;
plot_sensorlocsXXYYV3(binar ,par);