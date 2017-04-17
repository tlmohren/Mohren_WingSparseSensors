%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
% Clear memory, Add paths containing functions etc. 
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry to all simulations
par = setParameters();           % creates parameter structure
par.savename = 'test_strainy';

par.datafolder = 
par.iter = 1;
par.w_range = 14;
par.rmodes = 35;
par.runSim = 0;
par.saveSim = 1;
par.simStartup = 1;
par.simEnd = 4;
par.sampFreq = 1e3;
par.chordElements = 26;
par.spanElements = 51;
par.xInclude = 1;
par.yInclude =1; 
par.trainFraction = 0.9;
par.SSPOC_on = 1;
par.showFigure = 1;
par.baseZero = 0;   % doesn't do anything 

%% Initialize results matrices, 5D matrix
%            rot disturbance (4)         flap disturbance (4)  filter cases(4)     trunc weight(40) iterations(20)   
Datamat = zeros(length(par.theta_dist) , length(par.phi_dist) ,length(par.cases) , par.rmodes , par.iter*2);
Sensmat = zeros(length(par.theta_dist) , length(par.phi_dist) ,length(par.cases) , par.rmodes , par.rmodes , par.iter*2 );

%% Run simulation and Sparse sensor placement for combinations of 4 parameters, over a set number of iterations
tic 
for th = 1:length(par.theta_dist)
    for ph = 1:length(par.phi_dist)
        for c = 1:length(par.cases)
            for j = 1:length(par.w_range)   
                % adjust parameters for this set of iterations-------------
                par.w_trunc= par.w_range(j); 
                par.SSPOC_on = par.SSPOC(c);
                
                for k = 1:par.iter
                    % Generate strain with Euler-Lagrange simulation ------
                    strainSet = eulerLagrangeConcatenate( par.theta_dist(th) , par.phi_dist(ph) ,par );
            
                    % Apply neural filters to strain ----------------------
                    [X,G] = neuralEncoding(strainSet, par); 
                    
                    % after this things are not good yet 
                    
                    save(['test_code' filesep 'testdata_sparseWingSensors_2651strainy.mat'],'X','G','par')
                    % Find accuracy and optimal sensor locations  ---------
                    [acc,sensors ] = sparseWingSensors( X,G, par);
                    
                    % Store data in 5D matrix -----------------------------
                    q = length(sensors);
                    prev = length(find( Datamat(th,ph,c,q,:) )  );
                    Datamat(th,ph,c,q, prev+1) = acc; 
                    Sensmat(th,ph,c,q, 1:q,prev+1) = sensors ; 
                    fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.w_trunc,q,acc])
                end
            end
        end
    end
end

run('run_paperAnalysis_outputtest')
        