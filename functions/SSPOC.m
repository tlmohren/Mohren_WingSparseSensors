function [s] = SSPOC(Psi, w, varargin)
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
alpha = 0.9;

% define some dimensions
[n, r] = size(Psi); %#ok<ASGLU>
c = size(w, 2);

% solve Psi'*s = w
% using the l1 norm to promote sparsity
% elastic net (combination of L1 and L2 norm) to deal with uniqueness % issues
% unit = ones(c,1);
cvx_begin quiet
    variable s( n, c );
    minimize(   alpha*norm(s,1) + (1-alpha)*norm(s,2) );
    subject to
        Psi'*s == w;
cvx_end
