%------------------------------
% run_exampleScript
% Runs a single instance of the neurally encoded sparse sensor classification. 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
clear all,clc;close all
% close all, clc
addpathFolderStructure()
parameterSetName    = 'Example 1';
figuresToRun        = 'E1'; % run Example 1 
iter                = 1; % number of iterations 
fixPar              = createFixParStruct( parameterSetName,iter); % load fixed parameters 
[ varParStruct,~]   = createVarParStruct( fixPar, figuresToRun); % load variable parameters 

%%%%%%%%%%%%%%% Choices to make %%%%%%%%%%%%%%%%%%%%%%%%
sparse_sensors_on           = 1; % choose 1 for sparse sensors ON, if 0 the sensors will be random 
desired_number_of_sensors   = 1326; % choose an integer between 1 and 30
desired_number_of_sensors   = 3; % choose an integer between 1 and 30
rerun_structural_simulation_on = 0; % choose to load structural euler-lagrange simulation results, or to rerun them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sparse_sensors_on
    varPar              = varParStruct(2);  % SSPOC on 
else
	varPar              = varParStruct(1);  % SSPOC off 
end
varPar.wTrunc           = desired_number_of_sensors;
if rerun_structural_simulation_on
    fixPar.runSim       = 1;
    fixPar.saveSim      = 0;
end
varPar.curIter      = iter;
% varPar.phi_dist = 31.2;
varPar.phi_dist = 3.12;
varPar.theta_dist = 1;
% % varPar.phi_dist = 0.312;
% varPar.theta_dist = 0.1;

%% Run the exampale simulation
strainSet       = eulerLagrangeConcatenate( fixPar,varPar);
[X,G]           = neuralEncoding(strainSet, fixPar,varPar );
[Xtrain, Xtest, Gtrain, Gtest] = predictTrain(X, G, fixPar.trainFraction);
% [sensors, Psir, w_t]    = sensorLocSSPOCWeights(Xtrain,Gtrain,fixPar,varPar);
% sensors         = [1301, 1313]; % ,1326]'
% sensors         = [1301, 1313 ,  1326]'; 
sensors         = [1301, 1313 , 1314 , 1315,1316,  1326]'; 
% sensors         = [1301:1326]; 
% sensors         = 1:1326;
% accuracy        = sensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest );
[ accuracy, w_sspoc ]       = sensorLocClassifyWeights(  sensors,Xtrain,Gtrain,Xtest,Gtest );

if sparse_sensors_on
    fprintf('\n %g sensors found for the %g truncated modes, with clas. accuracy of %g \n', length(sensors),varPar.wTrunc, accuracy)
else
    fprintf('\n%g random sensors give a clas. accuracy of %g \n', length(sensors), accuracy)
end

[ accuracy, w_sspoc ]       = sensorLocClassifySTD(  sensors,Xtrain,Gtrain,Xtest,Gtest );
    if sparse_sensors_on
    fprintf('\n %g sensors found for the %g truncated modes, with clas. accuracy of %g \n', length(sensors),varPar.wTrunc, accuracy)
else
    fprintf('\n%g random sensors give a clas. accuracy of %g \n', length(sensors), accuracy)
end
% %% Plot sensor locations on the wing 
binar           = zeros(fixPar.chordElements,fixPar.spanElements,1);
binar(sensors)  = 1;
sensorloc_tot   = reshape( binar, fixPar.chordElements,fixPar.spanElements); 
% 
colorBarOpts    = { 'YDir', 'reverse', 'Ticks' ,0:0.5:1, 'TickLabels', {1:-0.5:0}  ,'TickLabelInterpreter','latex'};
axOpts          = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4],'XLim',[0,52],'YLim',[0,27]};
x               = [0 1 1 0]* (fixPar.spanElements+1);  
y               = [0 0 1 1]* (fixPar.chordElements+1);
[X,Y]           = meshgrid(1:fixPar.spanElements,1:fixPar.chordElements);
I               = find( sensorloc_tot );    
% 
% figure()
%     pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
%     hold on   
%     scatter(X(I) ,Y(I) , 100 ,'.','r');      
%     scatter(0,13,100,'.k')
%     plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
%     ax = gca(); 
%     set(ax,axOpts{:})
%     axis off
%     
    
%% 
figure(); 
subplot(211);
% plot eigenStrain
    eig_fire = reshape(w_t'*Psir' , fixPar.chordElements,fixPar.spanElements);
    aaa   = w_t'*Psir' ;

    if aaa(1326) > 0 
       eig_fire = -eig_fire;
       display('flipped fire')
    end

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

        pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
        hold on   
    pcolor(eig_fire)
    % colormap(fireScheme)
    colormap(differenceScheme)
    %     scatter(X(I) ,Y(I) , 100 ,'.','r');      
%         dot_legend =  scatter(X(I) ,Y(I) ,   ceil( abs( w_sspoc)*10)*100 ,dotColor,'.');    
%         dot_legend2 =  scatter(X(I(3)) ,Y(I(3)) , 100 ,dotColor(3,:),'.');    
        scatter(0,13,100,'.k')
        plot([1,1]*0,[-0.5,27],'k','LineWidth',1)
        ax = gca(); 
        set(ax,axOpts{:})
        axis off
    
    
subplot(212) 
hold on
    pc  = patch(x,y,[1,1,1]*255/255,'EdgeColor','k');
%     weights = U(:, mode );
%     sensors = find( abs(weights) > 0.01 )
%     sensors = [1301, 1313,1326]'
%     w_sspoc = U(sensors, mode );
    

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
    
    
    
    