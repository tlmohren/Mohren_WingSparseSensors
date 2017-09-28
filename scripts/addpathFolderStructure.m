function addpathFolderStructure()
%addpathFolderStructure() Creates folder to store simulation data, adds
%folders to workspace, and checks if CVX is installed 
%   Last updated: 2017/07/03  (TLM)

%% Find location of this script 
    
    scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
    [folderLocation,baseName] = fileparts(scriptLocation);
    dataFolderLocation = [folderLocation, filesep, baseName,'Data'];
    
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
    addpath([scriptLocation filesep 'scripts'])
%     addpath('D:\Mijn_documenten\Dropbox\A. PhD\C. Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow')

%% Check if CVX is downloaded/installed
    if size(strfind(path, 'cvx')) < 1
        warning('CVX might not be installed correctly or at all. This code requires CVX to run.');
    end


end

