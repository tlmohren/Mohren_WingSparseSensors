clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath(scriptLocation );

% run_all_tests = false
run_all_tests = true

if run_all_tests % run all tests in folder 
    runtests
else % select individual tests
%     results_randCrossVal = runtests('test_randcrossval.m');
    results_SSPOC = runtests('test_SSPOC.m');
end 