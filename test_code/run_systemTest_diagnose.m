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
% strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
strainSet = load('strainSet_th0.1ph0.312it2harm0.2.mat');
% fixPar.showFilt = 1;
% fixPar.STAdelay = 4;
% conditions under which error occurs 
varPar = varParStruct(1);
% varPar.wTrunc = 9;
%% Test neural encoding effert

fixPar.STAdelay = 3.6;
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

fixPar.STAdelay = 4;
[X4,G] = neuralEncoding(strainSet, fixPar,varPar );

figure();
    plot(X(100,2600:3400))
    hold on
    plot(X4(100,2600:3400))
    legend('delay 3.6','delay 4') 

%% adjusted parameters 

% varPar.wTrunc = 11; %% 11 does it for iter2 eNet 09
varPar.wTrunc = 7; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.5;
fixPar.sThreshold =  fixPar.rmodes/varPar.wTrunc;
fixPar.singValsMult = 1;
fixPar.rmodes = 25; % reduce from 30, solves it? Overfitting problem? 
%% 
% [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varyPar);
        [w_r, Psi, singVals,~] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR = singVals(1:length(w_r));
        if fixPar.singValsMult == 1
            [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
        else
            [~,Iw]=sort(abs(w_r),'descend');  
        end
        big_modes = Iw(1:varPar.wTrunc);
        w_t = w_r(big_modes);
        Psir = Psi(:,big_modes);
        s = SSPOC(Psir,w_t,fixPar);
        s = sum(s, 2);   
        [~, I_top2] = sort( abs(s),'descend');
        sensors_sort = I_top2(1:fixPar.rmodes);
        cutoff_lim = norm(s, 'fro')/fixPar.rmodes*fixPar.sThreshold;
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim )
            sensors = I_top2(1:varPar.wTrunc)
acc = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])


% [acc,sensors ] = sparseWingSensors( X4,G,fixPar, varPar);
[Xtrain4, Xtest4, Gtrain, Gtest] = predictTrain(X4, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain4,Gtrain,fixPar,varyPar);
        [w_r4, Psi4, singVals4,~] = PCA_LDA_singVals(Xtrain4, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR4 = singVals4(1:length(w_r));
        if fixPar.singValsMult == 1
            [~,Iw]=sort(abs(w_r4).*singValsR4,'descend');  
        else
            [~,Iw]=sort(abs(w_r4),'descend');  
        end
        big_modes4 = Iw(1:varPar.wTrunc);
        w_t = w_r4(big_modes4);
        Psi4r = Psi4(:,big_modes4);
        s4 = SSPOC(Psi4r,w_t,fixPar);
        s4 = sum(s4, 2);   
        [~, I_top2] = sort( abs(s4),'descend');
        sensors_sort4 = I_top2(1:fixPar.rmodes);
        
        cutoff_lim4 = norm(s4, 'fro')/fixPar.rmodes*fixPar.sThreshold;
        norm(s4, 'fro')
        sensors4 = sensors_sort4(  abs(s4(sensors_sort4))>= cutoff_lim4 );
        
            sensors4 = I_top2(1:varPar.wTrunc)
        
acc = sensorLocClassify(  sensors4,Xtrain4,Gtrain,Xtest4,Gtest );
q = length(sensors4);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])




%% Show quantities of interest 
figure();
semilogy(singValsR,'o')
hold on 
semilogy(singValsR4,'+')
%% 
figure();
subplot(211) 
    plot( abs(w_r) );
    hold on 
    plot( abs(w_r4),'o') 
    plot(big_modes, -0.2*ones(1,length(big_modes)),'*')
    plot(big_modes4, -0.25*ones(1,length(big_modes)),'*')
subplot(212) 
    plot( abs(w_r.*singValsR) );
    hold on 
    plot( abs(w_r4.*singValsR4),'o') 
    plot(big_modes, zeros(1,length(big_modes)),'o')
    plot(big_modes4, zeros(1,length(big_modes)),'+')
%%     
figure()
    plot( abs(s) )
    hold on
    plot([1,1326],cutoff_lim*[1,1],'k--','LineWidth',1)
    plot(- abs(s4) )
    plot([1,1326],-cutoff_lim4*[1,1],'k--','LineWidth',1)
    plot(sensors, zeros(1,length(sensors)),'*')
    plot(sensors4, zeros(1,length(sensors4)),'*')
    legend('delay 3.6','theshold 3.6','delay 4','theshold 4','Location','NorthEastOutside')
    
%% 
for j = 1:30
    figure(11)
    subplot(6,5,j)
        pcolor( reshape(Psi(:,j),26,51) *singValsR(j) )
    figure(12)
    subplot(6,5,j)
        pcolor( reshape(Psi4(:,j),26,51) *singValsR(j)  )
end
    
    