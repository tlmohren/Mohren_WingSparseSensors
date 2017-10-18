% TLM 2017/10/13

% % % starts test
function tests = test_disturbanceCalibrate
    tests = functiontests(localfunctions);
end

function testInputVerificationError(testCase)
    example_fun = @(x) sin(x);
    testCase.verifyError(@() disturbanceCalibrate(example_fun  ),'disturbanceCalibrate:inputNotSymbolic')
end
