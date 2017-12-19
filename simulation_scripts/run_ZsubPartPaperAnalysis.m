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
% To Do:
% createFilt as a function
% clean up code 




clear all, close all, clc
addpathFolderStructure()

% parameterSetName    = 'R1toR4Iter10_delay4';
% parameterSetName    = 'subPartPaperR1Iter5_delay4';

% parameterSetName    = 'subPartPaperR1Iter3_delay5_singValsMult1_eNet085_real';
parameterSetName    = 'subPartPaperR1_try';

iter                = 3;
figuresToRun        = {'subSetTest'};
% select any from {'R2A','R2B','R2C','R3','R4','R2allSensorsnoFilt','R2allSensorsFilt} 

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );

% fixPar.elasticNet = 0.99;
fixPar.subPart = 1;
% fixPar.sThreshold = 1;
% fixPar.sThreshold = @(wTrunc) fixPar.rmodes/wTrunc;
% varParStruct = varParStruct(45);
% % aa.par
% % % varParStruct = varParStruct(1);
%% Run eulerLagrangeSimulation (optional) and sparse sensor placement algorithm
tic 
parfor j = 1:length(varParStruct)
    
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
%         try
            varPar.curIter = k; 
            % Generate strain with Euler-Lagrange simulation ----------
            strainSet = eulerLagrangeConcatenate( fixPar,varPar);
            % Apply neural filters to strain --------------------------
            [X,G] = neuralEncoding(strainSet, fixPar,varPar );
            % Find accuracy and optimal sensor locations  ---------
            [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);
            % Store data in 3D matrix ----------------------------
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
%         catch
%             fprintf(['W_trunc = %1.0f, gave error \n'],[varPar.wTrunc])
%         end
    end
%     % save classification accuracy and sensor location in small .mat file
%     fillString = 'Data_%s_dT%g_dP%g_sOn%g_STAw%g_STAf%g_NLDs%g_NLDg%g_wT%g_';
%     fillCell = {fixPar.saveNameParameters ,varPar.theta_dist , varPar.phi_dist, varPar.SSPOCon , ...
%                 varPar.STAwidth , varPar.STAfreq , varPar.NLDshift , varPar.NLDgrad , varPar.wTrunc };
%             
%     saveNameBase = sprintf( fillString,fillCell{:} );
%     saveName = [saveNameBase,computer,'_',datestr(datetime('now'), 30),'.mat'];
%     save(  ['accuracyData',filesep, saveName]  ,'DataMat','SensMat','fixPar','varPar')
%     fprintf('Runtime = %g[s], Saved as: %s \n',[toc,saveName]) 
    
    % Sync to github(git required) once every 100 parameter combinations or if last combination is reached 
%     if ~(mod(j, 100)~= 0 && j ~= length(varParStruct))
%         system('git pull');
%         system('git add data/*.mat');
%         system(sprintf('git commit * -m "pushing data from more runs %i"', j));
%         system('git push');
%     end;
end
toc