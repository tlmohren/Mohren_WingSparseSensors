%

clear all, close all, clc
addpathFolderStructure()

x = 1:30;

modelfun = @(c,x)( c(1) + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
betaTrue = [0.5;0.4;15;2];

y = modelfun(betaTrue,x) + randn(1,length(x))*0.03;

opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';
% Fit the nonlinear model using the robust fitting options.

beta0 = [1;1;1;1];
beta = nlinfit(x,y,modelfun,beta0,opts)

figure();
plot(y)
hold on 
plot(x,modelfun(beta,x))

legend('noisy sigmoid','recovered sigmoid','Location','Best')


