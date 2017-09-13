function [ X,G ] = neuralEncoding( strainSet,fixPar ,varPar)
%[ X,G ] = neuralEncoding( strainSet,par ) 
%   Takes strain data and uses specified
%   parameters [par] to generate [Pfire], here called [X], and specifies
%   the class belonging to the first half and second half of X, called [G].
%   Created: 2017/??/??  (TLM)
%   Last updated: 2017/07/03  (TLM)
    
    G = [];
    fn = {'strain_0','strain_10'};
    
% define neural filters 
    [STAFunc,NLDFunc ] = createNeuralFilt(fixPar,varPar);
    
%-----------------------------------------------
%     STAFunc = @(t) cos( varPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varPar.STAwidth.^2);
%     if varPar.NLDgrad <=1
%         NLDFunc = @(s)  heaviside(0.5*s-varPar.NLDshift+0.5).*(0.5*s-varPar.NLDshift+0.5) ...
%            -heaviside(0.5*s-varPar.NLDshift-1+0.5).*(0.5*s-varPar.NLDshift-1+0.5);
%     elseif varPar.NLDgrad >= 25
%         NLDFunc = @(s) heaviside( 0.5*s - 0.5*varPar.NLDshift) ;
%     else
%         NLDFunc = @(s) ( 1./ (1+ exp(-varPar.NLDgrad.*(s-varPar.NLDshift)) ) - 0.5) + 0.5; 
%     end
%-----------------------------------------------


    if fixPar.subSamp == 1
        STAt = -39:0;   
    else
    STAt = linspace(-39,0,40*fixPar.subSamp);
    end
    STAfilt = STAFunc( STAt ) ; 
    figure(101);
        subplot(121)
        plot(STAt,STAfilt);hold on;drawnow
        subplot(122)
        plot(-1:0.01:1,NLDFunc(-1:0.01:1));hold on;drawnow; grid on

    % Remove startup phase from strain, but leave a piece the lenght of the
        convMat = [];
%     if fixPar.subSamp == 1
%         n_conv = ( fixPar.simStartup  *fixPar.sampFreq*fixPar.subSamp +2 -length(STAt) )...
%                 : fixPar.simEnd*fixPar.sampFreq*fixPar.subSamp;
%         n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq*fixPar.subSamp;
%         t = (1:size(strainSet.(fn{1}),2))/fixPar.sampFreq;
%         
%     else
    n_conv = ( fixPar.simStartup  *fixPar.sampFreq*fixPar.subSamp +2 -length(STAt) )...
            : fixPar.simEnd*fixPar.sampFreq*fixPar.subSamp;
    n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq*fixPar.subSamp;
    t = (1:size(strainSet.(fn{1}),2))/fixPar.sampFreq;
    tNew = linspace(t(1),t(end),size(strainSet.(fn{1}),2)*fixPar.subSamp);
%     end
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

%     fixPar.normalizeVal
%     fixPar.normalizeVal = tempNorm;
    X = NLDFunc( convMat/fixPar.normalizeVal/fixPar.subSamp );

    
    if fixPar.determineNorm == 1
        X.tempNorm = max(convMat(:));
    end
    
%     tSet =2500:3000;
%     figure()
%     subplot(321)
%     plot(strainSet.(fn{j})(1000,tSet))
%     subplot(323)
%     plot(strainConv(1000,tSet))
%     subplot(325)
%     plot(X(1000,tSet))
% 
%     subplot(322)
%     plot(strainSet.(fn{j})(1,tSet))
%     subplot(324)
%     plot(strainConv(1,tSet))
%     subplot(326)
%     plot(X(1,tSet))
        
end
