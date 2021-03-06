function [ dataStruct,paramStruct ] = combineDataMat(fixPar,varParCombinations)
% combineDataMat collects data for a certain figure from accuracyData

% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

%required inputs
p = inputParser; 
p.addRequired('fixPar', @(x) isstruct(x));
p.addRequired('varParCombinations', @(x) isstruct(x));
p.parse(fixPar,varParCombinations);
inputs = p.Results;

m = fixPar.rmodes;
mn = length(varParCombinations.wTruncList);
n = prod( structfun(@length,varParCombinations)) / mn;

if varParCombinations.wTruncList(end)<=30
    dataMatTot = zeros( n , m , fixPar.iter);
    sensorMatTot = zeros( n , m , m ,fixPar.iter);
    weightMatTot = zeros( n , m , m ,fixPar.iter);
else
    dataMatTot = zeros( n , fixPar.iter);
    sensorMatTot = [];
end

varParCombinationsShort = varParCombinations;
varParCombinationsShort.wTruncList = 1;
paramStruct =  createParListSingle(varParCombinationsShort);     

for j1 = 1:length(paramStruct);   
    varPar = paramStruct(j1);     
    if varParCombinations.wTruncList(end)<=30
       for j2 = 1:length(varParCombinations.wTruncList)
            wTrunc = varParCombinations.wTruncList(j2);

            fillString = 'Data_%s_dT%g_dP%g_sOn%g_STAw%g_STAf%g_NLDs%g_NLDg%g_wT%g_';
            fillCell = {fixPar.saveNameParameters ,varPar.theta_dist , varPar.phi_dist, varPar.SSPOCon , ...
                        varPar.STAwidth , varPar.STAfreq , varPar.NLDshift , varPar.NLDgrad , wTrunc };
            saveNameBase = sprintf( fillString,fillCell{:} );
            nameMatches = dir([fixPar.data_loc filesep saveNameBase '*']);
            if ~isempty(nameMatches)
%                 for k2 = 1:length(nameMatches)
                for k2 = 1: (fixPar.nIterFig/fixPar.iter)
                    
                    tempDat = load( [fixPar.data_loc filesep nameMatches(k2).name] ); 
                    [q_vec,it] = ind2sub(size(tempDat.DataMat),find(tempDat.DataMat));
                    for k3 = 1:length(q_vec)
                        q = q_vec(k3);
                        prev = length(find( dataMatTot(j1,q,:) )  );
                        dataMatTot(j1,q, prev+1) = tempDat.DataMat(q_vec(k3),it(k3)); 

                        sensorMatTot(j1,q,1:q, prev+1) = tempDat.SensMat(q_vec(k3),1:q_vec(k3),it(k3)); 
                        
                        try 
                            weightMatTot(j1,q,1:q, prev+1) = tempDat.WeightMat(q_vec(k3),1:q_vec(k3),it(k3)); 
                        end
                    end
                end
%                 display( ['loaded ' num2str(fixPar.nIterFig) ' out of ' num2str( length(nameMatches)*fixPar.nIterSim) 'results'])
            end
       end
    else            
        fillString = 'Data_%s_dT%g_dP%g_sOn%g_STAw%g_STAf%g_NLDs%g_NLDg%g_wT%g_';
        fillCell = {fixPar.saveNameParameters ,varPar.theta_dist , varPar.phi_dist, varPar.SSPOCon , ...
                    varPar.STAwidth , varPar.STAfreq , varPar.NLDshift , varPar.NLDgrad , varParCombinations.wTruncList(end) };
        saveNameBase = sprintf( fillString,fillCell{:} );
        nameMatches = dir([fixPar.data_loc filesep saveNameBase '*']);      

        if ~isempty(nameMatches);
            for k2 = 1:length(nameMatches)
                tempDat = load( [fixPar.data_loc filesep nameMatches(k2).name] ); 
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
try
    dataStruct.weightMatTot = weightMatTot;
end
dataStruct.paramStruct = paramStruct;

end

