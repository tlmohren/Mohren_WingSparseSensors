function [fixPar,varParCombinationsAll, varParStruct ] = createPar( parameterSetName,figuresToRun,iter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [fixPar,varParCombinationsAll] = setAllParameters(parameterSetName,iter);
    varParIndex = [];
    for j = 1:length(figuresToRun)
         figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , figuresToRun{j} )));
         varParIndex = [ varParIndex, figMatch];
    end
    
    if  isempty(figMatch)
        error('Incorrect simulation entry')
    end
    
    for j = varParIndex
        varParCombinationsAll(j)
       if  ~exist('varParStruct')
           varParStruct = createParList(varParCombinationsAll(j));
       else
           prev_length = length(varParStruct) + 1;
           new_length = length(varParStruct) + length( createParList(varParCombinationsAll(j)) );
           varParStruct( prev_length:new_length )  = createParList( varParCombinationsAll(j) );
       end
    end
        
%     varParCombinations = varParCombinationsAll(varParIndex);
    save( ['data' filesep 'parameterSet_', parameterSetName '.mat'], 'fixPar','varParCombinationsAll','varParStruct')

end

