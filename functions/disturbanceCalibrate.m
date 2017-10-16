function [meanval,stdev] =  disturbanceCalibrate( distFunc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


if ~strcmp(class(distFunc ),'sym')
   error('disturbanceCalibrate:inputNotSymbolic','input needs to be a symbolic function') 
end

% symvar(distFunc) == t
%     distFunc
t = 0: 0.001: 3.999;
disturbanceSignal = eval(distFunc);
meanval = mean(disturbanceSignal);
stdev = std(disturbanceSignal);
    

end

