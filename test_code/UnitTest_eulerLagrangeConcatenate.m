% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 
clc;clear all;close all
run('link_folders_SSPOC.m')


            
%% Run testcases
% Specify testcase 
par = setParameters();
testCase = 2;
par.baseZero = 0;
par.xInclude = 0;
par.yInclude = 1;
if testCase == 1
    ph = 0;
    th = 0; 
    par.runSim = 1;
    par.saveSim = 0;
    par.chordElements = 26;
    par.spanElements = 51;
elseif testCase == 2
    ph = 0;
    th = 0.1; 
    par.runSim = 0;
    par.saveSim = 1;
    par.chordElements = 26;
    par.spanElements = 51;
elseif testCase == 3
    ph = 1;
    th = 0; 
    par.runSim = 0;
elseif testCase == 4
    ph = 0.1;
    th = 0.1; 
    par.runSim = 1;
    par.saveSim = 1;
elseif testCase == 5
    % test for fewer evaluation points 
    ph = 0;
    th = 0; 
    par.runSim = 1;
    par.chordElements = 10;
    par.spanElements = 10;
else
    display('Invalid testcase entry')
end

strain = eulerLagrangeConcatenate(ph,th,par);


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