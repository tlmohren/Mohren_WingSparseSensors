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
parameterSetName    = ' ';
figuresToRun        = {'subSetTest'};
iter = 1;
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
fixPar.xInclude = 0;
fixPar.yInclude = 1;
testCase =1;

if testCase == 1
    % regular testcase
    frot = 0;
    th = 3;
    ph = 3.12;
elseif testCase == 2
    % reduce size for speed increase 
    frot = 0;
    ph = 0;
    th = 0; 
    fixPar.chordElements = 10;
    fixPar.spanElements = 10;
elseif testCase == 3
    % introduce disturbance level 
    frot = 0;
    ph = 1;
    th = 1; 
    fixPar.runSim = 1;
    fixPar.chordElements = 10;
    fixPar.spanElements = 10;
elseif testCase == 4
    % introduce disturbance level 
    frot = 10;
    th = 1;
    ph = 10;
else
    error('Invalid testcase entry    TLM 2017')
end

fixPar
% [strain,figdata] =  eulerLagrange_forfigures(frot, th,ph ,par );
strain =  eulerLagrange(frot, th,ph ,fixPar );
%% 
% save('flapDisturbance_31_2.mat','figdata')

%% check output here, size, content 
display('Output diagnostics')
[m,n] = size(strain);
figure(); plot(strain(50,:))