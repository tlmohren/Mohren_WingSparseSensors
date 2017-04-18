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
par.savename = 'test_3x3_yonly';
par.iter = 8;
par.showFigure = 0;
par.theta_dist = [0,0.1,1];
par.phi_dist = [0,0.1,1];
par.w_range = 5:20;
par.cases = {'SSPOC + filt','Random filt'} ;

par
errorCheckPar(par); 
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
                
                fprintf('Running th=%g,ph=%g,c=%g,j=%g, toc = %g \n',[th,ph,c,j,toc])
                % adjust parameters for this set of iterations-------------
                par.w_trunc= par.w_range(j); 
                par.SSPOC_on = par.SSPOC(c);
                
                for k = 1:par.iter
                    % Generate strain with Euler-Lagrange simulation ------
                    strainSet = eulerLagrangeConcatenate( par.theta_dist(th) , par.phi_dist(ph) ,par );
            
                    % Apply neural filters to strain ----------------------
                    [X,G] = neuralEncoding(strainSet, par); 
                    
                    % Find accuracy and optimal sensor locations  ---------
                    [acc,sensors ] = sparseWingSensors( X,G, par);
                    
                    % Store data in 5D matrix -----------------------------
                    q = length(sensors);
                    prev = length(find( Datamat(th,ph,c,q,:) )  );
                    Datamat(th,ph,c,q, prev+1) = acc; 
                    Sensmat(th,ph,c,q, 1:q,prev+1) = sensors ; 
%                     fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.w_trunc,q,acc])
                end
            end
        end
    end
end

%% Save results 
save(  ['results/',par.savename,'_',date]  ,'Datamat','Sensmat','par')
fprintf('Saving as : %s.m \n',['results/',par.savename,'_',date])

%% Plot figures 
run('run_paperAnalysis_outputtest')
        


%%% unused code
%                     save(['test_code' filesep 'testdata_sparseWingSensors_2651strainy.mat'],'X','G','par')