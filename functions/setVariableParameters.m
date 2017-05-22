function [ varParList,varParList_short] = setVariableParameters_saveIntermitted(par)
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017
nFigures = 7;
count = 0;
count_short  = 0;
for j0= 1:nFigures
    if j0 == 1
        % disturbance sweep figure  YY
        par.theta_distList = [0,0.1,1,10];
        par.phi_distList = [0,0.1,1,10];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 2
        % disturbance sweep figure   XX
        par.theta_distList = [0,0.1,1,10];
        par.phi_distList = [0,0.1,1,10];
        par.xIncludeList = [1];
        par.yIncludeList = [0];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 3
        % disturbance sweep figure   XXYY 
        par.theta_distList = [0,0.1,1,10];
        par.phi_distList = [0,0.1,1,10];
        par.xIncludeList = [1];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 4
        % hump phi disturbance plot   check the hump  phi 
        par.theta_distList = [0];
        par.phi_distList = spa_sf( 10.^[-3:0.4:2] ,2);
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        par.wTruncList = 1:30;
        
    elseif j0 == 5
        % hump theta disturbance plot     check the hump theta
        par.theta_distList = spa_sf( 10.^[-3:0.4:2] ,2);
        par.phi_distList = [0];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        
        
    elseif j0 == 6
        % STA sweep  
        par.theta_distList = [0];
        par.phi_distList = [0];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [1:2:10];
        par.STAshiftList = [-4:-3:-16];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 7
        % NLD sweep 
        par.theta_distList = [0];
        par.phi_distList = [0];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [-0.1:0.2:0.9];
        par.NLDsharpnessList = [4:2:12];
        par.wTruncList = 1:30;
    end
    
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
                                                for j11 = 1:length(par.wTruncList)
                                                    count = count + 1;
                                                    varParList(count).STAwidth = par.STAwidthList(j1); 
                                                    varParList(count).STAshift = par.STAshiftList(j2);
                                                    varParList(count).theta_dist = par.theta_distList(j3);
                                                    varParList(count).phi_dist = par.phi_distList(j4);
                                                    varParList(count).SSPOCon = par.SSPOConList(j6);
                                                    varParList(count).xInclude = par.xIncludeList(j7);
                                                    varParList(count).yInclude = par.yIncludeList(j8);
                                                    varParList(count).NLDshift = par.NLDshiftList(j9);
                                                    varParList(count).NLDsharpness = par.NLDsharpnessList(j10);
                                                    varParList(count).wTrunc = par.wTruncList(j11);
                                                end
                                                count_short = count_short + 1;
                                                varParList_short(count_short).STAwidth = par.STAwidthList(j1); 
                                                varParList_short(count_short).STAshift = par.STAshiftList(j2);
                                                varParList_short(count_short).theta_dist = par.theta_distList(j3);
                                                varParList_short(count_short).phi_dist = par.phi_distList(j4);
                                                varParList_short(count_short).SSPOCon = par.SSPOConList(j6);
                                                varParList_short(count_short).xInclude = par.xIncludeList(j7);
                                                varParList_short(count_short).yInclude = par.yIncludeList(j8);
                                                varParList_short(count_short).NLDshift = par.NLDshiftList(j9);
                                                varParList_short(count_short).NLDsharpness = par.NLDsharpnessList(j10);
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
        
end
fprintf('varPar has %g parameter sets \n',count)

