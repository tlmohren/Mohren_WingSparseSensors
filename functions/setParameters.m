function [ par] = setParameters 
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017

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
    par.saveSim = 0;
% neural encoding parameters match filter 
    par.STAsel = 1;
    par.jSTA = 1;
    par.STAwidth = [3,6,10];
    par.STAshift = [-10,-15,-20];% 
%     par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
%         ./ (2*par.STAwidth(par.jSTA) ^2) ) ...
%         ./ (sqrt(3*par.STAwidth(par.jSTA)) *pi^1/4)...
%         .* ( 1-(t-par.STAshift).^2/par.STAwidth(par.jSTA)^2);
%     par.STAt = -39:0;   
%     par.STAfilt = par.STAFunc(par.STAt);    
% neural encoding parameters non-linear filter 
    par.NLDsel = 1;
    par.jNLD = 1;
    par.NLDshift = [0,0.5,0,0,5];                % with ramp, shift best turned off 
    par.NLDsharpness= [2,2,10,10]; 
%     par.NLD = @(s) 1./(  1 +...
%         exp( -(s-par.NLDshift) * par.NLDsharpness(par.jNLD) )  );
% sparse sensor placement parameters 
    par.w_range = 15;
    par.rmodes = 40;
    par.iter = 1; 
    par.cases = {'SSPOC + filt'} ;%{'SSPOC + filt','Random filt','SSPOC no filt ', 'Random no filt'};
    par.SSPOC = [1,0,1,0];
    par.theta_dist = 0;% [0,0.1,1,10];
    par.phi_dist = 0;%[0,0.1,1,10];
    par.trainFraction = 0.9;

    %% Detailed explanation of parameters 
    % par.c