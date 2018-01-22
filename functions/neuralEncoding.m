function [ X,G ] = neuralEncoding( strainSet,fixPar ,varPar)
%[ X,G ] = neuralEncoding( strainSet,fixPar,varPar ) 
%   Takes strain data and uses specified
%   parameters [par] to generate [Pfire], here called [X], and specifies
%   the class belonging to the first half and second half of X, called [G].
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
G = [];
fn = {'strain_0','strain_10'};
    
% define neural filters 
[STAFunc,NLDFunc ] = createNeuralFilt(fixPar,varPar);

if fixPar.subSamp == 1
    STAt = -39:0;   
else
    STAt = linspace(-39,0,40*fixPar.subSamp);
end
STAfilt = STAFunc( STAt) ; 

% Remove startup phase from strain, but leave a piece the lenght of the
convMat = [];
n_conv = ( fixPar.simStartup  *fixPar.sampFreq*fixPar.subSamp +2 -length(STAt) )...
        : fixPar.simEnd*fixPar.sampFreq*fixPar.subSamp;
n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq*fixPar.subSamp;
t = (1:size(strainSet.(fn{1}),2))/fixPar.sampFreq;
tNew = linspace(t(1),t(end),size(strainSet.(fn{1}),2)*fixPar.subSamp);
m = size(strainSet.(fn{1}),1);

% Part1) For each individual sensor, convolve strain with match filter over time.
for j = 1:numel(fn)
%         [m,~] = size( strainSet.(fn{j}) );
    strainConv = zeros(m,n_out);
    for jj = 1:m
        if fixPar.subSamp == 1
            strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv)  , (STAfilt),'valid');
        else
            strainSub = interp1(t,strainSet.(fn{j})(jj,:),tNew,'spline');
            strainConv(jj,:) = conv(  strainSub(n_conv)  , STAfilt,'valid');
        end
    end
    convMat = [convMat , strainConv];
    Gtemp = ones(1, n_out); % For each iteration, a class of magnitude j is added to G
    G = [G Gtemp*j];
end

% Part2) The calibrated filtered signal is padded through the Non-linear function
X = NLDFunc( convMat/fixPar.normalizeVal/fixPar.subSamp );
if fixPar.determineNorm == 1
    X.tempNorm = max(convMat(:));
end

