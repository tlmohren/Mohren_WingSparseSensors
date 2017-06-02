function [unitDisturbance ] = whiteNoiseDisturbance( par )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    syms t 
    freqs = rand(par.nFreq,1)* (par.freqEnd-par.freq0) + par.freq0;
    phase = rand(par.nFreq,1)*2*pi;
    ph_d = 0;
    for j = 1:length(freqs)
        ph_d = ph_d + sin( 2*pi*t*freqs(j) + phase(j) );
    end
    [meanval,stdval] = disturbanceCalibrate(ph_d);
    
    unitDisturbance = (ph_d-meanval)/stdval;        % 2 is correction factor to achieve right std
end

