function [ strainSet ] = eulerLagrangeConcatenate(fixPar,varPar)
%[ strainSet ] = eulerLagrangeConcatenate_predictTrain(th,ph,par)
%   Simulates flat plate using eulerLagrange
%   input: th = disturbance level around rotating axis [rad/s]
%   input: ph = disturbance level around flapping axis [rad/s]
%   input: par = parameter set, used to set simulation parameters 
%   output: strainSet = structure containing strain for two cases: 
%    1) flapping, 2) flapping & rotating
%   Last updated: 2017/07/03  (TLM)


% define name for simdata with these parameters 
%     simName = sprintf('strainSet_th%gph%git%gcEl%2.0fsEl%2.0fEx%1.0fEy%1.0f.mat',...
%         [ varPar.theta_dist,varPar.phi_dist,varPar.curIter,...
%         fixPar.chordElements,fixPar.spanElements,...
%         fixPar.xInclude,fixPar.yInclude]);
    
    simName = sprintf('strainSet_th%gph%git%gharm%g.mat',...
        [ varPar.theta_dist,varPar.phi_dist,...
        varPar.curIter, fixPar.harmonic]);

% find location where data is stored 
    [dataDirectory,baseName] = fileparts(pwd);
    simLocation = [dataDirectory filesep baseName,'Data'];
    simLocationName = [simLocation filesep simName];

    if (fixPar.runSim == 0) && (exist(simLocationName,'file')==2) 
        % if exists and par.runSim says to load instead of run simulation
        strainSet = load(simLocationName);
        fprintf(['Loaded simData: ', simName,'..  ']); 
    else
        % Run simulations for the given parameters 
        fprintf(['Running simulations for: ' simName '\n']); 
%         
        strain_0 = eulerLagrange( 0, varPar.phi_dist, varPar.phi_dist ,fixPar);
        strain_10 = eulerLagrange( 10, varPar.phi_dist, varPar.phi_dist ,fixPar);
        strainSet.strain_0 = strain_0;
        strainSet.strain_10 = strain_10;
        
        fprintf(['Completed simulations for: ' simName '\n']); 
        
        if (fixPar.saveSim == 1)
            % save eulerLagrange results
            save(simLocationName,'strain_0','strain_10')
            fprintf(['saved simulations for: ' simName '\n']); 
        end
    end
    
% % %     % (optional, not used) set base sensors strain to zero (useful if clamping effect gives weird results)
% % %     if fixPar.baseZero == 1
% % %         display('did this')
% % %        strainSet.strain_0(1:fixPar.chordElements,:)= 0;  
% % %        strainSet.strain_10(1:fixPar.chordElements,:)= 0;  
% % %     end
    
end
