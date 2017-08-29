function [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        for k2 = 1:size(dataStruct.dataMatTot,2)
%             [Dat_I,k2]
            meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(dataMatTot(Dat_I,k2,:)) , dotcol{1})
        end

end

