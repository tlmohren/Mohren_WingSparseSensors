%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

% fixPar = struct with fixed parameters used throughout the simulation
% varParList = struct(1:5).xxx  contains lists of variable parameters 
% combinationStruct contains all required combinations specified in varParList
% varPar is one combination specified in combinationStruct
%------------------------------
% To Do:


clear all, close all, clc

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpath([scriptLocation filesep 'test_code']);
addpathFolderStructure()

parameterSetName    = ' ';
iter                = 1;
figuresToRun        = {'subSetTest'};

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
fixPar.showFilt = 1;
% fixPar.STAdelay = 4;
%% conditions under which error occurs 
varPar = varParStruct(1);
varPar.wTrunc = 15;

%% Test neural encoding effert

fixPar.STAdelay = 3.6;
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

fixPar.STAdelay = 4;
[X4,G] = neuralEncoding(strainSet, fixPar,varPar );

% % figure();
% %     plot(X(100,2600:3400))
% %     hold on
% %     plot(X4(100,2600:3400))
% %     legend('delay 3.6','delay 4') 

%% 
% [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varyPar);
        [w_r, Psi, singVals,~] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR = singVals(1:length(w_r));
%         [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
        [~,Iw]=sort(abs(w_r),'descend');  
        big_modes = Iw(1:varPar.wTrunc);
        w_t = w_r(big_modes);
        Psi = Psi(:,big_modes);
        s = SSPOC(Psi,w_t,fixPar);
        s = sum(s, 2);   
        [~, I_top] = sort( abs(s));
        I_top2 = flipud(I_top);
        sensors_sort = I_top2(1:fixPar.rmodes);
        cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
acc = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])


% [acc,sensors ] = sparseWingSensors( X4,G,fixPar, varPar);
[Xtrain4, Xtest4, Gtrain, Gtest] = predictTrain(X4, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain4,Gtrain,fixPar,varyPar);
        [w_r, Psi, singVals4,~] = PCA_LDA_singVals(Xtrain4, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR4 = singVals4(1:length(w_r));
%         [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
        [~,Iw]=sort(abs(w_r),'descend');  
        big_modes = Iw(1:varPar.wTrunc);
        w_t = w_r(big_modes);
        Psi = Psi(:,big_modes);
        s = SSPOC(Psi,w_t,fixPar);
        s = sum(s, 2);   
        [~, I_top] = sort( abs(s));
        I_top2 = flipud(I_top);
        sensors_sort = I_top2(1:fixPar.rmodes);
        cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
acc = sensorLocClassify(  sensors,Xtrain4,Gtrain,Xtest4,Gtest );
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])




%% Show quantities of interest 
figure();
semilogy(singValsR,'o')
hold on 
semilogy(singValsR4,'+')