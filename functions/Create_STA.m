function [ STA_filt ] = Create_STA( STA_on, varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


p = inputParser;

% % required inputs
p.addRequired('STA_on');
p.addParameter('shift', -10, @(x)isnumeric(x));
p.addParameter('width', 3, @(x)isnumeric(x) && x>=0);
p.addParameter('sta_name', 'exp_STA.mat', @(x)ischar(x) );
p.parse('STA_on', varargin{:});
p.KeepUnmatched = true;
inp = p.Results;

if STA_on == 1
    phi_f = @(t)  2/(sqrt(3*inp.width) *pi^1/4)*( 1-(t-inp.shift).^2/inp.width^2) .* exp( -(t-inp.shift).^2/(2*inp.width^2));
    t = -39:1:0;
    STA_filt = phi_f(t);        % create sta_1kHz 
elseif STA_on == 2
    load(inp.sta_name,'sta_1kHz');  
    STA_filt = sta_1kHz;
else
    STA_filt = ones(40,1);
end

end

