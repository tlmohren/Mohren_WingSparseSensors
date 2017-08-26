function [ paramStruct ] = createParamStructSTAtest( par )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    count = 0;
    for j0 = 1:length(par.NF_on)
        for j01 = 1:length( par.elasticNetList)
            for j02 = 1:length( par.STAdelayList)
                for j1 = 1:length(par.STAwidthList)
                    for j2 = 1:length(par.STAshiftList)
                        for j10 = 1:length(par.NLDsharpnessList)
                            for j9 = 1:length(par.NLDshiftList)
                                for j3 = 1:length(par.theta_distList)
                                    for j4 = 1:length(par.phi_distList)
                                        for j6 = 1:length(par.SSPOConList)
                                            for j7 = 1:length(par.xIncludeList)
                                                for j8 = 1:length(par.yIncludeList)

                                                    count = count + 1;
                                                    if par.NF_on(j0) == 1
                                                        paramStruct(count).STAdelay = par.STAdelayList(j02); 
                                                        paramStruct(count).elasticNet = par.elasticNetList(j01); 
                                                        paramStruct(count).STAwidth = par.STAwidthList(j1); 
                                                        paramStruct(count).STAshift = par.STAshiftList(j2);
                                                        paramStruct(count).NLDsharpness = par.NLDsharpnessList(j10);
                                                    else
                                                        paramStruct(count).STAwidth = 0; 
                                                        paramStruct(count).STAshift = 0;
                                                        paramStruct(count).NLDsharpness = 0;
                                                    end

                                                    paramStruct(count).STAdelay = par.STAdelayList(j02); 
                                                    paramStruct(count).elasticNet = par.elasticNetList(j01); 
                                                    paramStruct(count).theta_dist = par.theta_distList(j3);
                                                    paramStruct(count).phi_dist = par.phi_distList(j4);
                                                    paramStruct(count).SSPOCon = par.SSPOConList(j6);
                                                    paramStruct(count).xInclude = par.xIncludeList(j7);
                                                    paramStruct(count).yInclude = par.yIncludeList(j8);
                                                    paramStruct(count).NLDshift = par.NLDshiftList(j9);
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

