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

set(0,'defaultLineLineWidth',0.3);   % set the default line width to lw
set(0,'defaultLineMarkerSize',2); % set the default line marker size to msz
% pre plot decisions 
width = 7;     % Width in inches,   find column width in paper 
height = 2.5;    % Height in inches
plot_on = false ;

%% data collection
% parameterSetName    = 'R3R4withExpFilterIter5';
% parameterSetName    = 'R1toR4Iter10_delay4';
% parameterSetName    = 'R1R4Iter10_delay3_6_fixSTAwidth';
% parameterSetName = 'R1R4_Iter3_delay5_eNet09';
parameterSetName = 'R1R4_Iter5_delay5_eNet09';

overflow_loc = 'D:\Mijn_documenten\Dropbox\A. PhD\C. Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
github_loc = 'accuracyData';

try
    load([github_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = github_loc;
catch
    display('not on github, looking at old data')
    load([overflow_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = overflow_loc;
end 

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R3' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinations);
ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);

% plot_on = plas;
%% Figure 2B

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

n_x = length(varParCombinations.STAwidthList);
n_y =  length(varParCombinations.STAfreqList);
n_plots = n_x*n_y;
if plot_on == true
    fig4plots=figure('Position', [50, 50, 1200, 1000]);
end

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoffB( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        
        if plot_on 
            subplot(n_y,n_x, sub_nr)
            hold on
            a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        end
        thresholdMatB(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOConB(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        
        
        if plot_on == 1
            for k2 = 1:size(dataStructB.dataMatTot,2)
                iters = length(nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) );
                scatter( ones(iters,1)*k2,nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) , dotcol{2})
                plot(realNumbers, meanVec(realNumbers),col{2})
            end
        end
        thresholdMatB(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        if plot_on == 1
        %--------------------------------Figure cosmetics-------------------------    
            ylh = get(gca,'ylabel');                                            % Object Information
            ylp = get(ylh, 'Position');
            set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
            grid on 
            set(gca, axisOptsFig2A{:})
            axis off 
            drawnow
        end
    end
end


if plot_on == true
    tightfig;
end

%% Figure 3
fig3 = figure();
set(fig3, 'Position', [fig3.Position(1:2) width*100, height*100]); %<- Set size
plot_on = true ;

%% Axis makeup 
errLocFig2A = 40;
axisOptsFig2A = {'xtick',[0:15:30,errLocFig2A ],'xticklabel',{'0','15','30','\textbf{ {1326}}'},...
    'ytick',0.4:0.3:1 ,'xlim', [-1,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

n_x = length(varParCombinations.STAwidthList);
n_y =  length(varParCombinations.STAfreqList);
d_x = 19;
pltSTA = repmat(13:19, 5, 1)+ repmat( (0:4)', [1,7])*19;


% fixPar.STAdelay = 3;
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*d_x + k;
%         plot_nr = (j-1)*n_x + k;
        subplot(n_y,d_x, sub_nr)
        hold on
        varPar.STAfreq = varParCombinations.STAfreqList(k);
        varPar.STAwidth = varParCombinations.STAwidthList(j);
        varPar.NLDshift = varParCombinations.NLDshiftList;
        varPar.NLDgrad = varParCombinations.NLDgradList;
        [STAfunc,NLDfunc]= createNeuralFilt (fixPar,varPar);
        if  isfield(fixPar,'subSamp') == 0 
            STAt = -39:1:0;
        else
            STAt = -39:1/fixPar.subSamp:0;
        end
        plot( STAt,STAfunc(STAt),'k')
        axis([-39,0,-1,1.2])
        axis off
        grid on 
        if (varPar.STAfreq == 1 && varPar.STAwidth == 4)
%             plot( STAt,STAfunc(STAt),'r','Linewidth',2)
            plot( [-40,1,1,-40,-40],[-1,-1,1,1,-1]+0.2,'r','LineWidth',0.5)
        axis([-40,1,-1,1.2])
        end
%         scatter(STAt,STAfunc(STAt),'.','k')
    end
end

%% Heatmap & Mask 
thresholdMatB( isnan(thresholdMatB) ) = 35;
tickList = 1:5:length(varParCombinations.STAfreqList);
axisOptsFig3_heatMap = {
    'xtick', tickList,...
    'xticklabel',varParCombinations.STAfreqList(tickList),...
    'ytick', tickList,...
    'yticklabel',varParCombinations.STAwidthList(tickList), ...
     'clim',[0,35]};

colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,[0:10:30,34], 'TickLabels', {0,10,20,30,'$>$ 30' }  ,'TickLabelInterpreter','latex'};
summerWithBlack = flipud(summer(300));
summerWithBlack = [ summerWithBlack ; ones(50,3)*0.1];%     summerMa

pltTop = repmat(13:19, 5, 1)+ repmat( (0:4)', [1,7])*19;
pltBottom = repmat(13:19, 5, 1)+ repmat( (6:10)', [1,7])*19;

subplot(11,19,pltTop(:))
    imagesc(thresholdMatB(:,:,2))
    colormap( summerWithBlack );
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
    title('Optimal')
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,2.5+ [1,1;1,0;0,0;0,1],'r')
    
subplot(11,19,pltBottom(:))
    imagesc(thresholdMatB(:,:,1))
    colormap( summerWithBlack );
    set(gca, axisOptsFig3_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
    title('Random')
    hold on 
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,2.5+ [1,1;1,0;0,0;0,1],'r')
    xlabel('f [$\frac{Hz}{2 \pi}$]'); ylabel('$\sigma$')
    
%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig3,'InvertHardcopy','on');
set(fig3,'PaperUnits', 'inches');
papersize = get(fig3, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig3, 'PaperPosition', myfiguresize);

%% Saving figure 
print(fig3, ['figs' filesep 'Figure_R3' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig3, 'PaperPosition', myfiguresize);

print(fig3, ['figs' filesep 'Figure_R3' ], '-dsvg');