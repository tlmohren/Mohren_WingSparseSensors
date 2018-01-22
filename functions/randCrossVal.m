function [trainData, testData, Gtrain, Gtest] = randCrossVal(X, G, trainRatio)
% function [trainData, testData, Gtrain, Gtest] = randCrossVal(X, G, trainRatio)
% Function that takes a data set to be cross-validated and splits it up 
% randomly into separate training and test sets, such that each class 
% have an equal number to each other in both sets.
% (original) Sam Kinn: 5/9/2016
% TLM 2017/10/12  
%-----------------------------------------------------------
% required inputs
p = inputParser; 
p.addRequired('X', @isnumeric);
p.addRequired('G', @isnumeric);
p.addRequired('trainRatio', @(x) isnumeric(x) && x>=0 && x<=1 );
p.parse(X, G, trainRatio);
inputs = p.Results;

classes = length(unique(G));
[n, m] = size(X);

if mod(m,2) ~= 0
   error('randCrossVal:XMustBeEven','X must be even.') 
end

if classes <= 1
   error('randCrossVal:GhasLessThanTwoClasses','G has less than two classes.') 
end

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