%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

% fixPar = struct with fixed parameters used throughout the simulation
% varParList = struct(1:5).xxx  contains lists of variable parameters 
% combinationStruct contains all required combinations specified in varParList
% varPar is one combination specified in combinationStruct
%------------------------------

clear all, close all, clc
addpathFolderStructure()

figuresToRun        = {'R4'};
iter                = 10;
parameterSetName    = ['R3R4_Iter' num2str(iter)];


% figuresToRun        = {'R1','R2','R3','R4','S'};
% iter                = 10;
% parameterSetName = 'R1toR4_Iter10_run1';
% parameterSetName = 'R1toR4_Iter5_delay5_eNet09';
% parameterSetName = 'R1R4_Iter5_delay5_eNet09'

% Build struct that specifies all parameter combinations to run 

fixPar = createFixParStruct( parameterSetName,iter);
[ varParStruct,simulation_menu ] = createVarParStruct( fixPar, figuresToRun);
save( ['accuracyData' filesep 'parameterSet_', parameterSetName '.mat'], ...
        'fixPar','varParStruct','simulation_menu')

% varParStruct = varParStruct(45);

%% Run eulerLagrangeSimulation (optional) and sparse sensor placement algorithm
tic 
for j = 1:length(varParStruct)
    
    varPar = varParStruct(j);
    % Initialize matrices for this particular parameter set----------------
    if varPar.wTrunc <=30
        DataMat = zeros(fixPar.rmodes,fixPar.iter);
        SensMat = zeros(fixPar.rmodes,fixPar.rmodes,fixPar.iter);
    else 
        DataMat = zeros(1,fixPar.iter);
        SensMat = [];
    end
    
    
    % Run parameter combination for a set number of iterations ---------
    for k = 1:fixPar.iter
        try
            varPar.curIter = k; 
            % Generate strain with Euler-Lagrange simulation ----------
            strainSet = eulerLagrangeConcatenate( fixPar,varPar);
            % Apply neural filters to strain --------------------------
            [X,G] = neuralEncoding(strainSet, fixPar,varPar );
            % Find accuracy and optimal sensor locations  ---------
            [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);
            % Store data  ----------------------------
            if varPar.wTrunc <=30
                q = length(sensors);
                prev = length(find( DataMat(q, :) )  );
                DataMat(q, prev+1) = acc; 
                SensMat(q, 1:q,prev+1) = sensors ;    
            else 
                q = length(sensors);
                prev = length(find( DataMat(1, :) )  );
                DataMat(1, prev+1) = acc; 
            end
            % Print accuracy in command window --------------------
            fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])
        catch
            fprintf(['W_trunc = %1.0f, gave error \n'],[varPar.wTrunc])
        end
    end
    % save classification accuracy and sensor location in small .mat file
    fillString = 'Data_%s_dT%g_dP%g_sOn%g_STAw%g_STAf%g_NLDs%g_NLDg%g_wT%g_';
    fillCell = {fixPar.saveNameParameters ,varPar.theta_dist , varPar.phi_dist, varPar.SSPOCon , ...
                varPar.STAwidth , varPar.STAfreq , varPar.NLDshift , varPar.NLDgrad , varPar.wTrunc };
            
    saveNameBase = sprintf( fillString,fillCell{:} );
    saveName = [saveNameBase,computer,'_',datestr(datetime('now'), 30),'.mat'];
    save(  ['accuracyData',filesep, saveName]  ,'DataMat','SensMat','fixPar','varPar')
    fprintf('Runtime = %g[s], Saved as: %s \n',[toc,saveName]) 
    
% %     Sync to github(git required) once every 100 parameter combinations or if last combination is reached 
    if ~(mod(j, 100)~= 0 && j ~= length(varParStruct))
        system('git pull');
        system('git add accuracyData/*.mat');
        system(sprintf('git commit * -m "pushing data from more runs %i"', j));
        system('git push');
    end;
end
