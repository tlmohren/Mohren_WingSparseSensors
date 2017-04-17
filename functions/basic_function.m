function [ sensors,accuracy,q ] = basic_function( X,G,r,SSPOC_on,varargin )
%UNTITLED2 Summary of this function goes here
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
p.addParameter('trainratio', 0.8, @(x)isnumeric(x));
p.KeepUnmatched = true;
p.parse(X,G,r,SSPOC_on, varargin{:})
inp = p.Results ;

n =  size(inp.X,1);
classes = unique(inp.G); 
c = numel(classes); 

if inp.fulltrain == 1
    Xtrain = inp.X;
    Xtest = inp.X;
    Gtrain = inp.G;
    Gtest = inp.G; 
else
    [Xtrain, Xtest, Gtrain, Gtest] = rand_cross_val(inp.X, inp.G,inp.trainratio);
end 

% LDA
[w, Psi, centroid] = PCA_LDA(Xtrain, Gtrain, 'nFeatures',r);

if inp.diagnostic == 1
   figure()
   plot(w,'o-b')
   size(w)
end

s = SSPOC(Psi,w);
s = sum(s, 2);    
if SSPOC_on 
    [~, I_top] = sort( abs(s));
    I_top2 = flipud(I_top);
    sensors_sort = I_top2(1:r);
    
    cutoff_lim = norm(s, 'fro')/c/r/2;
    sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
    if inp.early_cutoff > 0 && inp.early_cutoff <= length(sensors)
        display('checked')
%         s(sensors)
        sensors = sensors_sort(1:inp.early_cutoff);
%         s(sensors)
%         sensors = sensors(end-early_cutoff:end);
    end
else
    randloc = randperm(n);
    sensors = randloc(1:r);
    if inp.early_cutoff > 0 && inp.early_cutoff <= length(sensors)
        sensors = sensors(1:inp.early_cutoff);
    end
end;   

    
    
q = numel(sensors);
sensor_imp = s(sensors );
cutoff_lim = norm(s, 'fro')/c/r/2;

% (abs(sensor_imp) >= cutoff_lim)


Phi = zeros(q, n);                                      % construct the measurement matrix Phi
for qi = 1:q,
    Phi(qi, sensors(qi)) = 1;
end;

% #####################    
if inp.diagnostic == 1
    run('R1_diagnostic_sensorlocs')  
end
% #####################    

% learn new classifier for sparsely measured data
w_sspoc= LDA_n(Phi * Xtrain, Gtrain);
Xcls = w_sspoc' * (Phi * Xtrain);

% compute centroid of each class in classifier space
centroid = zeros(c-1, c);
for i = 1:c, 
    centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
end;

% use sparse sensors to classify X
cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
accuracy =  sum(cls == Gtest)/numel(cls);

% centroid

% print classification accuracy
% fprintf('Classification accuracy of %i SSPOC sensors is %g.\n',...
%     q, accuracy);
display('got here')
% #####################
if inp.diagnostic == 1 
    run('R1_diagnostic_classification')
end
% #####################

end

