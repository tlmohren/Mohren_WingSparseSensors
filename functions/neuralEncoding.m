function [ X,G ] = neuralEncoding( strainSet,fixPar ,varPar)
%[ X,G ] = neuralEncoding( strainSet,par ) 
%   Takes strain data and uses specified
%   parameters [par] to generate [Pfire], here called [X], and specifies
%   the class belonging to the first half and second half of X, called [G].
%   Created: 2017/??/??  (TLM)
%   Last updated: 2017/07/03  (TLM)
    
% Obtain fieldnames in the structure strainSet (expected to be  strain_0,strain_10
    fn = fieldnames(strainSet); 
    
% create empty matrices to fill later 
    G = [];
% define neural filters 
    STAt = -39:0;   
    STAFunc = @(t) cos( varPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varPar.STAwidth.^2);
    STAfilt = STAFunc( STAt ) ; 

    if varPar.NLDgrad <=1
        NLD = @(s)  heaviside(0.5*s-varPar.NLDshift+0.5).*(0.5*s-varPar.NLDshift+0.5) ...
           -heaviside(0.5*s-varPar.NLDshift-1+0.5).*(0.5*s-varPar.NLDshift-1+0.5);
    elseif varPar.NLDgrad >= 25
        NLD = @(s) heaviside( 0.5*s - 0.5*varPar.NLDshift) ;
    else
        NLD = @(s) ( 1./ (1+ exp(-varPar.NLDgrad.*(s-varPar.NLDshift)) ) - 0.5) + 0.5; 
    end
    
    figure(101);
        subplot(121)
        plot(STAt,STAfilt);hold on;drawnow
        subplot(122)
        plot(-1:0.01:1,NLD(-1:0.01:1));hold on;drawnow; grid on

    % Remove startup phase from strain, but leave a piece the lenght of the
    % match filter to obtain correct output length
    n_conv = ( fixPar.simStartup*fixPar.sampFreq +2 -length(STAt) )...
            : fixPar.simEnd*fixPar.sampFreq;
    n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq;
%        strainMat = [strainSet.(fn{1})(n_conv) ;strainSet.(fn{2})(n_conv) ];
%       normalize_strain2 = max(strainMat(:))
    convMat = [];
    for j = 1:numel(fn)
        [m,~] = size( strainSet.(fn{j}) );
        strainConv = zeros(m,n_out);
   % Part1) For each individual sensor, convolve strain with match filter over time
        for jj = 1:m
            strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv)  , (STAfilt),'valid');
        end
        convMat = [convMat , strainConv];
%             % For each iteration, a class of magnitude j is added to G
        Gtemp = ones(1, n_out);
        G = [G Gtemp*j];
    end


%        normalize_strain = max(convMat(:))
%        calib = max(std(convMat'))

%     % Part2) The calibrated filtered signal is padded through the Non-linear function
    X = NLD( convMat/fixPar.normalizeVal );


    tSet =2500:3000;
    figure()
    subplot(321)
    plot(strainSet.(fn{j})(1000,tSet))
    subplot(323)
    plot(strainConv(1000,tSet))
    subplot(325)
    plot(X(1000,tSet))

    subplot(322)
    plot(strainSet.(fn{j})(1,tSet))
    subplot(324)
    plot(strainConv(1,tSet))
    subplot(326)
    plot(X(1,tSet))
        
        
end
