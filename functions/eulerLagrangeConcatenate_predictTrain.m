function [ strainSet ] = eulerLagrangeConcatenate_predictTrain(th,ph,par)
%eulerLagrangeConcatenate Simulates and concatenates strain data
%   strain = eulerLagrangeConcatenate() runs simulation eulerLagrange for
%   two different conditions, 1) flapping, 2) flapping & rotating. The
%   strain from these two cases is concatenated into a large matrix.
%   TLM 2017

% define name for simdata with these parameters 
    simName = sprintf('strainSet_th%gph%git%gcEl%2.0fsEl%2.0fEx%1.0fEy%1.0f.mat',...
        [th,ph,par.curIter,par.chordElements,par.spanElements,par.xInclude,par.yInclude]);

% find location where data is stored 
    [dataDirectory,baseName] = fileparts(pwd);
    simLocation = [dataDirectory filesep baseName,'Data'];
    simLocationName = [simLocation filesep simName];

    if (par.runSim == 0) && (exist(simLocationName,'file')==2) 
        % if exists and don't run: load data
            strainSet = load(simLocationName);
            fprintf(['Loaded simData: ', simName,'..  ']); 
    else
        % Run simulations for the given parameters 
        fprintf(['Running simulations for: ' simName '\n']); 
        strain_0 = eulerLagrange(0,ph,th ,par);
        strain_10 = eulerLagrange(10,ph,th ,par);
        strainSet.strain_0 = strain_0;
        strainSet.strain_10 = strain_10;
        fprintf(['Completed simulations for: ' simName '\n']); 
        
        if (par.saveSim == 1)
            % save if you want to
            save(simLocationName,'strain_0','strain_10')
            fprintf(['saved simulations for: ' simName '\n']); 
        end
    end
    
    % set first row to zero of strain, does not work? 
    if par.baseZero == 1
        display('did this')
       strainSet.strain_0(1:par.chordElements,:)= 0;  
       strainSet.strain_10(1:par.chordElements,:)= 0;  
    end
    
    
end

