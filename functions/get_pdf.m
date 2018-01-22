function [ binar ] = get_pdf(Sloc)
% get_pdf gives out the probability density function for the sensor
% location matrix

% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

n_iters = length( nonzeros( Sloc(1,1,1,:)) );
Sloc_sq= squeeze(Sloc);
binar = zeros(1326*1,1);
for j = 1:n_iters 
    sensors = Sloc_sq(:,j);
    binar(sensors)  = binar(sensors) + 1/n_iters ;
end
