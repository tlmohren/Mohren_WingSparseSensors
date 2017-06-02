%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
clear all, close all, clc
addpathFolderStructure()
%  Build struct with parameters to carry throughout simulation
par = setParameters;
[varParList,varParList_short] = setVariableParameters_CVXtestscript(par);
par.varParNames = fieldnames(varParList);
for k = 1:length(par.varParNames)
    par.(par.varParNames{k}) = varParList(1).(par.varParNames{k});
end
par.SSPOCon = 1;
par.rmodes = 40;
%%%%%%%%%%%%%%%%
par.iter = 5;
par.wTrunc = 16;
par.simEnd = 4;
par.trainFraction = 0.9;
par.saveNameTest = 'formulate_original';par.CVXcase = 1; % original formulation
% par.saveNameTest = 'formulate_equality'; par.CVXcase = 2; % equality
% par.saveNameTest = 'adjust_epsilon'; par.CVXcase = 3; % epsilon
% par.saveNameTest = 'adjust_lambda'; par.CVXcase = 4; % equality
%%%%%%%%%%%%%%%%
  % 
load(['data' filesep 'testX_Xtrain_Classifying.mat'])
% load(['data' filesep 'testX_Xtrain_notClassifying.mat'])

resultStruct = [];
%% 
figure('position',[100,100,600,1000])
for j = 1:par.iter
%     strainSet = eulerLagrangeConcatenate( par.theta_dist , par.phi_dist ,par);
% % %     % Apply neural filters to strain --------------------------
%     [X,G] = neuralEncoding(strainSet, par );
% % %     % Find accuracy and optimal sensor locations  ---------
%     [resultStruct(j).Xtrain, resultStruct(j).Xtest,...
%         resultStruct(j).Gtrain, resultStruct(j).Gtest] = ...
%         rand_cross_val(X, G, par.trainFraction);
%         [resultStruct(j).Xtrain, resultStruct(j).Xtest,      resultStruct(j).Gtrain, resultStruct(j).Gtest] = ...
%         randCrossVal(X, G, par.trainFraction);
    [resultStruct(j).Xtrain, resultStruct(j).Xtest,      resultStruct(j).Gtrain, resultStruct(j).Gtest] = ...
        randCrossVal(X, G, par.trainFraction);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%Xtrain%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     sensors = sensorLocSSPOC_CVXtest(resultStruct(j).Xtrain,resultStruct(j).Gtrain,par);
    sensors = [859,1319,1274,988,1301,1067,547,1318,261,286,27,442,52];
    
    q = length(sensors);
    
    acc = sensorLocClassify(  sensors,...
        resultStruct(j).Xtrain,resultStruct(j).Gtrain,...
        resultStruct(j).Xtest,resultStruct(j).Gtest  );
    fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])    
    resultStruct(j).sensors = sensors;
    resultStruct(j).acc = acc;

    
%     sensors'
    binar = zeros(26*51,1);
    binar(sensors)=1;
    subplot( ceil(par.iter/2),2,j)
    plotSensorLocs(binar,par)
    title(['iteration: ',num2str(j)])
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%Corerct answers%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     sensors = sensorLocSSPOC_CVXtest(resultStruct(j).Xtrain,resultStruct(j).Gtrain,par);
%     q = length(sensors);
% %     sensors = [859,1319,1274,988,1301,1067,547,1318,261,286,27,442,52];
%     sensors = [1301;1326;1316;1274;911;443;52;1233;58;313;157;183;703;45;73;885];
%     acc = sensorLocClassify(  sensors,...
%         resultStruct(j).Xtrain,resultStruct(j).Gtrain,...
%         resultStruct(j).Xtest,resultStruct(j).Gtest );
%     fprintf('correct,W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])    
%    acc = sensorLocClassify(  sensors,...
%         resultStruct(j).Xtest,resultStruct(j).Gtest,...
%         resultStruct(j).Xtrain,resultStruct(j).Gtrain);
%     fprintf('correct2,W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])    
%  acc = sensorLocClassify(  sensors,...
%         resultStruct(j).Xtrain,resultStruct(j).Gtrain,...
%         resultStruct(j).Xtrain,resultStruct(j).Gtrain);
%     fprintf('correct3,W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])    
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end


%% 
% save(['data' filesep 'CVXtest_resultStruct.mat'],'resultStruct')


% %%
% % selectRuns = [1,5,6];
% selectRuns = [2:6,9]; % only good ones 
% % selectRun
% figure()
% subplot(211)
% for j = 1:length(selectRuns)
%     k = selectRuns(j);
%     [U,S,V] = svd(resultStruct(k).Xtrain,'econ');
%     semilogy(diag(S),'o')
%     axis([0,30,S(30,30)*0.5,max(S(:))])
%     hold on
% end
% subplot(212)
% for j = 1:length(selectRuns)
%     k = selectRuns(j);
%     [U,S,V] = svd(resultStruct(k).Xtest,'econ');
%     semilogy(diag(S),'o')
%     axis([0,30,S(30,30)*0.5,max(S(:))])
%     hold on
% end
    
