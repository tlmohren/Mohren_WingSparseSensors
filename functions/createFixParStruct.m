function [ fixPar ] = createFixParStruct(name,iter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% variable parameters 

% eulerLagrange parameters 
    fixPar.iter = iter; 
    fixPar.chordElements = 26;
    fixPar.spanElements = 51;
    fixPar.simStartup = 1;
    fixPar.simEnd = 4; % in seconds
    fixPar.flapFrequency = 25;
    fixPar.harmonic = 0.2;
    fixPar.runSim = 0;
    fixPar.saveSim = 1;
% Neural Encoding parameters 
    fixPar.normalizeVal = 3.7732e-4; % for harmonic 0.2 .
    fixPar.STAdelay = 5;
    fixPar.subSamp = 1;
% Sparse sensor placement parameters 
    fixPar.predictTrain = 1;
    fixPar.rmodes = 30;
    fixPar.trainFraction = 0.9;
    fixPar.saveNameParameters = name;        
    fixPar.singValsMult = 1;
    fixPar.determineNorm = 0;
    fixPar.elasticNet = 0.9;
%     fixPar.data_loc = 'accuracyData'; ;;
%     fixPar.data_loc = 'accuracyData'; 
    fixPar.data_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
    % to phase out -----------------------------------------------
    % currently used for Euler-lagrange simulation
    fixPar.sampFreq = 1e3;
    fixPar.xInclude = [0];
    fixPar.yInclude = [1];
    fixPar.allSensors = 0;
    
end

