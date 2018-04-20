%------------------------------
% run_ZcreateFigHist
% This script creates the histograms used in the intro figure of paper. 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all, close all, clc
addpathFolderStructure()


width = 6;     % Width in inches,   find column width in paper 
height = 3.5;    % Height in inches

set(0,'DefaultAxesFontSize',7)% .


parameterSetName    = 'Example 1';
figuresToRun        = 'E1'; % run Example 1 
iter                = 1; % number of iterations 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 
varPar = varParStruct(1);
varPar.wTrunc = 26;
% % varPar.phi_dist = 3.12;
% % varPar.theta_dist = 0.1;
varPar.phi_dist = 0.312;
varPar.theta_dist = 0.1;
% pre plot decisions 
% width = 2.5;     % Width in inches,   find column width in paper 
% height = 2.8;    % Height in inches
fontSize = 8; 
legend_location = 'NorthOutside';
strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it1harm0.2.mat']);
%% Test neural encoding effect
[X,G] = neuralEncoding(strainSet, fixPar,varPar );

[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);

%% 
% [w_r, Psi, singVals,V] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
% singValsR = singVals(1:length(w_r));
% 
% if fixPar.singValsMult == 1
%     [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
% else
%     [~,Iw]=sort(abs(w_r),'descend');  
% end
% big_modes = Iw(1:varPar.wTrunc);
% Psir = Psi(:,big_modes);
% 
% w_t = w_r(big_modes);
% 
% a = Psir'*Xtrain;
% w_t = LDA_n(a, Gtrain);
% 
% s = SSPOCelastic(Psir,w_t,'alpha',fixPar.elasticNet);
% s = sum(s, 2);   
% [~, I_top2] = sort( abs(s),'descend');
% 
% sensors_sort = I_top2(1:fixPar.rmodes);
% cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
% sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
% sensors = [1326;1313;1314;624;1301;1275;1312;1014;1315;79;312;650];
sensors = 1:1326;
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
XclsTrain = w_sspoc' * (Phi * Xtrain);
% Xcls = w_sspoc' * (Phi * Xtest);

% compute centroid of each class in classifier space
centroid = zeros(c-1, c);
s_dev= zeros(c-1, c);
for i = 1:c, 
    centroid(:,i) = mean(XclsTrain(:,Gtrain==classes(i)), 2);
    s_dev(:,i) = std(XclsTrain(:,Gtrain==classes(i)));
end;
encodedSparseMidLine = mean(centroid);
% use sparse sensors to classify X



XclsTest = w_sspoc' * (Phi * Xtest);
cls = zeros(1, size(XclsTest,2));
centroid_dist = abs( centroid(1)-centroid(2) );
a = s_dev(2)^-2 - s_dev(1)^-2;
b = 2*centroid(1) / s_dev(1)^2    -  2 *centroid(2) / s_dev(2)^2  ;
c = 2*log( ( s_dev(2)/s_dev(1)) ) + centroid(2)^2/s_dev(2)^2 - centroid(1)^2/s_dev(1)^2;

x_int(1) = (-b+sqrt(b^2-4*a*c))/(2*a);
x_int(2) = (-b-sqrt(b^2-4*a*c))/(2*a);

std_sep_I = find( (x_int>=min(centroid)) & (x_int<=max(centroid)) );
std_sep = x_int(std_sep_I);

[min_centroid,I] = min(centroid);
%     sep_line = min_centroid + n_sdev*s_dev(I);
mean_sep = min_centroid + centroid_dist/2;
if ~isempty(std_sep)
    sep_line = std_sep;
else
    sep_line = mean_sep;
end
classes = [1,2];


for i = 1:size(XclsTest,2),
    if XclsTest(:,i) <= sep_line
        cls(i) = I;
    elseif XclsTest(:,i) > sep_line
        cls(i) = classes(classes ~= I);
    end
end;





acc =  sum(cls == Gtest)/numel(cls);


q = length(sensors);
fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[varPar.wTrunc,q,acc])

%%

n_bins = 15;
edgeCol = 'none';
col = linspecer(2);
barOpts1 = {'BarWidth',0.7,'EdgeColor','none',...
            'FaceColor',col(1,:),...
            'FaceAlpha',0.5,...
            };
barOpts2 = {'BarWidth',0.7,...
        'FaceColor',col(2,:),...
        'EdgeColor','none',...
        'FaceAlpha',0.5,...
        };

% define color schemes 
colScheme = [255,245,239
    227, 214, 244
    255,246,213
    255,230,213]/255;


fontSize            = 7;


%% 
n_bins = 20;
fig2 = figure();
set(fig2, 'Position', [fig2.Position(1:2) width*100, height*100]); %<- Set size
hold on
    expo = round( - log10(max(abs(XclsTest))));
    xLims = [ round(min(XclsTest),expo+1)-10^(-expo-1), ( round(max(XclsTest),expo+1) +10^(-expo-1)) ];
    rangeBins = linspace(xLims(1), xLims(2), n_bins);
    xstep = (xLims(2)-xLims(1))/n_bins; 
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;
    midWay = length(XclsTest)/2;
    [aCounts] = histcounts(XclsTest(1:midWay), rangeBins);
    [bCounts] = histcounts(XclsTest(midWay+1:end), rangeBins);
    
    xLimsBase = xLims +[-1,1]*xstep*1;
%     
    bar1 = bar(binMids,aCounts,'b' );
%     bar2 = bar(binMids,bCounts,'r');
    plot(xLimsBase,[0,0],'k','LineWidth',0.5)
    
    
    
    
%
% xLims = [ round(min(XclsTest),expo+1)-10^(-expo-1), ( round(max(XclsTest),expo+1) +10^(-expo-1)) ];
    xLimsBase = xLims +[-1,1]*xstep*2;
eta = linspace(xLimsBase(1),xLimsBase(2),100);
Gauss = @(x) xstep*300*1/sqrt(2*pi*s_dev(1)^2) * exp( -(x-centroid(1)).^2/(2*s_dev(1)^2) );
G1 = xstep*300*1/sqrt(2*pi*s_dev(1)^2) * exp( -(eta-centroid(1)).^2/(2*s_dev(1)^2) );
G2 = xstep*300*1/sqrt(2*pi*s_dev(2)^2) * exp( -(eta-centroid(2)).^2/(2*s_dev(2)^2) );
plot(eta,G1,'Color',col(1,:)*0.8,'LineWidth',2)
plot(eta,G2,'Color',col(2,:)*0.8,'LineWidth',2)
plot([1,1]*sep_line, [-0.1,1]*max([aCounts,bCounts]),'--k','LineWidth',1)
% scatter(sep_line, Gauss(sep_line),'k*')


    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})
    set( bar1.BaseLine,'Visible','off')
    axis off
    text( xLimsBase(end)+xstep/2,0,'$\mathbf{\eta}$','FontSize',12)
    txtcol = linspecer(2); 
    text( binMids(end-2),200,...
        ['Flapping' char(10) '$\phantom{..}$Only'],'Color',...
        txtcol(1,:),'FontSize',fontSize)
    text( binMids(end-2),-300,...
        ['$\phantom{..}$ With' char(10) 'Rotation'],'Color',...
        txtcol(2,:),'FontSize',fontSize)
    
    
    
%% Setting paper size for saving 
set(fig2,'InvertHardcopy','on');
set(fig2,'PaperUnits', 'inches');
papersize = get(fig2, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig2, 'PaperPosition', myfiguresize);
print(fig2, ['figs' filesep 'Figure13_histogramSeparation' ], '-dpng', '-r600');
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig2, 'PaperPosition', myfiguresize);
print(fig2, ['figs' filesep 'Figure13_histogramSeparation'], '-dsvg', '-r600');
