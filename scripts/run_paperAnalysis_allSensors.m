%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
clear all, close all, clc
addpathFolderStructure()

% addpath('C:\Users\Thomas\AppData\Local\GitHub\PortableGit_f02737a78695063deace08e96d5042710d3e32db\cmd')
%%  Build struct with parameters to carry throughout simulation

par = setParameters;
varParList = setVariableParameters_allSensors(par);
par.varParNames = fieldnames(varParList);
par.iter = 10;
par.wTrunc = 1326;
par.predictTrain = 1;
par.elasticNet = 0.9;
par.saveNameParameters = 'elasticNet09_Fri_allSensors';

save(  ['data',filesep, 'ParameterList_', par.saveNameParameters '.mat']  ,'par','varParList')
%% Run simulation and Sparse sensor placement for combinations of 4 parameters, over a set number of iterations

tic 
for j = 1:length(varParList)
        % adjust parameters for this set of iterations----------------------
        DataMat = zeros(1,par.iter);
%         SensMat = zeros(par.rmodes,par.rmodes,par.iter);

        for k = 1:length(par.varParNames)
            par.(par.varParNames{k}) = varParList(j).(par.varParNames{k});
        end

        for k = 1:par.iter
%              try
                par.curIter = k; 
                % Generate strain with Euler-Lagrange simulation ----------
    %             strainSet = eulerLagrangeConcatenate( varParList(j).theta_dist , varParList(j).phi_dist ,par);
                strainSet = eulerLagrangeConcatenate_predictTrain( varParList(j).theta_dist , varParList(j).phi_dist ,par);

                % Apply neural filters to strain --------------------------
                [X,G] = neuralEncoding(strainSet, par );

                % Find accuracy and optimal sensor locations  ---------
                [acc,sensors ] = sparseWingSensors( X,G, par);

        %         Store data in 3D matrix ----------------------------
                q = length(sensors);
                prev = length(find( DataMat(1, :) )  );
                DataMat(1, prev+1) = acc; 
%                 SensMat(q, 1:q,prev+1) = sensors ;    

                % Print accuracy in command window --------------------
                fprintf('All sensors, giving accuracy =%4.2f \n',[acc])        
%             catch
%                 fprintf(['W_trunc = %1.0f, gave error \n'],[par.wTrunc])
%             end
        end

        % save data 
    saveNameBase = sprintf(['Data_',par.saveNameParameters, '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
                        [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
                        par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , par.wTrunc ]);      
    saveName = [saveNameBase,computer,'_',datestr(datetime('now'), 30),'.mat'];
    save(  ['data',filesep, saveName]  ,'DataMat','par')
    fprintf('Runtime = %g[s], Saved as: %s \n',[toc,saveName]) 
    
    if ~(mod(j, 10)~= 0 && j ~= length(varParList))
        system('git pull');
        system('git add data/*.mat');
        system(sprintf('git commit * -m "pushing data from more runs %i"', j));
        system('git push');
    end;
end
%%

