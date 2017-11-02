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
width = 3.3;     % Width in inches,   find column width in paper 
height = 3.4;    % Height in inches

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


%% setup figure S2 
figS1 = figure();
set(figS1, 'Position', [figS1.Position(1:2) width*100, height*100]); %<- Set size

for j = 1:fixPar.rmodes
    subplot(10,6,j*2-1)
        pcolor( reshape(Us(:,j),26,51)  )
        axis off 
        txt = text(3,5,num2str(j),'Color','w');
    subplot(10,6,j*2)
        plot(1:100,Vs(2901:3000,j));
        hold on
        plot(101:200,Vs(3001:3100,j))
        axis off 
end
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


%% setup figure S1
figS2 = figure();
% subplot(1,2,1)
set(figS2, 'Position', [figS2.Position(1:2) width*100, height*100]); %<- Set size
for j = 1:fixPar.rmodes
    subplot(10,6,j*2-1)
        pcolor( reshape(U(:,j),26,51)  )
        axis off 
        txt = text(3,5,num2str(j),'Color','w');
    subplot(10,6,j*2)
        plot(1:100,V(2901:3000,j));
        hold on
        plot(101:200,V(3001:3100,j))
        axis off 
end
tightfig;
set(figS2,'InvertHardcopy','on');
set(figS2,'PaperUnits', 'inches');
papersize = get(figS2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(figS2, 'PaperPosition', myfiguresize);

figS2.Color = 'w';
% Saving figure 
print(figS2, ['figs' filesep 'Figure_S2' ], '-dpng', '-r600');

%% setup figure S3
width = 3.3;     % Width in inches,   find column width in paper 
height = 1.5;    % Height in inches
figS1 = figure();
set(figS1, 'Position', [figS1.Position(1:2) width*100, height*100]); %<- Set size

semilogy(diagS(1:30),'o')
hold on
semilogy(diagSs(1:30),'*')
xlabel('Singular Value Index')
ylabel('Normalized Magnitude')
legend('Encoded Strain','Strain','Location','NorthEastOutside')

set(figS1,'InvertHardcopy','on');
set(figS1,'PaperUnits', 'inches');
papersize = get(figS1, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(figS1, 'PaperPosition', myfiguresize);

% Saving figure 
print(figS1, ['figs' filesep 'Figure_S3' ], '-dpng', '-r600');

