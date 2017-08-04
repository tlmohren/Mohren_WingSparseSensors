
% script to get other scripts rolling 

clear all, close all, clc
addpathFolderStructure()


run('run_paperAnalysis_allSensors.m')
% run('run_paperAnalysis_STANLD0.m')
run('run_paperAnalysis.m')