function [ par] = setParameters_varPar
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017

% variable parameters 



%  unsorted
par.iter = 2;
par.showFigure = 0;
par.setBaseZero = 1;
par.singValsMult = 0;



% eulerLagrange parameters 
    par.chordElements = 26;
    par.spanElements = 51;
    par.simStartup = 1;
    par.simEnd = 4; % in seconds
    par.flapFrequency = 25;
    par.harmonic = 0.2;
    par.sampFreq = 1e3;
    par.chordElements = 26;
    par.spanElements = 51;
    par.baseZero = 0;   % doesn't do anything 
    par.xInclude = 0;
    par.yInclude =1; 
%eulerLagrangeConcatenate parameters
    par.runSim = 0;
    par.saveSim = 1;
% neural encoding parameters match filter
% sparse sensor placement parameters 
    par.w_range = 15;
    par.rmodes = 40;
    par.iter = 1; 
    par.theta_dist = 0;% [0,0.1,1,10];
    par.phi_dist = 0;%[0,0.1,1,10];
    par.trainFraction = 0.9;

    %% Detailed explanation of parameters 
