function [ X,G ] = neuralEncoding( strainSet,par )
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
    
    
    if ~(par.STAwidth == 0 && par.NLDsharpness == 0)
    
    % define neural filters 
        par.STAt = -39:0;   
         
        par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
            ./ (2*par.STAwidth ^2) ) ...
            ./ (sqrt(3*par.STAwidth) *pi^1/4)...
            .* ( 1-(t-par.STAshift).^2/par.STAwidth^2);
        par.STAfilt = par.STAFunc(par.STAt);   
%         figure(100);plot(par.STAfilt);hold on;drawnow

        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
%         figure(101);plot(par.NLD(-1:0.01:1));hold on;drawnow; grid on
    
% apply neural encoding to strain, one rotation rate at a time 
        for j = 1:numel(fn)
            % Remove startup phase from strain, but leave a piece the lenght of the
            % match filter to obtain correct output length
            [m,~] = size( strainSet.(fn{j}) ); 
            n_conv = ( par.simStartup*par.sampFreq +2 -length(par.STAt) )...
                : par.simEnd*par.sampFreq;

            % initialize output
            n_out = (par.simEnd-par.simStartup) * par.sampFreq ;
            strainConv = zeros(m,n_out);

            % Part1) For each individual sensor, convolve strain with match filter over time

    %         n_conv
            for jj = 1:m
                strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv) , (par.STAfilt),'valid');

            end
    %         jj
            % Part2) The calibrated filtered signal is padded through the Non-linear function
            calib = max( strainConv(:) );
            X = [X  par.NLD( strainConv/calib ) ];

            % For each iteration, a class of magnitude j is added to G
            Gtemp = ones(1, n_out);
            G = [G Gtemp*j];

        end
    else
        % set filter to zero
        for j = 1:numel(fn)
            strainDat = strainSet.(fn{j})(:,(par.simStartup*par.sampFreq+1 :par.simEnd*par.sampFreq ) ); 
            calib = max(strainDat (:) );
            X = [X  , strainDat   /calib  ];
            Gtemp = ones(1, size(strainDat ,2)   );
            G = [G Gtemp*j];
        end
    end
    
    if par.setBaseZero == 1
        X(1:par.chordElements,:) = 0;
    end
end
