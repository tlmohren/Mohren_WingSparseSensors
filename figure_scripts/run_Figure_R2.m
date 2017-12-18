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

% set(groot, 'defaultAxesTickLabelInterpreter', 'factory');
addpathFolderStructure()
w = warning ('off','all');

% pre plot decisions 
width = 4.8;     % Width in inches,   find column width in paper 
height = 3.8;    % Height in inches

set(0,'DefaultAxesFontSize',7)% .
% set(0,'DefaultAxesLabelFontSize', 8/6)
%% Data collection 
% parameterSetName = 'R1toR4_Iter5_delay5_eNet09';
parameterSetName = 'R1toR4_Iter10_run1';

overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
github_loc = 'accuracyData';
    
try
    load([github_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = github_loc;
catch
    display('not on github, looking at old data')
    load([overflow_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = overflow_loc;
end 

fixPar.nIterFig = 10;
fixPar.nIterSim = 10; 
data
% figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2A' )));
% varParCombinationsR2A = varParCombinationsAll(figMatch);
% [dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinationsR2A);


[dataStruct,paramStruct]                    = combineDataMat( fixPar, simulation_menu.R2_q );

[dataStructAllnoFilt,paramStructAllnoFilt]  = combineDataMat( fixPar, simulation_menu.R2_all_nofilt );

[dataStructAllFilt,paramStructAllFilt]      = combineDataMat( fixPar, simulation_menu.R2_all_filt );



% display('added paths')
% %
% figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsNoFilt' )));
% varParCombinationsR2A_allNoFilt = varParCombinationsAll(figMatch);
% [dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinationsR2A_allNoFilt);
% 
% figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R2allSensorsFilt' )));
% varParCombinationsR2A_allFilt = varParCombinationsAll(figMatch);
% [dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinationsR2A_allFilt);



ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);
%% 

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
%     'xtick',[0:10:30 ],'xticklabel',{[0:10:30] },...   
%         'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
%     'xtick',[0:15:30,errLocFig2A ],'xticklabel',{'0','15','30','\textbf{ {1326}}'},...
    };
axisOptsFig2In = { 'box', 'on',...    
     'ytick',0.5:0.25:1, 'yticklabel',{'0.5',' ','1'},...
     'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
    'xtick',[10,20,30,errLocFig2A],'xticklabel',{'','','',''},...   
%         'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] ,...
%     'xtick',[0:15:30,errLocFig2A ],'xticklabel',{'0','15','30','\textbf{ {1326}}'},...
    };
% col = {ones(3,1)*0.5,'-r'};
col = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 

n_plots = 16; 
n_x = length( simulation_menu.R2_q.theta_distList);
n_y = length(simulation_menu.R2_q.phi_distList);
d_x = 4;



%% 

    subInds = subGrid( 1,  2:end );
subplot(pX,pY,subInds)
%     text(0,0,'\bf{Flapping Disturbance}, $\dot{\phi}^*$' ,'FontSize',fszM)
    text(0.3,0,'\bf{Flapping Disturbance}, ${  \dot{\phi}^* }$' ,'FontSize',fszM)
    axis off 
    
    subInds = subGrid( 2:end,1);
subplot(pX,pY,subInds)
%     tx  = text(0,0,'\bf{Rotation Disturbance}, $\dot{\theta}^*$','Rotation',90 ,'FontSize',fszM);
%     tx  = text(0,0.3,'\bf{Rotation Disturbance}, ${\boldmath \dot{\theta}^* }$','Rotation',90 ,'FontSize',fszM);
    tx  = text(0,0.3,'\bf{Rotation Disturbance}, ${ \dot{\theta}^* }$','Rotation',90 ,'FontSize',fszM);
%     tx  = text(0.2,0.3,'\bf{Flapping Disturbance}, ${\boldmath \dot{\phi}^* }$','Rotation',90 ,'FontSize',fszM);
%     tx  = text(0.4,0.3,'\bf{Flapping Disturbance}, ${\bm \dot{\phi}^* }$','Rotation',90 ,'FontSize',fszM);
    axis off 
%% 
phantomH = {'$\phantom{}$','$\phantom{}$','$\phantom{0}$','$\phantom{0}$'};
phantomV = {'$\phantom{}$','$\phantom{}$','$\phantom{0}$','$\phantom{}$'};
for j = 1:4
   inds = subGrid( 2, RowS(j):RowE(j) );
   subplot(pY,pX,inds(:))
   tx = [phantomH{j} ' $\dot{\phi^*}=$' num2str( spa_sf( simulation_menu.R2_q.phi_distList(j),2) )];
   txt1 = text(0,0, tx  ,'FontSize',fszM );
   axis off
   
   
   inds = subGrid(  RowS(j):RowE(j),2 );
   subplot(pY,pX,inds(:))
   if mod(j,2)==0
        x = [0 1 1 0];  y = [0 0 1 1];
        pc = patch(x,y,[1,1,1]*0.85,'EdgeColor','none');
   end
   
   tx = [phantomV{j} ' $\dot{\theta^*}=$' num2str( spa_sf(simulation_menu.R2_q.theta_distList(j),2)  ) ];
   text(0,0,tx  ,'FontSize',fszM ,'Rotation',90 )
   axis off
   
   
   
end
%% 
ebar_linewidth = 0.3;
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*d_x + k;
        plot_nr = (j-1)*n_x + k;
        
%         subplot(n_y,d_x, sub_nr)
%         (RowS(j):RowE(j))
%          (RowS(k):RowE(k)) 
% subGrid( (RowS(j):RowE(j)),  (RowS(k):RowE(k))  )
        subInds = subGrid( (RowS(j):RowE(j)),  (RowS(k):RowE(k))  );
      subplot(pX,pY,subInds(:)     )
        
        hold on
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( plot_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(plot_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(plot_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(plot_nr,:)  ) );
%         errorbar(errLocFig2A,meanval,stdval,'b','LineWidth',ebar_linewidth)
%         plot([-1,1]+errLocFig2A,[meanval,meanval],'b','LineWidth',ebar_linewidth)   
        scatter(errLocFig2A,meanval,8,'filled','bd')
        
        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(plot_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(plot_nr,:)  ) );
%         errorbar(errLocFig2A,meanval,stdval,'k','LineWidth',ebar_linewidth)
%         plot([-1,1]+errLocFig2A,[meanval,meanval],'k','LineWidth',ebar_linewidth)   
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
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig2,'InvertHardcopy','on');
set(fig2,'PaperUnits', 'inches');
papersize = get(fig2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig2, 'PaperPosition', myfiguresize);

%% Saving figure 
print(fig2, ['figs' filesep 'Figure_R2' ], '-dpng', '-r600');
% print(fig2, ['figs' filesep 'Figure_R2pdf' ], '-dpdf');


stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig2, 'PaperPosition', myfiguresize);

print(fig2, ['figs' filesep 'Figure_R2'], '-dsvg', '-r600');


