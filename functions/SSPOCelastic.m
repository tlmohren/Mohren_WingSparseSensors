function [s] = SSPOCelastic(Psi, w, varargin)
% function [s] = SSPOCelastic(Psi, w, varargin)
% the elastic net version of SSPOC, for 2 classes only! 

% INPUTS:
% Psi
%           feature space
%           for example, from SVD of the original data
%           n by r matrix, n is number of measurements, r is number of
%           features
%
% w
%           subspace in Psi that we want to reconstruct
%           vector length = r, r must match features in Psi
% alpha
%           ratio between L1 and L2 in elastic net (default is 1, fully L1
%           norm)

% OUTPUTS:
% s
%           sparse vector in space of the data;
%           non-zero entries in s correspond to sparse sensor locations
%
% orignal: BWB, June 2015
% TLM 2017/10/12  

% required inputs
p = inputParser; 
p.addRequired('Psi', @isnumeric);
p.addRequired('w', @isnumeric);
p.addParameter('alpha', 1, @(x)isscalar(x) && x>=0 && x<=1);
p.parse(Psi, w, varargin{:});
inputs = p.Results;

% determine n sensors in Psi vector 
[n, r] = size(Psi); %
[r_w, c] = size(w); %
if r ~= r_w 
   error('SSPOCelastic:DimensionPsiMismatchR','number of modes in Psi do not match length of R.') 
end

% solve Psi'*s = w
% using the L1 norm to promote sparsity
% elastic net (combination of L1 and L2 norm) to deal with uniqueness issue
cvx_begin quiet
    variable s( n );
    minimize(   inputs.alpha*norm(s,1) + (1-inputs.alpha)*norm(s,2) );
    subject to
        Psi'*s == w;
cvx_end