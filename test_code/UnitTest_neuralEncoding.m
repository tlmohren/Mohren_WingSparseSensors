% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 


clear all, close all, clc
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

parameterSetName    = 'R1toR4Iter10_delay4';
iter                = 10;
figuresToRun        = {'R1'};
% select any from {'R2A','R2B','R2C','R3','R4','R2allSensorsnoFilt','R2allSensorsFilt} 

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
%% Run testcases
% varPar = varParStruct(15);
varPar = varParStruct(45);
varPar.curIter = 1; 

fixPar.subSamp =20;
% Generate strain with Euler-Lagrange simulation ----------
strainSet = eulerLagrangeConcatenate( fixPar,varPar);
% Apply neural filters to strain --------------------------
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

Xsub = X(:,1:fixPar.subSamp:size(X,2));
Gsub = G(:,1:fixPar.subSamp:size(X,2));
[acc,~ ] = sparseWingSensors( Xsub,Gsub,fixPar, varPar)

%% check output here, size, content 
display('Output diagnostics')
% [m,n] = size(strain)
[mx,nx] = size(X)
partShow = (2500:3500);
partShowSub = (2500:3500)*fixPar.subSamp;
figure(); 
    subplot(311)
    plot( [strainSet.strain_0(40,partShow) ; strainSet.strain_10(40,partShow) ]')
    subplot(312)
    plot( X(40,partShowSub))
    
    subplot(313)
    plot( G(partShowSub))
    
