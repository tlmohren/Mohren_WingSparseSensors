function [ par] = setParameters 
%setParameters Create parameter structure
%     par = SetParameters() sets which filter, number of iterations, and
%     other parameters will be used throughout the simulation
%  TLM 2017



% unsorted parameters 
par.w_range = 15;
par.runSim = 0;
par.saveSim = 0;
par.simStartup = 1;
par.simEnd = 4;
par.sampFreq = 1e3;
par.chordElements = 26;
par.spanElements = 51;
par.xInclude = 0;
par.yInclude =1; 
par.trainFraction = 0.9;
par.SSPOC_on = 1;
par.showFigure = 1;














% eulerLagrange parameters 
par.chordElements = 26;
par.spanElements = 51;
par.simEnd = 4; % in seconds
par.flapFrequency = 25;
par.harmonic = 0.2;
par.sampFreq = 1e3;
par.simStartup = 1;
par.chordElements = 12;
par.spanElements = 12;

%eulerLagrangeConcatenate parameters
par.runSim = 0;
par.saveSim = 0;

% neural encoding parameters match filter 
par.STA = 1;
par.STAwidth = 3;
par.STAshift = -10;% 
par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2/ (2*par.STAwidth^2) ) ...
    ./ (sqrt(3*par.STAwidth) *pi^1/4)...
    .* ( 1-(t-par.STAshift).^2/par.STAwidth^2);
par.STAt = -39:0; 
par.STAfilt = par.STAFunc(par.STAt);      

% neural encoding parameters non-linear filter 
par.NLD = 0;
par.NLDshift = 0.5;                % with ramp, shift best turned off 
par.NLDsharpness= 10; 
par.NLD = @(s) 1./(  1 +...
    exp( -(s-par.NLDshift) * par.NLDsharpness )  );

% sparse sensor placement parameters 
par.w_range = 15;
par.rmodes = 40;
par.iter = 1; 
par.cases = {'SSPOC + filt'} ;%{'SSPOC + filt','Random filt','SSPOC no filt ', 'Random no filt'};
par.SSPOC = [1,0,1,0];
par.theta_dist = 0;% [0,0.1,1,10];
par.phi_dist = 0;%[0,0.1,1,10];





%% Detailed explanation of parameters 
% par.c