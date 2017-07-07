% analyze varParList 
clc;clear all;close all
%% 
% par.saveNameParameters = 'elasticNet09';
% par.saveNameParameters = 'elasticNet09_phiCorrect_allSensors';
% par.saveNameParameters = 'elasticNet09_phiAllNFAll_allSensors';
% par.saveNameParameters = 'elasticNet09_phiAllNFAll_Fri_allSensors';
% load(['data', filesep, 'ParameterList_' par.saveNameParameters])


par.saveNameParameters = 'elasticNet09_phiAllNFAll_Fri_allSensors';
load(['data', filesep, 'ParameterList_' par.saveNameParameters])
par.varParNames = fieldnames(varParList);
par.varParNames = fieldnames(varParList);
par.saveNameParameters
par.saveNameParameters = 'elasticNet09_phiAllNFAll_Fri_allSensors'

exp_duplicates = 3;

% dataMatTot = zeros( length(varParList), par.rmodes , par.iter*exp_duplicates);
dataMatTot = zeros( length(varParList) ,par.iter);
% sensorMatTot = zeros( length(varParList), par.rmodes , par.rmodes ,par.iter*exp_duplicates);
%% 
display('loading in datafiles to combine results')
tic 
for j = 1:length(varParList)
%     j
    for k = 1:length(par.varParNames)
        par.(par.varParNames{k}) = varParList(j).(par.varParNames{k});
    end
    
    for j2 = 1326           
        saveNameBase = sprintf(['Data_',par.saveNameParameters, '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
        [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
        par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , j2 ]);      

        nameMatches = dir(['data' filesep saveNameBase '*']);
        if ~isempty(nameMatches)
            for k2 = 1:length(nameMatches)

                tempDat = load( ['data' filesep nameMatches(k2).name] ); 
%                 [q_vec,it] = ind2sub(size(tempDat.DataMat),find(tempDat.DataMat));
                it_success = find(tempDat.DataMat);
%                 n_iters = size(tempDat.DataMat);
                for j3 = it_success
%                     q = q_vec(j3);
                    prev = length(find( dataMatTot(j,:) )  );
%                     dataMatTot(j,q, prev+1) = tempDat.DataMat(q_vec(j3),it(j3)); 
                    dataMatTot(j, prev+1) = tempDat.DataMat(it_success(j3)); 
%                     sensorMatTot(j,q,1:q, prev+1) = tempDat.SensMat(q_vec(j3),1:q_vec(j3),it(j3)); 
                    
                    % check, often 30 sensors found now 
%                     if prev > 100
%                         varParList(j)
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
save(['results' filesep 'dataMatTot_' par.saveNameParameters],'dataMatTot','varParList','varParList','par')
 