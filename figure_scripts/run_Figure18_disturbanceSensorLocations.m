%------------------------------
% run_Figure_R2_disturbance
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clc;clear all; close all 
addpathFolderStructure()
w = warning ('off','all');

% pre plot decisions 
width = 4.8;     % Width in inches,   find column width in paper 
height = 3.8;    % Height in inches

set(0,'DefaultAxesFontSize',7)% .
%% Data collection 
parameterSetName = 'R2_Iter10';
load([ 'accuracyData' filesep 'parameterSet_' parameterSetName ])
fixPar.data_loc = 'accuracyData';
fixPar.nIterFig = 10;

[dataStruct,paramStruct]                    = combineDataMat( fixPar, simulation_menu.R2_q );
[dataStructAllnoFilt,paramStructAllnoFilt]  = combineDataMat( fixPar, simulation_menu.R2_all_nofilt );
[dataStructAllFilt,paramStructAllFilt]      = combineDataMat( fixPar, simulation_menu.R2_all_filt );

ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);
%%  subplot organisation 
tw = 2;
th = 2;

dx = 2;
pX = tw+1+4*dx;
pY = th+1+4*dx;
subGrid = reshape(1:(pX*pY),pX,pY)';

RowE = th+1 + (1:4)*dx;
RowS = RowE+1 -dx;

%% Figure settings
fig2 = figure();
set(fig2, 'Position', [fig2.Position(1:2) width*100, height*100]); %<- Set size
plot_on = false;

fszL = 8;  
fszM = 7;
fszS = 6; 
%% Axis makeup 
errLocFig2A = 34;
axisOptsFig2Out = { 'box', 'on',...    
     'ytick',0.5:0.25:1, 'yticklabel',{'0.5',' ','1'},...
     'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
    'xtick',[10,20,30,errLocFig2A],'xticklabel',{'10',' ','30',''},...  
    };
axisOptsFig2In = { 'box', 'on',...    
     'ytick',0.5:0.25:1, 'yticklabel',{'0.5',' ','1'},...
     'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
    'xtick',[10,20,30,errLocFig2A],'xticklabel',{'','','',''},...   
    };
col = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 

n_plots = 16; 
n_x = length( simulation_menu.R2_q.theta_distList);
n_y = length(simulation_menu.R2_q.phi_distList);
d_x = 4;

%% 
subplot(pX,pY, subGrid( 1,  2:end )  )
    text(0.3,0,'\bf{Flapping Disturbance}, ${  \dot{\phi}^* }$' ,'FontSize',fszM)
    axis off 
    
subplot(pX,pY, subGrid( 2:end,1) )
    tx  = text(0,0.3,'\bf{Rotation Disturbance}, ${ \dot{\theta}^* }$','Rotation',90 ,'FontSize',fszM);
    axis off 
%% 
phantomH = {'$\phantom{}$','$\phantom{}$','$\phantom{0}$','$\phantom{0}$'};
phantomV = {'$\phantom{}$','$\phantom{}$','$\phantom{0}$','$\phantom{}$'};
for j = 1:4
   subplot( pY,pX,  subGrid( 2, RowS(j):RowE(j) ) )
       tx = [phantomH{j} ' $\dot{\phi^*}=$' num2str( spa_sf( simulation_menu.R2_q.phi_distList(j),2) )];
       txt1 = text(0,0, tx  ,'FontSize',fszM );
       axis off
   subplot( pY,pX, subGrid(  RowS(j):RowE(j),2 ))
       if mod(j,2)==0
            x = [0 1 1 0];  y = [0 0 1 1];
            pc = patch(x,y,[1,1,1]*0.85,'EdgeColor','none');
       end
       tx = [phantomV{j} ' $\dot{\theta^*}=$' num2str( spa_sf(simulation_menu.R2_q.theta_distList(j),2)  ) ];
       text(0,0,tx  ,'FontSize',fszM ,'Rotation',90 )
       axis off   
end
%% 
for j = 1:n_y
    for k = 1:n_x
%         sub_nr = (j-1)*d_x + k;
        plot_nr = (j-1)*n_x + k;
        subInds = subGrid( (RowS(j):RowE(j)),  (RowS(k):RowE(k))  );
        subplot(pX,pY,subInds(:)     )
        hold on
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( plot_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',false);
        
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(plot_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',2);
        
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(plot_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(plot_nr,:)  ) );
        scatter(errLocFig2A,meanval,8,'filled','rd')
  
        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(plot_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(plot_nr,:)  ) );
        scatter(errLocFig2A,meanval,8,'filled','kd')
        %--------------------------------Figure cosmetics-------------------------    
        grid on 
        if  plot_nr <13
            set(gca, 'Xtick',[],'XTicklabel', []);
            set(gca, axisOptsFig2In{:})
        elseif plot_nr == 13
            xlabel('$q$')
            ylabel('Accuracy')
            set(gca, axisOptsFig2Out{:})
        else
            set(gca, axisOptsFig2Out{:})
%             break_axisSubPlot('axis','x','position',38, 'length',0.02)
        end
        if ~rem(plot_nr-1,4)== 0
            set(gca, 'YTicklabel', []);
        end
        drawnow
    end
end

%% Setting paper size for saving 
% % set(fig2,'InvertHardcopy','on');
% % set(fig2,'PaperUnits', 'inches');
% % papersize = get(fig2, 'PaperSize');
% % left = (papersize(1)- width)/2;
% % bottom = (papersize(2)- height)/2;
% % myfiguresize = [left, bottom, width, height];
% % set(fig2, 'PaperPosition', myfiguresize);
% % print(fig2, ['figs' filesep 'Figure_R2' ], '-dpng', '-r600');
% % stupid_ratio = 15/16;
% % myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
% % set(fig2, 'PaperPosition', myfiguresize);
% % print(fig2, ['figs' filesep 'Figure_R2'], '-dsvg', '-r600');










%% 

%% 

width = 10;     % Width in inches,   find column width in paper 
height = 7;    % Height in inches
fig3 = figure();
set(fig3, 'Position', [fig2.Position(1:2)-[0,300] width*100, height*100]); %<- Set size


subplot(pX,pY, subGrid( 1,  2:end )  )
    text(0.3,0,'\bf{Flapping Disturbance}, ${  \dot{\phi}^* }$' ,'FontSize',fszM)
    axis off 
    
subplot(pX,pY, subGrid( 2:end,1) )
    tx  = text(0,0.3,'\bf{Rotation Disturbance}, ${ \dot{\theta}^* }$','Rotation',90 ,'FontSize',fszM);
    axis off 
%
phantomH = {'$\phantom{}$','$\phantom{}$','$\phantom{0}$','$\phantom{0}$'};
phantomV = {'$\phantom{}$','$\phantom{}$','$\phantom{0}$','$\phantom{}$'};
for j = 1:4
   subplot( pY,pX,  subGrid( 2, RowS(j):RowE(j) ) )
       tx = [phantomH{j} ' $\dot{\phi^*}=$' num2str( spa_sf( simulation_menu.R2_q.phi_distList(j),2) )];
       txt1 = text(0,0, tx  ,'FontSize',fszM );
       axis off
   subplot( pY,pX, subGrid(  RowS(j):RowE(j),2 ))
       if mod(j,2)==0
            x = [0 1 1 0];  y = [0 0 1 1];
            pc = patch(x,y,[1,1,1]*0.85,'EdgeColor','none');
       end
       tx = [phantomV{j} ' $\dot{\theta^*}=$' num2str( spa_sf(simulation_menu.R2_q.theta_distList(j),2)  ) ];
       text(0,0,tx  ,'FontSize',fszM ,'Rotation',90 )
       axis off   
end

%% 
        upLim = [0.4,0.7,1.1];
        lowLim = [-0.1,0.4,0.7];
        dim = [0.1,0.5,1];
        col = [255,140,140
        255,70,70
        255,0,0]/255;
        colE = zeros(3,3);
        scOpts = {'MarkerFaceAlpha',0.5};
        colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
        axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};

q = 11;
for j = 1:n_y
    for k = 1 :n_x
        plot_nr = (j-1)*n_x + k;
        subInds = subGrid( (RowS(j):RowE(j)),  (RowS(k):RowE(k))  );
        subplot(pX,pY,subInds(:)     )
        
        
        hold on
        plot(x,y,'k','LineWidth',0.5)
        plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
        pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
        scatter(0,13,100,'.k')
        
        iter = length(nonzeros( dataStruct.sensorMatTot( ind_SSPOCon(plot_nr) ,q,1,: ) ) );
        binar           = get_pdf( dataStruct.sensorMatTot( ind_SSPOCon(plot_nr) ,q,1:q,1:iter));
        w_sspoc = nonzeros(binar);
        sensorloc_tot   = reshape(binar,fixPar.chordElements,fixPar.spanElements); 

        x   = [0 1 1 0]* (fixPar.spanElements+1);  
        y   = [0 0 1 1]* (fixPar.chordElements+1);
        [X,Y] = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
        I = find( sensorloc_tot );      
%         sc  = scatter(X(I) ,Y(I) , 100 ,'.','r');      
        for j2 = 1:3
            I_group = I( (w_sspoc < upLim(j2)) & (w_sspoc >lowLim(j2)) );
        %             scatter(X(I) ,Y(I) ,   100 ,'.','r');  
            sc =  scatter(X(I_group) ,Y(I_group) ,   100 ,'.','MarkerEdgeColor',col(j2,:));  
        end
        % create black frame 
        ax = gca(); 
        set(ax,axOpts{:})
        axis off
    end
end
