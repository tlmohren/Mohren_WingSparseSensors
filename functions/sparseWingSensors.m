function [accuracy, sensors] = sparseWingSensors(X,G,par)
%sparseWingSensors Find sparse locations and classification accuracy
%   [accuracy, sensors] = sparseWingSensors(X,G,par) takes data [X] with
%   rows being sensors, and columns being sensor data snapshots in time.
%   [par] specifies things like truncation mode, raddom vs. optimal sensor
%   placement. 

% input

% output
    % sensors = index of optimal sensors
    % accuracy = average fraction of correct prediction by LDA for the set of
    % optimal sensors 
    if par.predictTrain == 1
        [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, par.trainFraction);
    else
        [Xtrain, Xtest, Gtrain, Gtest] = randCrossVal(X, G, par.trainFraction);
    end
%     save('testdata_SensorLocSSPOC_april.mat','Xtrain','Gtrain','par')
    sensors = sensorLocSSPOC(Xtrain,Gtrain,par);

    accuracy = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );

end
