function [ strainSet ] = eulerLagrangeConcatenate(fixPar,varPar)
%[ strainSet ] = eulerLagrangeConcatenate_predictTrain(th,ph,par)
%   Simulates flat plate using eulerLagrange
%   input: th = disturbance level around rotating axis [rad/s]
%   input: ph = disturbance level around flapping axis [rad/s]
%   input: par = parameter set, used to set simulation parameters 
%   output: strainSet = structure containing strain for two cases: 
%    1) flapping, 2) flapping & rotating
%   Last updated: 2017/07/03  (TLM)

    simName = sprintf('strainSet_th%gph%git%gharm%g.mat',...
        [ varPar.theta_dist,varPar.phi_dist,...
        varPar.curIter, fixPar.harmonic]);

% find location where data is stored 
%     [dataDirectory,baseName] = fileparts(pwd);
%     simLocation = [dataDirectory filesep baseName,'Data'];
    simLocationName = ['eulerLagrangeData' filesep simName];

    if (fixPar.runSim == 0) && (exist(simLocationName,'file')==2) 
        % if exists and par.runSim says to load instead of run simulation
        strainSet = load(simLocationName);
        fprintf(['Loaded simData: ', simName,'..  ']); 
    else
        % Run simulations for the given parameters 
        fprintf(['Running simulations for: ' simName '\n']); 

        strainSet.strain_0 = eulerLagrange( 0, varPar.theta_dist, varPar.phi_dist ,fixPar);
        strainSet.strain_10 = eulerLagrange( 10, varPar.theta_dist, varPar.phi_dist ,fixPar);
        
        fprintf(['Completed simulations for: ' simName '\n']); 
        
        if (fixPar.saveSim == 1)
            save(simLocationName,'-struct','strainSet','strain_0','strain_10');
            fprintf(['saved simulations for: ' simName '\n']); 
        end
    end
    
end
