
% name fixer 
clc;clear all;close all
% par.oldname =  'elasticNet09_Week';
par.oldname = 'elasticNet09_10iters';
load(['data', filesep, 'ParameterList_' par.oldname])

% 
% oldname =  'elasticNet09_Week';
oldname = '10iters';
%  newNameFri = '3iters';


% par.varParNames = fieldnames(varParList_short);
saveNameBase = sprintf(['Data_', oldname, '_']);      
nameMatches = dir(['data' filesep saveNameBase '*']);
%% 
counter = 0;
for j = 1:length(nameMatches);
    clear temp
    temp = load(['data', filesep, nameMatches(j).name]);
    load(['data', filesep, nameMatches(j).name]);
    [token,remain] = strtok(nameMatches(j).name,'x');
     token(end-1)
    if token(end-1)== '2'
        
%        display('yes')
    else token(end-1)== '1'
        counter = counter + 1
        oldTotalName = nameMatches(j).name;
        newTotalName = [token(1:end-1), '2_', remain];
        
        save_string = fieldnames(temp);
        save(['data', filesep,newTotalName], save_string{:})
        
        delete(['data', filesep,oldTotalName ] )
    
    end
    
    
%     if remain(1:4) == 'Week'
%         newTotalName = ['data', filesep, 'Data_', newNameWeek, remain(5:end)];
%     elseif remain(1:3) == 'Fri'
%         newTotalName = ['data', filesep, 'Data_', newNameFri, remain(5:end)];
%     end
    
end


%% 
% Test1 = load(['data', filesep,newTotalName])
% Test2 = load(['data', filesep, nameMatches(j).name])