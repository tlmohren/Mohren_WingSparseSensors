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



% par.NLDshiftList = [-0.2:0.1:0.7];
par.NLDshiftList = linspace(-1 ,1,10)
par.NLDsharpnessList = linspace(1,11,10);% [1:1:14];
par.NLDsharpnessList(8:10) = [11,15,20];
% par.NLDsharp

NF3 =figure('Position', [100, 100, 1000, 1000]);
for j = 1:length(par.NLDsharpnessList)
%    subplot(1,length(par.NLDsharpnessList),j )
   subplot(11,11,plot_list(j) )
   
   par.NLDshift = par.NLDshiftList(j);
   par.NLDsharpness = 10;%par.NLDsharpnessList(5);
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
%         par.NLD = @(s) 1./(  1 +...
%             exp( -(s-par.NLDshift) * par.NLDsharpness)  );
        x = -1:0.02:1;
    if abs(par.NLDshift - 0.5)<1e-10
        plot(  x,par.NLD(x),'k','LineWidth',4);hold on
    else
        par.NLD(1)
         plot(  x,par.NLD(x) /par.NLD(1))
         hold on
         plot(  x,par.NLD(x) )
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
   par.NLDshift = 0;
%       par.NLDshift = par.NLDshiftList(5);
   par.NLDsharpness = par.NLDsharpnessList(j);
%         par.NLD = @(s) 1./(  1 +...
%             exp( -(s-par.NLDshift) * par.NLDsharpness)  );
%         par.NLD = @(s) ((1./(  1 +...
%             exp( -(s-par.NLDshift) * par.NLDsharpness)  ) - 0.5)  *( (1 + exp(-par.NLDsharpness))*2 ) + 0.5 )   ;

        par.NLD = @(s)   ((  1./(  1 +...
             exp( -(s-par.NLDshift) * par.NLDsharpness)  ) - 0.5  ))  *...
             1/(2* ((  1./(  1 +  exp( - par.NLDsharpness)  ) - 0.5  )))  + 0.5;
        x = -1:0.02:1;
    if par.NLDsharpness == 10
        plot(  x,par.NLD(x),'k','LineWidth',4);hold on
    else
         plot(  x,par.NLD(x))
%          plot(  x,par.NLD(x) /par.NLD(1))
    end
    hold on 
    plot( 5* [-0.5,0.5]/par.NLDsharpness+par.NLDshift ,...
        5*par.NLD( [-0.5,0.5]/par.NLDsharpness +par.NLDshift   ) + 0.5 - 5*par.NLD(par.NLDshift),...
        'k:')
%             plot( [1,1]*par.NLDshift,[min(par.STAfilt),max(par.STAfilt)*1.1],'--k')
    axis([-1,1,-0.2,1.2])
   axis off
end
% set(NF4,'PaperPositionMode','auto')
% saveas(NF4,['figs' filesep 'Figure_NF4'], 'png')
% saveas(NF4,['figs' filesep 'Figure_NF4'], 'svg')
%% 
close all
        s = - 1:0.01:1;
figure()
   par.NLDshift = 0;
      par.NLDsharpness = 1;
        par.NLD = @(s)   ((  1./(  1 +...
             exp( -(s-par.NLDshift) * par.NLDsharpness)  ) - 0.5  ))  *...
             1/(2* ((  1./(  1 +  exp( - par.NLDsharpness)  ) - 0.5  )))  + 0.5;
    plot(s,par.NLD(s))
%     par.NLD(1)
        hold on
   par.NLDshift = 0;
      par.NLDsharpness = 5;
%         par.NLD = @(s)   ((  1./(  1 +...
%              exp( -(s-par.NLDshift) * par.NLDsharpness)  ) - 0.5  )* (1+par.NLDsharpness*exp(-par.NLDsharpness)))  ;

        par.NLD = @(s)   ((  1./(  1 +...
             exp( -(s-par.NLDshift) * par.NLDsharpness)  ) - 0.5  ))  *...
             1/(2* ((  1./(  1 +  exp( - par.NLDsharpness)  ) - 0.5  )))  + 0.5;
         plot(s,par.NLD(s))
         
         
         %% 
A1List = [0.1,1,2];
A2List = 1:0.4:2;
x = -39:0.1:0;

freqList = [0.1,1,5];
widthList = [5,10,20,40];
figure();
subplot(211)
hold on
for j = 1:length(freqList)
%     A1 = A1List(j);
%     A2 = 1;
    freq = freqList(j);
    width = 5;
%     func = @(t) cos(A1*(t+10) )./(1*(t+10).^A2); 
%     func = @(t) cos(A1*(t+10) )./(exp(-A2*abs(t+10))); 
%     func = @(t) cos(A1*(t+10) ) .*exp(-(t+10)); 
%     func = @(t) exp(-t.^2)
    func = @(t) cos( freq*(t+10)  ).*exp(-(t+10).^2 / width)
    plot(x,func(x))
end
subplot(212)
hold on
for j = 1:length(widthList)
    freq = 1;
    width = widthList(j);
%     A1 = A1List(1);
%     A2 = A2List(j);
%     func = @(t) cos(A1*t)./(1*t.^A2); 
    func = @(t) cos( freq*(t+10)  ).*exp(-(t+10).^2 / width)
    plot(x,func(x))
end


%% STA


x = -39:1:0;
freqList = linspace(0,2,7);
% dList = [5,10,20,40];
widthList = linspace(1,8,7);
widthList(1) = 0.1;


figure('Position',[100,100,1000,1000])

for j = 1: length(freqList)
    for k = 1:length(widthList)
        sub_nr = (j-1)*length(widthList) + k;
        subplot( length(freqList) , length(widthList),sub_nr )
        freq = freqList(j);
        width = widthList(k);
    % 
        func = @(t) cos( freq*(t+20)  ).*exp(-(t+20).^2 / width^2);
        plot(x,func(x)/sum(func(x)))
%         plot(x,func(x),'-','LineWidth',)
%         hold on
%         plot(x,func(x),'k.')
%         axis([-40,0,-1.5,1.5])
    end
end


%%  NLD
close all
s = -1:0.01:1;
% par.NLDshiftList = [-0.2:0.1:0.7];
NLDshiftList = linspace(-1 ,1,7);
NLDsharpnessList = linspace(1,5,7).^2;% [1:1:14];
% NLDsharpnessList(8:10) = [11,15,20];

figure('Position',[100,100,1000,1000])

for j = 1:length(NLDshiftList)
    for k = 1:length(NLDsharpnessList)
        sub_nr = (j-1)*length(NLDsharpnessList) + k;
        subplot( length(NLDshiftList) , length(NLDsharpnessList),sub_nr )
        shift = NLDshiftList(j);
        eta = NLDsharpnessList(k);
    % 
        funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; ...
        if k == 1;
%            funNLD = @(s)  heaviside(s-shift+0.5).*(s-shift+0.5)  -heaviside(s-shift-1+0.5).*(s-shift-1+0.5)
           funNLD = @(s)  heaviside(0.5*s-shift+0.5).*(0.5*s-shift+0.5) ...
               -heaviside(0.5*s-shift-1+0.5).*(0.5*s-shift-1+0.5);
        elseif k == length(NLDsharpnessList)
            funNLD = @(s) heaviside( 0.5*s - 0.5*shift) ;
        else
            funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; 
        end
%         end
%             *0.5/ ( 1/ (1+ exp(-eta.*(1-shift)) ) - 0.5) ...  
%             + 0.5 ;
%         
%         0.5/ ( 1/ (1+ exp(-eta.*(1+shift)) ) - 0.5)
%         0.5/ ( 1/ (1+ exp(-eta.*(1-shift)) ) - 0.5)
%         
%         min( 0.5/ ( 1/ (1+ exp(-eta.*(-1-shift)) ) - 0.5) , ...
%         0.5/ ( 1/ (1+ exp(-eta.*(1-shift)) ) - 0.5))
%         plot(x,func(x),'-','LineWidth',)
%         hold on
%         plot(x,func(x),'k.')
        plot(s,funNLD(s))
        axis([-1,1,-0.6,1.2])
        grid on
    end
end

