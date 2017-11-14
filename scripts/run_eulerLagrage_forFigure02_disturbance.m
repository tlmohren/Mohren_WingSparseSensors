% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

clc;clear all;close all

%% Run testcases
% Specify testcase 
parameterSetName    = ' ';
figuresToRun        = {'subSetTest'};
iter = 1;
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
fixPar.xInclude = 0;
fixPar.yInclude = 1;
testCase =1;

runMat = [ 0 10 0 10 0 10;
    0 0 1 1 10 10;
    0 0 3.12 3.12 31.2 31.2]; 

for j = 1:4
    frot = runMat(1,j)
    th = runMat(2,j)
    ph = runMat(3,j)
    [strain,figdata] =  eulerLagrange_forfigures(frot, th,ph ,fixPar );
    % % save('flapDisturbance_31_2.mat','figdata')
    save(['introFigData' filesep 'anglesDisturbanceFig_frot' num2str(frot) ,'_th' num2str(th) '_ph' num2str(ph) '.mat' ],'figdata')

end


% frot = 0; % done 
% th = 0;
% ph = 0;

% frot = 10; % done 
% th = 0;
% ph = 0;
% 
% th = 1;   % done 
% ph = 3.12;
% frot = 0;
% % 
% th = 1;  % done
% ph = 3.12;
% frot = 10;

% th = 10;   % done 
% ph = 31.2;
% frot = 0;
% 
% th = 10;
% ph = 31.2;
% frot = 10;

% fixPar
% [strain] =  eulerLagrange(frot, th,ph ,fixPar );
% strain =  eulerLagrange(frot, th,ph ,fixPar );
%% 
syms t
flapamp = 15;
phi = deg2rad(flapamp) ...
        .*(  sin(2*pi*25*t) ...
        + 0.2*sin(2*pi*2*25*t) );
phi_diff = diff(phi);
        
t = 1:0.001:4;

phiDot_clean = eval(phi_diff);
phiDot_dist = eval(figdata.phi_dot);
% std( phi_clean-phi_dist)

figure();
subplot(211)
hold on
plot(phiDot_clean)
plot(phiDot_dist)

subplot(212)
plot(phiDot_clean-phiDot_dist)


final_std = std( phiDot_dist - phiDot_clean ) 
%% 

% % save('flapDisturbance_31_2.mat','figdata')
save(['introFigData' filesep 'anglesDisturbanceFig_frot' num2str(frot) ,'_th' num2str(th) '_ph' num2str(ph) '.mat' ],'figdata')

%% check output here, size, content 
display('Output diagnostics')
[m,n] = size(strain);
figure(); plot(strain(50,:))

%% 


