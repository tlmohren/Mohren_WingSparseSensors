function [ varParList] = setVariableParameters_allSensors(par)
%[ varParList] = setVariableParameters_allSensors(par)
%   Creates a struct for different combinations of parameters (par). 
%   Input: General simulation parameters (not used)
%   Output: varParList, defines the parameter combinations to simulate
%   Last updated: 2017/07/03  (TLM)


nFigures = 8;
count = 0;
for j0= 8%3:nFigures% 8%3:7%1:6
        count
    if j0 == 1
        % disturbance sweep figure   2A
% % %         par.theta_distList =[0.001,0.01,0.1,1] * 10;
% % %         par.phi_distList = [0.001,0.01,0.1,1] * 10;
% % %         par.xIncludeList = [0];
% % %         par.yIncludeList = [1];
% % %         par.SSPOConList = [2];
% % %         par.STAwidthList = [3];
% % %         par.STAshiftList = [-10];% 
% % %         par.NLDshiftList = [0.5];
% % %         par.NLDsharpnessList = [10];
%         count 
%         varParList.counter(j0) = count;
    elseif j0 == 2
        %  No neural filter  2A
% % %         par.theta_distList = [0.001,0.01,0.1,1] * 10;
% % %         par.phi_distList = [0.001,0.01,0.1,1] * 10 ;
% % %         par.xIncludeList = [0];
% % %         par.yIncludeList = [1];
% % %         par.SSPOConList = [2];
% % %         par.STAwidthList = [0];
% % %         par.STAshiftList = [-10];% 
% % %         par.NLDshiftList = [0.5];
% % %         par.NLDsharpnessList = [0];
%         varParList.count 
%         count
%         varParList.count(j0) = count;
        
        
    elseif j0 == 3
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
%         varParList.count(j0) = count;
    elseif j0 == 4
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
%         varParList.count(j0) = count;
    elseif j0 == 5
        % hump phi disturbance plot 2B
        par.theta_distList = [0.01];
        par.phi_distList = spa_sf( 10.^[-2:0.2:2] ,2)* 3.12;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
%         varParList.count(j0) = count;
    elseif j0 == 6
        % hump theta disturbance plot   2B
        par.theta_distList = spa_sf( 10.^[-2:0.2:2] ,2);
        par.phi_distList = [0.031];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
%         varParList.count(j0) = count;
        
    elseif j0 == 7
        % STA sweep 
        par.theta_distList = [0.01];
        par.phi_distList = [0.031];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [1:1:10];
        par.STAshiftList = [-1:-1:-10];% 
        par.NLDshiftList = [0.5];
        par.NLDsharpnessList = [10];
%         varParList.count(j0) = count;
        
    elseif j0 == 8
        % NLD sweep 
        par.theta_distList = [0.01];
        par.phi_distList = [0.031];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [2];
        par.STAwidthList = [3];
        par.STAshiftList = [-10];% 
        par.NLDshiftList = [-0.2:0.1:0.8];
        par.NLDsharpnessList = [5:1:15];
%         varParList.count(j0) = count;
        
    end

        for j1 = 1:length(par.STAwidthList)
            for j2 = 1:length(par.STAshiftList)
                for j3 = 1:length(par.theta_distList)
                    for j4 = 1:length(par.phi_distList)
        %                 for j5 = 1:length(par.wList)

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
    end
fprintf('varPar has %g parameter sets \n',count)


    %% Detailed explanation of parameters 
    % par.c