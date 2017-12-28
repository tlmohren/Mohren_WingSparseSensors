%------------------------------
% run_Figure1_Figure2A_ThetaDistVSPhiDist.m
%
% Plots figures 1 and 2A
%
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)
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
        scatter(errLocFig2A,meanval,8,'filled','bd')
  
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
set(fig2,'InvertHardcopy','on');
set(fig2,'PaperUnits', 'inches');
papersize = get(fig2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig2, 'PaperPosition', myfiguresize);
print(fig2, ['figs' filesep 'Figure_R2' ], '-dpng', '-r600');
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig2, 'PaperPosition', myfiguresize);
print(fig2, ['figs' filesep 'Figure_R2'], '-dsvg', '-r600');


