%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

%------------------------------
clear all, close all, clc

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

parameterSetName    = ' ';
iter                = 1;
figuresToRun        = {'subSetTest'};

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
% strainSet = load('strainSet_th0.1ph0.312it1harm0.2.mat');
strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it2harm0.2.mat']);
varPar = varParStruct(1);


varPar.wTrunc = 11; %% 11 does it for iter2 eNet 09
fixPar.elasticNet = 0.9;
fixPar.singValsMult = 1;
fixPar.rmodes = 30; % reduce from 30, solves it? Overfitting problem? 



%% Test neural encoding effert

fixPar.STAdelay = 5;
[X,G] = neuralEncoding(strainSet, fixPar,varPar );


%% 
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
% sensors = sensorLocSSPOC(Xtrain,Gtrain,fixPar,varyPar);
[w_r, Psi, singVals,V] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
singValsR = singVals(1:length(w_r));

size(w_r) 

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

%         XtrainFake = Psi(:,big_modes)*diag(singVals(big_modes))*V(:,big_modes)';
%         [w_t, Psir, ~,~] = PCA_LDA_singVals(XtrainFake, Gtrain, 'nFeatures',varPar.wTrunc);

s = SSPOCelastic(Psir,w_t,'alpha',fixPar.elasticNet);
s = sum(s, 2);   
[~, I_top2] = sort( abs(s),'descend');

sensors_sort = I_top2(1:fixPar.rmodes);
cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim )
%             sensors_empty = I_top2(1:varPar.wTrunc)
%             sensors = sensors_empty;

% acc = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
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
% setup figure
fig4 = figure();

% pre plot decisions 
width = 6.5;     % Width in inches,   find column width in paper 
height = 7.5;    % Height in inches
fsz = 8;      % Fontsize

col = [1,1,1]*0.9;
% subplot(5,3,4:15)
set(fig4, 'Position', [100,100, width*100, height*100]); %<- Set size

errLocFig1A = 34;
axisOptsFig1A = {'xtick',[0:10:30,errLocFig1A  ],'xticklabel',{'0','10','20','30', '\bf 1326'},...
    'ytick',0.5:0.25:1 ,'xlim', [0,errLocFig1A+2],'ylim',[0.4,1] ,...
    'LabelFontSizeMultiplier',1};

plotCol = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 
hold on

%
pX =7;
pY = 21;
subMat = reshape(1:pY*pX,pX,pY)';


subplot(pY,pX, subMat(1,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\dot{\phi}^*$, $\dot{\theta}^*$','FontSize',fsz,'fontweight','bold');
    axis off
    
    
    
    

% Strain---------------------------------------------------
subplot(pY,pX, subMat(2,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'Euler-Lagrange Simulation','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(3,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'Strain(x,y,t)','FontSize',fsz,'fontweight','bold');
    axis off

    
% Strain---------------------------------------------------
subplot(pY,pX, subMat(4,1)  ); hold on
    x = [0,1,0 ]*0.2+0.8; y = [  1 0.5 0];  
    pc = patch(x,y,'k');
    plot( [min(x)-0.1,min(x)], [1,1]*y(2)  ,'k','LineWidth',3)
    tx = text(0,0.7,'STA(t)','FontSize',fsz);
    tx = text(0,-0.2,'NLD($\xi$)','FontSize',fsz);
    axis([0,1,0,1])
    axis off
subplot(pY,pX, subMat(4,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'Neural Encoder','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(5,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{X}$','FontSize',fsz,'fontweight','bold');
    axis off

% Train / Test ---------------------------------------------------
subplot(pY,pX, subMat(6,1)  ); hold on
    x = [0,1,0 ]*0.2+0.8; y = [  1 0.5 0];  
    pc = patch(x,y,'k');
    plot( [min(x)-0.1,min(x)], [1,1]*y(2)  ,'k','LineWidth',3)
    tx = text(0,0.7,'Train','FontSize',fsz);
    tx = text(0,-0.2,'Ratio','FontSize',fsz);
    axis([0,1,0,1])
    axis off
subplot(pY,pX, subMat(6,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'Train Split','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(7,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{X_{train}}$','FontSize',fsz);
    axis off    
    
    
% SVD---------------------------------------------------
subplot(pY,pX, subMat(8,1)  ); hold on
    x = [0,1,0 ]*0.2+0.8; y = [  1 0.5 0];  
    pc = patch(x,y,'k');
    plot( [min(x)-0.1,min(x)], [1,1]*y(2)  ,'k','LineWidth',3)
    tx = text(0,0.7,'Truncation','FontSize',fsz);
    tx = text(0,-0.2,'r','FontSize',fsz);
    axis([0,1,0,1])
    axis off
subplot(pY,pX, subMat(8,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'SVD','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(9,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{\Psi_r}$, $\mathbf{X_{train}}$','FontSize',fsz,'fontweight','bold');
    axis off  
    
% LDA---------------------------------------------------
subplot(pY,pX, subMat(10,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'LDA','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(11,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{w}$, $\mathbf{\Psi_r}$','FontSize',fsz,'fontweight','bold');
    axis off  
    
    
% Mode selection---------------------------------------------------
subplot(pY,pX, subMat(12,1)  ); hold on
    x = [0,1,0 ]*0.2+0.8; y = [  1 0.5 0];  
    pc = patch(x,y,'k');
    plot( [min(x)-0.1,min(x)], [1,1]*y(2)  ,'k','LineWidth',3)
    tx = text(0,0.7,'Truncation','FontSize',fsz);
    tx = text(0,-0.2,'t','FontSize',fsz);
    axis([0,1,0,1])
    axis off
subplot(pY,pX, subMat(12,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'Mode Selection','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(13,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{w_t}, \mathbf{\Psi_t}$','FontSize',fsz,'fontweight','bold');
    axis off      
  
    
% SSPOC + elastic net ---------------------------------------------------
subplot(pY,pX, subMat(14,1)  ); hold on
    x = [0,1,0 ]*0.2+0.8; y = [  1 0.5 0];  
    pc = patch(x,y,'k');
    plot( [min(x)-0.1,min(x)], [1,1]*y(2)  ,'k','LineWidth',3)
%     tx = text(0,0.7,'Truncation','FontSize',fsz);
    tx = text(0,-0.2,'$\alpha$','FontSize',fsz);
    axis([0,1,0,1])
    axis off
subplot(pY,pX, subMat(14,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'SSPOC + Elastic Net','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(15,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{s}$','FontSize',fsz,'fontweight','bold');
    axis off      
    
    
% Threshold ---------------------------------------------------
subplot(pY,pX, subMat(16,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'Threshold','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(17,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'\bf{Sensors}, $\mathbf{X_{train}}$','FontSize',fsz,'fontweight','bold');
    axis off          
    
% LDA---------------------------------------------------
subplot(pY,pX, subMat(18,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'LDA','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(19,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'$\mathbf{w_t}$','FontSize',fsz,'fontweight','bold');
    axis off       

        
% LDA---------------------------------------------------
subplot(pY,pX, subMat(20,[2,3])  )
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x,y,col(1,:));
    tx = text(0.1,0.3,'Classify','FontSize',fsz,'fontweight','bold');
    axis off
subplot(pY,pX, subMat(21,[2,3])  ); hold on
    x = [0.25 0.5 0.75 ]*0.3;  y = [1 0 1 ]*0.3;
    pc = patch(x,y,'k');
    plot( [1,1]*x(2), [1,max(y)] ,'k','LineWidth',3)
    axis([0,1,0,1])
    tx = text(0.3,0.3,'Accuracy','FontSize',fsz,'fontweight','bold');
    axis off       
    
          
% Connecting arrows---------------------------------------------------
subplot(pY,pX, subMat([1:21],[4])  ); hold on
    axis([0,1,0,21])
    
    
    tx = text(0.2,16,'$\mathbf{X_{test}}$','FontSize',fsz,'fontweight','bold');
    plot( [1,1]*0.8, [1.5,15.7] ,'k','LineWidth',3)
    plot( [0,1]*0.8,[1,1]*15.7,'k','LineWidth',3)
    plot( [0.2,1]*0.8,[1,1]*1.5,'k','LineWidth',3)
    x = [1,0,1]*0.2; y = [  0.5 0 -0.5]*0.3+1.5;  
    pc = patch(x,y,'k');
   
    
    tx = text(0.2,13.7,'$\mathbf{\Sigma_{r}}$','FontSize',fsz,'fontweight','bold');
    plot( [1,1]*0.6, [9.5,13.5] ,'k','LineWidth',3)
    plot( [0,0.6],[1,1]*13.5,'k','LineWidth',3)
    plot( [0.2,0.6],[1,1]*9.5,'k','LineWidth',3)
    x = [1,0,1]*0.2; y = [  0.5 0 -0.5]*0.3+9.5;  
    pc = patch(x,y,'k');
    axis off    
    
    
    
    
% Training/test comic ---------------------------------------------------
subplot(pY,pX,  reshape(  subMat([5,6],[5,7]), 1,[]) ); hold on

col =[0.9,0.7]'*[1,1,1]; 
    x = [0 1 1 0];  y = [0 0 1 1];
    pc = patch(x*0.35,y,col(1,:));
    pc = patch(x*0.1+0.35,y,col(2,:));
    pc = patch(x*0.35+0.55,y,col(1,:));
    pc = patch(x*0.1+0.9,y,col(2,:));
    
    tx = text(0.1,0.5,'$\mathbf{X_{train}}$','FontSize',fsz,'fontweight','bold');
    tx = text(0.35,0.5,'$\mathbf{X_{test}}$','FontSize',fsz,'fontweight','bold');
    tx = text(0.65,0.5,'$\mathbf{X_{train}}$','FontSize',fsz,'fontweight','bold');
    tx = text(0.9,0.5,'$\mathbf{X_{test}}$','FontSize',fsz,'fontweight','bold');
    axis off
    
    tx = text(0.15,1.1,'$\bar{\dot{\theta}} = 0$','FontSize',fsz,'fontweight','bold');
    tx = text(0.7,1.1,'$\bar{\dot{\theta}} = 10$','FontSize',fsz,'fontweight','bold');
    

subplot(pY,pX,  reshape(  subMat([9,10],[5,7]), 1,[]) ); hold on
    plot( abs(w_r),'.k')
    xlabel('Mode Index'); ylabel('abs(w)')
    box on 
subplot(pY,pX,  reshape(  subMat([12,13],[5,7]), 1,[]) ); hold on
    plot(abs(w_r).*singValsR,'.k')
    xlabel('Mode Index'); ylabel('abs(w) $\Sigma_r$')
    box on

subplot(pY,pX,  reshape(  subMat([16,17],[5,7]), 1,[]) ); hold on
    plot(abs(s))
%     axis tight
    xlabel('Sensor Index'); ylabel('abs(s)')
    ax = gca();
    axOpts = {'XLim',[0,1300],...
        };
    set(ax,axOpts{:})
    box on


    
    

txtcol = linspecer(2);
barOpts1 = {'BarWidth',0.7,'EdgeColor','none','FaceColor',txtcol(1,:)};
%     barOpts2 = {'BarWidth',0.9,'EdgeColor','k','FaceColor',col(2,:)};
barOpts2 = {'BarWidth',0.7,...
'FaceColor',txtcol(2,:),...
'EdgeColor','none',...
};
n_bins = 15;
    
colScheme = [255,245,239
    227, 214, 244
    255,246,213
    255,230,213]/255;
edgeCol= 'k';
subplot(pY,pX,  reshape(  subMat([19,21],[5,7]), 1,[]) ); hold on
%     plot(abs(s))
    barPlots(Xcls, mean(centroid), n_bins, [1,1,1], edgeCol, barOpts1, barOpts2)

        text( min(Xcls) ,200,...
        ['Flapping' char(10) '$\phantom{..}$Only'],'Color',...
        txtcol(1,:),'FontSize',fsz)
    text( min(Xcls),-300,...
        ['$\phantom{..}$ With' char(10) 'Rotation'],'Color',...
        txtcol(2,:),'FontSize',fsz)
    
    
    
    
%% Setting paper size for saving 
% set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
% tightfig;

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



    