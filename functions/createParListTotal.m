function [fixPar,varParCombinationsAll, varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [fixPar,varParCombinationsAll] = createParSet(parameterSetName,iter)
    varParIndex = [];
    {varParCombinationsAll.resultName} 
     figuresToRun{1} 
    for j = 1:length(figuresToRun)
         figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , figuresToRun{j} )));
         varParIndex = [ varParIndex, figMatch];
    end
    
    if  isempty(figMatch)
        error('Incorrect simulation entry')
    end
    
    for j = varParIndex
% % % % %         varParCombinationsAll(j)
       if  ~exist('varParStruct')
           varParStruct = createParListSingle(varParCombinationsAll(j));
       else
           prev_length = length(varParStruct) + 1;
           new_length = length(varParStruct) + length( createParListSingle(varParCombinationsAll(j)) );
           varParStruct( prev_length:new_length )  = createParListSingle( varParCombinationsAll(j) );
       end
    end
        
%     varParCombinations = varParCombinationsAll(varParIndex);
    save( ['accuracyData' filesep 'parameterSet_', parameterSetName '.mat'], 'fixPar','varParCombinationsAll','varParStruct')

end

