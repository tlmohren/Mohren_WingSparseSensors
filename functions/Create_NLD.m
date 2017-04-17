function [ NLD ] = Create_NLD( NLD_on, shift,sharpness )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Create_NLD(NLD_on, shift,sharpness)
if NLD_on == 0          % determine nonlinear filter 
    NLD = @(s) s;
elseif NLD_on == 1          % determine nonlinear filter         % 
%     sharpness = 8.4234;                                  % sharpness  (horizontal scaling 
%     shift = 0.4813;                                    % shift left or right 

	shift = 0.5;                % with ramp, shift best turned off 
	sharpness= 10; 

    NLD = @(s) 1./(1+exp(-(s-shift)*sharpness));
elseif NLD_on == 2
    shift = 0.5;                % with ramp, shift best turned off 

    NLD = @(s) (s>= shift).*(s-shift);                           % use ramp 
    elseif NLD_on == 3          % determine nonlinear filter         % 
%     sharpness = 8.4234;                                  % sharpness  (horizontal scaling 
%     shift = 0.4813;                                    % shift left or right         % shift left or right 
    
%     shift =0; 
    NLD = @(s) 2./(1+exp(-(s-shift)*sharpness))-1; % double_sided
elseif NLD_on == 4
    NLD = @(s) (s>= shift);                           % use ramp 
    
end

end

