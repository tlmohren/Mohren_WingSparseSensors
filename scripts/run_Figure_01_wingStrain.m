% -------------------------
% TLM 2017
% -----------------------------
clc;clear all;close all

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()


% pre plot decisions 
width = 2;     % Width in inches,   find column width in paper 
height = 2.5;    % Height in inches
%  legend_location = 'best'
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
shading interp

 %% 
    colormap(parula)
subplot(311)
    pcolor(strain0(:,:,t_inst))
shading flat
    axis equal
    axis off
    colorbar
    h = colorbar;
    colorbarOpts = {'FontSize', 8,...
        'Box','off',...
        'TickLabelInterpreter','latex',...
        };
    ylabel(h, 'Strain [$\frac{\Delta L}{L}$]','Interpreter','Latex')
%     ylabel(h, 'Strain [$\Delta L /L$]','Interpreter','Latex')
    set(h,colorbarOpts{:})  
    title('Flapping')
    
    hold on
%     scatter(25,1,'o')
    scatter(1,13,10,'o','filled','k')
%     plot([0,1]*10,[1,1]*13,'k','LineWidth',0.5)
%     plot([1,1]*1,[5,13],'k')
    plot([1,1]*1,[1,25],'k','LineWidth',0.5)
    
    
subplot(312)
    pcolor(strain10(:,:,t_inst))
shading flat
    axis equal
    axis off
    h = colorbar;
    colorbarOpts = {'FontSize', 8,...
        'Box','off',...
        'TickLabelInterpreter','latex',...
        };
%     ylabel(h, 'Strain','Interpreter','Latex')
    ylabel(h, 'Strain [$\frac{\Delta L}{L}$]','Interpreter','Latex')
    set(h,colorbarOpts{:})  
    title('Flapping \& Rotating')
    hold on
%     shading interp 
%     scatter(25,1,'o')
    scatter(1,13,10,'o','filled','k')
%     plot([0,1]*10,[1,1]*13,'k','LineWidth',0.5)
%     plot([1,1]*1,[5,13],'k')
    plot([1,1]*1,[1,25],'k','LineWidth',0.5)
    
    
ax3 = subplot(313);
    colormap(ax3,hot)
%     imagesc(strain10(:,:,t_inst)-strain0(:,:,t_inst))
    pcolor(strain10(:,:,t_inst)-strain0(:,:,t_inst))
    
shading flat
    axis equal
    axis off
    h = colorbar;
    colorbarOpts = {'FontSize', 8,...
        'Box','off',...
        'TickLabelInterpreter','latex',...
        };
%     ylabel(h, 'Strain','Interpreter','Latex')
    ylabel(h, '$\Delta$ Strain [$\frac{\Delta L}{L}$]','Interpreter','Latex')
    set(h,colorbarOpts{:})  
    title('Difference')
    hold on
%     scatter(25,1,'o')
    scatter(1,13,10,'o','filled','k')
%     plot([0,1]*10,[1,1]*13,'k','LineWidth',0.5)
%     plot([1,1]*1,[5,13],'k')
    plot([1,1]*1,[1,25],'k','LineWidth',0.5)
    
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

print(fig01, ['figs' filesep 'Figure_01_wingFlapAngles'], '-dsvg');