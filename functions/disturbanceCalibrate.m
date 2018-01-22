function [meanval,stdev] =  disturbanceCalibrate( distFunc )
% disturbanceCalibrate evaluates the disturbance function and gives back
% the mean and std 

% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

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

