% -------------------------
% Test eulerLagrangeConcatenate for errors
% TLM 2017
% -----------------------------
% initialize path and clear memory 
clc;clear all;close all
% run('link_folders_SSPOC.m')


scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

            
%% Run testcases
% Specify testcase 
par = setParameters();



testCase = 3;
par.baseZero = 0;
par.xInclude = 0;
par.yInclude = 1;
if testCase == 1
    ph = 0;
    th = 0; 
    par.runSim = 1;
    par.saveSim = 0;
    par.chordElements = 26;
    par.spanElements = 51;
elseif testCase == 2
    ph = 1;
    th = 1; 
    par.runSim = 1;
    par.saveSim = 0;
    par.chordElements = 26;
    par.spanElements = 51;
elseif testCase == 3
    ph = 1;
    th = 1; 
    par.runSim = 0;
    par.saveSim = 0;
    par.chordElements = 26;
    par.spanElements = 51;
else
    display('Invalid testcase entry')
end

strain = eulerLagrangeConcatenate_forfigures(ph,th,par);


%% check output here, size, content 
% 
% save(['test_code' filesep 'noise0'],'strain')
N0= load(['test_code' filesep 'noise0'],'strain')
N1=load(['test_code' filesep 'noise1'],'strain')

t = 0:0.001:2;

% N0.

figure()
subplot(221)
 hold on
% plot(t,eval(strain.figData0.theta))
plot(t,eval(N0.strain.figData0.theta*t),'k:')
plot(t,eval(N0.strain.figData10.theta),'k--')
plot(t,eval(N1.strain.figData0.theta))
plot(t,eval(N1.strain.figData10.theta))
xlabel('Time [s]'); ylabel('\theta [rad]')


% figure(); hold on

subplot(222)
hold on 
% plot(t,eval(strain.figData0.theta_dot))
plot(t,eval(N0.strain.figData0.theta_dot*t),'k:')
plot(t,eval(N0.strain.figData10.theta_dot),'k--')
plot(t,eval(N1.strain.figData0.theta_dot))
plot(t,eval(N1.strain.figData10.theta_dot))
xlabel('Time [s]'); ylabel('d theta / dt [rad/s]')
% axis([0,1,


subplot(223)
hold on 
% figure(); hold on
plot(t,eval(N0.strain.figData0.phi),'k:')
plot(t,eval(N0.strain.figData10.phi),'k--')
plot(t,eval(N1.strain.figData0.phi))
plot(t,eval(N1.strain.figData10.phi))
xlabel('Time [s]'); ylabel('\phi [rad]')

subplot(224)
hold on 
plot(t,eval(N0.strain.figData0.phi_dot),'k:')
plot(t,eval(N0.strain.figData10.phi_dot),'k--')
plot(t,eval(N1.strain.figData0.phi_dot))
plot(t,eval(N1.strain.figData10.phi_dot))
xlabel('Time [s]'); ylabel('d phi / dt [rad/s]')

legend('Flapping No disturbance','Flapping & rotating No disturbance','Flapping','Flapping & rotating')


%% 
flap_d1 = load('flapDisturbance');
flap_d10 = load('flapDisturbance_10');
flap_d3_12 = load('flapDisturbance_3_12');
flap_d31_2 = load('flapDisturbance_31_2');
% plot(t,eval(strain.figData10.phi_dot))
figure()
subplot(121)
% t = 0:0.001:2
hold on 
% plot(t,eval(flap_d1.figdata.phi_dot),'b')
% plot(t,eval(flap_d10.figdata.phi_dot),'b')
% plot(t,eval(flap_d3_12.figdata.phi_dot),'b')
plot(t,eval(flap_d31_2.figdata.phi_dot))
plot(t,eval(N0.strain.figData0.phi_dot),'k:')
% plot(t,eval(N0.strain.figData10.phi_dot),'k--')
% plot(t,eval(N1.strain.figData0.phi_dot))
% plot(t,eval(N1.strain.figData10.phi_dot))
xlabel('Time [s]'); ylabel('d phi / dt [rad/s]')
axis([1,1.4,-70,80])





% figure()
subplot(122)
 hold on
% plot(t,eval(strain.figData0.theta_dot))
plot(t,eval(N0.strain.figData0.theta_dot*t),'k:')
plot(t,eval(N0.strain.figData10.theta_dot),'k--')
plot(t,eval(N1.strain.figData0.theta_dot))
plot(t,eval(N1.strain.figData10.theta_dot))
xlabel('Time [s]'); ylabel('d theta / dt [rad/s]')

%% 
dim_wing = [51,26,4000];
dim_wing = [26,51,4000];
strain0 = reshape(N0.strain.strain_0,dim_wing);
strain10 = reshape(N0.strain.strain_10,dim_wing);



t_inst = 3008;
shading interp

% figure('Renderer', 'Painters')
figure();

% subplot(311)
pcolor(strain0(:,:,t_inst))
axis equal
colorbar
figure();
pcolor(strain10(:,:,t_inst))
axis equal
colorbar
figure();
pcolor(strain10(:,:,t_inst)-strain0(:,:,t_inst))
axis equal
colorbar
colormap cool

%  saveas(gcf,'wing_test4.svg')
 
% export_fig wing_test4.svg


