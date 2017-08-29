function [ dataStruct ] = combineDataMatSTAtest( par)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    m = length(par.wTruncList);
    n = prod(structfun(@length,par)) / length(par.wTruncList);

    par.iter = 10;
    if par.allSensors == 0
        dataMatTot = zeros( n , m , par.iter);
        if par.sensorMatOn == 1
            sensorMatTot = zeros( n , m , m ,par.iter);
        else
            sensorMatTot = [];
        end
    elseif par.allSensors == 1
        dataMatTot = zeros( n , par.iter);
        sensorMatTot = [];
    end
    paramStruct  = createParamStructSTAtest( par );
                                            
    par.varParNames = fieldnames(paramStruct);
   for j1 = 1:length(paramStruct);         
        for k = 1:length(par.varParNames)
            par.(par.varParNames{k}) =paramStruct(j1).(par.varParNames{k});
        end
        if par.allSensors == 0
           for j2 = 1:length(par.wTruncList)
                wTrunc = par.wTruncList(j2);

                saveNameBase = sprintf(['Data_',par.naming{1}, '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_wT%g_del%g_'],...
                [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
                par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , wTrunc, par.elasticNet,par.STAdelay]);

                nameMatches = dir(['data' filesep saveNameBase '*'])
                if ~isempty(nameMatches)
                    for k2 = 1:length(nameMatches)
                        tempDat = load( ['data' filesep nameMatches(k2).name] ); 
                        [q_vec,it] = ind2sub(size(tempDat.DataMat),find(tempDat.DataMat));
                        for k3 = 1:length(q_vec)
                            q = q_vec(k3);
                            prev = length(find( dataMatTot(j1,q,:) )  );
                            dataMatTot(j1,q, prev+1) = tempDat.DataMat(q_vec(k3),it(k3)); 
                            
                            if par.sensorMatOn == 1
                                sensorMatTot(j1,q,1:q, prev+1) = tempDat.SensMat(q_vec(k3),1:q_vec(k3),it(k3)); 
                       
                            end
                        end
                    end
                end
           end
        elseif par.allSensors == 1
            saveNameBase = sprintf(['Data_',par.naming{1}, '_allSensors_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
            [par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
            par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , 1326]);
            nameMatches = dir(['data' filesep saveNameBase '*']);
            if ~isempty(nameMatches);
                for k2 = 1:length(nameMatches)
                    tempDat = load( ['data' filesep nameMatches(k2).name] ); 
                    [q_vec,it] = ind2sub(size(tempDat.DataMat),find(tempDat.DataMat));
                    for k3 = 1:length(q_vec)
                        prev = length(find( dataMatTot(j1,:) )  );
                        dataMatTot(j1, prev+1) = tempDat.DataMat(it(k3)); 
                    end 
                end
            end
        end
    end
    dataStruct.dataMatTot = dataMatTot;
    dataStruct.sensorMatTot = sensorMatTot;
    dataStruct.paramStruct = paramStruct;

end

