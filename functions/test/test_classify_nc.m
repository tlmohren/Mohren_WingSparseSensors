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
% test if input combination errors are triggered 
function testInputCombinationErrorPhiX(testCase)
    X = (-5:3)' *sin(2*pi*(0.05+(0:0.1:2)));
    Phi = zeros(2,10); Phi(1,3) = 1; Phi(2,8) =1;
    centroid = [-0.56, 0.615];
    w = [1;1];
    testCase.verifyError(@() classify_nc(X, Phi, w, centroid),'SSPOCelastic:DimensionPhiMismatchX')
end


function testInputCombinationErrorPhiW(testCase)
    X = (-5:4)' *sin(2*pi*(0.05+(0:0.1:2)));
    Phi = zeros(2,10); Phi(1,3) = 1; Phi(2,8) =1;
    centroid = [-0.56, 0.615];
    w = [1;1;2];
    testCase.verifyError(@() classify_nc(X, Phi, w, centroid),'SSPOCelastic:DimensionPhiMismatchw')
end



% 
function testStandardCase(testCase)
    X = (-5:4)' *sin(2*pi*(0.05+(0:0.1:2)));
    Phi = zeros(2,10); Phi(1,3) = 1; Phi(2,8) =1;
    centroid = [-0.56, 0.615];
    w = [1;1];
    
    actData = classify_nc(X, Phi, w, centroid);
    
    expData = ones(1,21); 
    expData([6:10,16:20])= 2;
    
    verifyEqual(testCase,actData,expData)
end
