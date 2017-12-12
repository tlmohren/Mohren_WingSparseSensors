function [ XclsStrain,XclsEncoded] = create_histograms( )
%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

%------------------------------



% scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
% addpath([scriptLocation filesep 'scripts']);
% addpathFolderStructure()

parameterSetName    = ' ';
iter                = 1;
figuresToRun        = {'subSetTest'};

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
% strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it1harm0.2.mat']);
varPar = varParStruct(1);
%% Test neural encoding effert

fixPar.STAdelay = 5;

[X,G] = neuralEncoding(strainSet, fixPar,varPar );

varPar.SSPOCon = [0];
varPar.NLDgrad = -1;
varPar.STAfreq = 1;
varPar.STAwidth = 0.01;

[X4,G] = neuralEncoding(strainSet, fixPar,varPar );

%% adjusted parameters 
% varPar.wTrunc = 7;
varPar.wTrunc = 10; %% 11 does it for iter2 eNet 09
% varPar.wTrunc = 7; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.9;
% fixPar.sThreshold =  fixPar.rmodes/varPar.wTrunc;
fixPar.singValsMult = 1;
fixPar.rmodes = 30; % reduce from 30, solves it? Overfitting problem? 
%% 
% [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);



[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);






%% 
% sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varyPar);
        [w_r, Psi, singVals,V] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR = singVals(1:length(w_r));
        
        if fixPar.singValsMult == 1
            [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
        else
            [~,Iw]=sort(abs(w_r),'descend');  
        end
        big_modes = Iw(1:varPar.wTrunc);
        Psir = Psi(:,big_modes);
        
        w_t = w_r(big_modes);
        
        a = Psir'*Xtrain;
        w_t = LDA_n(a, Gtrain);
        
%         XtrainFake = Psi(:,big_modes)*diag(singVals(big_modes))*V(:,big_modes)';
%         [w_t, Psir, ~,~] = PCA_LDA_singVals(XtrainFake, Gtrain, 'nFeatures',varPar.wTrunc);
        
        s = SSPOCelastic(Psir,w_t,'alpha',fixPar.elasticNet);
        s = sum(s, 2);   
        [~, I_top2] = sort( abs(s),'descend');
        
        sensors_sort = I_top2(1:fixPar.rmodes);
        cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );

% acc = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
        n =  size(Xtest,1);
        classes = unique(Gtest); 
        c = numel(classes); 
        q = length(sensors);

        Phi = zeros(q, n);                                      % construct the measurement matrix Phi
        for qi = 1:q,
            Phi(qi, sensors(qi)) = 1;
        end;
        % learn new classifier for sparsely measured data
        w_sspoc= LDA_n(Phi * Xtrain, Gtrain);
        XclsEncodedSparse = w_sspoc' * (Phi * Xtrain);

         
        % compute centroid of each class in classifier space
        centroid = zeros(c-1, c);
        for i = 1:c, 
            centroid(:,i) = mean(XclsEncodedSparse(:,Gtrain==classes(i)), 2);
        end;
        encodedSparseMidLine = mean(centroid);
        % use sparse sensors to classify X
        cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
        acc =  sum(cls == Gtest)/numel(cls);

       
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])

%% 

        % learn new classifier for sparsely measured data
        w_sspoc= LDA_n(Xtrain, Gtrain);
        Phi = eye(1326);
        XclsEncoded = w_sspoc' * (Phi * Xtrain);
        c = 2;
        % compute centroid of each class in classifier space
        centroid = zeros(c-1, c);
        for i = 1:c, 
            centroid(:,i) = mean(XclsEncoded(:,Gtrain==classes(i)), 2);
        end;
        
        encodedMidLine = mean(centroid);
        % use sparse sensors to classify X
        cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
        acc =  sum(cls == Gtest)/numel(cls);
sensors = 1:1326;
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])



%% 
% [acc,sensors ] = sparseWingSensors( X4,G,fixPar, varPar);
[Xtrain4, Xtest4, Gtrain4, Gtest4] = predictTrain(X4, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain4,Gtrain,fixPar,varyPar);
        [w_r4, Psi4, singVals4,V4] = PCA_LDA_singVals(Xtrain4, Gtrain4, 'nFeatures',fixPar.rmodes);
        singValsR4 = singVals4(1:length(w_r4));
        if fixPar.singValsMult == 1
            [~,Iw]=sort(abs(w_r4).*singValsR4,'descend');  
        else
            [~,Iw]=sort(abs(w_r4),'descend');  
        end
        big_modes4 = Iw(1:varPar.wTrunc);
        Psir4 = Psi4(:,big_modes4);
        
        w_t4 = w_r4(big_modes4);
        
        a4 = Psir4'*Xtrain4;
        w_t4 = LDA_n(a4, Gtrain);
        
%         XtrainFake = Psi4(:,big_modes4)*diag(singVals4(big_modes4))*V4(:,big_modes4)';
%         [w_t, Psi4r, ~,~] = PCA_LDA_singVals(XtrainFake, Gtrain, 'nFeatures',varPar.wTrunc);
        
        s4 = SSPOCelastic(Psir4,w_t4,'alpha',fixPar.elasticNet);
        s4 = sum(s4, 2);   
        [~, I_top2] = sort( abs(s4),'descend');
        sensors_sort4 = I_top2(1:fixPar.rmodes);
        
        cutoff_lim4 = norm(s4, 'fro')/fixPar.rmodes;
        sensors4 = sensors_sort4(  abs(s4(sensors_sort4))>= cutoff_lim4 );

%         sensors4 = sensors 
% acc = sensorLocClassify(  sensors4,Xtrain4,Gtrain,Xtest4,Gtest4 );
        n =  size(Xtest4,1);
        classes = unique(Gtest); 
        c = numel(classes); 
        q = length(sensors4);

        Phi = zeros(q, n);                                      % construct the measurement matrix Phi
        for qi = 1:q,
            Phi(qi, sensors4(qi)) = 1;
        end;
        % learn new classifier for sparsely measured data
        w_sspoc= LDA_n(Phi * Xtrain4, Gtrain);
        XclsStrain = w_sspoc' * (Phi * Xtrain4);

        % compute centroid of each class in classifier space
        centroid = zeros(c-1, c);
        for i = 1:c, 
            centroid(:,i) = mean(XclsStrain(:,Gtrain==classes(i)), 2);
        end;
        
        strainMidLine = mean(centroid);
        % use sparse sensors to classify X
        cls = classify_nc(Xtest4, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
        acc =  sum(cls == Gtest)/numel(cls);

q = length(sensors4);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])

%% 



%% 
save( ['introFigData' filesep 'LDAhistograms'],...
    'XclsStrain','XclsEncoded','XclsEncodedSparse','encodedMidLine','strainMidLine','encodedSparseMidLine')


