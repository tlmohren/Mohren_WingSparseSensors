% TLM 2017/XX/XX

% starts test
function tests = test_classify_nc
    tests = functiontests(localfunctions);
end

% test if input verification is triggered 
function testInputVerificationError(testCase)
    X = [1,1];
    Phi = [1,2];
    centroid = [-1,1];
    w = 'a';
    testCase.verifyError(@() classify_nc(X, Phi, w, centroid),'MATLAB:InputParser:ArgumentFailedValidation')
end
% 
% % test if input combination errors are triggered 
% function testInputCombinationError(testCase)
% %     X = [ones(2,100) , 3*ones(2,99) ];
% %     G = [ones(1,100) , 2* ones(1,99) ];
% %     trainRatio = 0.6;
% %     testCase.verifyError(@()predictTrain(X, G, trainRatio),'randCrossVal:XMustBeEven')
% end
% 
% function testStandardCase(testCase)
% %     X = [ones(2,100) , 3*ones(2,100) ];
% %     G = [ones(1,100) , 2* ones(1,100) ];
% %     trainRatio = 0.6;
% %     [actTrainData, actTestData, actGtrain, actGtest] = predictTrain(X, G, trainRatio);
% % 
% %     expTrainData = [ones(2,100*trainRatio) , 3*ones(2,100*trainRatio) ];
% %     expTestData = [ones(2,100*(1-trainRatio)) , 3*ones(2,100*(1-trainRatio)) ];
% %     expGtrain = [ones(1,100*trainRatio) , 2*ones(1,100*trainRatio) ];
% %     expGtest = [ones(1,100*(1-trainRatio)) , 2*ones(1,100*(1-trainRatio)) ];
% %     
% %     verifyEqual(testCase,actTrainData,expTrainData)
% %     verifyEqual(testCase,actTestData,expTestData)
% %     verifyEqual(testCase,actGtrain,expGtrain)
% %     verifyEqual(testCase,actGtest,expGtest)
% end
