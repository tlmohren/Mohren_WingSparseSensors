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
par.iter = 2;
par.wTrunc = 19;
%%%%%%%%%%%%%%%%

% load(['data' filesep 'testX_Xtrain_notClassifying.mat'])        % 
load(['data' filesep 'testX_Xtrain_Classifying.mat'])

%% 
figure('position',[100,100,400,1000])
for j = 1:par.iter
    
	% Generate new data --------------------------
    if 0 
        strainSet = eulerLagrangeConcatenate( par.theta_dist , par.phi_dist ,par);
        [ X,G ] = neuralEncoding(strainSet, par );
    end
	% Do new crossval --------------------------
    
    Xtrain = []; 
    Xtest = [];
    Gtrain = []; 
    Gtest = [];
        
    if 0
        [ Xtrain,  Xtest, Gtrain,  Gtest] = randCrossVal(X, G, par.trainFraction);
    elseif 0
        for j = 1:length(unique(G)) % 2 classes 
            classData = X(:, G==j);
            classLength = size(classData,2);
            trainLength = floor(classLength * par.trainFraction);
            testLength = classLength - trainLength;
	%-----------wing cycle
            randIndices = randperm(classLength);
            
%             trainIndices = randIndices( 1:trainLength);
%             testIndices =  randIndices( trainLength+1:end) ;
            
%             phase_ind = [1:30,36:40]';
%             phase_ind = [1:40]';
            phase_ind = [1:10,21:30]';
            phase_indTest = [11:20,31:40]';
            
%             phase_ind = [11:20,31:40]';
            % 35 important 
            trainIndices = phase_ind*ones(1,75)+ones(length(phase_ind),1)*(0:40:2960);
            trainIndices = trainIndices(:);
            
            testIndices = phase_indTest*ones(1,75)+ones(length(phase_indTest),1)*(0:40:2960);
            testIndices = testIndices(:);
%             
%             
%             testIndices =  randIndices( 1:(classLength-length(trainIndices)) ) ;
%             testIndices = randIndices(1:1000);
            
%             ind_vec = 1:3000;
%             ind_vec(trainIndices(:)) 
%             testIndices = ind_vec(trainIndices(:)~=ind_vec);

            addTrainG = G( trainIndices + (j-1)*classLength);
            addTestG = G(testIndices+ (j-1)*classLength);
            Gtrain = [Gtrain addTrainG];
            Gtest = [Gtest addTestG];
            
            addTrainData = classData(:, trainIndices  );
            addTestData = classData(:,testIndices);
            Xtrain = [Xtrain addTrainData];
            Xtest = [Xtest addTestData];
        end
	%-----------2 sec train, 1 sec test 
    elseif 1
        par.trainFraction = 0.7;
        for j = 1:length(unique(G)) % 2 classes 
            classData = X(:, G==j);
            classLength = size(classData,2);
            trainLength = floor(classLength * par.trainFraction);
            testLength = classLength - trainLength;
	%-----------wing cycle
            
            trainIndices = 1:floor(classLength * par.trainFraction);
            testIndices =  (classLength-length(trainIndices)):classLength ;
            
            addTrainG = G( trainIndices + (j-1)*classLength);
            addTestG = G(testIndices+ (j-1)*classLength);
            Gtrain = [Gtrain addTrainG];
            Gtest = [Gtest addTestG];
            
            addTrainData = classData(:, trainIndices  );
            addTestData = classData(:,testIndices);
            Xtrain = [Xtrain addTrainData];
            Xtest = [Xtest addTestData];
        end
    end
    
    
    sensors = sensorLocSSPOC_CVXtest( Xtrain, Gtrain,par);
%     sensors = [859,1319,1274,988,1301,1067,547,1318,261,286,27,442,52];           % 13 sensors 
%     sensors = [1301;1326;1274;1316;911;443;52;157;1234;58;313;703;45;183];        %14 sensors 
%     sensors =[1301;1326;1316;1274;443;157;52;911;58;1234;313;45;885;729;703];     % 15 sensors
%     [1301;1326;1274;1316;911;157;443;52;58;1233;313;45;1259;703;729;74];          % 16 sensors 


    q = length(sensors);
    acc = sensorLocClassify(  sensors,  Xtrain, Gtrain, Xtest, Gtest  );
    fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.wTrunc,q,acc])    
    
    binar = zeros(26*51,1);
    binar(sensors)=1;
    subplot( ceil(par.iter/2),2,j)
    plotSensorLocs(binar,par)
    title(['iteration: ',num2str(j)])
    
end


%% 
% save(['data' filesep 'CVXtest_resultStruct.mat'],'resultStruct')

    
