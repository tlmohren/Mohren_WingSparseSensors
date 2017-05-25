function [trainData, testData, Gtrain, Gtest] = randCrossVal(X, G, trainRatio)
% load(['data' filesep 'testXworking.mat'])
% trainRatio = 0.8;
% Updated: 5/9/2016
% Author: Sam Kinn
% Adjusted: Thomas Mohren 5/23/2017
% Function that takes a data set to be cross-validated and splits it up 
% randomly into separate training and test sets, such that each class 
% have an equal number to each other in both sets.


classes = length(unique(G));
[n, m] = size(X);
trainData = []; 
testData = [];
Gtrain = []; 
Gtest = [];

for j = 1:classes
    classData = X(:, G==j);
    classLength = size(classData,2);
    
    randIndices = randperm(classLength);
    
    trainLength = floor(classLength * trainRatio);
    testLength = classLength - trainLength;
    
    Gtrain = [Gtrain j*ones(1, trainLength)];
    Gtest = [Gtest j*ones(1, testLength)];
    
    addTrainData = classData(:, randIndices( 1:trainLength) );
    addTestData = classData(:, randIndices( trainLength+1:end) );
    
    trainData = [trainData addTrainData];
    testData = [testData addTestData];
end