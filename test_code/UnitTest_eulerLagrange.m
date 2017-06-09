% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

clc;clear all;close all

%% Run testcases
% Specify testcase 
par = setParameters();
par.xInclude = 0;
par.yInclude = 1;
testCase =4;

if testCase == 1
    % regular testcase
    frot = 0;
    th = 0;
    ph = 0;
elseif testCase == 2
    % reduce size for speed increase 
    frot = 0;
    ph = 0;
    th = 0; 
    par.chordElements = 10;
    par.spanElements = 10;
elseif testCase == 3
    % introduce disturbance level 
    frot = 0;
    ph = 1;
    th = 1; 
    par.runSim = 1;
    par.chordElements = 10;
    par.spanElements = 10;
elseif testCase == 4
    % introduce disturbance level 
    frot = 10;
    th = 1;
    ph = 0.1;
else
    error('Invalid testcase entry    TLM 2017')
end

par
[strain] = eulerLagrange_forfigures(frot, th,ph ,par );


%% check output here, size, content 
display('Output diagnostics')
[m,n] = size(strain);
figure(); plot(strain(50,:))