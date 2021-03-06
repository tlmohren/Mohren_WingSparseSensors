%------------------------------
% run_mainSimulation
% Runs a set of classifications for parameter combinations in figures
% Every 100th combination the results are synced with git 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

clear all, close all, clc
addpathFolderStructure()

figuresToRun        = {'S4'};
iter                = 50;
parameterSetName    = ['S4_vectorExtract' num2str(iter)];

fixPar = createFixParStruct( parameterSetName,iter);
[ varParStruct,simulation_menu ] = createVarParStruct( fixPar, figuresToRun);
save( ['accuracyData' filesep 'parameterSet_', parameterSetName '.mat'], ...
        'fixPar','varParStruct','simulation_menu')

%% Run eulerLagrangeSimulation (optional) and sparse sensor placement algorithm
tic 
for j = 1:length(varParStruct)
    
    varPar = varParStruct(j);
    % Initialize matrices for this particular parameter set----------------
    if varPar.wTrunc <=30
        DataMat = zeros(fixPar.rmodes,fixPar.iter);
        SensMat = zeros(fixPar.rmodes,fixPar.rmodes,fixPar.iter);
        WeightMat = zeros(fixPar.rmodes,fixPar.rmodes,fixPar.iter);
    else 
        DataMat = zeros(1,fixPar.iter);
        SensMat = [];
        WeightMat = [];
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
%             [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);
            [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);

            sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varPar);
            
            
                n =  size(Xtest,1);
                classes = unique(Gtest); 
                c = numel(classes); 
                q = length(sensors);

                Phi = zeros(q, n);                                      % construct the measurement matrix Phi
                for qi = 1:q,
                    Phi(qi, sensors(qi)) = 1;
                end;
                % learn new classifier for sparsely measured data
                w_sspoc= LDA_n(Phi * Xtrain, Gtrain);
                Xcls = w_sspoc' * (Phi * Xtrain);

                % compute centroid of each class in classifier space
                centroid = zeros(c-1, c);
                for i = 1:c, 
                    centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
                end;
                % use sparse sensors to classify X
                cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
                acc =  sum(cls == Gtest)/numel(cls);

            % Store data  ----------------------------
            if varPar.wTrunc <=30
                q = length(sensors);
                prev = length(find( DataMat(q, :) )  );
                DataMat(q, prev+1) = acc; 
                SensMat(q, 1:q,prev+1) = sensors ;    
                WeightMat(q, 1:q,prev+1) = w_sspoc ;    
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
    save(  ['accuracyData',filesep, saveName]  ,'DataMat','SensMat','WeightMat','fixPar','varPar')
    fprintf('Runtime = %g[s], Saved as: %s \n',[toc,saveName]) 
    
% %     Sync to github(git required) once every 100 parameter combinations or if last combination is reached 
    if ~(mod(j, 100)~= 0 && j ~= length(varParStruct))
        system('git pull');
        system('git add accuracyData/*.mat');
        system(sprintf('git commit * -m "pushing data from more runs %i"', j));
        system('git push');
    end;
end
