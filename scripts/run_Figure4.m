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

%% 
% parameterSetName    = 'R3R4withExpFilterIter5';
% parameterSetName    = 'R1toR4Iter10_delay4';
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

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R4' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructB,paramStructB] = combineDataMat(fixPar,varParCombinations);
ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);

%% Figure 4

errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
n_x =  length(varParCombinations.NLDgradList);
n_y = length(varParCombinations.NLDshiftList);
n_plots = n_x*n_y;

if plot_on == true
    fig4plots=figure('Position', [100, 100, 950, 750]);
end
for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_x + k;
        if plot_on == true
            subplot(n_y,n_x, sub_nr)
            hold on
        end
        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoffB( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));
        if plot_on == true
            a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        end
        thresholdMatB(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOConB(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
        realNumbers = find(~isnan(meanVec));        
        thresholdMatB(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
        
        if plot_on == true
            for k2 = 1:size(dataStructB.dataMatTot,2)
                iters = length(nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) );
                scatter( ones(iters,1)*k2,nonzeros(dataStructB.dataMatTot(Dat_I,k2,:)) , dotcol{2})
            end
            plot(realNumbers, meanVec(realNumbers),col{2})
            %--------------------------------Figure cosmetics-------------------------    
            ylh = get(gca,'ylabel');                                            % Object Information
            ylp = get(ylh, 'Position');
            set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
            grid on 
            set(gca, axisOptsFig2A{:})
    %         title( paramStructB(Dat_I).phi_dist)
            axis off 
            drawnow
        end
    end
end
if plot_on == true
    tightfig;
end


%% Figure 4
fig4 = figure();
set(fig4, 'Position', [fig4.Position(1:2) width*100, height*100]); %<- Set size
plot_on = true ;

%% Axis makeup 
errLocFig2A = 40;
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

n_x = length(varParCombinations.NLDgradList);
n_y =  length(varParCombinations.NLDshiftList);
d_x = 19;
% pltSTA = repmat(13:19, 5, 1)+ repmat( (0:4)', [1,7])*19;

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*d_x + k;
%         plot_nr = (j-1)*n_x + k;
        subplot(n_y,d_x, sub_nr)
        hold on
        varPar.STAwidth = varParCombinations.STAwidthList(1);
        varPar.STAfreq = varParCombinations.STAfreqList(1);
        varPar.NLDshift = varParCombinations.NLDshiftList(j);
        varPar.NLDgrad = varParCombinations.NLDgradList(k);
        [STAfunc,NLDfunc]= createNeuralFilt (fixPar,varPar);
        NLDs = -1:0.1:1;
        plot( NLDs,NLDfunc(NLDs),'k')
        axis([-1,1,0,1])
        axis off
        if ( 0.45 <= varPar.NLDshift && varPar.NLDshift <= 0.55 && 9.8<= varPar.NLDgrad && varPar.NLDgrad <= 10.2)
%             plot( NLDs,NLDfunc(NLDs),'r')
            plot( [-1,1,1,-1,-1]*1.2,[-0.05,-0.05,1.05,1.05,-0.05]*1.1,'r','LineWidth',0.5)
            axis([ [-1,1]*1.2 ,-0.05,1.05]*1.1)
        end
    end
end

%% Heatmap & Mask 
thresholdMatB( isnan(thresholdMatB) ) = 35;
xtickList = 1:2:length(varParCombinations.NLDgradList);
ytickList = 1:5:length(varParCombinations.NLDgradList);

axisOptsFig4_heatMap = {'xtick', xtickList,...
    'xticklabel',varParCombinations.NLDgradList(xtickList),...
    'ytick', ytickList,...
    'yticklabel',varParCombinations.NLDshiftList(ytickList),...
     'clim',[0,35]};
 
summerWithBlack = flipud(summer(300));
summerWithBlack = [ summerWithBlack ; ones(50,3)*0.1];%     summerMa
colorBarOpts = { 'YDir', 'reverse', 'Ticks' ,[0:10:30,34], 'TickLabels', {0,10,20,30,'$>$ 30' }  ,'TickLabelInterpreter','latex'};

pltTop = repmat(13:19, 5, 1)+ repmat( (0:4)', [1,7])*19;
pltBottom = repmat(13:19, 5, 1)+ repmat( (6:10)', [1,7])*19;

subplot(11,19,pltTop(:))
    imagesc(thresholdMatB(:,:,2))
    colormap( summerWithBlack );
    set(gca, axisOptsFig4_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
    title('Optimal')
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,8.5+ [1,1;1,0;0,0;0,1],'r')

subplot(11,19,pltBottom(:))
    imagesc(thresholdMatB(:,:,1))
    colormap( summerWithBlack );
    set(gca, axisOptsFig4_heatMap{:})
    h = colorbar;
    set( h, colorBarOpts{:})
    ylabel(h, 'Sensors for 75\% Accuracy', 'Interpreter', 'latex')
    title('Random')
    hold on
    plot( 5.5 + [0,1 ; 1,1;1,0;0,0] ,8.5+ [1,1;1,0;0,0;0,1],'r')
    xlabel('$\zeta$'); ylabel('$\eta$')  
    
%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% % % Here we preserve the size of the image when we save it.
set(fig4,'InvertHardcopy','on');
set(fig4,'PaperUnits', 'inches');
papersize = get(fig4, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig4, 'PaperPosition', myfiguresize);

%% Saving figure 
print(fig4, ['figs' filesep 'Figure_R4' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig4, 'PaperPosition', myfiguresize);

print(fig4, ['figs' filesep 'Figure_R4' ], '-dsvg');
