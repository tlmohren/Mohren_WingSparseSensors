function [ fixPar,varyPar ] = setAllParameters(name,iter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% variable parameters 
% fixPar = d

% eulerLagrange parameters 
    fixPar.predictTrain = 1;
    fixPar.chordElements = 26;
    fixPar.spanElements = 51;
    fixPar.simStartup = 1;
    fixPar.simEnd = 4; % in seconds
    fixPar.flapFrequency = 25;
    fixPar.harmonic = 0.2;
    fixPar.runSim = 0;
    fixPar.saveSim = 1;
    fixPar.rmodes = 30;
    fixPar.iter = iter; 
    fixPar.trainFraction = 0.9;
    fixPar.saveNameParameters = name;        
    fixPar.STAdelay = 3.6;
    fixPar.elasticNet = 0.9;
    fixPar.allSensors = 0;
    % to phase out -----------------------------------------------
    % currently used for Euler-lagrange simulation
    fixPar.sampFreq = 1e3;
    fixPar.xInclude = [0];
    fixPar.yInclude = [1];
    
    
%     par.baseZero = 0;   % doesn't do anything 
%     par.singValsMult = 1;
%     par.setBaseZero = 1;
%     par.showFigure = 0;
%    -----------------------------------------------
    
    standardPar.SSPOConList = [0,1];
    standardPar.theta_distList = 0.01;
    standardPar.phi_distList = 0.0312 ;
    standardPar.STAwidthList = [12];
    standardPar.STAfreqList = 1;% 
    standardPar.NLDshiftList = [0.5];
    standardPar.NLDgradList = [12];
    standardPar.wTruncList = 1:30;
    standardPar.resultName = '';

    for j = 1:6%length(resultNames)
        if j == 1
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2A_disturbance';
            varyPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
%             standardPar.wTruncList = 13:15;
        elseif j == 2
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2B_disturbance_theta';
            varyPar(j).phi_distList = spa_sf( 10.^[-2:0.1:2] ,2) * 3.12;
        elseif j == 3
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2C_disturbance_phi';
            varyPar(j).theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);
        elseif j == 4
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R3_STA';
            varyPar(j).STAfreqList = linspace(0,2,11);        
            varyPar(j).STAwidthList = linspace(0,20,11);
            varyPar(j).STAwidthList(1) = 0.1;
        elseif j == 5
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R4_NLD';
            varyPar(j).NLDshiftList = linspace(-1 ,1,11);
            varyPar(j).NLDgradList = linspace(1,5,11).^2;% [1:1:14];
        elseif j == 6
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2allSensorsA_disturbance';
            varyPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
            varyPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varyPar(j).SSPOConList = [0];
%             standardPar.wTruncList = 13:15;
        end
    end
        

    
    
end

