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
testCase =1;

if testCase == 1
    % load 26 x 51 strain wing data 
    testData = load(['test_code' filesep 'UnitTest_sensorLocSSPOC_testdataRandom.mat']);
    par = testData.par;
elseif testCase == 2
    testData = load(['test_code' filesep 'UnitTest_sensorLocSSPOC_testdataSSPOC.mat']);
    par = testData.par;
else
    error('Invalid testcase entry    TLM 2017')
    
end
par.showFigure = 1;

par 
sensors = sensorLocSSPOC( testData.Xtrain , testData.Gtrain , par);


%% check output here, size, content 

binar = zeros(    par.chordElements * par.spanElements * (par.xInclude + par.yInclude) ,1);
binar( sensors ) =1;
plot_sensorlocsXXYYV3(binar ,par);