function [s] = SSPOC(Psi, w, fixPar)
% function [s] = SSPOC(Psi, w, varargin)
% the elastic net version
% INPUTS:
% Psi
%           feature space
%           for example, from SVD of the original data
%           n by r matrix, n is number of measurements, r is number of
%           features
%
% w
%           subspace in Psi that we want to reconstruct
%           r by c matrix, r must match Psi, c is the number of clusters
%           minus 1 (the dimensionality of the decision space)
% OUTPUTS:
% s
%           sparse vector in space of the data;
%           non-zero entries in s correspond to sparse sensor locations
%
% BWB, June 2015
%   Last updated: 2017/07/03  (TLM)

% value set for elastic net 
alpha = fixPar.elasticNet;

% p = inputParser; 
% 
% % required inputs
% p.addRequired('Psi', @isnumeric);
% p.addRequired('w', @isnumeric);
% 
% % parameter value iputs
% % p.addParameter('lambda', 0, @(x)isnumeric(x) && x>=0);
% % % p.addParameter('epsilon', 1e-10, @(x)isnumeric(x) && x>=0);
% % p.addParameter('epsilon',2.22e-16, @(x)isnumeric(x) && x>=0);
% 
% % now parse the inputs
% p.parse(Psi, w, varargin{:});
% inputs = p.Results;


% define some dimensions
[n, r] = size(Psi); %#ok<ASGLU>
c = size(w, 2);

% solve Psi'*s = w
% using the L1 norm to promote sparsity
% elastic net (combination of L1 and L2 norm) to deal with uniqueness issue

cvx_begin quiet
    variable s( n, c );
    minimize(   alpha*norm(s,1) + (1-alpha)*norm(s,2) );
    subject to
        Psi'*s == w;
cvx_end
