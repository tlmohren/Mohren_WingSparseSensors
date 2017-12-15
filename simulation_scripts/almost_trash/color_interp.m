%


% designed_colors = 
clc;clear all;close all
purpleStrain = [ 255,247,243
253,224,221
252,197,192
250,159,181
247,104,161
221,52,151
174,1,126
122,1,119
73,0,106];

purpWhiteGreen = [118,42,131
153,112,171
194,165,207
231,212,232
247,247,247
217,240,211
166,219,160
90,174,97
27,120,55];
        
strain_data = purpleStrain;
strain_data = purpWhiteGreen ;
% x = 
% figure()
% plot(x,purpleStrain)
% 
% x = 1:;
nOrig = length(strain_data );

nNew = 15

xOrig = 1:nOrig
xInterp = linspace(1,nOrig,nNew)

    figure();
for j = 1:3
    Cinterp(:,j) = interp1(xOrig,strain_data(:,j),xInterp);
%     Cinterp = Cfun(xInterp)
    plot(xOrig,strain_data(:,j) )
    hold on
    plot(xInterp,Cinterp(:,j) ,'o')
end