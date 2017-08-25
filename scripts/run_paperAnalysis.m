%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)
%------------------------------
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry throughout simulation

par = setParameters;
par.elasticNetList = [0.9];
[varParList,~] = setVariableParameters_MultipleSets(par);
par.varParNames = fieldnames(varParList);
par.iter = 10;
% par.elasticNet = 0.9;
par.saveNameParameters = 'STANLD_expDerived_Iter10';

% Save parameter list, necessary for assembling .mat files in figure making
save( ['data' filesep 'ParameterList_', par.saveNameParameters '.mat'], 'varParList', 'par')

%% Run eulerLagrangeSimulation (optional) and sparse sensor placement algorithm

tic 
for j = 1:length(varParList)
    % Initialize matrices for this particular parameter set----------------
    DataMat = zeros(par.rmodes,par.iter);
    SensMat = zeros(par.rmodes,par.rmodes,par.iter);
    
    % Redefine parameter combination in parameter structure (par) ---------
    for k = 1:length(par.varParNames)
        par.(par.varParNames{k}) = varParList(j).(par.varParNames{k});
    end
    
    % Run parameter combination for a set number of iterations ---------
    for k = 1:par.iter
        try 
            par.curIter = k; 
            % Generate strain with Euler-Lagrange simulation ----------
            strainSet = eulerLagrangeConcatenate_predictTrain( varParList(j).theta_dist , varParList(j).phi_dist ,par);

            % Apply neural filters to strain --------------------------
            [X,G] = neuralEncodingNewFilters(strainSet, par );

            % Find accuracy and optimal sensor locations  ---------
            [acc,sensors ] = sparseWingSensors( X,G, par);

            % Store data in 3D matrix ----------------------------
            q = length(sensors);
            prev = length(find( DataMat(q, :) )  );
            DataMat(q, prev+1) = acc; 
            SensMat(q, 1:q,prev+1) = sensors ;    

            % Print accuracy in command window --------------------
            fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])
        catch
            fprintf(['W_trunc = %1.0f, gave error \n'],[par.wTrunc])
        end
    end

    % save classification accuracy and sensor location in small .mat file
    saveNameBase = sprintf(['Data_',par.saveNameParameters, '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
                        [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
                        par.STAwidth , par.STAfreq , par.NLDshift , par.NLDgrad , par.wTrunc ]);      
    saveName = [saveNameBase,computer,'_',datestr(datetime('now'), 30),'.mat'];
    save(  ['data',filesep, saveName]  ,'DataMat','SensMat','par')
    fprintf('Runtime = %g[s], Saved as: %s \n',[toc,saveName]) 
    
    % Sync to github(git required) once every 100 parameter combinations or if last combination is reached 
    if ~(mod(j, 100)~= 0 && j ~= length(varParList))
        system('git pull');
        system('git add data/*.mat');
        system(sprintf('git commit * -m "pushing data from more runs %i"', j));
        system('git push');
    end;
end
