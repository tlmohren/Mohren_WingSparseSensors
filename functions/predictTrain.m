function [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, trainRatio)
% function [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, trainRatio)
% For each class in X as defined by G, that part of X is split into
% training and test. 
% TLM 2017/10/12  

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

