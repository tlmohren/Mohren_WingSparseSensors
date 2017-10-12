function tests = test_randcrossval
    tests = functiontests(localfunctions);
end

% test if input errors are triggered 
function testUnevenError(testCase)
    X = [ones(2,100) , 3*ones(2,99) ];
    G = [ones(1,100) , 2* ones(1,99) ];
    trainRatio = 0.6;
    testCase.verifyError(@()randCrossVal(X, G, trainRatio),'randCrossVal:XMustBeEven')
end

function testMinimumClasses(testCase)
    X = [ones(2,100) ];
    G = [ones(1,100)];
    trainRatio = 0.6;
    testCase.verifyError(@()randCrossVal(X, G, trainRatio),'randCrossVal:GhasLessThanTwoClasses','G has less than two classes.')
end

% test if output matches expected values
function testInputOutput2D(testCase)
    X = [ones(2,100) , 3*ones(2,100) ];
    G = [ones(1,100) , 2* ones(1,100) ];
    trainRatio = 0.6;
    [actTrainData, actTestData, actGtrain, actGtest] = randCrossVal(X, G, trainRatio);

    expTrainData = [ones(2,100*trainRatio) , 3*ones(2,100*trainRatio) ];
    expTestData = [ones(2,100*(1-trainRatio)) , 3*ones(2,100*(1-trainRatio)) ];
    expGtrain = [ones(1,100*trainRatio) , 2*ones(1,100*trainRatio) ];
    expGtest = [ones(1,100*(1-trainRatio)) , 2*ones(1,100*(1-trainRatio)) ];
    
    verifyEqual(testCase,actTrainData,expTrainData)
    verifyEqual(testCase,actTestData,expTestData)
    verifyEqual(testCase,actGtrain,expGtrain)
    verifyEqual(testCase,actGtest,expGtest)
end

function testInputOutput3D(testCase)
    X = [ones(2,100) , 3*ones(2,100), 5*ones(2,100)  ];
    G = [ones(1,100) , 2* ones(1,100), 3* ones(1,100) ];
    trainRatio = 0.6;
    [actTrainData, actTestData, actGtrain, actGtest] = randCrossVal(X, G, trainRatio);

    expTrainData = [ones(2,100*trainRatio) , 3*ones(2,100*trainRatio)  , 5*ones(2,100*trainRatio)];
    expTestData = [ones(2,100*(1-trainRatio)) , 3*ones(2,100*(1-trainRatio)), 5*ones(2,100*(1-trainRatio)) ];
    expGtrain = [ones(1,100*trainRatio) , 2*ones(1,100*trainRatio), 3*ones(1,100*trainRatio)  ];
    expGtest = [ones(1,100*(1-trainRatio)) , 2*ones(1,100*(1-trainRatio)), 3*ones(1,100*(1-trainRatio)) ];
    
    verifyEqual(testCase,actTrainData,expTrainData)
    verifyEqual(testCase,actTestData,expTestData)
    verifyEqual(testCase,actGtrain,expGtrain)
    verifyEqual(testCase,actGtest,expGtest)
end