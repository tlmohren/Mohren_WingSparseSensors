function [ X,G ] = neuralEncodingNewFilters( strainSet,fixPar ,varyPar)
%[ X,G ] = neuralEncoding( strainSet,par ) 
%   Takes strain data and uses specified
%   parameters [par] to generate [Pfire], here called [X], and specifies
%   the class belonging to the first half and second half of X, called [G].
%   Created: 2017/??/??  (TLM)
%   Last updated: 2017/07/03  (TLM)
    
% Obtain fieldnames in the structure strainSet (expected to be  strain_0,strain_10
    fn = fieldnames(strainSet); 
    
% create empty matrices to fill later 
    X = [];
    G = [];

% define neural filters 
    STAt = -39:0;   
    STAFunc = @(t) cos( varyPar.STAfreq*(t+ fixPar.STAdelay)  ).*exp(-(t+fixPar.STAdelay).^2 / varyPar.STAwidth.^2);
    STAfilt = STAFunc(STAt) / sum(STAFunc(STAt));   

    if varyPar.NLDgrad <=1
        NLD = @(s)  heaviside(0.5*s-varyPar.NLDshift+0.5).*(0.5*s-varyPar.NLDshift+0.5) ...
           -heaviside(0.5*s-varyPar.NLDshift-1+0.5).*(0.5*s-varyPar.NLDshift-1+0.5);
    elseif varyPar.NLDgrad >= 25
        NLD = @(s) heaviside( 0.5*s - 0.5*varyPar.NLDshift) ;
    else
        NLD = @(s) ( 1./ (1+ exp(-varyPar.NLDgrad.*(s-varyPar.NLDshift)) ) - 0.5) + 0.5; 
    end
    
%     figure(101);
%         subplot(121)
%         plot(STAt,STAfilt);hold on;drawnow
%         subplot(122)
%         plot(-1:0.01:1,NLD(-1:0.01:1));hold on;drawnow; grid on

    % calibrate strain 
% % % % % %     calib = max([strainSet.(fn{1})(:) ;strainSet.(fn{2})(:) ] );
% % % % % % 
% % % % % %     % apply neural encoding to strain, one rotation rate at a time 
% % % % % %     for j = 1:numel(fn)
% % % % % %         % Remove startup phase from strain, but leave a piece the lenght of the
% % % % % %         % match filter to obtain correct output length
% % % % % %         [m,~] = size( strainSet.(fn{j}) ); 
% % % % % %         n_conv = ( fixPar.simStartup*fixPar.sampFreq +2 -length(STAt) )...
% % % % % %             : fixPar.simEnd*fixPar.sampFreq;
% % % % % %         
% % % % % %         % initialize output
% % % % % %         n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq ;
% % % % % %         strainConv = zeros(m,n_out);
% % % % % %         for jj = 1:m
% % % % % %             strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv) / calib , (STAfilt),'valid');
% % % % % %         end
% % % % % %         
% % % % % %         X = [X  NLD( strainConv) ];
% % % % % %         Gtemp = ones(1, n_out);
% % % % % %         G = [G Gtemp*j];
% % % % % %     end
            for j = 1:numel(fn)
            % Remove startup phase from strain, but leave a piece the lenght of the
            % match filter to obtain correct output length
            [m,~] = size( strainSet.(fn{j}) ); 

        n_conv = ( fixPar.simStartup*fixPar.sampFreq +2 -length(STAt) )...
            : fixPar.simEnd*fixPar.sampFreq;
            % initialize output
        n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq ;
        strainConv = zeros(m,n_out);
            % Part1) For each individual sensor, convolve strain with match filter over time
            for jj = 1:m
                strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv) , (STAfilt),'valid');
            end
            % Part2) The calibrated filtered signal is padded through the Non-linear function
            calib = max( strainConv(:) );
            X = [X  NLD( strainConv/calib ) ];
            % For each iteration, a class of magnitude j is added to G
            Gtemp = ones(1, n_out);
            G = [G Gtemp*j];
        end
end
