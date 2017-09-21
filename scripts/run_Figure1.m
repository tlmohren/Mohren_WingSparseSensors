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

set(groot, 'defaultAxesTickLabelInterpreter', 'factory');
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()
w = warning ('off','all');

%% 

% parameterSetName    = 'R1R2withExpFilterIter5';
% parameterSetName    = 'subPartPaperR1Iter5_delay3_6';
% parameterSetName    = 'subPartPaperR1Iter5_delay4_forReal';
% parameterSetName    = 'subPartPaperR1Iter5_delay4_eNet08';
% parameterSetName    = 'subPartPaperR1Iter5_delay4_eNet1';
% parameterSetName    = 'subPartPaperR1Iter5_delay4_eNet1';
% parameterSetName    = 'subPartPaperR1Iter3_delay4_eNet08';
% parameterSetName    = 'R1toR4Iter10_delay4_subSamp10';

% parameterSetName    = 'subPartPaperR1Iter3_delay4_singValMult0_eNet1';
% parameterSetName    = 'subPartPaperR1Iter3_delay4_singValMult0_eNet098'
% parameterSetName    = 'subPartPaperR1Iter3_delay4_singValMult0_eNet099'
% parameterSetName    = 'subPartPaperR1Iter3_delay4_singValMult0_eNet095';
% parameterSetName    = 'subPartPaperR1Iter3_delay4_singValMult0_eNet08';
% parameterSetName    = 'subPartPaperR1Iter3_delay4_singValMult0_eNet09';
% parameterSetName    = 'subPartPaperR1Iter5_delay4_eNet09';
% parameterSetName    = 'subPartPaperR1Iter5_delay4_eNet09';
parameterSetName    = 'subPartPaperR1Iter5_delay4_singValsMult0_eNet09';

load(['data' filesep 'parameterSet_', parameterSetName])

figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_disturbance' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStruct,paramStruct] = combineDataMat(fixPar,varParCombinations);

ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);

%% 
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_allSensorsNoFilt' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,varParCombinations);

%% 
figMatch = find(~cellfun('isempty', strfind({varParCombinationsAll.resultName} , 'R1_allSensorsFilt' )));
varParCombinations = varParCombinationsAll(figMatch);
[dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,varParCombinations);

%% Figure settings

errLocFig1A = 35;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] };
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 

%% Figure 2A
fig1A=figure('Position', [100, 600, 600, 450]);

hold on
%---------------------------------SSPOCoff-------------------------
if any(ind_SSPOCoff)
    Dat_I = ind_SSPOCoff( 1);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
    realNumbers = find(~isnan(meanVec));
    a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
end
%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));
for k2 = 1:size(dataStruct.dataMatTot,2)
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
    scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
end
plot(realNumbers, meanVec(realNumbers),col{2})
%--------------------------------Allsensors Neural filt-------------------------    
meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(1,:)  ) );
stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(1,:)  ) );
errorbar(errLocFig1A,meanval,stdval,'b','LineWidth',1)
plot([-1,1]+errLocFig1A,[meanval,meanval],'b','LineWidth',1)   
%--------------------------------Allsensors no NF-------------------------    
meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(1,:)  ) );
stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(1,:)  ) );
errorbar(errLocFig1A,meanval,stdval,'k','LineWidth',1)
plot([-1,1]+errLocFig1A,[meanval,meanval],'k','LineWidth',1)   
%--------------------------------Figure cosmetics-------------------------    
ylh = get(gca,'ylabel');                                            % Object Information
ylp = get(ylh, 'Position');
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
grid on 
set(gca, axisOptsFig1A{:})
drawnow

saveas(fig1A,['figs' filesep 'Figure1A_' parameterSetName '.png'])

%%
fig1B = figure();
q = 10;
binar = get_pdf( dataStruct.sensorMatTot(2,q,1:q,:));
plotSensorLocs(binar,fixPar)
if sum(binar) == 0
   display(['no simulations ended on q = ' num2str(q)] ) 
end

saveas(fig1B,['figs' filesep 'Figure1B_' parameterSetName '.png'])

%% 
