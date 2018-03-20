%------------------------------
% run_Figure_S3_disturbanceRefined
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clc;clear all; close all 
addpathFolderStructure()
w = warning ('off','all');
% pre plot decisions 
width = 6;     % Width in inches,   find column width in paper 
height =6;    % Height in inches
set(0,'DefaultAxesFontSize',7)% .

%% Data collection 
parameterSetName = 'R1R4_Iter5_delay5_eNet09';
% parameterSetName = 'R1toR4_Iter10_run1';
% parameterSetName = 'R1toR4_Iter10_delay4';

overflow_loc = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors_githubOverflow';
github_loc = 'accuracyData';
    
try
    load([github_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = github_loc;
catch
    display('not on github, looking at old data')
    load([overflow_loc filesep 'parameterSet_' parameterSetName ])
    fixPar.data_loc = overflow_loc;
end 
    
fixPar.nIterFig = 10;
fixPar.nIterSim = 10; 

[dataStructA,paramStructA] = combineDataMat( fixPar, simulation_menu.S3A_phiDist );
ind_SSPOCoffA = find( ~[paramStructA.SSPOCon]);
ind_SSPOConA = find([paramStructA.SSPOCon]);

[dataStructB,paramStructB] = combineDataMat(fixPar,  simulation_menu.S3B_thetaDist );

ind_SSPOCoffB = find( ~[paramStructB.SSPOCon]);
ind_SSPOConB = find([paramStructB.SSPOCon]);

load(['accuracyData' filesep 'parameterSet_' 'S3C_phiDistnoSTA10' ])
fixPar.nIterFig = 10;
[dataStructC,paramStructC] = combineDataMat( fixPar,  simulation_menu.S3C_phiDistnoSTA );
ind_SSPOCoffC = find( ~[paramStructC.SSPOCon]);
ind_SSPOConC = find([paramStructC.SSPOCon]);



load(['accuracyData' filesep 'parameterSet_' 'S3D_thetaDistnoSTA10' ])
fixPar.nIterFig = 10;
[dataStructD,paramStructD] = combineDataMat( fixPar,  simulation_menu.S3D_thetaDistnoSTA );
ind_SSPOCoffD = find( ~[paramStructD.SSPOCon]);
ind_SSPOConD = find([paramStructD.SSPOCon]);


%% Figure settings
fig_S5 = figure();
set(fig_S5, 'Position', [ 100,100 width*100, height*100]); %<- Set size
plot_on = false;
fszL = 8;  
fszM = 7;
fszS = 6; 
% Axis makeup 
col = {[1,1,1]*100/255,'-r'};
dotcol = {'.k','.r'}; 


%% 
n_x = length(simulation_menu.S3A_phiDist.phi_distList);
for k = 1:n_x
    %---------------------------------SSPOCoff-------------------------
    Dat_I = ind_SSPOCoffA( k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructA );
    realNumbers = find(~isnan(meanVec));
    thresholdMatA(k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

    %---------------------------------SSPOCon-------------------------
    Dat_I = ind_SSPOConA(k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructA );
    realNumbers = find(~isnan(meanVec));
    thresholdMatA(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
end

n_x = length(simulation_menu.S3B_thetaDist.theta_distList);
for k = 1:n_x
    %---------------------------------SSPOCoff-------------------------
    Dat_I = ind_SSPOCoffB( k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
    realNumbers = find(~isnan(meanVec));
    thresholdMatB(k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

    %---------------------------------SSPOCon-------------------------
    Dat_I = ind_SSPOConB(k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructB );
    realNumbers = find(~isnan(meanVec));
    thresholdMatB(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
end



%% 
n_x = length(simulation_menu.S3C_phiDistnoSTA.phi_distList );
for k = 1:n_x
    %---------------------------------SSPOCoff-------------------------
    Dat_I = ind_SSPOCoffC( k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
    realNumbers = find(~isnan(meanVec));
    thresholdMatC(k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

    %---------------------------------SSPOCon-------------------------
    Dat_I = ind_SSPOConC(k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
    realNumbers = find(~isnan(meanVec));
    thresholdMatC(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
end

%% 
n_x = length(simulation_menu.S3D_thetaDistnoSTA.theta_distList );
for k = 1:n_x
    %---------------------------------SSPOCoff-------------------------
    Dat_I = ind_SSPOCoffD( k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructD );
    realNumbers = find(~isnan(meanVec));
    thresholdMatD(k,1) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);

    %---------------------------------SSPOCon-------------------------
    Dat_I = ind_SSPOConD(k);
    [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructD );
    realNumbers = find(~isnan(meanVec));
    thresholdMatD(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
end





%% 
cols = [ [1,1,1]*0.5 ; 
            1,0,0 ];
fig2SimsA = mod(log10(simulation_menu.S3A_phiDist.phi_distList/0.00312) ,1) == 0;
fig2SimsB = mod(log10(simulation_menu.S3B_thetaDist.theta_distList/0.01) ,1) == 0;

subplot(211); 
%     l1=semilogx(simulation_menu.S3A_phiDist.phi_distList, thresholdMatA(:,1),'Color',cols(1,:));
    l2=semilogx(simulation_menu.S3A_phiDist.phi_distList, thresholdMatA(:,2),'Color',cols(2,:));
    hold on
    %     plot(simulation_menu.S3A_phiDist.phi_distList(fig2SimsA ), thresholdMatA(fig2SimsA ,1)','o','Color',cols(1,:))
    semilogx(simulation_menu.S3A_phiDist.phi_distList(fig2SimsA ), thresholdMatA(fig2SimsA ,2),'o','Color',cols(2,:))
    l4 =semilogx(simulation_menu.S3C_phiDistnoSTA.phi_distList, thresholdMatC(:,2),':','Color',cols(2,:));
%     plot(simulation_menu.S3C_phiDistnoSTA.phi_distList(fig2SimsA ), thresholdMatC(fig2SimsA ,1)','o','Color',cols(1,:))
    semilogx(simulation_menu.S3C_phiDistnoSTA.phi_distList(fig2SimsA ), thresholdMatC(fig2SimsA ,2),'o','Color',cols(2,:))

    xlabel('Disturbance $\dot{\phi}^*$ [rad/s]'); 
    ylabel(['Fewest sensors ' char(10) 'required for' char(10) 'classification'],'Rotation',0)
    legend([l2,l4], 'SSPOC Sensors',['SSPOC Sensors' char(10) 'without STA'],'Location','Best')
%     legend([l1,l2,l4],'Random Sensors','SSPOC Sensors','SSPOC sensors without STA','Best')

subplot(212); 
%     l1 =semilogx(simulation_menu.S3B_thetaDist.theta_distList, thresholdMatB(:,1),'Color',cols(1,:))
    l2 =semilogx(simulation_menu.S3B_thetaDist.theta_distList, thresholdMatB(:,2),'Color',cols(2,:));
hold on
%     plot(simulation_menu.S3B_thetaDist.theta_distList(fig2SimsB ), thresholdMatB(fig2SimsB ,1)','o','Color',cols(1,:))
    plot(simulation_menu.S3B_thetaDist.theta_distList(fig2SimsA ), thresholdMatB(fig2SimsB ,2),'o','Color',cols(2,:))
%     semilogx(simulation_menu.S3D_thetaDistnoSTA.theta_distList, thresholdMatD(:,1),':','Color',cols(1,:))
    l4 =semilogx(simulation_menu.S3D_thetaDistnoSTA.theta_distList, thresholdMatD(:,2),':','Color',cols(2,:));
%     plot(simulation_menu.S3D_thetaDistnoSTA.theta_distList(fig2SimsA ), thresholdMatD(fig2SimsA ,1)','o','Color',cols(1,:))
    plot(simulation_menu.S3D_thetaDistnoSTA.theta_distList(fig2SimsA ), thresholdMatD(fig2SimsA ,2),'o','Color',cols(2,:))
%     legend([l1,l2,l4],'Random Sensors','SSPOC Sensors','SSPOC sensors without STA','Best')
    xlabel('Disturbance $\dot{\theta}^*$ [rad/s]'); 
    ylabel(['Fewest sensors ' char(10) 'required for' char(10) 'classification'],'Rotation',0)
%     legend([l2,l4], 'SSPOC Sensors','Location','Best')    
%     
    
    
    %%  
%     
% %% check sigmoidFit, what happends without distu
% figure()
% for k = 1:n_x
%     Dat_I = ind_SSPOConC(k);
%     [ meanVec,stdVec, iters] = getMeanSTD( Dat_I,dataStructC );
%     realNumbers = find(~isnan(meanVec));
%     plot_on = 1;
%     thresholdMatC(k,2) = sigmFitParam(realNumbers,meanVec(realNumbers),'plot_show',plot_on);
%    subplot(7,6,k)
%    plot(realNumbers,meanVec(realNumbers)  )
%    axis([1,30,0.4,1])
% end
    
%% Setting paper size for saving 

set(fig_S5,'InvertHardcopy','on');
set(fig_S5,'PaperUnits', 'inches');
papersize = get(fig_S5, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig_S5, 'PaperPosition', myfiguresize);
% Saving figure 
print(fig_S5, ['figs' filesep 'Figure_S5' ], '-dpng', '-r600'); 

stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig_S5, 'PaperPosition', myfiguresize);
print(fig_S5, ['figs' filesep 'Figure_S5'], '-dsvg', '-r600');


