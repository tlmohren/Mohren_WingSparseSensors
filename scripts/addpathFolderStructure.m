function addpathFolderStructure()
%addpathFolderStructure() Creates folder to store simulation data, adds
%folders to workspace, and checks if CVX is installed 
%   Last updated: 2017/07/03  (TLM)

% Find location of this script 
    
    scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
    cd(scriptLocation );

% Add paths required for main script
    addpath([scriptLocation filesep 'functions'])
    addpath([scriptLocation filesep 'scripts'])

%  Check if CVX is downloaded/installed
    if size(strfind(path, 'cvx')) < 1
        warning('CVX might not be installed correctly or at all. This code requires CVX to run.');
    end


end

