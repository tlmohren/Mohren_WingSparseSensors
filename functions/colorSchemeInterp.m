function [Cinterp ] = colorSchemeInterp( colorScheme, nInterp )
% colorSchemeInterp interpolates a colorscheme from e.g. colorbrewer

% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

[nOrig,~] = size(colorScheme);

xOrig = 1:nOrig;
xInterp = linspace(1,nOrig,nInterp);
Cinterp = zeros(nInterp,3);

for j = 1:3
    Cinterp(:,j) = interp1(xOrig, colorScheme(:,j), xInterp);
end

