function [ varParList ] = createParListSingle( par)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    count = 0;
    for j1 = 1:length(par.theta_distList)
        for j2 = 1:length(par.phi_distList)
            for j3 = 1:length(par.STAwidthList)
                for j4 = 1:length(par.STAfreqList)
                    for j5 = 1:length(par.NLDshiftList)
                        for j6 = 1:length(par.NLDgradList)
                            for j7 = 1:length(par.SSPOConList)
                               for j8 = 1:length(par.wTruncList)
                                    count = count + 1;
                                    varParList(count).theta_dist = par.theta_distList(j1);
                                    varParList(count).phi_dist = par.phi_distList(j2);
                                    varParList(count).STAwidth = par.STAwidthList(j3); 
                                    varParList(count).STAfreq = par.STAfreqList(j4);
                                    varParList(count).NLDshift = par.NLDshiftList(j5);
                                    varParList(count).NLDgrad = par.NLDgradList(j6);
                                    varParList(count).SSPOCon = par.SSPOConList(j7);
                                    varParList(count).wTrunc = par.wTruncList(j8);
                               end
                            end
                        end
                    end
                end
            end
        end
    end

end

