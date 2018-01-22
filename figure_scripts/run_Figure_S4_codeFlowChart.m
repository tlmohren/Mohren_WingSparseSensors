%------------------------------
% run_Figure_S4_codeFlowChart
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all, close all, clc
addpathFolderStructure()

parameterSetName = 'R1_Iter100';
load(['accuracyData' filesep 'parameterSet_' parameterSetName ])

varParStruct = varParStruct(45);
varPar = varParStruct(1);


varPar.wTrunc = 10; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.9;
fixPar.singValsMult = 1;
fixPar.rmodes = 30; % reduce from 30, solves it? Overfitting problem? 


%% Disected code for a single classification run 

strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it2harm0.2.mat']);
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
[w_r, Psi, singVals,V] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
singValsR = singVals(1:length(w_r));

if fixPar.singValsMult == 1
    [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
else
    [~,Iw]=sort(abs(w_r),'descend');  
end
big_modes = Iw(1:varPar.wTrunc);
Psir = Psi(:,big_modes);
w_t = w_r(big_modes);
a = Psir'*Xtrain;
w_t = LDA_n(a, Gtrain);
s = SSPOCelastic(Psir,w_t,'alpha',fixPar.elasticNet);
s = sum(s, 2);   
[~, I_top2] = sort( abs(s),'descend');

sensors_sort = I_top2(1:fixPar.rmodes);
cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
n =  size(Xtest,1);
classes = unique(Gtest); 
c = numel(classes); 
q = length(sensors);

Phi = zeros(q, n);                                      % construct the measurement matrix Phi
for qi = 1:q,
    Phi(qi, sensors(qi)) = 1;
end;

% learn new classifier for sparsely measured data
w_sspoc= LDA_n(Phi * Xtrain, Gtrain);
Xcls = w_sspoc' * (Phi * Xtrain);

% compute centroid of each class in classifier space
centroid = zeros(c-1, c);
for i = 1:c, 
    centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
end;
% use sparse sensors to classify X
cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
acc =  sum(cls == Gtest)/numel(cls);

q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])


%% Overview figure
fig4 = figure();

width = 6.5;     % Width in inches,   find column width in paper 
height = 7.5;    % Height in inches
fsz = 8;      % Fontsize

col = [1,1,1]*0.9;
set(fig4, 'Position', [100,100, width*100, height*100]); %<- Set size
errLocFig1A = 34;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A  ],'xticklabel',{'0','10','20','30', '\bf 1326'},...
    'ytick',0.5:0.25:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] ,...
    'LabelFontSizeMultiplier',1};

plotCol = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 

% subplot numbers 
pX =7;
pY = 21;
subMat = reshape(1:pY*pX,pX,pY)';
    
% text cells 
boxText = {'Euler-Lagrange Simulation',...
        'Neural Encoder',...
        'Training - Testing Split',...
        'SVD',...
        'LDA',...
        'Mode Selection',...
        'SSPOC + Elastic net',...
        'Threshold',...
        'LDA',...
        'Classification'};    
    
arrowText = {'$\dot{\phi}^*, \dot{\theta}^*$',...
        'Strain(x,y,t)',...
        '\bf{X}',...
        '$\mathbf{X_{train}}$',...
        '$\mathbf{\Psi_r}, \mathbf{X_{train}}$',...
        '$\mathbf{\Psi_r}, \mathbf{w} $',...
        '$\mathbf{\Psi_t}, \mathbf{w_t} $',...
        '\bf{s}',...
        'q, \bf{Sensors}, $\mathbf{X_{train}}$',...
        '$ \mathbf{w_t}$',...
        'Accuracy'};
        
% box text subplots 
for j = 1:10
   subplot(pY, pX, subMat(2*j, [2,3]) ) 
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,boxText{j},'FontSize',fsz,'fontweight','bold');
    axis off
   
end

% variables along arrows subplot
for j = 1:11
   subplot(pY, pX, subMat(2*j-1, [2,3]) ); hold on 
    x = [0.25 0.5 0.75 ]*0.2;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,arrowText{j},'FontSize',fsz,'fontweight','bold');
    axis off
end

% input variables subplots 
inputRows = [4,6,8,12,14];
inputText = { 'STA(t), NLD($\xi$)',...
               'Train Ratio',...
               'Truncation, r',...
               'Truncation, t',...
               '$\alpha$'};
for j = 1:length(inputRows) 
   subplot(pY, pX, subMat(inputRows(j), [1]) ); hold on 
    x = [0,1,0 ]*0.1+0.8; y = [  1 0.5 0];  
    pc = patch(x,y,'k');
    plot( [min(x)-0.1,min(x)], [1,1]*y(2)  ,'k','LineWidth',2)
    axis([0,1,0,1])
    tx = text(0,-0.5,inputText{j},'FontSize',fsz,'fontweight','bold');
    axis off
end

          
% Connecting arrows---------------------------------------------------
subplot(pY,pX, subMat([1:21],[4])  ); hold on
    axis([0,1,0,21])
    
    tx = text(0.2,15.8,'$\mathbf{X_{test}}$','FontSize',fsz,'fontweight','bold');
    plot( [1,1]*0.8, [1.5,15.5] ,'k','LineWidth',3)
    plot( [0,1]*0.8,[1,1]*15.5,'k','LineWidth',3)
    plot( [0.2,1]*0.8,[1,1]*1.5,'k','LineWidth',3)
    x = [1,0,1]*0.2; y = [  0.5 0 -0.5]*0.3+1.5;  
    pc = patch(x,y,'k');
   
    
    tx = text(0.2,13.8,'$\mathbf{\Sigma_{r}}$','FontSize',fsz,'fontweight','bold');
    plot( [1,1]*0.6, [9.5,13.5] ,'k','LineWidth',3)
    plot( [0,0.6],[1,1]*13.5,'k','LineWidth',3)
    plot( [0.2,0.6],[1,1]*9.5,'k','LineWidth',3)
    x = [1,0,1]*0.2; y = [  0.5 0 -0.5]*0.3+9.5;  
    pc = patch(x,y,'k');
    axis off    
    
% Training/test comic ---------------------------------------------------
subplot(pY,pX,  reshape(  subMat([2,4],[5,7]), 1,[]) ); hold on

col =[0.9,0.7]'*[1,1,1]; 
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x*0.3,y,col(1,:));
    pc = patch(x*0.15+0.3,y,col(2,:));
    pc = patch(x*0.3+0.55,y,col(1,:));
    pc = patch(x*0.15+0.85,y,col(2,:));
    tx = text(0.1,0.5,'$\mathbf{X_{train}}$','FontSize',fsz,'fontweight','bold');
    tx = text(0.3,0.5,'$\mathbf{X_{test}}$','FontSize',fsz,'fontweight','bold');
    tx = text(0.65,0.5,'$\mathbf{X_{train}}$','FontSize',fsz,'fontweight','bold');
    tx = text(0.85,0.5,'$\mathbf{X_{test}}$','FontSize',fsz,'fontweight','bold');
    axis off
    tx = text(0.15,1.1,'$\bar{\dot{\theta}} = 0$','FontSize',fsz,'fontweight','bold');
    tx = text(0.7,1.1,'$\bar{\dot{\theta}} = 10$','FontSize',fsz,'fontweight','bold');

subplot(pY,pX,  reshape(  subMat([6,8],[5,7]), 1,[]) ); hold on
    w_tVals = abs(w_r).*singValsR;
    t = 10; 
    [~,I ] = sort( w_tVals,'descend');
    plot(abs(w_r).*singValsR,'.k')
    plot( I(1:t), w_tVals(I(1:t)) ,'or')
    plot( [0,30], [1,1]*w_tVals(I(t)), '--k')
    xlabel('Mode Index'); ylabel('abs(w) $\Sigma_r$')
    box on
    title('Mode Truncation at t = 10')

subplot(pY,pX,  reshape(  subMat([11,13],[5,7]), 1,[]) ); hold on
    plot( abs(s) )
    hold on 
    plot([0,1326], [1,1]*cutoff_lim,'--k')
    plot( sensors, abs( s(sensors) ),'or')
    xlabel('Sensor Index'); ylabel('abs(s)')
    ax = gca();
    axOpts = {'XLim',[0,1300],...
        };
    set(ax,axOpts{:})
    box on
    title('Sensor Threshold, q = 12')


subplot(pY,pX,  reshape(  subMat([16,18],[5,7]), 1,[]) ); hold on
    txtcol = linspecer(2);
    barOpts1 = {'BarWidth',0.7,'EdgeColor','none','FaceColor',txtcol(1,:)};
    barOpts2 = {'BarWidth',0.7,...
    'FaceColor',txtcol(2,:),...
    'EdgeColor','none',...
    };
    n_bins = 15;
    colScheme = [255,245,239
        227, 214, 244
        255,246,213
        255,230,213]/255;
    edgeCol= 'k';%     plot(abs(s))
    
       expo = round( - log10(max(abs(Xcls))));
    xLims = [ round(min(Xcls),expo+1)-10^(-expo-1), ( round(max(Xcls),expo+1) +10^(-expo-1)) ];
    
    rangeBins = linspace(xLims(1), xLims(2), n_bins);
    xstep = (xLims(2)-xLims(1))/n_bins; 
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;
    midWay = length(Xcls)/2;
    [aCounts] = histcounts(Xcls(1:midWay), rangeBins);
    [bCounts] = histcounts(Xcls(midWay+1:end), rangeBins);
    yLims = [ max(aCounts),-max(bCounts)];
    ystep = (yLims(1)-yLims(2))/n_bins;
    
    
    xLimsBase = xLims +[-1,1]*xstep*1;
    yLimsMid = yLims +[1,-1]*ystep*2;
    
    xLimsPatch = xLims +[-xstep*2.5,xstep*4];
    yLimsPatch = yLims+[1,-1]*ystep*3;
    
    x = [xLimsPatch(1) xLimsPatch(2) xLimsPatch(2) xLimsPatch(1)];
    y = [yLimsPatch(2),yLimsPatch(2),yLimsPatch(1),yLimsPatch(1)];
%     pc = patch(x,y,backCol,'EdgeColor',edgeCol);
        hold on
    midLine = mean(centroid);
    bar1 = bar(binMids,aCounts);
    bar2 = bar(binMids,-bCounts,'r');
    % baseline and midline 
    plot(xLimsBase,[0,0],'k','LineWidth',0.5)
    l1 = plot([1,1]*midLine,yLimsMid,'k:','LineWidth',0.5);
  
    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})
    set( bar1.BaseLine,'Visible','off')
    
    axis([xLimsPatch(1),xLimsPatch(2),yLimsPatch(2),yLimsPatch(1)])
    axis off
    
    text( xLimsBase(2),0,'$\mathbf{\eta}$','FontSize',7)
    
        hold on 
     l2=    plot( [1,1]'*centroid, [0,1]'*[max(aCounts),-max(bCounts)]*1.2,'k:'   ,'LineWidth',1.5  );
        text( min(Xcls)*1.5 ,400,...
        ['Flapping' char(10) '$\phantom{..}$Only'],'Color',...
        txtcol(1,:),'FontSize',fsz)
    text( min(Xcls)*1.5,-500,...
        ['$\phantom{..}$ With' char(10) 'Rotation'],'Color',...
        txtcol(2,:),'FontSize',fsz)
    
%     legend( [l1,l2(1)],{'Separating line','Centroid'})%     ylabel('\# of snapshots in bin')
%     xlabel('
        
    

%% Setting paper size for saving 

set(fig4,'InvertHardcopy','on');
set(fig4,'PaperUnits', 'inches');
papersize = get(fig4, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig4, 'PaperPosition', myfiguresize);
% Saving figure 
print(fig4, ['figs' filesep 'Figure_S4' ], '-dpng', '-r600');
% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig4, 'PaperPosition', myfiguresize);

print(fig4, ['figs' filesep 'Figure_S4' ], '-dsvg');



    