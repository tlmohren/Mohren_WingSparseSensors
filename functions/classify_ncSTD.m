function cls = classify_ncSTD(X, Phi, w, centroid, s_dev)
% function cls = classify_nc(X, Phi, w, centroid)
% nearest-centroid classifier
%
% INPUTS:
%
% X         
%           a [n x m] matrix of the raw data to be classified,
%           where there are m observations of n-dimensional vectors
%
% Phi   
%           a [q x n] measurement matrix
%           if the full n-dimensional states are to be used, set Phi = 1
%
% w         trained discrimination vector from LDA_n.m
%
% centroid  
%           the centroid of each class in w space
%           a [nFeatures x c] matrix
%
% OUTPUTS:
%
% cls       the class to which each observation belongs
%           a [1 x m] vector
%
% BWB, June 2015

% % % required inputs
p = inputParser; 
p.addRequired('X', @isnumeric);
p.addRequired('Phi', @isnumeric);
p.addRequired('w', @isnumeric);
p.addRequired('centroid', @isnumeric);
p.parse(X, Phi, w, centroid);
inputs = p.Results;

% % % determine combination input
[qPhi, ntotal] = size(Phi); %
[ntotalX, ntime] = size(X); %
[qw,~] = size(w); %
if ntotal ~= ntotalX  
   error('SSPOCelastic:DimensionPhiMismatchX','# of modes in Phi do not match # modes of X.') 
elseif qPhi ~= qw  
   error('SSPOCelastic:DimensionPhiMismatchw','# of sensors in Phi do not match length of w.') 
end




Xcls = w'*(Phi * X);

cls = zeros(1, size(Xcls,2));






centroid_dist = abs( centroid(1)-centroid(2) );
%     std_dist =  s_dev(1) +s_dev(2);
%     n_sdev = centroid_dist /std_dist;

a = s_dev(2)^-2 - s_dev(1)^-2;
b = 2*centroid(1) / s_dev(1)^2    -  2 *centroid(2) / s_dev(2)^2  ;
c = 2*log( ( s_dev(2)/s_dev(1)) ) + centroid(2)^2/s_dev(2)^2 - centroid(1)^2/s_dev(1)^2;

x_int(1) = (-b+sqrt(b^2-4*a*c))/(2*a);
x_int(2) = (-b-sqrt(b^2-4*a*c))/(2*a);

std_sep_I = find( (x_int>=min(centroid)) & (x_int<=max(centroid)) )
std_sep = x_int(std_sep_I)


[min_centroid,I] = min(centroid);
%     sep_line = min_centroid + n_sdev*s_dev(I);
mean_sep = min_centroid + centroid_dist/2;
if ~isempty(std_sep)
    sep_line = std_sep;
else
    sep_line = mean_sep;
end
classes = [1,2];
    
for i = 1:size(Xcls,2),
    if Xcls(:,i) <= sep_line
        cls(i) = I;
    elseif Xcls(:,i) > sep_line
        cls(i) = classes(classes ~= I);
    end
    
%     if Xcls(:,i) <= sep_line
%         cls(i) = 1;
%     elseif Xcls(:,i) > sep_line
%         cls(i) = 2;
%     end
%     D = centroid - repmat(Xcls(:,i), 1, size(centroid,2));
%     D = sqrt(sum(D.^2, 1));
%     D_std = D./s_dev;
% 
%     [~, cls(i)] = min(D_std);
end;

figure();
% plot(1:300,Xcls(1:300),'.r')
plot( find(cls == 1) , Xcls( (cls ==1) ),'r.')
hold on 
plot( find(cls == 2) , Xcls( (cls ==2) ),'b.')
% plot( 301:600 ,Xcls(301:600),'.b')
plot( [1,300], centroid(1)*[1,1] ,'k')
plot( [301,600], centroid(2)*[1,1] ,'k')
plot( [1,600], sep_line*[1,1] ,'k--')
plot( [1,600], mean_sep*[1,1] ,'k:')

% plot(