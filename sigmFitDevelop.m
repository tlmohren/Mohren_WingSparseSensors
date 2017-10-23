%---------------------
% TMohren
% develop sigmFitParam function 
% --------------------------

clc;clear all;close all

%% regular case
x = 0:1:30;
% x = 15:1:30;
beta0 = [0.5;0.4;10;1];
modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
y_clean = modelfun(beta0,x);
y_dist = randn(1,length(x));
y = y_clean + 0.06*y_dist;

figure();
plot(x,y,'-o')
[q ] = sigmFitParam( x,y,'plot_show',true);

%% 0only top data 

% x = 0:1:30;
x = 15:1:30;
beta0 = [0.5;0.4;10;1];
modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
y_clean = modelfun(beta0,x);
y_dist = randn(1,length(x));
y = y_clean + 0.06*y_dist;

figure();
plot(x,y,'-o')
[q ] = sigmFitParam( x,y,'plot_show',true);

%% no data 

% x = 0:1:30;
x = zeros(1,0);
y = x;

figure();
plot(x,y,'-o')
[q ] = sigmFitParam( x,y,'plot_show',true);

%% no data 

x = 0:1:30;
% x = zeros(1,0);
y = [ones(1,5)*0.5, ones(1,26)*0.9];
y(10:13) = 0.5;
y(2:4) = 0.9;

figure();
plot(x,y,'-o')
[q ] = sigmFitParam( x,y,'plot_show',true);

%% 0only bottom data 

% x = 0:1:30;
x = 25:1:30;
y = ones(size(x))*0.5;
y(end-1:end) = 0.7;
% beta0 = [0.5;0.4;10;1];
% modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
% y_clean = modelfun(beta0,x);
% y_dist = randn(1,length(x));
% y = y_clean + 0.06*y_dist;

figure();
plot(x,y,'-o')
[q ] = sigmFitParam( x,y,'plot_show',true);
