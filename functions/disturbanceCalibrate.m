function [meanval,stdev] =  disturbanceCalibrate( distFunc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%     distFunc
    t = 0: 0.001: 3.999;
    disturbanceSignal = eval(distFunc);
    meanval = mean(disturbanceSignal);
    stdev = std(disturbanceSignal);
    

end

