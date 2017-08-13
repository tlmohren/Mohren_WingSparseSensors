clc;clear all; close all 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

% load(['results' filesep 'analysis_FigR1toR4_XXYY_270Par'])

% load(['results' filesep 'tempDataMatTot'])
% Datamat = dataMatTot;

plot_list = [1:11:100,112:121];




par.STAwidthList = 1:10;
par.STAshiftList = -10:1:1;
NF1 =figure('Position', [100, 100, 1000, 1000]);
for j = 1:10
   subplot(11,11,plot_list(j+10) )
   par.STAwidth = 3;
   par.STAshift = par.STAshiftList(j);
   t_sta = -39:0.1:0;
      par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
            ./ (2*par.STAwidth ^2) ) ...
            ./ (sqrt(3*par.STAwidth) *pi^1/4)...
            .* ( 1-(t-par.STAshift).^2/par.STAwidth^2);
        par.STAfilt = par.STAFunc(t_sta);   
        
      
            if par.STAshift == -10
                plot(t_sta,par.STAfilt,'k','LineWidth',4); hold on;
            else
                plot(t_sta,par.STAfilt); hold on;
            end
            plot( [1,1]*par.STAshift,[-0.5,max(par.STAfilt)*1.1],':k')
            plot([-39,0],[1,1]*-0.5,'k','LineWidth',1)
            
   axis off
end

% set(NF1,'PaperPositionMode','auto')

par.STAwidthList = 1:10;
% NF2 =figure('Position', [100, 100, 200, 1000]);
for j = 1:length(par.STAwidthList)
   subplot(11,11,plot_list(j)  )
   par.STAwidth = par.STAwidthList(j);
   par.STAshift = -10;
   t_sta = -39:0.1:0;
      par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
            ./ (2*par.STAwidth ^2) ) ...
            ./ (sqrt(3*par.STAwidth) *pi^1/4)...
            .* ( 1-(t-par.STAshift).^2/par.STAwidth^2);
        par.STAfilt = par.STAFunc(t_sta);   

        
        
            
            if par.STAwidth == 3
                plot(t_sta,par.STAfilt,'k','LineWidth',4); hold on;
            else
                plot(t_sta,par.STAfilt); hold on;
            end
            
            if par.STAwidth + par.STAshift < 0 
                plot( [-1,1]*par.STAwidth+par.STAshift,[0,0],':k')
            else
                plot( [-par.STAwidth+par.STAshift,0],[0,0],':k')
            end
            
   axis off
end

%% 



par.NLDshiftList = [-0.2:0.1:0.7];
par.NLDsharpnessList = [5:1:14];

NF3 =figure('Position', [100, 100, 1000, 1000]);
for j = 1:length(par.NLDsharpnessList)
%    subplot(1,length(par.NLDsharpnessList),j )
   subplot(11,11,plot_list(j) )
   
   par.NLDshift = par.NLDshiftList(j);
   par.NLDsharpness = 10;%par.NLDsharpnessList(5);
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
        x = -1:0.02:1;
    if abs(par.NLDshift - 0.5)<1e-10
        plot(  x,par.NLD(x),'k','LineWidth',4);hold on
    else
         plot(  x,par.NLD(x))
    end
    hold on
            plot( [1,1]*par.NLDshift,[min(par.NLD(x)),max(par.NLD(x))],':k')
    axis([-1,1,0,1])
   axis off
end

% set(NF3,'PaperPositionMode','auto')
% saveas(NF3,['figs' filesep 'Figure_NF3'], 'png')
% saveas(NF3,['figs' filesep 'Figure_NF3'], 'svg')

%
% NF4 =figure('Position', [100, 100, 100, 1000]);
for j = 1:length(par.NLDsharpnessList)
%    subplot(length(par.NLDshiftList),1,j )
   
   subplot(11,11,plot_list(j+10) )
   par.NLDshift = 0.5;
%       par.NLDshift = par.NLDshiftList(5);
   par.NLDsharpness = par.NLDsharpnessList(j);
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
        x = -1:0.02:1;
    if par.NLDsharpness == 10
        plot(  x,par.NLD(x),'k','LineWidth',4);hold on
    else
         plot(  x,par.NLD(x))
    end
    hold on 
    plot( 5* [-0.5,0.5]/par.NLDsharpness+par.NLDshift ,...
        5*par.NLD( [-0.5,0.5]/par.NLDsharpness +par.NLDshift   ) + 0.5 - 5*par.NLD(par.NLDshift),...
        'k:')
%             plot( [1,1]*par.NLDshift,[min(par.STAfilt),max(par.STAfilt)*1.1],'--k')
    axis([-1,1,0,1])
   axis off
end
% set(NF4,'PaperPositionMode','auto')
% saveas(NF4,['figs' filesep 'Figure_NF4'], 'png')
% saveas(NF4,['figs' filesep 'Figure_NF4'], 'svg')

