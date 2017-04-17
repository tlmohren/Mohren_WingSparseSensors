%%----------------------------------------------------
% link_folder_SSPOC.m
% Last updated: 2017/4/06  (edit by Thomas Mohren)
% Author: Sam Kinn
% Script finds it's own location and adds necessary folders to workpath.
% Also checks if CVX is installed

%% Find location of this script 
baseDirectory = fileparts(fileparts(mfilename('fullpath') ));
% baseName = 
[dataDirectory,baseName] = fileparts(baseDirectory);
if ~exist([dataDirectory filesep baseName,'Data'])
    display(['Data folder does not exist yet=  ',dataDirectory filesep baseName,'Data'])
    mkdir(dataDirectory , [baseName,'Data'])
    display('created folder')
else
%     display('datafile exists')
end
cd(baseDirectory );

%% Add paths required for main script
addpath([dataDirectory filesep baseName,'Data'])
addpath([baseDirectory filesep 'functions'])
% addpath([baseDirectory filesep 'functionsXXYY'])
addpath([baseDirectory filesep 'functions_UnitTested'])
% addpath([baseDirectory filesep 'diagnostics'])
addpath([baseDirectory filesep 'data'])
addpath([baseDirectory filesep 'results'])
addpath([baseDirectory filesep 'scripts'])
% addpath([baseDirectory filesep 'scripts figures'])
% addpath([baseDirectory filesep 'scriptsXXYY'])

%% Check if CVX is downloaded/installed
if size(strfind(path, 'cvx')) < 1
    warning('CVX might not be installed correctly or at all. This code requires CVX to run.');
end
