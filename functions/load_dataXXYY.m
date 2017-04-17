function [ X,G] = load_data( files ,sta_1kHz, NLD, STA_on,varargin)
% ( files ,sta_1kHz, NLD,noise_ratio,STA_on)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


p = inputParser;

% % required inputs
p.addRequired('files');
p.addRequired('sta_1kHz');
p.addRequired('NLD');
p.addRequired('STA_on');
p.addParameter('diagnostic', 0, @(x)isnumeric(x));
p.KeepUnmatched = true;
p.parse(files,sta_1kHz,NLD,STA_on, varargin{:})
inp = p.Results ;

%     load data    
    X = [];
    G = [];
    Xtemp = [];
    for j = 1:length(inp.files)
%         load(['data\' inp.files{j}],'strain')
        
        load(['data' filesep files{j}],'strainx','strainy')
        
%     strainx = zeros(size(strainx)); 
        
        strain = [strainx(:,:), strainy(:,:)];
        [m,n] = size(strain(:,:));
    
    
        m = size(strain, 1);
        n = length(strain(1,:));
        Xtemp_lead = reshape(  strain(962:1000,:,:),39,n(1))';
        Xtemp = reshape(  strain(1001:end,:,:),3000,n(1))';
%         Xtemp = Xtemp + rand(size(Xtemp)).*max(Xtemp(:));
        Xtemp_filt = zeros(size(Xtemp));
        if inp.STA_on == 1
            for jj = 1:n
                Xtemp_filt(jj,:) = conv([Xtemp_lead(jj,:),Xtemp(jj,:)], fliplr(inp.sta_1kHz),'valid');
            end
        else 
            Xtemp_filt = Xtemp;
        end
        calib = max(Xtemp_filt(:));
        Xtemp_nld = NLD(Xtemp_filt ./calib );
        X = [X, Xtemp_nld];  
        G = [G j*ones(1,length(Xtemp))];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if inp.diagnostic == 1
        run('R1_diagnostic_filtereffect')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

