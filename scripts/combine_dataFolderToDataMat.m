% analyze varParList 
clc;clear all;close all
%% 
% par.saveNameParameters = 'elasticNet09'; %phiCorrect still to run 
par.saveNameParameters = 'elasticNet09_phiAll';
% par.saveNameParameters = 'elasticNet09_phiCorrect';
load(['data', filesep, 'ParameterList_' par.saveNameParameters])
par.varParNames = fieldnames(varParList_short);

exp_duplicates = 3;
dataMatTot = zeros( length(varParList_short), par.rmodes , par.iter*exp_duplicates);
sensorMatTot = zeros( length(varParList_short), par.rmodes , par.rmodes ,par.iter*exp_duplicates);
%% 
display('loading in datafiles to combine results')
tic 
for j = 1:length(varParList_short)
%     j
    for k = 1:length(par.varParNames)
        par.(par.varParNames{k}) = varParList_short(j).(par.varParNames{k});
    end
    
    for j2 = 1:par.rmodes            
        saveNameBase = sprintf(['Data_',par.saveNameParameters, '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
        [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
        par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , j2 ]);      

        nameMatches = dir(['data' filesep saveNameBase '*']);
        if ~isempty(nameMatches)
            for k2 = 1:length(nameMatches)

                tempDat = load( ['data' filesep nameMatches(k2).name] ); 
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
 