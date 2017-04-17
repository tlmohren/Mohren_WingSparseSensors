function  [  sensors  ] = SensorLocSSPOCtest(   Xtrain,Gtrain,r,SSPOC_on,varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


p = inputParser;

% % required inputs
p.addRequired('X');
p.addRequired('G');
p.addRequired('r');
p.addRequired('SSPOC_on');
p.addParameter('diagnostic', 0, @(x)isnumeric(x));
p.addParameter('diagnostic_bingnorm', 0, @(x)isnumeric(x));
p.addParameter('early_cutoff', 0, @(x)isnumeric(x));
p.addParameter('fulltrain', 0, @(x)isnumeric(x));
p.addParameter('w_truncate',0, @(x)isnumeric(x));
p.KeepUnmatched = true;
p.parse(Xtrain,Gtrain,r,SSPOC_on, varargin{:})
inp = p.Results ;

n =  size(Xtrain,1);
classes = unique(Gtrain); 
c = numel(classes); 
% inp

if SSPOC_on == 1
% LDA
    [w, Psi, centroid] = PCA_LDA(Xtrain, Gtrain, 'nFeatures',r);

    if inp.w_truncate ~= 0 
        [~,Iw ] =sort( abs(w) , 'descend');
        %---optionlal-----------------------
            [~,Sigma, ~] = svd(Xtrain, 'econ' );
            sing_vals = diag(Sigma(1:length(w),1:length(w)));
            [~,Iw]=sort(abs(w).*sing_vals,'descend');  
        % -------------------------
        big_modes = Iw(1:inp.w_truncate);
        w = w(big_modes);
        Psi = Psi(:,big_modes);
    end
    
    
    
    s = SSPOC(Psi,w);
    s = sum(s, 2);   


    [~, I_top] = sort( abs(s));
    I_top2 = flipud(I_top);
    sensors_sort = I_top2(1:r);

    cutoff_lim = norm(s, 'fro')/c/r/2;
    sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
    
else
    randloc = randperm(n);
    sensors = randloc(1:r);
end

end

