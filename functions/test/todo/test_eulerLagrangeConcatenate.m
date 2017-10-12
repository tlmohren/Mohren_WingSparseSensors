% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 
clc;clear all;close all
% run('link_folders_SSPOC.m')


scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

            
%% Run testcases
% Specify testcase 
parameterSetName    = ' ';
figuresToRun        = {'subSetTest'};
iter = 1;
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );


varPar = varParStruct(1);
varPar.curIter = 1;
testCase = 3;
fixPar.baseZero = 0;
fixPar.xInclude = 0;
fixPar.yInclude = 1;
if testCase == 1
    ph = 0;
    th = 0; 
    fixPar.runSim = 1;
    fixPar.saveSim = 0;
    fixPar.chordElements = 26;
    fixPar.spanElements = 51;
elseif testCase == 2
    ph = 0.1;
    th = 0; 
    fixPar.runSim = 1;
    fixPar.saveSim = 1;
    fixPar.chordElements = 26;
    fixPar.spanElements = 51;
elseif testCase == 3
    varPar.phi_dist = 2.5;
    varPar.theta_dist = 0.312; 
    fixPar.runSim = 0;
elseif testCase == 4
    ph = 0.1;
    th = 0.1; 
    fixPar.runSim = 1;
    fixPar.saveSim = 1;
elseif testCase == 5
    % test for fewer evaluation points 
    ph = 0;
    th = 0; 
    fixPar.runSim = 1;
    fixPar.chordElements = 10;
    fixPar.spanElements = 10;
else
    display('Invalid testcase entry')
end

strain = eulerLagrangeConcatenate(fixPar,varPar);


%% check output here, size, content 
display('Output diagnostics')

strain


Delta_strain = strain.strain_10-strain.strain_0;
max_Delta_strain = max(Delta_strain(:))
% --------------Check difference between two cases 
sens_I = 102
figure();
    subplot(211)
    plot(strain.strain_0(sens_I,:))
    hold on 
    plot(strain.strain_10(sens_I,:))
    subplot(212)
    plot( strain.strain_10(sens_I,:) -  strain.strain_0(sens_I,:) )
% [m,n] = size(strain)

%% If desired, save output for other UnitTests 
% save(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata1010'],'strain')