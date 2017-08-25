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
% load required parameters 

par = setParameters;
[varParList,~] = setVariableParameters_MultipleSets(par);
par.varParNames = fieldnames(varParList);
par.iter = 20;
par.elasticNet = 0.9;
par.saveNameParameters = 'STANLD11_Iter20';


% Specify testcase 
testCase =2;

% [varParList,varParList_short] = setVariableParameters_STANLD0(par);
j =1 ;
par.varParNames = fieldnames(varParList);
for k = 1:length(par.varParNames)
    par.(par.varParNames{k}) = varParList(j).(par.varParNames{k});
end


    DataFolder = 'D:\Mijn_documenten\Dropbox\A. PhD\C. Papers\ch_Wingsensors\Mohren_WingSparseSensorsData';
    strainSet = load([DataFolder filesep 'strainSet_th0ph0cEl26sEl51Ex0Ey1.mat']);
if testCase == 1
    % load 26 x 51 strain wing data 
%     strainSet = load(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata2651.mat']);
%     strainSet = load([DataFolder filesep 'strainSet_th0ph0cEl26sEl51Ex0Ey1.mat']);
%     strain = loadSingleVariableMATFile(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata2651.mat']);
    par.STAwidth = 0;
    par.NLDsharpness = 0;
elseif testCase == 2
    % load 10 x 10 strain wing data 
%     strainSet = load(['diagnostics' filesep 'UnitTest_neuralEncoding_testdata2651.mat']
%     strainSet = load(['data' filesep 'strainSet_th0ph0chElem12spElem12.mat']);
%     par.STAwidth = 0;
%     par.NLDsharpness = 0;
    
else
    error('Invalid testcase entry    TLM 2017')
    
end
par.STAfreq = 1;
par.STAwidth = 3;
% [X,G] = neuralEncoding(strainSet, par); 
[X,G] = neuralEncodingNewFilters(strainSet, par); 
parSort = orderfields(par);
par.wTrunc = 15;
[acc,~ ] = sparseWingSensors( X,G, par)

%% check output here, size, content 
display('Output diagnostics')
% [m,n] = size(strain)
% [mx,nx] = size(X)
partShow = 2500:3500;
figure(); 
    subplot(311)
    plot( [strainSet.strain_0(40,partShow) , strainSet.strain_10(40,partShow) ])
    subplot(312)
    plot( X(40,partShow))
    
    subplot(313)
    plot( G(partShow))
    
