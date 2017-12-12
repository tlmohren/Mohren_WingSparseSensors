function [Cinterp ] = colorSchemeInterp( colorScheme, nInterp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% strain_data = purpWhiteGreen ;
% x = 
% figure()
% plot(x,purpleStrain)
% 
% x = 1:;

[nOrig,~] = size(colorScheme);

% nOrig = length(strain_data );

% nNew = 15

xOrig = 1:nOrig;
xInterp = linspace(1,nOrig,nInterp);
Cinterp = zeros(nInterp,3);

%     figure();
    for j = 1:3
        Cinterp(:,j) = interp1(xOrig, colorScheme(:,j), xInterp);
%     %     Cinterp = Cfun(xInterp)
%         plot(xOrig,colorScheme(:,j) )
%         hold on
%         plot(xInterp,Cinterp(:,j) ,'o')
    end
end

