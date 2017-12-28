% -------------------------
% TLM 2017
% -----------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% pre plot decisions 
width = 2.5;     % Width in inches,   find column width in paper 
height = 2.8;    % Height in inches
fontSize = 8; 
legend_location = 'NorthOutside';

%% Get data
N0= load(['figData' filesep 'noise0'],'strain');
N1=load(['figData' filesep 'noise1'],'strain');
dim_wing = [26,51,4000];
strain0 = reshape(N0.strain.strain_0,dim_wing);
strain10 = reshape(N0.strain.strain_10,dim_wing);
t_inst = 3008;

boxLine = 0.5;
baseLine = 1; 

%% figure treatment
fig01 = figure();
set(fig01, 'Position', [fig01.Position(1:2) width*100, height*100]); %<- Set size
shading flat 

inoffensiveBlue =[247,252,240
224,243,219
204,235,197
168,221,181
123,204,196
78,179,211
43,140,190
8,104,172
8,64,129];
strainScheme = colorSchemeInterp(inoffensiveBlue/255, 500);

orangePurple = [179,88,6
224,130,20
253,184,99
254,224,182
247,247,245
216,218,235
178,171,210
128,115,172
84,39,136];
differenceScheme = colorSchemeInterp(orangePurple/255,500);

 %% 
axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
difOpts = {'DataAspectRatio',[1,1,1],...
     'PlotBoxAspectRatio',[3,4,4],...
     'CLim',[-1e-6,1e-6]*3};
pcOpts = {'FaceColor','flat',...
     'EdgeColor','none',...
     };
strainbarOpts = {'FontSize', fontSize,...
    'Limits',[0,2e-3],...
    'TickLabelInterpreter','latex',...
    'Color',[0,0,0],...
%     'Box','off',...
    };
differencebarOpts = {'FontSize', fontSize,...
    'TickLabelInterpreter','latex',...
    'Limits',[-1e-6,1e-6]*3,...
    'Ticks', [-1e-6,0,1e-6]*3,...
    'Color',[0,0,0],...
%     'Box','off',...
    };
%% 
subplot(311)
    colormap(strainScheme)
    pc1 = pcolor(strain0(:,:,t_inst));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off
    h = colorbar;
    ylabel(h, 'Strain($x,y,t$)','Interpreter','Latex')
    set(h,strainbarOpts{:})  
    title('Flapping Only','FontSize',fontSize)
    
    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',baseLine)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',boxLine)

subplot(312)
    pc2 = pcolor(strain10(:,:,t_inst));
    ax2 = gca();
    set(ax2,axOpts{:})
    set(pc2,pcOpts{:})
    axis off
    h = colorbar;
    ylabel(h, 'Strain(x,y,t)','Interpreter','Latex')
    set(h,strainbarOpts{:})  
    a = title('With Rotation','FontSize',fontSize);
    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',baseLine)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',boxLine)
    
ax3 = subplot(313);
    colormap(ax3, differenceScheme)
    pc3 = pcolor(strain10(:,:,t_inst)-strain0(:,:,t_inst));
    ax3 = gca();
    set(ax3,difOpts{:})
    set(pc3,pcOpts{:})
    axis off
    h = colorbar;
    ylabel(h, '$\Delta$ Strain(x,y,t)','Interpreter','Latex')
    set(h,differencebarOpts{:})  
    title('Difference','FontSize',fontSize)
    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',baseLine)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',boxLine)
    
%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% % % Here we preserve the size of the image when we save it.
set(fig01,'InvertHardcopy','on');
set(fig01,'PaperUnits', 'inches');
papersize = get(fig01, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig01, 'PaperPosition', myfiguresize);
% saving of image
print(fig01, ['figs' filesep 'Figure_01_wingFlapAngles'], '-dpng', '-r300');
% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig01, 'PaperPosition', myfiguresize);

print(fig01, ['figs' filesep 'Figure_01_wingFlapAngles'], '-dsvg', '-r499');
