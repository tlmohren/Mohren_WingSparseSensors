%------------------------------
% run_Figure_R1_SSPOCvsRandom
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clc;clear all; close all
addpathFolderStructure()
w = warning ('off','all');

% figure decisions 
width       = 4;     % Width in inches,   find column width in paper 
height      = 4.5;    % Height in inches
fsz         = 8;      % Fontsize
labels_on   = false;
% plot_on     = false;
sigmoid_fit = true;
% 'S4'
%% Processing before plotting 
parameterSetName = 'S4_vectorExtract50';
overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';

load( ['accuracyData' filesep 'parameterSet_' parameterSetName ] )
fixPar.data_loc = 'accuracyData';
fixPar.nIterFig = 50;

[dataStruct,paramStruct] = combineDataMat( fixPar, simulation_menu.S4_vectorExtract  );
% [dataStructAllnoFilt,paramStructAllnoFilt] = combineDataMat(fixPar,simulation_menu.R1_all_nofilt);
% [dataStructAllFilt,paramStructAllFilt] = combineDataMat(fixPar,simulation_menu.R1_all_filt);

%  R1_all_filt
ind_SSPOCoff = find( ~[paramStruct.SSPOCon]);
ind_SSPOCon = find([paramStruct.SSPOCon]);
%% setup figure
fig1 = figure();
subplot(5,3,4:15)
set(fig1, 'Position', [fig1.Position(1:2) width*100, height*100]); %<- Set size

errLocFig1A = 34;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A  ],'xticklabel',{'0','10','20','30', '\bf 1326'},...
    'ytick',0.5:0.25:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] ,...
    'LabelFontSizeMultiplier',1};

plotCol = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 
hold on

%% ---------------------------------Plot SSPOC and random sensors -------------------------
if any(ind_SSPOCoff)
    Dat_I = ind_SSPOCoff( 1);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
    realNumbers = find(~isnan(meanVec));
    pltSSPOCoff = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),plotCol{1});
end
sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show', false);

%--------------------------------SSPOCon-------------------------
Dat_I = ind_SSPOCon(1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));
for k2 = 1:size(dataStruct.dataMatTot,2)
    y_data = nonzeros(dataStruct.dataMatTot(Dat_I,k2,:)); 
    mv = mean(y_data);
    med(k2) = median(y_data);
    if ~isempty(y_data)
        data = nan(length(y_data),30);
        data(:,k2) = y_data;
        plotSpread( data ,'distributionMarker','.','distributionColors','r','spreadWidth',1)
    end
end

Dat_I = ind_SSPOCon( 1);
[ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStruct );
realNumbers = find(~isnan(meanVec));
sigmFitParam( realNumbers,meanVec(realNumbers),'plot_show',2);

%% plot the line? 
%--------------------------------Allsensors Neural filt-------------------------    
% meanval = mean( nonzeros(  dataStructAllFilt.dataMatTot(1,:)  ) );
% stdval = std( nonzeros(    dataStructAllFilt.dataMatTot(1,:)  ) );
%     scatter(errLocFig1A,meanval,50,'rd','filled')
% 
% %--------------------------------Allsensors no NF-------------------------    
% meanval = mean( nonzeros(  dataStructAllnoFilt.dataMatTot(1,:)  ) );
% stdval = std( nonzeros(    dataStructAllnoFilt.dataMatTot(1,:)  ) );
%     scatter(errLocFig1A,meanval,50,'filled','kd')

%% Legend 
pltSSPOCon = plot(0,0);   % get line for legend only 
legend_entries = { ['Random Sensors,' char(10) '$\phantom{.....}$ Encoded'],...
                    ['SSPOC Sensors,'  char(10) '$\phantom{.....}$ Encoded']};

legend_location = 'Best';
legVec = [pltSSPOCoff.mainLine, pltSSPOCon];
legOpts = {'FontSize',fsz,'Location',legend_location};

allText1 = ['All Sensors,' char(10) 'Raw Strain'];
allText2 = ['All Sensors,' char(10)  'Encoded'];

grid on 
axPlot = gca();
set(axPlot, axisOptsFig1A{:})
if labels_on == true
    [leg,lns] = legend(legVec,legend_entries, legOpts{:});
    tx1 = text(20,0.5,allText1,'FontSize',fsz);
    tx2 = text(20,0.7,allText2,'FontSize',fsz);  
    xlabel('Number of Sensors, $q$'); ylabel('Cross-Validated Accuracy')
    break_axis('axis','x','position',(errLocFig1A -30)/2+30, 'length',0.05)
end




%% Sensor locations 
q = 13;
binar           = get_pdf( dataStruct.sensorMatTot(2,q,1:q,:));
sensorloc_tot   = reshape(binar,fixPar.chordElements,fixPar.spanElements); 

colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};

subplot(5,3,[1,2])
    x   = [0 1 1 0]* (fixPar.spanElements+1);  
    y   = [0 0 1 1]* (fixPar.chordElements+1);
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on 
    [X,Y] = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
    I = find( sensorloc_tot );      
    sc  = scatter(X(I) ,Y(I) , 100 ,'.','r');    
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    plot(x,y,'k','LineWidth',0.5)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off

%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;
% 
% set(fig1,'InvertHardcopy','on');
% set(fig1,'PaperUnits', 'inches');
% papersize = get(fig1, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(fig1, 'PaperPosition', myfiguresize);
% % Saving figure 
% print(fig1, ['figs' filesep 'Figure_R1' ], '-dpng', '-r600');
% % total hack, why does saving to svg scale image up???
% stupid_ratio = 15/16;
% myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
% set(fig1, 'PaperPosition', myfiguresize);
% 
% print(fig1, ['figs' filesep 'Figure_R1' ], '-dsvg');





%% sensor locations for good and bad, spy plots 

qRange = 11;

dataSelect = dataStruct.dataMatTot( 2, qRange ,:);
sensorSelect = dataStruct.sensorMatTot(2, qRange ,:,:);
weightSelect = dataStruct.weightMatTot(2, qRange ,:,:);

accData = reshape( dataSelect, prod(size( dataSelect)),1 );
sensorTemp = permute( sensorSelect  , [1,2,4,3]);
weightTemp = permute( weightSelect  , [1,2,4,3]);

[a1,a2,a3,a4 ]= size(sensorTemp);
sensorData = reshape( sensorTemp, a1*a2*a3,a4);
weightData = reshape( weightTemp, a1*a2*a3,a4);

successMask = find( accData >=0.75 );
failMask  =  find(  (accData <0.75) & (accData>0.4) )  ;


Locmat = zeros(qRange, length(successMask)+length(failMask) );
Xmat = zeros(1326,  length(successMask)+length(failMask));
G = zeros(1, length(successMask)+length(failMask) ); 

figure()
hold on
for j = 1:length(successMask)
    Ind = successMask(j);
    q = length(nonzeros(sensorData( Ind ,:)));
    d1 =  plot( j*ones(q,1) , nonzeros( sensorData(Ind,:) ) ,'ro');
    Locmat(:,j )  = sort( nonzeros( sensorData(Ind,:) ) ,'descend');
    Xmat(  nonzeros( sensorData(Ind,:) ) ,j) = nonzeros(weightData(Ind,:)) ;
    Gmat(j) = 1;
end
j_end = j; 
% figure()
% hold on
for j = 1:length(failMask)
    Ind = failMask(j);
    q = length(nonzeros(sensorData( Ind ,:)));
   d2 = plot( (j+j_end+2)*ones(q,1) , nonzeros( sensorData(Ind,:) ) ,'ko');
    Locmat(:,j+length(successMask) )  = sort( nonzeros( sensorData(Ind,:) ) , 'descend');
    Gmat(j+length(successMask)) = 2;
    Xmat(  nonzeros( sensorData(Ind,:) ) ,j+length(successMask)) = nonzeros(weightData(Ind,:)) ;
end
legend([d1,d2],'above 75\% accuracy', 'below 75\% accuracy','Location', 'NorthEastOutside')
title( 'classification accuracy for q = 11')

figure();
spy(Xmat)

%% SVD of good and badd sensor locations 


% Xmat = [sin(2*pi*0:0.1:10)'*ones(1,34),  cos(2*pi*0:0.1:10)'*ones(1,33) ] ;
[U,S,V] = svd(Xmat, 'econ');

figure();
    plot( cumsum( diag(S)/sum(S(:)) ),'.')
    ylabel('cumulative singular values')
    xlabel('singular value index')
    sucInd = 1:length(successMask);
    failInd = (length(successMask)+1):(length(successMask)+length(failMask) );
%% V plots 

figure(); hold on
    scatter3( V(sucInd,1), V(sucInd,2), V(sucInd,3),'r')
    scatter3( V(failInd,1), V(failInd,2), V(failInd,3),'b')
    xlabel('mode 1'); ylabel('mode 2');zlabel('mode 3')
    legend('above 75\% accuracy', 'below 75\% accuracy','Location','Best')

figure(); hold on
    scatter3( V(sucInd,4), V(sucInd,5), V(sucInd,6),'r')
    scatter3( V(failInd,4), V(failInd,5), V(failInd,6),'b')
    xlabel('mode 4'); ylabel('mode 5');zlabel('mode 6')

    legend('above 75\% accuracy', 'below 75\% accuracy','Location','Best')
%% U plots 

 figure(); 
     subplot(311)
     plot(  U(:,1),'-')
     subplot(312)
     plot(  U(:,2),'-')
     subplot(313)
     plot(  U(:,3),'-')
%  subplot(212)
%  plot( find(sum(U>0,2)), U( sum(U>0,2) >0 ,1:2),'-o')
% axis([1200,1330,-1,1]) 
%
 figure(); 
     subplot(211)
     plot( find(sum(U>0.01,2)),  U( sum(U>0.01,2) >0 ,1:2),'-o')
     subplot(212)
     plot( find(sum(U>0.01,2)), U( sum(U>0.01,2) >0 ,1:2),'-o')
    axis([1200,1330,-1,1]) 
%% 
% 
% figure();
%     for j = 1:10
%         subplot(10,1,j)
%         plot( sucInd, V(sucInd,j),'r')
%         hold on
%         plot( failInd, V(failInd,j),'b')
%         axis off
%     end

%%  GoodV vs bad V 
STDmodes= [std(V(sucInd,:))' std(V(failInd,:))'];

goodModes = find( STDmodes(:,1) > STDmodes(:,2) );
badModes = find(STDmodes(:,2) > STDmodes(:,1) );


figure();
for j = 1:10
    subplot(10,1,j)
    plot([1,66],[0,0],'k'); hold on
    plot( sucInd, V(sucInd,j),'r')
    hold on
    plot( failInd, V(failInd,j),'b')
    axis off
end





%% Plot sensor locations on the wing 
colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
x               = [0 1 1 0]* (fixPar.spanElements+1);  
y               = [0 0 1 1]* (fixPar.chordElements+1);


figure(); hold on
for j = 1:2
    subplot(2,1,j);hold on
% figure
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    weights = U(:,j);
    sensors = find( abs(weights) > 0.01); 
    w_sspoc = U(sensors,j);

    binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
    binar(sensors)  = 1;
    sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
    I               = find( sensorloc_tot ); 
    [X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);   
    dotColor        = ones(length(w_sspoc),1)*[231,41,138]/255;
    dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
	
%     hold on   
    dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,dotColor,'.');    
    dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');     
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
    title(['Mode ' num2str(j) ])
end
    
    
    
% figure(); hold on
% scatter3( V(1,sucInd), V(2,sucInd), V(3,sucInd),'r')
% scatter3( V(1,failInd), V(2,failInd), V(3,failInd),'b')
% xlabel('mode 1'); ylabel('mode 2');zlabel('mode 3')


% % (accData>0.1) == (sensorData(:,1)>0.1)
% figure();
% plot( accData>0.1,'+');
% hold on
% plot(sensorData(:,1)>0.1,'o')
% dataStruct


%% Plot sum of goodmodes and badmodes 
colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
x               = [0 1 1 0]* (fixPar.spanElements+1);  
y               = [0 0 1 1]* (fixPar.chordElements+1);

        upLim = [0.4,0.7,1.1]*0.5;
        lowLim = [-0.1,0.4,0.7]*0.5;
        dim = [0.1,0.5,1];
        col = [255,140,140
        255,70,70
        255,0,0]/255;
        
placementTitle = {'Good Classification','Bad Classification'};
% goodInd = goodModes(1:6);
% badInd = badModes(1:11);
goodInd = goodModes(1:4);
badInd = badModes(1:4);
% Ugood = sum( abs( U(:,goodModes(1:4)) ), 2 );
% Ubad= sum( abs( U(:,badModes(1:8)) ), 2 );
S_vec = diag(S); 
SigmaGood  = S_vec( goodInd );
SigmaBad = S_vec( badInd );
% SigmaBad r = S(badModes(1:8),badModes(1:8));
Ugood = sum( ( U(:,goodInd) ), 2 );
Ubad= sum( ( U(:,badInd) ), 2 );

USgood = sum( ( U(:,goodInd).* SigmaGood' ), 2 );
USbad = sum( ( U(:,badInd).* SigmaBad' ), 2 );
% sum( ( U(:,goodModes(1:4)) ), 2 )
% Ucomb = [Ugood, Ubad];
Ucomb = [USgood, USbad];

figure(); hold on
for j = 1:2
    subplot(2,1,j);hold on
% figure
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    weights = Ucomb(:,j);
    sensors = find( abs(weights) > 0.01); 
    w_sspoc = Ucomb(sensors,j);

    binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
    binar(sensors)  = 1;
    sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
    I               = find( sensorloc_tot ); 
    [X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);   
    dotColor        = ones(length(w_sspoc),1)*[231,41,138]/255;
    dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
    
%     w_sspoc = abs(Ucomb(sensors,j));
%       for j2 = 1:3
%             I_group = I( (w_sspoc < upLim(j2)) & (w_sspoc >lowLim(j2)) );
%         %             scatter(X(I) ,Y(I) ,   100 ,'.','r');  
%             sc =  scatter(X(I_group) ,Y(I_group) ,   100 ,'.','MarkerEdgeColor',col(j2,:));  
%       end
    
    
    
    dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*20)*10 ,dotColor,'.');    
    dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');     
	
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
    title(placementTitle{j})
end


%% Good modes plot 
figure()
for j = 1:6
    
   if j <=4
   subplot(6,2,j*2-1); hold on
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    weights = U(:, goodModes(j) );
    sensors = find( abs(weights) > 0.01); 
    w_sspoc = U(sensors, goodModes(j) );

    binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
    binar(sensors)  = 1;
    sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
    I               = find( sensorloc_tot ); 
    [X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);   
    dotColor        = ones(length(w_sspoc),1)*[231,41,138]/255;
    dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
    
    
    dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,dotColor,'.');    
    dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');     
    
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
   end
    
    
   subplot(6,2,j*2); hold on
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    weights = U(:, badModes(j) );
    sensors = find( abs(weights) > 0.01); 
    w_sspoc = U(sensors, badModes(j) );

    binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
    binar(sensors)  = 1;
    sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
    I               = find( sensorloc_tot ); 
    [X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);   
    dotColor        = ones(length(w_sspoc),1)*[231,41,138]/255;
    dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
    
    
    dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,dotColor,'.');    
    dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');     
    
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off 
    
    
end


%% what sensors? 

mode = goodModes(1);
find( abs(U(:,mode)) >0.001)


figure(); hold on
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    weights = U(:, mode );
    sensors = find( abs(weights) > 0.01 );
    sensors = [1301, 1313,1326];
    w_sspoc = U(sensors, mode );

    binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
    binar(sensors)  = 1;
    sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
    I               = find( sensorloc_tot ); 
    [X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);   
    dotColor        = ones(length(w_sspoc),1)*[231,41,138]/255;
    dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
    
    
    dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,dotColor,'.');    
    dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');     
    
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
   
   
   
%% prob density func 
Xtgood = Xmat(:,sucInd);
Xtbad = Xmat(:,failInd);

sGood = zeros(size(Xtgood));
sGood( abs(Xtgood)>1e-9 ) = 1;
sBad = zeros(size(Xtbad));
sBad( abs(Xtbad)>1e-9 ) = 1;

sensorloc_tot = zeros(1326,2);
sensorloc_tot(:,1) = sum(sGood,2);
sensorloc_tot(:,2) =  sum(sBad,2);



        col = [255,140,140
        255,70,70
        255,0,0]/255;
        upLim = [5,15,100];
        lowLim = [0.1,5,15];
    
    
      col = [255,210,210
          255,140,140
        255,70,70
        255,0,0]/255;
        upLim = [5,10,20,100];
        lowLim = [0.1,5,10,20];
        
%% 
    figure()
for j = 1:2
    
  
    subplot(2,1,j);hold on
% figure
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    weights = Ucomb(:,j);
    sensors = find( abs(weights) > 0.01); 
    w_sspoc = Ucomb(sensors,j);

%     binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
%     binar(sensors)  = 1;
%     sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
    I               = find( sensorloc_tot(:,j) ); 
    [X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);   
%     dotColor        = ones(length(w_sspoc),1)*[231,41,138]/255;
%     dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;
    
%     w_sspoc = abs(Ucomb(sensors,j));
      for j2 = 1:size(col,1)
            I_group = (    sensorloc_tot(:,j)  < upLim(j2)) & (    sensorloc_tot(:,j)  >lowLim(j2)) ;
        %             scatter(X(I) ,Y(I) ,   100 ,'.','r');  
            sc =  scatter(X(I_group) ,Y(I_group) ,   100 ,'.','MarkerEdgeColor',col(j2,:));  
      end
    
    
    
%     dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*20)*10 ,dotColor,'.');    
%     dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');     
	
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
    title(placementTitle{j})
end

   