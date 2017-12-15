%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

%------------------------------
clear all, close all, clc

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

parameterSetName    = ' ';
iter                = 1;
figuresToRun        = {'R1'};

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(62);
% strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it2harm0.2.mat']);
varPar = varParStruct(1);

%% adjusted parameters 

% varPar.wTrunc = 1326; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.9;
fixPar.singValsMult = 1;
fixPar.rmodes = 30; % reduce from 30, solves it? Overfitting problem? 


%% Test neural encoding effert
refrac = 30;

x = -20:20;
sig = 2;  c = 0;
y = gaussmf( x, [sig c] );
gaussConv = y/norm(y,1);

[X,G] = neuralEncoding(strainSet, fixPar,varPar );

rMat = rand( size(X));
greaterProb = X > rMat ;
spikes = zeros( size(X) ); 
for j = 1:size( X,1)
    tLastSpike = 40;
    for k = 1:size(X,2)
        if (greaterProb(j,k) == 1) && (tLastSpike >= refrac)
           spikes(j,k) = 1;
           tLastSpike = 0;
        end
        tLastSpike = tLastSpike + 1;
    end
    fire_rate(j,:) = conv( spikes(j,:), gaussConv,'same');
end

sensor = 1000;
part = 2800:3200;
figure();
subplot(311)
plot(X(sensor,part) )
subplot(312)
plot(x,gaussConv)
subplot(313) 
plot(fire_rate(sensor, part) )


%% 
[acc, ~] = sparseWingSensors( X,G,fixPar, varPar)
[acc, ~ ] = sparseWingSensors( fire_rate,G,fixPar, varPar)



    