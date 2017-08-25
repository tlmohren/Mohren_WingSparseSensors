function [ par] = setParameters
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017

% variable parameters 
    par.predictTrain = 1;
    par.showFigure = 0;
    par.setBaseZero = 1;
    par.singValsMult = 1;

% eulerLagrange parameters 
    par.chordElements = 26;
    par.spanElements = 51;
    par.simStartup = 1;
    par.simEnd = 4; % in seconds
    par.flapFrequency = 25;
    par.harmonic = 0.2;
    par.sampFreq = 1e3;
    par.baseZero = 0;   % doesn't do anything 
%     par.xInclude = 0;
%     par.yInclude =1; 

%eulerLagrangeConcatenate parameters
    par.runSim = 0;
    par.saveSim = 1;
% neural encoding parameters match filter

% sparse sensor placement parameters 
    par.rmodes = 30;
    par.iter = 1; 
    par.trainFraction = 0.9;

    % experimental neural encoding parameters 
    par.STAdelay = 3;
    par.STAfreq = 1;
    par.STAwidth = 8;
    par.NLDgrad = 12;
    par.NLDshift = 5;
    %% Detailed explanation of parameters 
