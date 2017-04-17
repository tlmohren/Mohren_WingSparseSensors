function [w, Psi, centroid] = PCA_LDA(X, G,n_w, varargin)
% function [w, Psi, centroid] = PCA_LDA(X, G, varargin)
%
%
% INPUTS:
%
% X         
%           a [n x m] matrix of the raw data, where there are n samples with m
%           measurements each
%
% G     
%           a [1 x m] vector with the group id's of each sample in X; it's
%           nice when they're 0's and 1's, etc.
%
% VARIABLE PARAMETERS
%
% nFeatures 
%           number of features used in the discrimination
%
% OUTPUTS:
%
% w
%           the LDA vectors learned in the classification using nFeatures
%           a [nFeatures x c-1] matrix
%
% Psi
%           the feature basis used in the classification
%
% centroid
%           the centroid of each class in w space
%           a [nFeatures x c] matrix
%           useful for nearest centroid classification
%
% BWB, July 2015

% input parsing
p = inputParser; 

% required inputs
p.addRequired('X', @isnumeric);
p.addRequired('G', @(x)length(x)==size(X,2));

% parameter value iputs
p.addParameter('nFeatures', 10, @(x)isnumeric(x) && x<=size(X,2));

% now parse the inputs
p.parse(X, G, varargin{:});
inputs = p.Results;

classes = unique(G);
c = numel(classes); % number of groups


% compute feature basis Psi
[U, ~, ~] = svd(X, 0);
Psi = U(:, 1:inputs.nFeatures);

a = Psi'*X;

% LDA
w = LDA_n(a, G);

% w_or = w; 
% %alternate things  ----------------------------
% sv = diag(Sigma);
% w_norm = w.*sv(1:length(w));
% [~,Iw ] =sort( abs(w_norm) , 'descend');
% figure();plot(w_norm)

% 
% [~,Iw ] =sort( abs(w) , 'descend');
% % big_modes = Iw(1:n_w);
% 
% %alternate things present 
% Psi = Psi(:,big_modes);
% 
% figure();
%     subplot(311);
% %     plot(w)
%     semilogy( abs(w))
%     
% w = w(big_modes)
%     subplot(312);plot(w)
% a = Psi'*X;

% w = LDA_n(a, G);
    [~,I_temp] = sort(abs(w),'descend');
    subplot(313);plot(w(I_temp))

%alternate things--------------------------







% Psi

Xcls = w' * a;      % Projections onto decision space

% compute centroid of each class in classifier space
centroid = zeros(c-1, c);
for i = 1:c,
    centroid(:,i) = mean(Xcls(:,G==classes(i)), 2);
end;

