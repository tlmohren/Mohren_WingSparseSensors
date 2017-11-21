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
N0= load(['introFigData' filesep 'noise0'],'strain');
N1=load(['introFigData' filesep 'noise1'],'strain');
dim_wing = [26,51,4000];
strain0 = reshape(N0.strain.strain_0,dim_wing);
strain10 = reshape(N0.strain.strain_10,dim_wing);
t_inst = 3008;

%% figure treatment
fig01 = figure();
ax = gca();
set(fig01, 'Position', [fig01.Position(1:2) width*100, height*100]); %<- Set size
shading flat 

 %% 
 axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
%  pcOpts = {'EdgeColor',[1,1,1]*0,'LineWidth',0.1,'FaceColor','flat'};
 pcOpts = {'FaceColor','flat'};
%  	Sets DataAspectRatio to [1 1 1], sets PlotBoxAspectRatio to [3 4 4],
%     and sets the associated mode properties to manual. Disables the “stretch-to-fill” behavior.
    colormap(parula)
subplot(311)
    pc1 = pcolor(strain0(:,:,t_inst));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off
   
    h = colorbar;
    colorbarOpts = {'FontSize', fontSize,...
        'Box','off',...
        'Limits',[0,2e-3],...
        'TickLabelInterpreter','latex',...
        };
%     ylabel(h, 'Strain [$\frac{\Delta L}{L}$]','Interpreter','Latex')
    ylabel(h, 'Strain($x,y,t$)','Interpreter','Latex')
    set(h,colorbarOpts{:})  
%     title('Flapping','FontSize',fontSize)
    title('No Rotation','FontSize',fontSize)
    
    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',1)
    
subplot(312)
    pc2 = pcolor(strain10(:,:,t_inst));
    ax2 = gca();
    set(ax2,axOpts{:})
    set(pc2,pcOpts{:})
    axis off
    
    h = colorbar;
    ylabel(h, 'Strain(x,y,t)','Interpreter','Latex')
    set(h,colorbarOpts{:})  
%     title('Flapping \& Rotating','FontSize',fontSize)
    title('Rotation','FontSize',fontSize)
    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',1)
    
ax3 = subplot(313);
    colormap(ax3,hot)
    pc3 = pcolor(strain10(:,:,t_inst)-strain0(:,:,t_inst));
    ax3 = gca();
    set(ax3,axOpts{:})
    set(pc3,pcOpts{:})
    axis off
    
    h = colorbar;
    colorbarOpts = {'FontSize', fontSize,...
        'Box','off',...
        'TickLabelInterpreter','latex',...
        'Limits',[-2.2e-6,2.2e-6],...
        };
    ylabel(h, '$\Delta$ Strain(x,y,t)','Interpreter','Latex')
    set(h,colorbarOpts{:})  
    title('Difference','FontSize',fontSize)
    hold on
    scatter(1,13,10,'o','filled','k')
    plot([1,1]*1,[1,26],'k','LineWidth',0.5)
    
    
    
    
    
    
    
    
    
    
    
    
    
%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;

% % % Here we preserve the size of the image when we save it.
set(fig01,'InvertHardcopy','on');
set(fig01,'PaperUnits', 'inches');
papersize = get(fig01, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig01, 'PaperPosition', myfiguresize);
 
%% saving of image
print(fig01, ['figs' filesep 'Figure_01_wingFlapAngles'], '-dpng', '-r300');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig01, 'PaperPosition', myfiguresize);

print(fig01, ['figs' filesep 'Figure_01_wingFlapAngles'], '-dsvg', '-r499');