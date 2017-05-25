

load(['data' filesep 'testXworking.mat'])
trainRatio = 0.8;
% function [train_data, test_data, Gtrain, Gtest] = rand_cross_val(X, G, per_train)
% Updated: 5/9/2016
% Author: Sam Kinn
% Function that takes a data set to be cross-validated and splits it up 
% randomly into separate training and test sets, such that each class 
% have an equal number to each other in both sets.
%
% INPUTS:
%
% X        
%           the strain direction of interest (i.e., z, x, y, xy)
%
% classes
%           number of classes
%
% per_train
%           ratio of total data set to be used for training, with
%           the remainder being used for testing
%
% OUTPUTS:
%
% train_data
%           training set
%
% test_data
%           test set
%
% num_train
%           length of training set for each class
%
% num_test
%           length of test set for each class

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
    testData = [testData new_test_data];
end
% 
% size(train_data)
% size(test_data)