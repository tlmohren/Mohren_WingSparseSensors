function [accuracy, sensors] = sparseWingSensors(X,G,fixPar,varPar)
%[accuracy, sensors] = sparseWingSensors(X,G,par)
%    takes data [X] with rows being sensors, and columns being sensor data snapshots in time.
%   [par] specifies things like truncation mode, raddom vs. optimal sensor
%   placement. 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2017/07/03  (TLM)
%------------------------------
% output
    % sensors = index of optimal sensors
    % accuracy = average fraction of correct prediction by LDA for the set of
    % optimal sensors 
    
%     if fixPar.predictTrain == 1
%         [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
%     else
%         [Xtrain, Xtest, Gtrain, Gtest] = randCrossVal(X, G, fixPar.trainFraction);
%     end
    
    
    [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
    
    sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varPar);

    accuracy = sensorLocClassifySTD(  sensors,Xtrain,Gtrain,Xtest,Gtest );

end
