%

clear all, close all, clc
addpathFolderStructure()

x = 1:30;

modelfun = @(c,x)( c(1) + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
betaTrue = [0.7;0.4;15;2];

y = modelfun(betaTrue,x) + randn(1,length(x))*0.03;

opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';
% Fit the nonlinear model using the robust fitting options.


modelfunStrict = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
beta0 = [0.5;1;1;1];
beta = nlinfit(x,y,modelfunStrict,beta0,opts)

figure();
plot(y)
hold on 
plot(x,modelfunStrict(beta,x))

legend('noisy sigmoid','recovered sigmoid','Location','Best')


