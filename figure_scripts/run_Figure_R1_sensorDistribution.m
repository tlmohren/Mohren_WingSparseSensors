%------------------------------
% run_Figure_R1_sensorDistribution
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clc;clear all; close all
addpathFolderStructure()
w = warning ('off','all');

% figure decisions 
width       = 3;     % Width in inches,   find column width in paper 
height      = 2.5;    % Height in inches
fsz         = 8;      % Fontsize
labels_on   = false;
sigmoid_fit = true;

%% Processing before plotting 
parameterSetName = 'R1_Iter100';
overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
load( ['accuracyData' filesep 'parameterSet_' parameterSetName ] )
fixPar.data_loc = 'accuracyData';
fixPar.nIterFig = 100;
fixPar.nIterSim = 100; 

[dataStruct,paramStruct] = combineDataMat( fixPar, simulation_menu.R1_standard );





parameterSetName    = 'Example 1';
figuresToRun        = 'E1'; % run Example 1 
iter                = 1; % number of iterations 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 
varPar              = varParStruct(2);  % SSPOC on 
varPar.wTrunc       = 10;
varPar.curIter      = iter;
strainSet       = eulerLagrangeConcatenate( fixPar,varPar);
[X,G]           = neuralEncoding(strainSet, fixPar,varPar );
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
[sensors, Psir, w_t]    = sensorLocSSPOCWeights(Xtrain,Gtrain,fixPar,varPar);
[ accuracy, w_sspoc ]       = sensorLocClassifyWeights(  sensors,Xtrain,Gtrain,Xtest,Gtest );

% w_sspoc= LDA_n(Phi * Xtrain, Gtrain);
%% 























%% discriminant vector 
eig_fire = reshape(w_t'*Psir' , fixPar.chordElements,fixPar.spanElements);
aaa   = w_t'*Psir' ;
if aaa(1326) > 0 
   eig_fire = -eig_fire;
   display('flipped fire')
end
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








%% Sensor locations 
fig1 = figure();
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size

q = 13;

binar           = get_pdf( dataStruct.sensorMatTot(2,q,1:q,:));
sensorloc_tot   = reshape(binar,fixPar.chordElements,fixPar.spanElements); 

colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};

% subplot(5,3,[1,2])
    x   = [0 1 1 0]* (fixPar.spanElements+1);  
    y   = [0 0 1 1]* (fixPar.chordElements+1);
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on 
    [X,Y] = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
    I = find( sensorloc_tot );      
    sc  = scatter(X(I) ,Y(I) , 100 ,'.','r');      
    
    % create black frame 
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    plot(x,y,'k','LineWidth',0.5)
    
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
    
    
    
    w_sspoc = nonzeros(binar)
    
    
%%      
    
% binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
% binar(sensors)  = 1;
sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,[-0.1,0.05], 'TickLabels',{'+','-'}  ,...
                    'Limits',[-0.1,0.05],'TickLabelInterpreter','latex'};
% axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27],...
                    'XTick',[],'YTick',[]};
x               = [0 1 1 0]* (fixPar.spanElements+1);  
y               = [0 0 1 1]* (fixPar.chordElements+1);
x               = [1 51 51 1];
y               = [1 1 26 26];
[X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
I               = find( sensorloc_tot );    
% dotColor = ones(length(w_sspoc),1)*[231,41,138]/255;
% dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
% 
% fig2 = figure();
% set(fig2, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size
% % figure()
%     pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
%     hold on   
%     pcolor(eig_fire)
%     colormap(differenceScheme)
% %     scatter(X(I) ,Y(I) , 100 ,'.','r');      
% %     dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,'.r');    
% %     dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc).^2*10)*50 ,'.r');  
%     dot_legend =  scatter(X(I) ,Y(I) ,   100 ,'.','r');  
% %     dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');    
%     scatter(1,13,100,'.k')
%     plot([1,1]*1,[-0.5,27],'k','LineWidth',1)
%     ax = gca(); 
%     set(ax,axOpts{:})
% %     y = colorbar
% %     y.Label = '$\w_t^T \Psi^T$';
%     
% %     axis off 
%     
%     
%     h = colorbar;
%     set( h, colorBarOpts{:})
% %     xlabel('Frequency')
% %     ylabel('Width')
%     tx1 = ['$\mathbf{w_t}^T \mathbf{\Psi}^T$'];
%     ylabel(h, tx1, 'Interpreter', 'latex','Rotation',0 )
%     
%     axis off
%     set( h, colorBarOpts{:})
    
    
    
    
fig2 = figure();
set(fig2, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size
% figure()
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on   
%     pcolor(eig_fire)
    imagesc(eig_fire)
    colormap(differenceScheme)
%     scatter(X(I) ,Y(I) , 100 ,'.','r');      
%     dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,'.r');    
%     dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc).^2*10)*50 ,'.r');  
    upLim = [0.4,0.7,1.1];
    lowLim = [-0.1,0.4,0.7]
    dim = [0.1,0.5,1];
%     dim = [1,1,1];
% col = [252,146,114
% 251,106,74
% 239,59,44 ]/255;
col = [255,140,140
255,70,70
255,0,0]/255;
colE = zeros(3,3)
    scOpts = {'MarkerFaceAlpha',0.5};
    for j = 1:3
        I_group = I( (w_sspoc < upLim(j)) & (w_sspoc >lowLim(j)) )
%             scatter(X(I) ,Y(I) ,   100 ,'.','r');  
        sc =  scatter(X(I_group) ,Y(I_group) ,   100 ,'.','MarkerEdgeColor',col(j,:));  
%         sc =  scatter(X(I_group) ,Y(I_group) ,   100 ,'.','MarkerFaceColor',col(j,:),'MarkerEdgeColor',colE(j,:),'LineWidth',0.1);  
%         set(sc,scOpts{:})
    end
%     dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');    
    scatter(1,13,100,'.k')
    plot([1,1]*1,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
%     y = colorbar
%     y.Label = '$\w_t^T \Psi^T$';
    
%     axis off 
    
    
    h = colorbar;
    set( h, colorBarOpts{:})
%     xlabel('Frequency')
%     ylabel('Width')
    tx1 = ['$\mathbf{w_t}^T \mathbf{\Psi}^T$'];
    ylabel(h, tx1, 'Interpreter', 'latex','Rotation',0 )
    
    axis off
    set( h, colorBarOpts{:})

    
    
    
    
    
    
    
    
    
    
    
    

%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% 
% set(fig2,'InvertHardcopy','on');
% set(fig2,'PaperUnits', 'inches');
% papersize = get(fig2, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(fig2, 'PaperPosition', myfiguresize);
% 
% % Saving figure 
% print(fig2, ['figs' filesep 'Figure_R1_sensorDistrubtion' ], '-dpng', '-r600');
% 
% % total hack, why does saving to svg scale image up???
% stupid_ratio = 15/16;
% myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
% set(fig2, 'PaperPosition', myfiguresize);
% 
% print(fig2, ['figs' filesep 'Figure_R1_sensorDistrubtion' ], '-dsvg');
