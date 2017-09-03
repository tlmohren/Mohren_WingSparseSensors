function [ fixPar,varyPar ] = createParSet(name,iter)
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
    fixPar.normalizeVal = 3.7732e-4; % for harmonic 0.2 
%     fixPar.harmonic = 0;
%     fixPar.normalizeVal = 2.4803e-4;
    
    fixPar.runSim = 0;
    fixPar.saveSim = 1;
    fixPar.rmodes = 30;
    fixPar.iter = iter; 
    fixPar.trainFraction = 0.9;
    fixPar.saveNameParameters = name;        
    fixPar.STAdelay = 3.6;  
    fixPar.allSensors = 0;
    fixPar.elasticNet = 0.9;
    % to phase out -----------------------------------------------
    % currently used for Euler-lagrange simulation
    fixPar.sampFreq = 1e3;
    fixPar.xInclude = [0];
    fixPar.yInclude = [1];
    
%    -----------------------------------------------
    
    standardPar.SSPOConList = [0,1];
    standardPar.theta_distList = 0.01;
    standardPar.phi_distList = 0.0312 ;
    standardPar.STAwidthList = [4];
%     standardPar.STAwidthList = [4.5];
    standardPar.STAfreqList = 1;% 
    standardPar.NLDshiftList = [0.5];
    standardPar.NLDgradList = [20];
    standardPar.NLDgradList = [10];
    standardPar.wTruncList = 1:30;
    standardPar.resultName = '';

    for j = 1:10
        if j == 1
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2A_disturbance';
            varyPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
%             standardPar.wTruncList = 13:15;
        elseif j == 2
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2C_disturbance_phi';
            varyPar(j).phi_distList = spa_sf( 10.^[-2:0.1:2] ,2) * 3.12;
        elseif j == 3
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2B_disturbance_theta';
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
            varyPar(j).resultName = 'R2allSensorsNoFilt_disturbance';
            varyPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
            varyPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varyPar(j).SSPOConList = [0];
            varyPar(j).NLDshiftList = [-5];
            varyPar(j).NLDgradList = 10;
            varyPar(j).STAfreqList = 1;
            varyPar(j).STAwidthList = 0.01;
%             standardPar.wTruncList = 13:15;
        elseif j == 7
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R2allSensorsFilt_disturbance';
            varyPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
            varyPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varyPar(j).SSPOConList = [0];
        elseif j == 8
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R1_disturbance';
            varyPar(j).theta_distList = 0.01;%[0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =0.0312;%[0.001,0.01,0.1,1] * 31.2 ;
        elseif j == 9
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R1_allSensorsNoFilt';
            varyPar(j).theta_distList = 0.01;%[0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =0.0312;%[0.001,0.01,0.1,1] * 31.2 ;
            varyPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varyPar(j).SSPOConList = [0];
            varyPar(j).NLDshiftList = [-5];
            varyPar(j).NLDgradList = 10;
            varyPar(j).STAfreqList = 1;
            varyPar(j).STAwidthList = 0.01;
        elseif j == 10
            varyPar(j) = standardPar;
            varyPar(j).resultName = 'R1_allSensorsFilt';
            varyPar(j).theta_distList = 0.01;%[0.001,0.01,0.1,1] * 10;
            varyPar(j).phi_distList =0.0312;%[0.001,0.01,0.1,1] * 31.2 ;
            varyPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varyPar(j).SSPOConList = [0];
        end
    end
        

    
    
end
