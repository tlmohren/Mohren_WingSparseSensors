function [train_data, test_data, Gtrain, Gtest] = rand_cross_val(X, G, per_train)
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
train_data = []; test_data = [];
Gtrain = []; Gtest = [];

for i = 1:classes
    class_data = X(:, G==i);
    class_size = length(find(G==i));
    p = randperm(class_size);
    train_size = floor(class_size * per_train);
    test_size = class_size - train_size;
    Gtrain = [Gtrain i*ones(1, train_size)];
    Gtest = [Gtest i*ones(1, test_size)];
    new_train_data = zeros(n, train_size);
    new_test_data = zeros(n, test_size);
    
    for j = 1:train_size
        new_train_data(:,j) = class_data(:, p(j));
    end
    
    for j = 1:test_size
        new_test_data(:,j) = class_data(:,p(j+train_size));
    end
    
    train_data = [train_data new_train_data];
    test_data = [test_data new_test_data];
end

end