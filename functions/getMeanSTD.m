function [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct )
% getMeanSTD provides the mean and std from the nonzero entries in the
% dataStruct

% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
%   Detailed explanation goes here
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
end

