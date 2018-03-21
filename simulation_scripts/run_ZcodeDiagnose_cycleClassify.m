%------------------------------
% run_ZcodeDiagnose
% This script contains a similar code to exampleScript with functions
% unpacked. It is run for both neural encoding on and off. 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all, close all, clc
addpathFolderStructure()
iter                = 1; % number of iterations 
% phi_dist            = 31.2;
phi_dist            = 0.312;
theta_dist          = 0.1;
% phi_dist            = 31.2;
% theta_dist          = 1;
parameterSetName    = ' ';
figuresToRun        = {'E1'};

fixPar = createFixParStruct( parameterSetName,iter);
[ varParStruct,simulation_menu ] = createVarParStruct( fixPar, figuresToRun);
varPar = varParStruct(2); 
iter
strainSet = load(['eulerLagrangeData', filesep 'strainSet_th' num2str(theta_dist),'ph',num2str(phi_dist),'it' num2str(iter) 'harm0.2.mat']);
%% Test neural encoding effect

% neural encoding on 
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

% neural encoding off 
varPar.SSPOCon = [0];
varPar.NLDgrad = -1;
varPar.STAfreq = 1;
varPar.STAwidth = 0.01;
[X4,G] = neuralEncoding(strainSet, fixPar,varPar );

% check to see effect of neural encoding 
% figure();
%     plot(X(100,2600:3400))
%     hold on
%     plot(X4(100,2600:3400))
%     legend('Neural encoding on','Neural encoding off ') 

%% adjusted parameters 
varPar.wTrunc = 10;  
fixPar.elasticNet = 0.9;
fixPar.singValsMult = 1;
fixPar.rmodes = 30; 
%% 

[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);

[U, Sigma, V] = svd(Xtrain, 0);
Psi = U(:, 1:fixPar.rmodes);
singVals = diag(Sigma);
a = Psi'*X;

w_r = LDA_n(a, Gtrain);
Xcls = w_r' * a;      % Projections onto decision space
classes = unique(Gtrain);
c = numel(classes);

% compute centroid of each class in classifier space
centroid = zeros(c-1, c);
for i = 1:c,
    centroid(:,i) = mean(Xcls(:,G==classes(i)), 2);
end;
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
sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim )

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
    s_dev(:,i) = std(Xcls(:,Gtrain==classes(i)));
end;
% use sparse sensors to classify X
cls = classify_nc(Xtest, Phi, w_sspoc, centroid);            % NOTE: if Jared's is used, multiple outputs!
acc =  sum(cls == Gtest)/numel(cls);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])
cls = classify_ncSTD(Xtest, Phi, w_sspoc, centroid,s_dev);            % NOTE: if Jared's is used, multiple outputs!
acc =  sum(cls == Gtest)/numel(cls);

q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])


%% 
correct_vec = (cls == Gtest);
dphase = 2*pi/40;
phaseBase = ( dphase:dphase:2*pi);
phase = ( dphase:dphase:2*pi) +pi*19/20;

cols = linspecer(5);
goodcol = cols(3,:);
badcol = cols(4,:);

figure();
    subplot(221) 
        plot( phaseBase,  strainSet.strain_0(10,3720:3759)/max(strainSet.strain_0(10,3701:end) )  )
        hold on 
        plot(phaseBase,correct_vec(20:59) ,'*')
        ylabel('flapping')
    subplot(223) 
        plot(  phaseBase, strainSet.strain_10(19,3720:3759)/max(strainSet.strain_10(10,3701:end)))
        hold on 
        plot( phaseBase,correct_vec( (20:59)+300) ,'*' )
        ylabel('flapping w. Rotation')
        
    
    
    subplot(122)
    hold on
            r = 1;
            x = cos(phase+pi*19/20)*r;
            y = sin(phase+pi*19/20)*r;
            plot([x,x(1)],[y,y(1)],'k')
    for j = 1:7
        for k = 1:40
            jk = (j-1)*40+k;
            r = 1+0.05+0.03*j;
            x = cos(phase(k))*r;
            y = sin(phase(k))*r;

            if correct_vec(20+jk) == 1
                scatter(x,y,50,'.','CData',goodcol);
            else
                scatter(x,y,50,'.','CData',badcol)
            end
        end
    end
    for j = 1:7
        for k = 1:40
            jk = (j-1)*40+k;
            r = 1-0.05-0.03*j;
            x = cos(phase(k))*r;
            y = sin(phase(k))*r;

            if correct_vec(300+jk) == 1
                scatter(x,y,50,'.','CData',goodcol);
            else
                scatter(x,y,50,'.','CData',badcol)
            end

        end
    end

        
%% Run the classification again without neural encoding 
% % % [Xtrain4, Xtest4, Gtrain4, Gtest4] = predictTrain(X4, G, fixPar.trainFraction);
% % % [w_r4, Psi4, singVals4,V4] = PCA_LDA_singVals(Xtrain4, Gtrain4, 'nFeatures',fixPar.rmodes);
% % % singValsR4 = singVals4(1:length(w_r4));
% % % if fixPar.singValsMult == 1
% % %     [~,Iw]=sort(abs(w_r4).*singValsR4,'descend');  
% % % else
% % %     [~,Iw]=sort(abs(w_r4),'descend');  
% % % end
% % % big_modes4 = Iw(1:varPar.wTrunc);
% % % Psir4 = Psi4(:,big_modes4);
% % % w_t4 = w_r4(big_modes4);
% % % a4 = Psir4'*Xtrain4;
% % % w_t4 = LDA_n(a4, Gtrain);
% % % s4 = SSPOCelastic(Psir4,w_t4,'alpha',fixPar.elasticNet);
% % % s4 = sum(s4, 2);   
% % % [~, I_top2] = sort( abs(s4),'descend');
% % % sensors_sort4 = I_top2(1:fixPar.rmodes);
% % % cutoff_lim4 = norm(s4, 'fro')/fixPar.rmodes;
% % % sensors4 = sensors_sort4(  abs(s4(sensors_sort4))>= cutoff_lim4 );
% % % 
% % % n =  size(Xtest4,1);
% % % classes = unique(Gtest); 
% % % c = numel(classes); 
% % % q = length(sensors4);
% % % 
% % % Phi = zeros(q, n);                                      % construct the measurement matrix Phi
% % % for qi = 1:q,
% % %     Phi(qi, sensors4(qi)) = 1;
% % % end;
% % % % learn new classifier for sparsely measured data
% % % w_sspoc= LDA_n(Phi * Xtrain4, Gtrain);
% % % Xcls = w_sspoc' * (Phi * Xtrain4);
% % % 
% % % % compute centroid of each class in classifier space
% % % centroid = zeros(c-1, c);
% % % for i = 1:c, 
% % %     centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
% % % end;
% % % % use sparse sensors to classify X
% % % Xcls = w_sspoc'*(Phi * Xtest4);
% % % 
% % % cls = zeros(1, size(Xcls,2));
% % % for i = 1:size(Xcls,2),
% % %     D = centroid - repmat(Xcls(:,i), 1, size(centroid,2));
% % %     D = sqrt(sum(D.^2, 1));
% % % 
% % %     [~, cls(i)] = min(D);
% % % end;
% % % 
% % % acc =  sum(cls == Gtest)/numel(cls);
% % % q = length(sensors4);
% % % fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])


%% plot eigenStrain
eig_fire = reshape(w_t'*Psir' , fixPar.chordElements,fixPar.spanElements);
aaa   = w_t'*Psir' ;

if aaa(1326) > 0 
   eig_fire = -eig_fire;
   display('flipped fire')
end

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
% colormap(fireScheme)

orangePurple = [179,88,6
224,130,20
253,184,99
254,224,182
247,247,245
216,218,235
178,171,210
128,115,172
84,39,136];
differenceScheme = colorSchemeInterp(orangePurple/255,500);


% figure()
% pcolor(eig_fire)
% colormap(fireScheme)
% colormap(differenceScheme)
%% Plot sensor locations on the wing 
binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
binar(sensors)  = 1;
sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 

colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
x               = [0 1 1 0]* (fixPar.spanElements+1);  
y               = [0 0 1 1]* (fixPar.chordElements+1);
[X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
I               = find( sensorloc_tot );    

% dotColor = ones(length(w_sspoc),1)*[0,0,1];
dotColor = ones(length(w_sspoc),1)*[231,41,138]/255;

% dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[0,0.5,0];
% dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[1,0,0];
% dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[0.75,0.75,0];
% dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[0.6350, 0.0780, 0.1840];
dotColor(w_sspoc>=0,:) = ones(length(nonzeros(w_sspoc>=0)),1)*[102,166,30]/255;

	
figure()
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
    hold on   
pcolor(eig_fire)
% colormap(fireScheme)
colormap(differenceScheme)
%     scatter(X(I) ,Y(I) , 100 ,'.','r');      
    dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,dotColor,'.');    
    dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');    
    scatter(0,13,100,'.k')
    plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
    ax = gca(); 
    set(ax,axOpts{:})
    axis off
%     legend([dot_legend,dot_legend2],'Positive weight','Negative weight')
%     legend(
    
    
    