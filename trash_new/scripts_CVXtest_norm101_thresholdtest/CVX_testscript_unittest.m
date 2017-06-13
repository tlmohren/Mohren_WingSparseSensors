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
par.rmodes = 30;
par.simEnd = 4;

par.trainFraction = 0.8;
par.saveNameTest = 'formulate_original';par.CVXcase = 1; % original formulation
% par.saveNameTest = 'formulate_equality'; par.CVXcase = 2; % equality
% par.saveNameTest = 'adjust_epsilon'; par.CVXcase = 3; % epsilon
% par.saveNameTest = 'adjust_lambda'; par.CVXcase = 4; % equality

%%%%%%%%%%%%%%%%
par.iter = 1;
par.predictTrain = 1;


par.wTrunc = 6;
par.CVXcase = 8;
par.singValsMult = 1;

par.theta_dist = 0;
par.phi_dist = 0;

%%%%%%%%%%%%%%%%

% load(['data' filesep 'testX_Xtrain_notClassifying.mat'])        % 
load(['data' filesep 'testX_Xtrain_Classifying.mat'])

%% 
% figure('position',[100,100,400,1000])
for j = 1:par.iter
    par.curIter = j;
    
	% Generate new data --------------------------
    if 1
        strainSet = eulerLagrangeConcatenate_predictTrain( par.theta_dist , par.phi_dist , par);
        [ X,G ] = neuralEncoding(strainSet, par );
    end
	% Do new crossval --------------------------
    
        
    if par.predictTrain == 1
        [Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, par.trainFraction);
    else
        [Xtrain, Xtest, Gtrain, Gtest] = randCrossVal(X, G, par.trainFraction);
    end
%     save('testdata_SensorLocSSPOC_april.mat','Xtrain','Gtrain','par')
	%-----------2 sec train, 1 sec test 

    
    sensors = sensorLocSSPOC_CVXtest( Xtrain, Gtrain,par);
%     sensors = [859,1319,1274,988,1301,1067,547,1318,261,286,27,442,52];           % 13 sensors 
%     sensors = [1301;1326;1274;1316;911;443;52;157;1234;58;313;703;45;183];        %14 sensors 
%     sensors =[1301;1326;1316;1274;443;157;52;911;58;1234;313;45;885;729;703];     % 15 sensors
%     sensors = [1301;1326;1274;1316;911;157;443;52;58;1233;313;45;1259;703;729;74];   % 16 sensors 


    q = length(sensors);
    acc = sensorLocClassify(  sensors,  Xtrain, Gtrain, Xtest, Gtest  );
    fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])    
%     
%     binar = zeros(26*51,1);
%     binar(sensors)=1;
%     subplot( ceil(par.iter/2),2,j)
%     plotSensorLocs(binar,par)
%     title(['iteration: ',num2str(j)])
    
end


%% 
% save(['data' filesep 'CVXtest_resultStruct.mat'],'resultStruct')

    
