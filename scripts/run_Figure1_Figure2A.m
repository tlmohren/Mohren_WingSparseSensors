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

par.NF_on = 1;
par.theta_distList = [0.001,0.01,0.1,1] * 10;
par.phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
par.xIncludeList = [0];
par.yIncludeList = [1];
par.SSPOConList = [0,1];
par.STAwidthList = [3];
par.STAshiftList = [-10];% 
par.NLDshiftList = [0.5];
par.NLDsharpnessList = [10];
par.wTruncList = 1:30;
% par.naming = {'10iters'};
par.naming = {'elasticNet09_Week'};
par.allSensors = 0; 
par.sensorMatOn = 1;
par.chordElements = 26;
par.spanElements = 51;
dataStruct = combineDataMat(par);
par.allSensors = 1; 
par.SSPOConList = 2;
par.NF_on = [1,0];
dataStructAll = combineDataMat(par);

% Set which indices you want --------------------------------------------------------
ind_SSPOCoff = 1:2:32;
ind_SSPOCon = ind_SSPOCoff + 1;

%% Figure settings

% Figure 1 settings 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
errLocFig1A = 35;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1   ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1]};

% Figure 2A settings 
errLocFig2A = 38;
axisOptsFig2A = {'xtick',[0:10:30,errLocFig2A ],'xticklabel',{'0','10','20','30','\bf \it 1326'},...
    'ytick',0.4:0.2:1 ,'xlim', [0,errLocFig2A+2],'ylim',[0.4,1] };

% Figure 2C settings 
figure(1)
xh = get(gca, 'Xlabel');
yh = get(gca, 'Ylabel');
xh.String = '$\dot{\phi}^*$';
yh.String = '$\dot{\theta}^*$';
% axisOptsFig2C = {'xtick', [0.01,0.1,1,10]*3.1,'ytick',[0.01,0.1,1,10], ...
%      'XLabel', xh, 'YLabel', yh, 'xscale','log','yscale','log','clim',[0,30]};
 
col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 


axisOptsFig2C = {'xtick', 1:4,'ytick',1:4, ...
    'xticklabel', [0.01,0.1,1,10]*3.1,'yticklabel',[0.01,0.1,1,10], ...
    'xaxislocation','top',...
     'XLabel', xh, 'YLabel', yh,'clim',[0,20]};

%% Figure 2A
n_plots = 16; 
n_x = 4;
n_y = 4; 
par.phi_dist = [0.01,0.1,1,10]*3.1;
par.theta_dist = [0.01,0.1,1,10];
fig2A=figure('Position', [100, 100, 950, 750]);

for j = 1:n_y
    for k = 1:n_x
        sub_nr = (j-1)*n_y + k;
        subplot(n_y,n_x, sub_nr)
        hold on

        %---------------------------------SSPOCoff-------------------------
        Dat_I = ind_SSPOCoff( sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1});
        thresholdMat(j,k,1) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %---------------------------------SSPOCon-------------------------
        Dat_I = ind_SSPOCon(sub_nr);
        [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
        realNumbers = find(~isnan(meanVec));
        for k2 = 1:size(dataStruct.dataMatTot,2)
            iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
        end
        plot(realNumbers, meanVec(realNumbers),col{2})
        thresholdMat(j,k,2) = sigmFitParam(realNumbers,meanVec(realNumbers));

        %--------------------------------Allsensors Neural filt-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

        errorbar(errLocFig2A,meanval,stdval,'k','LineWidth',1)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'k','LineWidth',1)   

        %--------------------------------Allsensors no NF-------------------------    
        meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
        stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );

        errorbar(errLocFig2A,meanval,stdval,'b','LineWidth',1)
        plot([-1,1]+errLocFig2A,[meanval,meanval],'b','LineWidth',1)   

        %--------------------------------Figure cosmetics-------------------------    
        ylh = get(gca,'ylabel');                                            % Object Information
        ylp = get(ylh, 'Position');
        set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
        grid on 
        set(gca, axisOptsFig2A{:})
        
        if  sub_nr <13
            set(gca, 'XTicklabel', []);
        end
        if ~rem(sub_nr-1,4)== 0
            set(gca, 'YTicklabel', []);
        end
        drawnow
    end
end

%%

save( ['results' filesep 'Figure2_thresholdMat'],'thresholdMat')

% load( ['results' filesep 'Figure4_thresholdMat'])

%%  Figure 1A   plot figure 1 as one of figure 2
legendlist = [];
fig1A=figure('Position', [500, 100, 500, 400]);
sub_nr = 10;
hold on
%---------------------------------SSPOCoff-------------------------
Dat_I = ind_SSPOCoff( sub_nr);
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec_random(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec_random(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
end
realNumbers = find(~isnan(meanVec_random));
a = shadedErrorBar(realNumbers, meanVec_random(realNumbers),stdVec_random(realNumbers),col{1});
legendlist = [legendlist,a.mainLine];

%---------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(sub_nr);
for k2 = 1:size(dataStruct.dataMatTot,2)
    meanVec(k2) = mean(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    stdVec(k2) = std(  nonzeros(dataStruct.dataMatTot(Dat_I,k2,:))   );
    
    iters = length(nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) );
    scatter( ones(iters,1)*k2,nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)) , dotcol{2})
end

realNumbers = find(~isnan(meanVec));
b = plot(realNumbers, meanVec(realNumbers),col{2});
legendlist = [legendlist,b];

%--------------------------------Allsensors Neural filt-------------------------    
meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr,:)  ) );
stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr,:)  ) );

c = errorbar(errLocFig1A,meanval,stdval,'k','LineWidth',1);
plot([-1,1]+errLocFig1A,[meanval,meanval],'k','LineWidth',1)   

legendlist = [legendlist,c];
%--------------------------------Allsensors no NF-------------------------    
meanval = mean( nonzeros(  dataStructAll.dataMatTot(sub_nr+16,:)  ) );
stdval = std( nonzeros(    dataStructAll.dataMatTot(sub_nr+16,:)  ) );
d = errorbar(errLocFig1A,meanval,stdval,'b','LineWidth',1);
legendlist = [legendlist,d];
plot([-1,1]+errLocFig1A,[meanval,meanval],'b','LineWidth',1)   

%--------------------------------Figure cosmetics-------------------------    
ylabel('Cross validated accuracy [-]')
xlabel('number of sensors [-]')

ylh = get(gca,'ylabel');
gyl = get(ylh);                                                         % Object Information
ylp = get(ylh, 'Position');
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
grid on 
set(gca, axisOptsFig1A{:}) 




%% Heatmap  & Mask 


set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
[X,Y] = meshgrid(par.phi_dist,par.theta_dist);
fig2C_V2 = figure('Position', [1000, 100, 400, 600]);
subplot(211);
    Im(3) = imagesc(thresholdMat(:,:,2));
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig2C{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

subplot(212)
    imagesc(thresholdMat(:,:,1))
    colormap(flipud(summer(500)))
    set(gca, axisOptsFig2C{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

    
fig2C_mark = figure('Position', [1000, 100, 400, 600]);
subplot(211);

    mask1 = isnan(thresholdMat(:,:,2));
    Im(1) = imagesc( ones(size(mask1))*20 );
    
    set(gca, axisOptsFig2C{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')

   set(Im(1),'alphadata',mask1);
subplot(212)    
    mask2 = isnan(thresholdMat(:,:,1));
    Im(2) = imagesc(ones(size(mask2))*20);
    
    colormap(flipud(bone(3)))
    set(gca, axisOptsFig2C{:})
    h = colorbar;
    set( h, 'YDir', 'reverse' );
    ylabel(h, '# of sensors required for 75% accuracy')
    
   set(Im(2),'alphadata',mask2);
%    set(Im(3),'alphadata',mask2);
   

%% Figure 1B Plot sensor locations 

q_select = 17;
n_iters= length(nonzeros(dataStruct.dataMatTot(Dat_I,q_select,:)));
binar = zeros(26*51,1);
for j = 1:n_iters
    binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) = binar(dataStruct.sensorMatTot(Dat_I,q_select,1:q_select,j)) +1;
end
binar = binar/n_iters;

fig1B = figure();
plotSensorLocs(binar,par)
ylabel('base')


%% 

close(1)
