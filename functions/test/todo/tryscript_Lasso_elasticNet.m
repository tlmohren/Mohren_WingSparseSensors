

% elastic net test case
% comparison to CVX

% m = 16; n = 30;
% A = randn(m,n);
% b = randn(m,1);
% 
% x_ls = A \ b;
% 
% cvx_begin quiet
%     variable x(n)
%     minimize( norm(x,1) )
%     norm(A*x - b, 'fro')
% cvx_end
% 
% x
% 
% figure();plot(x)
clc;clear all;close all

rng default % For reproducibility
n = 100;
m = 5;
Psi = randn(n,m);
% r = [0;2;0;-3;0]; % Only two nonzero coefficients
% r = [0.2;0.12;0.512;0.121;
 w= rand(m,1);

%%%% Psi *x = r 

% Y =  randn(100,1)*.1; % Small added noise

[s,param] = lasso(Psi',w);
% s = lasso(Psi',r,'alpha',0.01);

    alpha = 0.9;
sl = lasso(Psi',w,'alpha',alpha,'lambda',0.001);
% sl = lasso(Psi',w,'alpha',alpha,'lambda',0.001);
% B1 = lasso(X,Y);
% B2 = lasso(X,Y,'alpha', 0.01);

cvx_begin quiet
    variable s( n );
        minimize(   alpha*norm(s,1) + (1-alpha)*norm(s,2) );
%         minimize(   (1-alpha)*norm(s,1) + alpha*norm(s,2) );
    subject to
    Psi'*s == w;
cvx_end



figure()
%     subplot(211)
    plot(sl/norm(sl))
    hold on
    plot(s/norm(s))
    legend('lasso','CVX')
% subplot(212)
% plot(s)