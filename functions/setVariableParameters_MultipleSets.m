function [ varParList,varParList_short] = setVariableParameters_MultipleSets(par)
%[ varParList,varParList_short] = setVariableParameters_MultipleSets(par)
%   Creates a struct for different combinations of parameters (par). 
%   Input: General simulation parameters (not used)
%   Output: varParList, defines the parameter combinations to simulate
%   Output: varParList_short, reduced varParList, useful for figures
%   Last updated: 2017/07/03  (TLM)

nFigures = 5;
count = 0;
count_short  = 0;
for j0= 1:nFigures
    count_short 
    if j0 == 1
        par.theta_distList = [0.001,0.01,0.1,1] * 10;
        par.phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
%         par.STAwidthList = [3];
%         par.STAshiftList = [-10];% 
        par.STAwidthList = [4.5];
        par.STAfreqList = 1;% 
        par.NLDshiftList = [0.5];
        par.NLDgradList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 2
        % hump phi disturbance plot 2B
        par.theta_distList = [0.01];
        par.phi_distList = spa_sf( 10.^[-2:0.1:2] ,2) * 3.12;
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
%         par.STAwidthList = [3];
%         par.STAshiftList = [-10];% 
        par.STAwidthList = [4.5];
        par.STAfreqList = 1;% 
        par.NLDshiftList = [0.5];
        par.NLDgradList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 3
        % hump theta disturbance plot   2B
        par.theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);
        par.phi_distList = [0.0312];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
%         par.STAwidthList = [3];
%         par.STAshiftList = [-10];% 
        par.STAwidthList = [4.5];
        par.STAfreqList = 1;% 
        par.NLDshiftList = [0.5];
        par.NLDgradList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 4
        % STA sweep 
        par.STAfreqList = linspace(0,2,11);
        par.STAwidthList = linspace(1,8,11);
        
        par.theta_distList = [0.01];
        par.phi_distList = [0.0312];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
%         par.STAwidthList = [1:1:10];
%         par.STAshiftList = [-1:-1:-10];% 
        par.NLDshiftList = [0.5];
        par.NLDgradList = [10];
        par.wTruncList = 1:30;
    elseif j0 == 5
        % NLD sweep 
        par.NLDshiftList = linspace(-1 ,1,11);
        par.NLDgradList = linspace(1,5,11).^2;% [1:1:14];
        par.theta_distList = [0.01];
        par.phi_distList = [0.0312];
        par.xIncludeList = [0];
        par.yIncludeList = [1];
        par.SSPOConList = [0,1];
        par.STAwidthList = [4.5];
        par.STAfreqList = 1;% 
%         par.NLDshiftList = [-0.2:0.1:0.7];
%         par.NLDsharpnessList = [5:1:14];
        par.wTruncList = 1:30;
% % %     elseif j0 == 6
% % %         par.theta_distList = [0:5:100] ;
% % %         par.phi_distList = [0:5:100]  ;
% % %         par.xIncludeList = [0];
% % %         par.yIncludeList = [1];
% % %         par.SSPOConList = [0,1];
% % %         par.STAwidthList = [3];
% % %         par.STAshiftList = [-10];% 
% % %         par.NLDshiftList = [0.5];
% % %         par.NLDsharpnessList = [10];
% % %         par.wTruncList = 1:30;
    end
    for j1 = 1:length(par.STAwidthList)
        for j2 = 1:length(par.STAfreqList)
            for j3 = 1:length(par.theta_distList)
                for j4 = 1:length(par.phi_distList)
                    for j9 = 1:length(par.NLDshiftList)
                        for j10 = 1:length(par.NLDgradList)
                            for j6 = 1:length(par.SSPOConList)
                                for j7 = 1:length(par.xIncludeList)
                                    for j8 = 1:length(par.yIncludeList)
                                       for j11 = 1:length(par.wTruncList)
                                            count = count + 1;
                                            varParList(count).STAwidth = par.STAwidthList(j1); 
                                            varParList(count).STAfreq = par.STAfreqList(j2);
                                            varParList(count).theta_dist = par.theta_distList(j3);
                                            varParList(count).phi_dist = par.phi_distList(j4);
                                            varParList(count).SSPOCon = par.SSPOConList(j6);
                                            varParList(count).xInclude = par.xIncludeList(j7);
                                            varParList(count).yInclude = par.yIncludeList(j8);
                                            varParList(count).NLDshift = par.NLDshiftList(j9);
                                            varParList(count).NLDgrad = par.NLDgradList(j10);
                                            varParList(count).wTrunc = par.wTruncList(j11);
                                        end
                                        count_short = count_short + 1;
                                        varParList_short(count_short).STAwidth = par.STAwidthList(j1); 
                                        varParList_short(count_short).STAfreq = par.STAfreqList(j2);
                                        varParList_short(count_short).theta_dist = par.theta_distList(j3);
                                        varParList_short(count_short).phi_dist = par.phi_distList(j4);
                                        varParList_short(count_short).SSPOCon = par.SSPOConList(j6);
                                        varParList_short(count_short).xInclude = par.xIncludeList(j7);
                                        varParList_short(count_short).yInclude = par.yIncludeList(j8);
                                        varParList_short(count_short).NLDshift = par.NLDshiftList(j9);
                                        varParList_short(count_short).NLDgrad = par.NLDgradList(j10);
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
fprintf('varPar has %g combinations of parameter \n',count)
fprintf('varPar_short has %g combinations of parameter \n',count_short)

