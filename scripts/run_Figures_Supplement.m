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
addpath([scriptLocation filesep 'test_code']);
addpathFolderStructure()

parameterSetName    = '';
iter                = 1;
figuresToRun        = {'subSetTest'};
fixPar.data_loc     = 'accuracyData';
svg_save            = false; 

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
% strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
strainSet = load('strainSet_th0.1ph0.312it2harm0.2.mat');
varPar = varParStruct(1);
%% Test neural encoding effert
fixPar.STAdelay = 5;
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

varParStrain = varPar;
% varParStrain.STAwdith = 0;
% varParStrain
varParStrain.NLDgrad = -1;
varParStrain.STAfreq = 1;
varParStrain.STAwidth = 0.01;
[Xstrain,~] = neuralEncoding(strainSet, fixPar,varParStrain );

figure();
    subplot(211)
    plot(X(100,2600:3400))
    legend('delay 3.6','delay 4') 
    subplot(212)
    plot(Xstrain(100,2600:3400))

%% adjusted parameters 
% varPar.wTrunc = 7;
varPar.wTrunc = 11; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.9;
fixPar.singValsMult = 1;
fixPar.rmodes = 26; % reduce from 30, solves it? Overfitting problem? 



%% 
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
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
s = SSPOC(Psir,w_t,fixPar);
s = sum(s, 2);   
[~, I_top2] = sort( abs(s),'descend');

sensors_sort = I_top2(1:fixPar.rmodes);
cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );

acc = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])


[XtrainStrain, XtestStrain, Gtrain, Gtest] = predictTrain(Xstrain, G, fixPar.trainFraction);
[w_rStrain, PsiStrain, singValsStrain,V] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
singValsRStrain = singValsStrain(1:length(w_rStrain));

if fixPar.singValsMult == 1
    [~,Iw]=sort(abs(w_rStrain).*singValsRStrain,'descend');  
else
    [~,Iw]=sort(abs(w_rStrain),'descend');  
end
big_modesStrain = Iw(1:varPar.wTrunc);
PsirStrain = PsiStrain(:,big_modesStrain);

w_tStrain = w_rStrain(big_modesStrain);

aStrain = PsirStrain'*XtrainStrain;
w_tStrain = LDA_n(aStrain, Gtrain);
sStrain = SSPOC(PsirStrain,w_tStrain,fixPar);
sStrain = sum(sStrain, 2);   
[~, I_top2] = sort( abs(sStrain),'descend');

sensors_sortStrain = I_top2(1:fixPar.rmodes);
cutoff_limStrain = norm(sStrain, 'fro')/fixPar.rmodes;
sensorsStrain = sensors_sortStrain(  abs(sStrain(sensors_sortStrain))>= cutoff_limStrain );

accStrain= sensorLocClassify(  sensorsStrain,XtrainStrain,Gtrain,Xtest,Gtest );
qStrain = length(sensorsStrain);
fprintf('Neural filter off, W_trunc,  = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,qStrain,accStrain])













%% 
XtrainFake = Psi(:,big_modes)*diag(singVals(big_modes))*V(:,big_modes)';
acc = sensorLocClassify(  1:size(X,1) ,XtrainFake,Gtrain,XtrainFake(:,2401:3000),Gtest );
q = 1326;

fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])
%         figure();plot(XtrainFake(100,2500:2900))

%% 
[U,S,V] = svd(X,'econ');
diagS = diag(S)/sum(S(:));
[Us,Ss,Vs] = svd(Xstrain,'econ');
diagSs = diag(Ss)/sum(Ss(:));


% figSub1A = figure('Position',[100,100,800,900]);
for j = 1:fixPar.rmodes
    
    subplot(10,6,j*2-1)
        pcolor( reshape(U(:,j),26,51)  )
        axis off 
    subplot(10,6,j*2)
        plot(1:100,V(2901:3000,j));
        hold on
        plot(101:200,V(3001:3100,j))
        axis off 
end
tightfig
saveas(figSub1A,['figs' filesep 'Figure_S1A' parameterSetName '.png'])
if svg_save == true
    saveas(figSub1A,['figs' filesep 'Figure_S1A' parameterSetName '.svg'])
end

% [Ustrain,Sstrain,Vstrain]=svd(Xstrain,'econ');
figSub1B = figure('Position',[100,100,800,900]);
for j = 1:fixPar.rmodes
    subplot(10,6,j*2-1)
        pcolor( reshape(Us(:,j),26,51)  )
        axis off 
    subplot(10,6,j*2)
        plot(1:100,Vs(2901:3000,j));
        hold on
        plot(101:200,Vs(3001:3100,j))
        axis off 
end
tightfig
saveas(figSub1B,['figs' filesep 'Figure_S1B' parameterSetName '.png'])
if svg_save == true
    saveas(figSub1B,['figs' filesep 'Figure_S1B' parameterSetName '.svg'])
end
%% 
% figure('Position',[100,100,800,900])
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


% saveas(fig2B,['figs' filesep 'Figure2B_' parameterSetName '.png'])


%% Show quantities of interest 
figSub2 = figure();
    semilogy(diagS(1:30),'o')
    hold on
    semilogy(diagSs(1:30),'*')
    xlabel('mode index')
    ylabel('singular value s(j)/sum(s)')
    legend('neurally filtered strain','strain')
saveas(figSub2 ,['figs' filesep 'Figure_S2' parameterSetName '.png'])
    
if svg_save == true
    saveas(figSub2,['figs' filesep 'Figure_S2' parameterSetName '.svg'])
end
%% 
figSub3 = figure();
subplot(211) 
    plot( abs(w_r) );
    hold on 
    plot(big_modes, -0.2*ones(1,length(big_modes)),'*')
    
subplot(212) 
    plot( abs(w_r.*singValsR) );
    hold on 
    plot(big_modes, zeros(1,length(big_modes)),'o')
    
%     plot( big_modes, abs(w_t4),'*')
    

%     saveas(figSub3,['figs' filesep 'Figure2B_' parameterSetName '.png'])
%%     
figSub4= figure();
    plot( abs(s) )
    hold on
    plot([1,1326],cutoff_lim*[1,1],'k--','LineWidth',1)
%     plot(- abs(s4) )
%     plot([1,1326],-cutoff_lim4*[1,1],'k--','LineWidth',1)
    plot(sensors, zeros(1,length(sensors)),'*')
%     plot(sensors4, zeros(1,length(sensors4)),'*')
    legend('delay 4','theshold 4','Location','NorthEastOutside')
    

    
% saveas(figSub4,['figs' filesep 'Figure2B_' parameterSetName '.png'])
    