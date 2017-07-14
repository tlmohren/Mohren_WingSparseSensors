function [ varParList] = setVariableParameters_allSensors(par)
%[ varParList] = setVariableParameters_allSensors(par)
%   Creates a struct for different combinations of parameters (par). 
%   Input: General simulation parameters (not used)
%   Output: varParList, defines the parameter combinations to simulate
%   Last updated: 2017/07/03  (TLM)

nFigures = 8;
count = 0;
for j0= 1:nFigures
        count
    if j0 == 1
        % disturbance sweep figure   2A
        par.theta_distList = [0.001,0.01,0.1,1] * 10;
        par.phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
    elseif j0 == 2
        % no neural filter 
        par.theta_distList = [0.001,0.01,0.1,1] * 10;
        par.phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [0];
        par.STAshiftList = [0];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [0];
    elseif j0 == 3
        % hump phi disturbance plot 2B
        par.theta_distList = [0.01];
        par.phi_distList = spa_sf( 10.^[-2:0.1:2] ,2)* 3.12;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
    elseif j0 == 4
        % hump theta disturbance plot   2B
        par.theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);
        par.phi_distList = [0.031];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        
    elseif j0 == 5
        % STA sweep 
        par.theta_distList = [0.01];
        par.phi_distList = [0.031];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [1:0.5:10];
        par.STAshiftList = [-1:-0.5:-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        
    elseif j0 == 6
        % NLD sweep 
        par.theta_distList = [0.01];
        par.phi_distList = [0.031];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [-0.2:0.05:0.7];
        par.NLDsharpnessList = [5:0.5:14];
        
    elseif j0 == 7
        par.theta_distList = [0:5:100] ;
        par.phi_distList = [0:5:100]  ;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
        par.wTruncList = 1:30;
    end

        for j1 = 1:length(par.STAwidthList)
            for j2 = 1:length(par.STAshiftList)
                for j3 = 1:length(par.theta_distList)
                    for j4 = 1:length(par.phi_distList)
                        for j9 = 1:length(par.NLDshiftList)
                            for j10 = 1:length(par.NLDsharpnessList)
                                for j6 = 1:length(par.SSPOConList)
                                    for j7 = 1:length(par.xIncludeList)
                                        for j8 = 1:length(par.yIncludeList)
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
fprintf('varPar has %g parameter sets \n',count)