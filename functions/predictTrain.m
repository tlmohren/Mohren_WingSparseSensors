function [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, trainRatio)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    Xtrain = []; 
    Xtest = [];
    Gtrain = []; 
    Gtest = [];

    for j = 1:length(unique(G)) % 2 classes 
        classData = X(:, G==j);
        classLength = size(classData,2);
        trainLength = floor(classLength *  trainRatio);
        testLength = classLength - trainLength;
        
        trainIndices = 1:trainLength;
        testIndices = (trainLength+1):classLength;
%             
        addTrainG = G( trainIndices + (j-1)*classLength);
        addTestG = G(testIndices+ (j-1)*classLength);
        Gtrain = [Gtrain addTrainG];
        Gtest = [Gtest addTestG];

        addTrainData = classData(:, trainIndices  );
        addTestData = classData(:,testIndices);
        Xtrain = [Xtrain addTrainData];
        Xtest = [Xtest addTestData];
    end
end

