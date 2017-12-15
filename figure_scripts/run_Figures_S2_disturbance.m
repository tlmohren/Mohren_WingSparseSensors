% -------------------------
% TLM 2017
% -----------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()


% pre plot decisions 
width = 7;     % Width in inches,   find column width in paper 
height =3;    % Height in inches
%  legend_location = 'best'
%  legend_location = 'NorthOutside';
 legend_location = 'Best';
%% Get data
N0= load(['introFigData' filesep 'noise0'],'strain');
N1=load(['introFigData' filesep 'noise1'],'strain');


% flap_d31_2 = load(['introFigData' filesep 'flapDisturbance_31_2']);

% % flap_d1 = load(['introFigData' filesep 'flapDisturbance']);
% flap_d10 = load(['introFigData' filesep 'flapDisturbance_10']);
% flap_d3_12 = load(['introFigData' filesep 'flapDisturbance_3_12']);



% anglesDisturbanceFig
% t = 0:0.001:1;
% 
%% figure treatment
figS3 = figure();
ax = gca();
set(figS3, 'Position', [figS3.Position(1:2) width*100, height*100]); %<- Set size

%% axis adjustment
axisOptsPhi = {'xtick',[0,1,1.8],'xticklabel',[0,1,4],...
    'xlim', [0,1.8],'ylim',[-45,90],...
     'box','off',...
    'ytick',-30:30:60,...
% %     'yticklabel',{-1:1:1},...
% %     'Position',tempPos2 +[0.1,0,0,0],...
     };
axisOptsTheta= {'xtick',[0,1,1.8],'xticklabel',[0,1,4], ...
'xtick',[0,1,1.8],'xticklabel',[0,1,4], ...
      'box','off',...
    'xlim', [0,1.8],'ylim',[-3,13],...
    'ytick',[0,10],...
%     'Position',tempPos2 +[0.1,0,0,0],...
     };

 lw = 1;
C = linspecer(5);
plotOpts1a = {'Color','k','LineWidth',lw};
plotOpts1b = {'Color',C(3,:),'LineWidth',0.7};

plotOpts2a = {'Color','k','LineWidth',lw};
plotOpts2b = {'Color','k','LineWidth',lw,'LineStyle','--'};
plotOpts2c = {'Color',C(1,:),'LineWidth',lw};
plotOpts2d = {'Color',C(4,:),'LineWidth',lw};

% Plot data 
t = 0:0.001:4;

inds_b = [1:1300];
inds_end = [3700:4000]; 
t_inds_end = 1500:1800; 

frot0th0ph0 = load(['introFigData' filesep 'anglesDisturbanceFig_frot0_th0_ph0.mat']);
frot10th1ph3_12 = load(['introFigData' filesep 'anglesDisturbanceFig_frot10_th1_ph3.12.mat']);

phiDot = eval( frot0th0ph0.figdata.phi_dot  );
phiDotDist = eval( frot10th1ph3_12.figdata.phi_dot  );



subplot(121)
hold on 
plt1a = plot(t(inds_b),phiDot(inds_b));
plt1aa = plot(t(t_inds_end),phiDot(inds_end));
plt1b = plot(t(inds_b),phiDotDist(inds_b));
plt1bb = plot(t(t_inds_end),phiDotDist(inds_end));
% plt1b = plot(t,);
% 
xlabel('Time [s]'); ylabel('$\dot{\phi}$ [rad/s]')
set(gca, axisOptsPhi{:});
set(plt1a, plotOpts1a{:});
set(plt1aa, plotOpts1a{:});
set(plt1b, plotOpts1b{:});
set(plt1bb, plotOpts1b{:});


plot([1.3,1.500],[15,15],':k')
% 
% legend_entries = {'$\bar{\dot{\theta}}$','$\bar{\dot{\theta}} + \dot{\theta}^*$'};
legend_entries = {'Flapping','Flapping + Disturbance '};
legOpts = {'Location', legend_location};
[leg,lns] = legend( [plt1a, plt1b],legend_entries );

%% 
% figure()
% subplot(122)
 hold on


frot10th1ph3_12 = load(['introFigData' filesep 'anglesDisturbanceFig_frot10_th1_ph3.12.mat']);
frot0th1ph3_12 = load(['introFigData' filesep 'anglesDisturbanceFig_frot0_th1_ph3.12.mat']);


phiDot = eval( frot0th0ph0.figdata.phi_dot  );
phiDotDist = eval( frot10th1ph3_12.figdata.phi_dot  );



frot0th0ph0 = load(['introFigData' filesep 'anglesDisturbanceFig_frot0_th0_ph0.mat']);
thetaDot0 = eval( frot0th0ph0.figdata.theta_dot*t  );
frot10th0ph0 = load(['introFigData' filesep 'anglesDisturbanceFig_frot10_th0_ph0.mat']);
thetaDot10 = eval( frot10th0ph0.figdata.theta_dot); 
frot0th1ph3_12 = load(['introFigData' filesep 'anglesDisturbanceFig_frot0_th1_ph3.12.mat']);
thetaDot0Dist = eval( frot0th1ph3_12.figdata.theta_dot);
frot10th1ph3_12 = load(['introFigData' filesep 'anglesDisturbanceFig_frot10_th1_ph3.12.mat']);
thetaDot10Dist = eval( frot10th1ph3_12.figdata.theta_dot);


% phiDot = eval( frot10th0ph0.figData0.phi_dot  );
phiDotDist = eval( frot0th1ph3_12.figdata.phi_dot  );
 
%% 
subplot(122)
hold on
plt2a = plot(t(inds_b),thetaDot0(inds_b));
plt2aa = plot(t(t_inds_end),thetaDot0(inds_end));
plt2b = plot(t(inds_b),thetaDot10(inds_b));
plt2bb = plot(t(t_inds_end),thetaDot10(inds_end));
plt2c = plot(t(inds_b),thetaDot0Dist(inds_b));
plt2cc = plot(t(t_inds_end),thetaDot0Dist(inds_end));
plt2d = plot(t(inds_b),thetaDot10Dist(inds_b));
plt2dd = plot(t(t_inds_end),thetaDot10Dist(inds_end));


xlabel('Time [s]'); ylabel('$\dot{\theta}$ [rad/s]')
set(plt2a, plotOpts2a{:});
set(plt2aa, plotOpts2a{:});
set(plt2b, plotOpts2b{:});
set(plt2bb, plotOpts2b{:});
set(plt2c, plotOpts2c{:});
set(plt2cc, plotOpts2c{:});
set(plt2d, plotOpts2d{:});
set(plt2dd, plotOpts2d{:});


plot([1.3,1.500],[10,10],':k')
plot([1.3,1.500],[0,0],':k')

set(gca, axisOptsTheta{:});

sub_legend = [plt2a, plt2b, plt2c,plt2d];
sub_legend_entries = {'Rotating','Rotating + Disturbance'};
legOpts = {'Location', legend_location};
[leg,lns] = legend(sub_legend ,'No Rotation', 'Rotation', 'No Rotation + Disturbance', 'Rotation + Disturbance');

set(leg,legOpts{:});


%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;

% % % Here we preserve the size of the image when we save it.
set(figS3,'InvertHardcopy','on');
set(figS3,'PaperUnits', 'inches');
papersize = get(figS3, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(figS3, 'PaperPosition', myfiguresize);

 
%% saving of image
print(figS3, ['figs' filesep 'Figure_02_disturbance'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(figS3, 'PaperPosition', myfiguresize);

print(figS3, ['figs' filesep 'Figure_S3'], '-dsvg');