function [ X,G] = neuralEncoding( strainSet,par)
%neuralEncoding Convert strain to Pfire
%   [X,G] = neuralEncoding(strain,par) takes strain data and uses specified
%   parameters [par] to generate [Pfire], here called [X], and specifies
%   the class belonging to the first half and second half of X, called [G].
%   TLM 2017 
    
% Obtain fieldnames in the structure strainSet (expected to be
% strain_0,strain_10
    fn = fieldnames(strainSet); 
    
% create empty matrices to fill later 
    X = [];
    G = [];

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
        for jj = 1:m
            strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv) , (par.STAfilt),'valid');
            
        end
        % Part2) The calibrated filtered signal is padded through the Non-linear function
        calib = max( strainConv(:) );
        X = [X  par.NLD( strainConv/calib ) ];
        
        % For each iteration, a class of magnitude j is added to G
        Gtemp = ones(1, n_out);
        G = [G Gtemp*j];
        
    end
    
end

%% notes
        % not sure yet if I need to convolve 
        % also, is flip necessary
%         Xtemp(jj,:) = conv(strain(jj,:), fliplr(STA_filt),'valid');