

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


rng default % For reproducibility
Psi = randn(100,5);
% r = [0;2;0;-3;0]; % Only two nonzero coefficients
% r = [0.2;0.12;0.512;0.121;
r = rand(5,1);

%%%% Psi *x = r 

% Y =  randn(100,1)*.1; % Small added noise

[s,param] = lasso(Psi',r);
% s = lasso(Psi',r,'alpha',0.01);
s = lasso(Psi',r,'alpha',0.99,'lambda',0.01);
% B1 = lasso(X,Y);
% B2 = lasso(X,Y,'alpha', 0.01);

figure()
subplot(211)
plot(s)
subplot(212)
plot(s(:,1))