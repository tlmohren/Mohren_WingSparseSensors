
function tests = test_SSPOC
    tests = functiontests(localfunctions);
end
function testUnevenError(testCase)
    X = [ones(2,100) , 3*ones(2,99) ];
    G = [ones(1,100) , 2* ones(1,99) ];
    trainRatio = 0.6;
    testCase.verifyError(@()randCrossVal(X, G, trainRatio),'randCrossVal:XMustBeEven')
end


% test if elastic net works on nyquist
function testNyquist(testCase)
    t_end       = 10;
    n           = 501;
    t           = linspace(0,t_end,n);              % time 
    f           = [3,7];
    signal      = sin( 2*pi*f(1)*t )+0.7*sin( 2*pi*f(2)*t );  % signal 
    bases       = dct(eye(n,n));                  % dct of diagonal mat
    dct_coeff   = bases\signal';                           % coefficients of dct 
    k           = (1:n)/(2*t_end);                    % frequency vector
    m           = 101;
    perm        = randintrlv(1:n,793);           % randomly ordered vector 
    sparse_signal = signal(perm(1:m));                       % random samples 
    Psi         = bases(perm(1:m),:);                      % random permutation of this 
    fixPar.elasticNet = 0.9;

    sparse_coeff = SSPOC(Psi',sparse_signal',fixPar);

    [~,I]   = sort(dct_coeff,'descend');
    [~,I3]  = sort(sparse_coeff,'descend');
    expFrequencies  = k(I(1:2));
    actFrequencies = k(I3(1:2));
    freq_amp = dct_coeff(I(1:2));
    sparse_freq_amp = sparse_coeff(I3(1:2));
    ratios =  abs( freq_amp ./ sparse_freq_amp );
    ratios_logic =  ratios <= 1.3; 

    verifyEqual(testCase,expFrequencies,actFrequencies)
    verifyLessThan(testCase, ratios(1), 1.3);
    verifyLessThan(testCase, ratios(2), 1.3);
end
