%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry throughout simulation

par = setParameters;
[varParList,varParList_short] = setVariableParameters_CVXtestscript(par);
par.varParNames = fieldnames(varParList);
par.iter = 3;

%% Run simulation and Sparse sensor placement for combinations of 4 parameters, over a set number of iterations

tic 
for j = 1:length(varParList)
    try
        % adjust parameters for this set of iterations----------------------
        DataMat = zeros(par.rmodes,par.iter);
        SensMat = zeros(par.rmodes,par.rmodes,par.iter);
        for k = 1:length(par.varParNames)
            par.(par.varParNames{k}) = varParList(j).(par.varParNames{k});
        end
        for k = 1:par.iter
            % Generate strain with Euler-Lagrange simulation ----------
            strainSet = eulerLagrangeConcatenate( varParList(j).theta_dist , varParList(j).phi_dist ,par);
            % Apply neural filters to strain --------------------------
            [X,G] = neuralEncoding(strainSet, par );
            % Find accuracy and optimal sensor locations  ---------
            [Xtrain, Xtest, Gtrain, Gtest] = rand_cross_val(X, G, par.trainFraction);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            sensors = sensorLocSSPOC(Xtrain,Gtrain,par);
            
%             sensors = 
            acc = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
            
%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %         Store data in 3D matrix ----------------------------
            q = length(sensors);
            prev = length(find( DataMat(q, :) )  );
            DataMat(q, prev+1) = acc; 
            SensMat(q, 1:q,prev+1) = sensors ;    
            % Print accuracy in command window --------------------
            fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])
        end
        % save data 

                        
                        
        saveName = sprintf('Data_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_',...
                            [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
                            par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , par.wTrunc ]); 

                    
        saveName = [saveName,computer,'_',datestr(datetime('now'), 30),'.mat'];
        save(  ['data',filesep, saveName]  ,'DataMat','SensMat','par')
        fprintf('Runtime = %g[s], Saved as: %s \n',[toc,saveName]) 
    catch
        fprintf('Run %i failed\n', j); 
    end
end
%%
system('git pull');
system('git add data/*.mat');
system(sprintf('git commit * -m "pushing data from more runs %i"', j));
system('git push');

save( ['data' filesep 'ParameterList_CVXtestscript.mat'], 'varParList','varParList_short', 'par')