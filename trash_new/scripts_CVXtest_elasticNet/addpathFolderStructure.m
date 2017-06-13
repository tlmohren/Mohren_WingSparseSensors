function addpathFolderStructure()
%addpathFolderStructure() Summary of this function goes here
%   Detailed explanation goes here
% link_folder_SSPOC.m
% Last updated: 2017/4/06  (edit by Thomas Mohren)
% Author: Sam Kinn
% Script finds it's own location and adds necessary folders to workpath.
% Also checks if CVX is installed

%% Find location of this script 
%     scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
%     cd(scriptLocation );
    
    scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
    [folderLocation,baseName] = fileparts(scriptLocation);
    dataFolderLocation = [folderLocation filesep baseName,'Data'];
    if ~exist(dataFolderLocation)
        display('Data folder does not exist yet')
        display(dataFolderLocation)
        
        % ask permission to create folder
        prompt = 'Permission to create folder [y/n]: ';
        if input( prompt,'s') ==  'y'
            mkdir(folderLocation , [baseName,'Data'])
            display('created folder')
        end
    else
        display('dataFolder exists')
    end
    
    cd(scriptLocation );
    

%% Add paths required for main script
    addpath([scriptLocation filesep 'functions'])
    addpath([scriptLocation filesep 'results'])
    addpath([scriptLocation filesep 'scripts'])

%% Check if CVX is downloaded/installed
    if size(strfind(path, 'cvx')) < 1
        warning('CVX might not be installed correctly or at all. This code requires CVX to run.');
    end


end

