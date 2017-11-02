% TLM 2017/10/12  

clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath(scriptLocation );

run_all_tests = true;

if run_all_tests % run all tests in folder 
    runtests
else % select individual tests
%     results_randCrossVal = runtests('test_randCrossVal.m');
%     results_randCrossVal = runtests('test_predictTrain.m');
%     results_SSPOCelastic = runtests('test_SSPOCelastic.m');
%     results_randCrossVal = runtests('test_classify_nc.m');
%     results_randCrossVal = runtests('test_disturbanceCalibrate.m');
%     results_randCrossVal = runtests('test_combineDataMat.m');
end 