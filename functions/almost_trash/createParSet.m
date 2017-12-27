function [ fixPar,varPar ] = createParSet(name,iter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% variable parameters 

% eulerLagrange parameters 
    fixPar.predictTrain = 1;
    fixPar.chordElements = 26;
    fixPar.spanElements = 51;
    fixPar.simStartup = 1;
    fixPar.simEnd = 4; % in seconds
    fixPar.flapFrequency = 25;
    fixPar.harmonic = 0.2;
    fixPar.normalizeVal = 3.7732e-4; % for harmonic 0.2 .
    
    fixPar.runSim = 0;
    fixPar.saveSim = 1;
%     fixPar.rmodes = 25;
    fixPar.rmodes = 30;
    fixPar.iter = iter; 
    fixPar.trainFraction = 0.9;
    fixPar.saveNameParameters = name;        
    fixPar.singValsMult = 1;
    fixPar.STAdelay = 5;
    fixPar.subSamp = 1;
    fixPar.determineNorm = 0;
    fixPar.elasticNet = 0.9;
%     fixPar.elasticNet = 0.5;
    
    % to phase out -----------------------------------------------
    % currently used for Euler-lagrange simulation
    fixPar.sampFreq = 1e3;
    fixPar.xInclude = [0];
    fixPar.yInclude = [1];
    fixPar.allSensors = 0;
%   
%    -----------------------------------------------
    
    standardPar.wTruncList = 1:fixPar.rmodes;
    standardPar.SSPOConList = [0,1];
    standardPar.theta_distList = 0.1;
    standardPar.phi_distList = 0.312 ;
    standardPar.STAwidthList = [4];
    standardPar.STAfreqList = 1;% 
    standardPar.NLDshiftList = [0.5];
    standardPar.NLDgradList = [10];
%     standardPar.wTruncList = 1:30;
    standardPar.wTruncList = 1:fixPar.rmodes;
    standardPar.resultName = '';
    
    % to overwrite regular parameters  -----------------------------------------------
    
    if strfind(name,'subPart')
        standardPar.theta_distList = 1;
        standardPar.phi_distList = 3.12;
        fixPar.singValsMult = 1;
        fixPar.elasticNet = 0.9;
        fixPar.rmodes = 30;
        standardPar.wTruncList = 3:5;
        standardPar.SSPOConList = [1];
    end
    % ----------------------------------------------------
    for j = 1:11
        if j == 1
            varPar(j) = standardPar;
            varPar(j).resultName = 'R2A_disturbance';
            varPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
        elseif j == 2
            varPar(j) = standardPar;
            varPar(j).resultName = 'R2B_disturbance_theta';
            varPar(j).theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);
        elseif j == 3
            varPar(j) = standardPar;
            varPar(j).resultName = 'R2C_disturbance_phi';
            varPar(j).phi_distList = spa_sf( 10.^[-2:0.1:2] ,2) * 3.12;
        elseif j == 4
            varPar(j) = standardPar;
            varPar(j).resultName = 'R3_STA';
            varPar(j).STAfreqList = linspace(0,2,11);        
            varPar(j).STAwidthList = linspace(0,20,11);
            varPar(j).STAwidthList(1) = 0.1;
        elseif j == 5
            varPar(j) = standardPar;
            varPar(j).resultName = 'R4_NLD';
            
%             varPar(j).NLDshiftList= linspace(-1 ,1,11);
            tempVec = linspace(-1 ,1,11);
            varPar(j).NLDshiftList  = [tempVec(1:8), 0.5, tempVec(9:end)];
            
            varPar(j).NLDgradList = spa_sf( linspace(1,5.4,11).^2 ,2 );
        elseif j == 6
            varPar(j) = standardPar;
            varPar(j).resultName = 'R2allSensorsNoFilt_disturbance';
            varPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
            varPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varPar(j).SSPOConList = [0];
            varPar(j).NLDgradList = -1;
            varPar(j).STAfreqList = 1;
            varPar(j).STAwidthList = 0.01;
        elseif j == 7
            varPar(j) = standardPar;
            varPar(j).resultName = 'R2allSensorsFilt_disturbance';
            varPar(j).theta_distList = [0.001,0.01,0.1,1] * 10;
            varPar(j).phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
            varPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varPar(j).SSPOConList = [0];
        elseif j == 8
            varPar(j) = standardPar;
            varPar(j).resultName = 'R1_disturbance';
            varPar(j).theta_distList = 0.1;
            varPar(j).phi_distList =0.312;
        elseif j == 9
            varPar(j) = standardPar;
            varPar(j).resultName = 'R1_allSensorsNoFilt';
            varPar(j).theta_distList = 0.1;
            varPar(j).phi_distList =0.312;
            varPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varPar(j).SSPOConList = [0];
%             varPar(j).NLDshiftList = [-5];
            varPar(j).NLDgradList = -1;
            varPar(j).STAfreqList = 1;
            varPar(j).STAwidthList = 0.01;
        elseif j == 10
            varPar(j) = standardPar;
            varPar(j).resultName = 'R1_allSensorsFilt';
            varPar(j).theta_distList = 0.1;
            varPar(j).phi_distList =0.312;
            varPar(j).wTruncList = fixPar.chordElements*fixPar.spanElements;
            varPar(j).SSPOConList = [0];
        elseif j == 11
            varPar(j) = standardPar;
            varPar(j).resultName = 'subSetTest';
            varPar(j).theta_distList = 1;
            varPar(j).phi_distList =3.12;
        end
    end
        

    
    
end
