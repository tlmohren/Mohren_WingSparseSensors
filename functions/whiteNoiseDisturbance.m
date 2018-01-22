function [unitDisturbance ] = whiteNoiseDisturbance( par )
% whiteNoiseDisturbance creates band-limited white noise function of
% specified limits and number of frequencies
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
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

