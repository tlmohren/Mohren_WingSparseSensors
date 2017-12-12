% -------------------------
% TLM 2017
% -----------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()


% pre plot decisions 
width = 3.3;     % Width in inches,   find column width in paper 
height = 1.5;    % Height in inches
%  legend_location = 'best'
%  legend_location = 'NorthOutside';
 legend_location = 'Best';
%% Get data
N0= load(['introFigData' filesep 'noise0'],'strain');
N1=load(['introFigData' filesep 'noise1'],'strain');

flap_d1 = load(['introFigData' filesep 'flapDisturbance']);
flap_d10 = load(['introFigData' filesep 'flapDisturbance_10']);
flap_d3_12 = load(['introFigData' filesep 'flapDisturbance_3_12']);
flap_d31_2 = load(['introFigData' filesep 'flapDisturbance_31_2']);

t = 0:0.001:1;

%% figure treatment
fig02 = figure();
ax = gca();
set(fig02, 'Position', [fig02.Position(1:2) width*100, height*100]); %<- Set size

%% axis adjustment
axisOptsTheta = {'xtick',0:.5:1,'xticklabel',{0:.5:1},...
    'xlim', [0,1],'ylim',[-55,80],...
     'box','off',...
%     'ytick',{0:5:10},...
% %     'yticklabel',{-1:1:1},...
% %     'Position',tempPos2 +[0.1,0,0,0],...
     };
axisOptsPhi = {'xtick',0:.5:1,'xticklabel',{0:.5:1}, ...
      'box','off',...
    'xlim', [0,1],'ylim',[-2,12],...
%     'ytick',-1:1:1 ,'yticklabel',{-1:1:1},...
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

%% Plot data 
subplot(121)
hold on 
plt1a = plot(t,eval(N0.strain.figData0.phi_dot));
plt1b = plot(t,eval(flap_d31_2.figdata.phi_dot));

xlabel('Time [s]'); ylabel('$\dot{\phi}$ [rad/s]')
set(gca, axisOptsTheta{:});
set(plt1a, plotOpts1a{:});
set(plt1b, plotOpts1b{:});

% legend_entries = {'$\bar{\dot{\theta}}$','$\bar{\dot{\theta}} + \dot{\theta}^*$'};
legend_entries = {'Flapping','Flapping + Disturbance '};
legOpts = {'Location', legend_location};
[leg,lns] = legend(legend_entries );
set(leg,legOpts{:});



% aa = get(gca,'OuterPosition');
% set(gca,'OuterPosition',aa + [0 0.1 0 0])


subplot(122)
 hold on
plt2a = plot(t, eval(N0.strain.figData0.theta_dot*t));
plt2b = plot(t, eval(N0.strain.figData10.theta_dot));
plt2c = plot(t, eval(N1.strain.figData0.theta_dot));
plt2d = plot(t, eval(N1.strain.figData10.theta_dot));

xlabel('Time [s]'); ylabel('$\dot{\theta}$ [rad/s]')
set(gca, axisOptsPhi{:});
set(plt2a, plotOpts2a{:});
set(plt2b, plotOpts2b{:});
set(plt2c, plotOpts2c{:});
set(plt2d, plotOpts2d{:});


% legend_entries = {'$\bar{\dot{\theta}} = 0$','$\bar{\dot{\theta}} = 10$','$0 + \dot{\theta}^*$','$10 + \dot{\theta}^*$'};

sub_legend = [plt2c,plt2d];
sub_legend_entries = {'Rotating','Rotating + Disturbance'};
legOpts = {'Location', legend_location};
% [leg,lns] = legend(legend_entries );
% [leg,lns] = legend(sub_legend,sub_legend_entries{:} );
[leg,lns] = legend('No Rotation', 'Rotation', 'No Rotation + Disturbance', 'Rotation + Disturbance');
% [leg,lns] = legend(sub_legend);
set(leg,legOpts{:});



% aa = get(gca,'OuterPosition');
% set(gca,'OuterPosition',aa + [0 0.1 0 0])

% break_axis('axis', 'x')
% BreakXAxis(t,eval(N0.strain.figData0.theta_dot*t),0.5,0.8,0.1)

%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;

% % % Here we preserve the size of the image when we save it.
set(fig02,'InvertHardcopy','on');
set(fig02,'PaperUnits', 'inches');
papersize = get(fig02, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig02, 'PaperPosition', myfiguresize);

 
%% saving of image
print(fig02, ['figs' filesep 'Figure_02_disturbance'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig02, 'PaperPosition', myfiguresize);

print(fig02, ['figs' filesep 'Figure_02_disturbance'], '-dsvg');