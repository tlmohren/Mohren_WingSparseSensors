% TLM 2017/10/12  

% starts test
function tests = test_predictTrain
    tests = functiontests(localfunctions);
end
% test if input verification is triggered 
function testInputVerificationError(testCase)
    X = [1,1];
    G = [1,2];
    trainRatio = 1.1;
    testCase.verifyError(@()predictTrain(X, G, trainRatio),'MATLAB:InputParser:ArgumentFailedValidation')
end

% test if input errors are triggered 
function testUnevenError(testCase)
    X = [ones(2,100) , 3*ones(2,99) ];
    G = [ones(1,100) , 2* ones(1,99) ];
    trainRatio = 0.6;
    testCase.verifyError(@()predictTrain(X, G, trainRatio),'randCrossVal:XMustBeEven')
end
% 
% test if minimum number of classes error is triggered 
function testMinimumClasses(testCase)
    X = [ones(2,100) ];
    G = [ones(1,100)];
    trainRatio = 0.6;
    testCase.verifyError(@()predictTrain(X, G, trainRatio),'randCrossVal:GhasLessThanTwoClasses','G has less than two classes.')
end

% test if 2 class output matches expected values
function testInputOutput2D(testCase)
    X = [ones(2,100) , 3*ones(2,100) ];
    G = [ones(1,100) , 2* ones(1,100) ];
    trainRatio = 0.6;
    [actTrainData, actTestData, actGtrain, actGtest] = predictTrain(X, G, trainRatio);

    expTrainData = [ones(2,100*trainRatio) , 3*ones(2,100*trainRatio) ];
    expTestData = [ones(2,100*(1-trainRatio)) , 3*ones(2,100*(1-trainRatio)) ];
    expGtrain = [ones(1,100*trainRatio) , 2*ones(1,100*trainRatio) ];
    expGtest = [ones(1,100*(1-trainRatio)) , 2*ones(1,100*(1-trainRatio)) ];
    
    verifyEqual(testCase,actTrainData,expTrainData)
    verifyEqual(testCase,actTestData,expTestData)
    verifyEqual(testCase,actGtrain,expGtrain)
    verifyEqual(testCase,actGtest,expGtest)
end

% test if 3 class output matches expected values 
function testInputOutput3D(testCase)
    X = [ones(2,100) , 3*ones(2,100), 5*ones(2,100)  ];
    G = [ones(1,100) , 2* ones(1,100), 3* ones(1,100) ];
    trainRatio = 0.6;
    [actTrainData, actTestData, actGtrain, actGtest] = predictTrain(X, G, trainRatio);

    expTrainData = [ones(2,100*trainRatio) , 3*ones(2,100*trainRatio)  , 5*ones(2,100*trainRatio)];
    expTestData = [ones(2,100*(1-trainRatio)) , 3*ones(2,100*(1-trainRatio)), 5*ones(2,100*(1-trainRatio)) ];
    expGtrain = [ones(1,100*trainRatio) , 2*ones(1,100*trainRatio), 3*ones(1,100*trainRatio)  ];
    expGtest = [ones(1,100*(1-trainRatio)) , 2*ones(1,100*(1-trainRatio)), 3*ones(1,100*(1-trainRatio)) ];
    
    verifyEqual(testCase,actTrainData,expTrainData)
    verifyEqual(testCase,actTestData,expTestData)
    verifyEqual(testCase,actGtrain,expGtrain)
    verifyEqual(testCase,actGtest,expGtest)
end