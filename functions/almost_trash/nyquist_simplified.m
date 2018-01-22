clc;clear all;close all

t_end       = 10;
n           = 501;
t           = linspace(0,t_end,n);              % time 
f           = [3,7];
signal      = sin( 2*pi*f(1)*t )+0.7*sin( 2*pi*f(2)*t );  % signal 
bases       = dct(eye(n,n));                  % dct of diagonal mat
dct_coeff   = bases\signal';                           % coefficients of dct 
k           = (1:n)/(2*t_end);                    % frequency vector
m           = 101;
perm        = randintrlv(1:n,793);           % randomly ordered vector 
sparse_signal = signal(perm(1:m));                       % random samples 
Psi         = bases(perm(1:m),:);                      % random permutation of this 
fixPar.elasticNet = 0.3;

sparse_coeff = SSPOC(Psi',sparse_signal',fixPar);

[~,I]   = sort(dct_coeff,'descend');
[~,I3]  = sort(sparse_coeff,'descend');
f_full  = k(I(1:2));
f_recon = k(I3(1:2));

isequal(f_full,f_recon)
freq_amp = dct_coeff(I(1:2))
sparse_freq_amp = sparse_coeff(I3(1:2))

ratios =  abs( freq_amp ./ sparse_freq_amp ) <= 1.3
%     testCase.verifyTrue( true,  ratios(1) <= 1.3 )
%     testCase.verifyThat( true,  ratios(2) <= 1.3 )
    
    
% testCase.verifyThat( true,  abs( freq_amp ./ sparse_freq_amp ) <= 1.3 )
% verifyLessThan(verifiable,actual,ceiling)
%% 
figure()
subplot(121);
    hold on
    plot(k,dct_coeff); 
    plot(k,sparse_coeff); 
    axis([0,10,-20,20])
subplot(122 ); 
    hold on
    plot(t,signal); 
    plot(t, idct(sparse_coeff)); 
    axis([0, 4, -3, 3]);