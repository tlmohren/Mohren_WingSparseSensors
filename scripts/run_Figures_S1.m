%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

%------------------------------
clear all, close all, clc
addpathFolderStructure()

parameterSetName    = '';
iter                = 1;
figuresToRun        = {'subSetTest'};
fixPar.data_loc     = 'accuracyData';
svg_save            = false; 
width = 7;     % Width in inches,   find column width in paper 
height = 4;    % Height in inches

%%  data gathering 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
strainStruct = load(['introFigData' filesep 'noise1.mat'] );
strainSet = strainStruct.strain;
varPar = varParStruct(1);
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

varParStrain = varPar;
varParStrain.NLDgrad = -1;
varParStrain.STAfreq = 1;
varParStrain.STAwidth = 0.01;
[Xstrain,~] = neuralEncoding(strainSet, fixPar,varParStrain );

[U,S,V] = svd(X,'econ');
diagS = diag(S)/sum(S(:));
[Us,Ss,Vs] = svd(Xstrain,'econ');
diagSs = diag(Ss)/sum(Ss(:));




inoffensiveBlue =[247,252,240
224,243,219
204,235,197
168,221,181
123,204,196
78,179,211
43,140,190
8,104,172
8,64,129];
strainScheme = colorSchemeInterp(inoffensiveBlue/255, 500);

fireRed = [255,247,236
254,232,200
253,212,158
253,187,132
252,141,89
239,101,72
215,48,31
179,0,0
127,0,0];
fireScheme = colorSchemeInterp(fireRed/255, 500);

%% setup figure S1 & S2 
figS1 = figure();
set(figS1, 'Position', [figS1.Position(1:2) width*100, height*100]); %<- Set size

subS = reshape(1:11*13,13,11)';
    colormap(strainScheme)
    strainS = reshape( subS(2:end,[1,3,5]), 30,1);
    pfireS = reshape( subS(2:end,[8,10,12]), 30,1);
for j = 1:fixPar.rmodes
%     subplot(10,13,j*2-1)
    subplot(11,13,strainS(j) )
    
        pcolor( reshape(Us(:,j),26,51)  )
        axis off 
        txt = text(6,10,num2str(j),'Color','w');
    subplot(11,13,strainS(j) +1 )
        plot(1:100,Vs(2901:3000,j));
        hold on
        plot(101:200,Vs(3001:3100,j))
        axis off 
end

for j = 1:fixPar.rmodes
%     subplot(10,13,j*2-1)
    sp1 =  subplot(11,13,pfireS(j) );
    colormap(sp1,fireScheme)
        pcolor( reshape(U(:,j),26,51)  )
        axis off 
%         txt = text(3,5,num2str(j),'Color','w');
        txt = text(6,10,num2str(j),'Color','w');
    sp2= subplot(11,13,pfireS(j)+1 );
    colormap(sp2,fireScheme)
        plot(1:100,V(2901:3000,j));
        hold on
        plot(101:200,V(3001:3100,j))
        axis off 
end
col = [0 0.4470 0.7410;...
    0.8500 0.3250 0.0980];


subplot(11,13,1)

    text(0,0,'Raw Strain','FontSize',8)
    axis off

subplot(11,13,3)
    text(0,0,'Mode','FontSize',8)
    axis off
subplot(11,13,4)
    text(0,0.5,'Flapping','Color',col(1,:),'FontSize',8)
    text(0,0,'With Rotation','Color',col(2,:),'FontSize',8)
    axis off
subplot(11,13,8)
    text(0,0,'Encoded Strain','FontSize',8)
    axis off
    

subplot(11,13,10)
    text(0,0,'Mode','FontSize',8)
    axis off
subplot(11,13,11)
    text(0,0.5,'Flapping','Color',col(1,:),'FontSize',8)
    text(0,0,'With Rotation','Color',col(2,:),'FontSize',8)
    axis off
    
    
tightfig;
set(figS1,'InvertHardcopy','on');
set(figS1,'PaperUnits', 'inches');
papersize = get(figS1, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(figS1, 'PaperPosition', myfiguresize);

figS1.Color = 'w';
% Saving figure 
print(figS1, ['figs' filesep 'Figure_S1' ], '-dpng', '-r600');
















%% setup figure S3
width = 4;     % Width in inches,   find column width in paper 
height = 3;    % Height in inches
logOpts = { 'XLim',[0,50],'YLim',[1e-17, 2] };

figS2 = figure();
set(figS2, 'Position', [figS2.Position(1:2) width*100, height*100]); %<- Set size
  
   
    strainLog = semilogy(diagSs(1:50),'ok' ,'MarkerFaceColor','k');
     hold on
    semilogy(diagS(1:50),'+r')
 

    ax = gca();
    set(ax,logOpts{:})


xlabel('Singular Value Index','FontSize',8)
ylabel('Normalized Singular Values','FontSize',8)
legend('Strain','Strain With Neural Encoding','Location','Best')

set(figS2,'InvertHardcopy','on');
set(figS2,'PaperUnits', 'inches');
papersize = get(figS2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(figS2, 'PaperPosition', myfiguresize);

% Saving figure 
print(figS2, ['figs' filesep 'Figure_S2' ], '-dpng', '-r600');
print(figS2, ['figs' filesep 'Figure_S2' ], '-dsvg', '-r600');

