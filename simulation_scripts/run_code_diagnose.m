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
figuresToRun        = {'subSetTest'};

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
% strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it2harm0.2.mat']);
varPar = varParStruct(1);
%% Test neural encoding effert

fixPar.STAdelay = 5;

[X,G] = neuralEncoding(strainSet, fixPar,varPar );

varPar.SSPOCon = [0];
varPar.NLDgrad = -1;
varPar.STAfreq = 1;
varPar.STAwidth = 0.01;


[X4,G] = neuralEncoding(strainSet, fixPar,varPar );

figure();
    plot(X(100,2600:3400))
    hold on
    plot(X4(100,2600:3400))
    legend('delay 3.6','delay 4') 

%% adjusted parameters 
% varPar.wTrunc = 7;
varPar.wTrunc = 11; %% 11 does it for iter2 eNet 09
% varPar.wTrunc = 7; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.9;
% fixPar.sThreshold =  fixPar.rmodes/varPar.wTrunc;
fixPar.singValsMult = 1;
fixPar.rmodes = 30; % reduce from 30, solves it? Overfitting problem? 
%% 
% [acc,sensors ] = sparseWingSensors( X,G,fixPar, varPar);





[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varyPar);
        [w_r, Psi, singVals,V] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR = singVals(1:length(w_r));
        
        
        size(w_r) 
        
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
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim )
%             sensors_empty = I_top2(1:varPar.wTrunc)
%             sensors = sensors_empty;



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
        Xcls = w_sspoc' * (Phi * Xtrain);

        % compute centroid of each class in classifier space
        centroid = zeros(c-1, c);
        for i = 1:c, 
            centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
        end;
        % use sparse sensors to classify X
        cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
        acc =  sum(cls == Gtest)/numel(cls);

       
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])

%%
% expo = round( - log10(max(abs(Xcls))));
% lims = [ round(min(Xcls),expo+1)-10^(-expo-1), ( round(max(Xcls),expo+1) +10^(-expo-1)) ];
% 
% rangeBins = lims(1):10^(-expo-1)*0.8 :lims(2);
% binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;
% 
% col = linspecer(2);
% midWay = length(Xcls)/2;
% [aCounts] = histcounts(Xcls(1:midWay),rangeBins);
% [bCounts] = histcounts(Xcls(midWay+1:end),rangeBins);
% 
% yLims = [ max(aCounts),-max(bCounts)];
% 
% figure()
% bar1 = bar(binMids,aCounts);
% ax1 = gca();
% hold on
% bar2 = bar(binMids,-bCounts,'r');
% ax2 = gca();
% 
% axOpts = {'XLim',lims};
% barOpts1 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(1,:)};
% barOpts2 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(2,:)};
% set(ax1,axOpts{:})
% set(ax2,axOpts{:})
% set(bar1,barOpts1{:})
% set(bar2,barOpts2{:})
% 
% plot( [1,1]*mean(centroid),yLims,'k--','LineWidth',3)
% 
% 
% yLims = [ max(aCounts),-max(bCounts)];
% txt1 = 'Flapping';
% txt2 = 'Flapping \& Rotating';
% text(binMids(19),yLims(1)*0.1,txt1)
% text(binMids(15),yLims(2)*1.3,txt2)
% 
% axis off






%% 
% % % % %         big% % % % % %         big_modes = [19,22,23]
% % % % %         XtrainFake = Psi(:,big_modes)*diag(singVals(big_modes))*V(:,big_modes)';
% % % % %         acc = sensorLocClassify(  1:size(X,1) ,XtrainFake,Gtrain,XtrainFake(:,2401:3000),Gtest );
% % % % %         q = 1326;
% % % % %         
% % % % %         fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])
% % _modes = 1:23;
%         figure();plot(XtrainFake(100,2500:2900))
        
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
%         
%         sensors4_empty = I_top2(1:varPar.wTrunc)
%             sensors4 = sensors4_empty;
        
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
        Xcls = w_sspoc' * (Phi * Xtrain4);

        % compute centroid of each class in classifier space
        centroid = zeros(c-1, c);
        for i = 1:c, 
            centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
        end;
        % use sparse sensors to classify X
        cls = classify_nc(Xtest4, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
        acc =  sum(cls == Gtest)/numel(cls);







q = length(sensors4);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])





%% 
expo = round( - log10(max(abs(Xcls))));
lims = [ round(min(Xcls),expo+1)-10^(-expo-1), ( round(max(Xcls),expo+1) +10^(-expo-1)) ];

rangeBins = lims(1):10^(-expo-1)*0.8 :lims(2);
binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;

col = linspecer(2);
midWay = length(Xcls)/2;
[aCounts] = histcounts(Xcls(1:midWay),rangeBins);
[bCounts] = histcounts(Xcls(midWay+1:end),rangeBins);

% 
% figure()
% bar1 = bar(binMids,aCounts);
% ax1 = gca();
% hold on
% bar2 = bar(binMids,-bCounts,'r');
% ax2 = gca();
% 
% axOpts = {'XLim',lims};
% barOpts1 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(1,:)};
% barOpts2 = {'BarWidth',0.9,'EdgeColor','None','FaceColor',col(2,:)};
% set(ax1,axOpts{:})
% set(ax2,axOpts{:})
% set(bar1,barOpts1{:})
% set(bar2,barOpts2{:})
% 
% % txt1 = 'Flapping';
% % txt2 = 'Flapping \& Rotating';
% % text(6e-6,100,txt1)
% % text(3e-6,-300,txt2)
% 
% 
% plot( [1,1]*mean(centroid),yLims,'k--','LineWidth',3)
% 
% 
% 
% yLims = [ max(aCounts),-max(bCounts)];
% txt1 = 'Flapping';
% txt2 = 'Flapping \& Rotating';
% text(binMids(19+2),yLims(1)*1.1,txt1)
% text(binMids(15+2),yLims(2)*1.1,txt2)
% 
% axis off
% 
% 
% 
% %% 
%     
% %         big_modes = 1:23;
% %         big_modes = [19,22,23]
% %         XtrainFake = Psi(:,big_modes)*diag(singVals(big_modes))*V(:,big_modes)';
%         XtrainFake = Psi4(:,big_modes4)*diag(singVals4(big_modes4))*V4(:,big_modes4)';
%         acc = sensorLocClassify(  1:size(X,1) ,XtrainFake,Gtrain,XtrainFake(:,2401:3000),Gtest );
%         q = 1326;
%         
%         fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])
% %         figure();plot(XtrainFake(100,2500:2900))
%         
%         
%         
%         
% %% 
%     figure('Position',[100,100,800,900])
% for j = 1:30%fixPar.rmodes
%     
%     subplot(10,6,j*2-1)
%         pcolor( reshape(Psi(:,j),26,51)  )
%         axis off 
%     subplot(10,6,j*2)
%         plot(1:100,V(2901:3000,j));
%         hold on
%         plot(101:200,V(3001:3100,j))
%         axis off 
% %     figure(12,'Position',[0,0,800,500])
% end
% 
%     figure('Position',[900,100,800,900])
% for j = 1:30%fixPar.rmodes
%     subplot(10,6,j*2-1)
%         pcolor( reshape(Psi4(:,j),26,51)  )
%         axis off 
%     subplot(10,6,j*2)
%         plot(1:100,V4(2901:3000,j));
%         hold on
%         plot(101:200,V4(3001:3100,j))
%         axis off 
% %     figure(12,'Position',[0,0,800,500])
% end
% %% 
%     figure('Position',[100,100,800,900])
% for j = 1:length(big_modes)%fixPar.rmodes
%     
%     subplot(6,6,j*2-1)
%         pcolor( reshape(Psi(:,big_modes(j)),26,51)  )
%         axis off 
%     subplot(6,6,j*2)
%         plot(1:100,V(2901:3000,big_modes(j)));
%         hold on
%         plot(101:200,V(3001:3100,big_modes(j)))
%         axis off 
% %     figure(12,'Position',[0,0,800,500])
% end
% 
%     figure('Position',[900,100,800,900])
% for j = 1:length(big_modes)%fixPar.rmodes
%     subplot(6,6,j*2-1)
%         pcolor( reshape(Psi4(:,big_modes(j)),26,51)  )
%         axis off 
%     subplot(6,6,j*2)
%         plot(1:100,V4(2901:3000,big_modes(j)));
%         hold on
%         plot(101:200,V4(3001:3100,big_modes(j)))
%         axis off 
% %     figure(12,'Position',[0,0,800,500])
% end
% 
% 
% 
% 
% %% Show quantities of interest 
% figure();
%     semilogy(singValsR,'o')
%     hold on 
%     semilogy(singValsR4,'+')
% 
% % %% 
% % figure()
% % subplot(211)
% % pcolor( reshape(w
% %% 
% figure();
% subplot(211) 
%     plot( abs(w_r) );
%     hold on 
%     plot( abs(w_r4),'o') 
%     plot(big_modes, -0.2*ones(1,length(big_modes)),'*')
%     plot(big_modes4, -0.25*ones(1,length(big_modes)),'*')
%     
%     plot(big_modes,  abs(w_t4),'*')
% subplot(212) 
%     plot( abs(w_r.*singValsR) );
%     hold on 
%     plot( abs(w_r4.*singValsR4),'o') 
%     plot(big_modes, zeros(1,length(big_modes)),'o')
%     plot(big_modes4, zeros(1,length(big_modes)),'+')
%     
% %     plot( big_modes, abs(w_t4),'*')
%     
%     
% %%     
% figure()
%     plot( abs(s) )
%     hold on
%     plot([1,1326],cutoff_lim*[1,1],'k--','LineWidth',1)
%     plot(- abs(s4) )
%     plot([1,1326],-cutoff_lim4*[1,1],'k--','LineWidth',1)
%     plot(sensors, zeros(1,length(sensors)),'*')
%     plot(sensors4, zeros(1,length(sensors4)),'*')
%     legend('delay 3.6','theshold 3.6','delay 4','theshold 4','Location','NorthEastOutside')
%     
% 
%     
%     