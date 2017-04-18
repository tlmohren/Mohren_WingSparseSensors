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
        
    [Xtrain, Xtest, Gtrain, Gtest] = rand_cross_val(X, G, par.trainFraction);
%     save('testdata_SensorLocSSPOC_april.mat','Xtrain','Gtrain','par')
    sensors = sensorLocSSPOC(Xtrain,Gtrain,par);

    accuracy = SensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );

end
