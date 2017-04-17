function [ accuracy ] = SensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest,varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
% % required inputs
% p.addRequired('X');
% p.addRequired('G');
% p.addRequired('r');
% p.addRequired('SSPOC_on');
% p.addParameter('diagnostic', 0, @(x)isnumeric(x));
% p.addParameter('diagnostic_bingnorm', 0, @(x)isnumeric(x));
% p.addParameter('early_cutoff', 0, @(x)isnumeric(x));
% p.addParameter('fulltrain', 0, @(x)isnumeric(x));
% p.KeepUnmatched = true;
% p.parse(X,G,r,SSPOC_on, varargin{:})
% inp = p.Results ;
    
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
accuracy =  sum(cls == Gtest)/numel(cls);


end

