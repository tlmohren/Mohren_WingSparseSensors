function addpathFolderStructure()
%addpathFolderStructure() Creates folder to store simulation data, adds
%folders to workspace, and checks if CVX is installed 
%   Last updated: 2018/01/16  (TM)

% Find location of this script 
    scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
    cd(scriptLocation );

% Add paths required for main script
    addpath([scriptLocation filesep 'functions'])
    addpath([scriptLocation filesep 'figure_scripts'])
    addpath([scriptLocation filesep 'simulation_scripts'])

%  Check if CVX is downloaded/installed
    if size(strfind(path, 'cvx')) < 1
        warning('CVX might not be installed correctly or at all. This code requires CVX to run.');
    end
end

