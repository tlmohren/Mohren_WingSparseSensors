%------------------------------
% combine_DataFolderToDataMat
%
% creates .mat file with a matrix of accuracies for different parameters
% and a matrix for different sensor locations. It extracts this from the
% numerous files stored in ['data' filesep 'Data_' par.saveNameParameters];
%
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)
%------------------------------



clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()


% par.saveNameParameters =  'elasticNet09_Fri';
par.saveNameParameters =  'elasticNet09_Week';
load(['data', filesep, 'ParameterList_' par.saveNameParameters])
par.varParNames = fieldnames(varParList_short);

par.saveNameParameters

par.saveNameParameters =  'elasticNet09_Week';


exp_duplicates = 3;
dataMatTot = zeros( length(varParList_short), par.rmodes , par.iter*exp_duplicates);
sensorMatTot = zeros( length(varParList_short), par.rmodes , par.rmodes ,par.iter*exp_duplicates);
%% 
display('loading in datafiles to combine results')
tic 

R2_list = 1:32;

for j = 1:length(varParList_short)
%     j
    for k = 1:length(par.varParNames)
        par.(par.varParNames{k}) = varParList_short(j).(par.varParNames{k});
    end
    
%     if j = any(R2_list == 1)
%         
%     end
        
    
    for j2 = 1:par.rmodes            
        saveNameBase = sprintf(['Data_',par.saveNameParameters, '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
        [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
        par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , j2 ]);      

        nameMatches = dir(['data' filesep saveNameBase '*']);
        if ~isempty(nameMatches)
            for k2 = 1:length(nameMatches)


                
                
                tempDat = load( ['data' filesep nameMatches(k2).name] ); 
                
                    if  any(R2_list == j)
%                         
                    end
                
                
                
                [q_vec,it] = ind2sub(size(tempDat.DataMat),find(tempDat.DataMat));
                
                for j3 = 1:length(q_vec)
                    q = q_vec(j3);
                    prev = length(find( dataMatTot(j,q,:) )  );
                    dataMatTot(j,q, prev+1) = tempDat.DataMat(q_vec(j3),it(j3)); 
                    sensorMatTot(j,q,1:q, prev+1) = tempDat.SensMat(q_vec(j3),1:q_vec(j3),it(j3)); 
                    
                    % check, often 30 sensors found now 
%                     if prev > 100
%                         varParList_short(j)
% %                         q
%                     end 
                    
                end
                
            end
        end
    end
end

%% save datamattot
display(['Saving results as: results' filesep  'dataMatTot_',par.saveNameParameters])
toc
save(['results' filesep 'dataMatTot_' par.saveNameParameters],'dataMatTot','sensorMatTot','varParList','varParList_short','par')
 