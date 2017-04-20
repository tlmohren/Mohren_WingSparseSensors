function [ varParList] = setVariableParameters(par)
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017
%  unsorted

count = 0;
for j1 = 1:length(par.STAwidthList)
    for j2 = 1:length(par.STAshiftList)
        for j3 = 1:length(par.theta_distList)
            for j4 = 1:length(par.phi_distList)
%                 for j5 = 1:length(par.wList)
                    for j6 = 1:length(par.SSPOConList)
                        for j7 = 1:length(par.xIncludeList)
                            for j8 = 1:length(par.yIncludeList)
                                for j9 = 1:length(par.NLDshiftList)
                                    for j10 = 1:length(par.NLDsharpnessList)
                                        count = count + 1;
                                        varParList(count).STAwidth = par.STAwidthList(j1); 
                                        varParList(count).STAshift = par.STAshiftList(j2);
                                        varParList(count).theta_dist = par.theta_distList(j3);
                                        varParList(count).phi_dist = par.phi_distList(j4);
%                                         varPar(count).w_trunc = par.wList(j5);
                                        varParList(count).SSPOCon = par.SSPOConList(j6);
                                        varParList(count).xInclude = par.xIncludeList(j7);
                                        varParList(count).yInclude = par.yIncludeList(j8);
                                        varParList(count).NLDshift = par.NLDshiftList(j9);
                                        varParList(count).NLDsharpness = par.NLDsharpnessList(j10);
                                    end
                                end
                            end
                        end
                    end
%                 end
            end
        end
    end
end

fprintf('varPar has %g parameter sets',count)


    %% Detailed explanation of parameters 
    % par.c