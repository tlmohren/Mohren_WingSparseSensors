function [ omega ] = gaussian_perturbation( t,filename )
%gaussian_perturbation   Jared Callaham  6/23/16
% Creates a signal of gaussian perturbations centered at times stored in
% external data file. Uses symbolic variables.
%
% Loads from file:
%   t0 - centers of Gaussian pulses
%   A - amplitudes (in rad)
%   width - width (2xstandard deviation)
%   startup_time - time to throw away in analysis (in seconds)
%
% Outputs:
%   omega - angular velocity at time t (symbolic variable)

load(filename)
A = pulse_amplitude;
width = pulse_width;
t0 = pulse_centers+startup_time;

omega = 0;
for i=1:numel(t0)
%     display(['pulse ' num2str(i)])
    omega = omega + A(i)*exp( -2*(t0(i) - t).^2 ./ width(i)^2);
end

end

