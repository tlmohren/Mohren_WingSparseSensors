%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
% Clear memory, Add paths containing functions etc. 
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry throughout simulation

% creates pre defined parameter structure
par = setParameters();     

% adjust commonly changed parameters 
par.savename = 'test_STAvariation';
par.iter = 2;
par.showFigure = 0;
par.theta_dist = 0;%[0,0.1,1];
par.theta_dist = 0;%[0,0.1,1];
par.phi_dist = 0;%[0,0.1,1];
par.w_range = 5:5:10;
par.xInclude = 0;
par.yInlucde = 1;
par.cases = {'SSPOC, filt','random'};
par.STAsel = 1:4;
    par.STAwidth = [3,3,6,6];
    par.STAshift = [-10,-15,10,15];% 
par.NLDsel = 1; 
    par.NLDshift = [0.5 , 0.5 , 0 , 0 ];                % with ramp, shift best turned off 
    par.NLDsharpness= [ 5 , 10, 5 ,10,]; 
par.setBaseZero = 1;
par.singValsMult = 0;
par
errorCheckPar(par); 
%% Initialize results matrices, 7D matrix=
Datamat = zeros( length(par.STAsel), length(par.NLDsel) , ...
            length(par.theta_dist) , length(par.phi_dist) ,...
            length(par.cases) , par.rmodes , par.iter*2);
Sensmat = zeros( length(par.STAsel), length(par.NLDsel) ,...
            length(par.theta_dist) , length(par.phi_dist) ,...
            length(par.cases) , par.rmodes , par.rmodes , par.iter*2 );

%% Run simulation and Sparse sensor placement for combinations of 4 parameters, over a set number of iterations
tic 
for jSTA = 1:length(par.STAsel)
    for jNLD = 1:length(par.NLDsel)
        for th = 1:length(par.theta_dist)
            for ph = 1:length(par.phi_dist)
                for c = 1:length(par.cases)
                    for j = 1:length(par.w_range)   

                        fprintf('Running jSTA=%g,jNLD=%g,th=%g,ph=%g,c=%g,j=%g, toc = %g \n',[jSTA,jNLD,th,ph,c,j,toc])
                        % adjust parameters for this set of iterations-------------
                        par.w_trunc= par.w_range(j); 
                        par.SSPOC_on = par.SSPOC(c);
                        par.jSTA = jSTA;
                        par.jNLD = jNLD;

                        for k = 1:par.iter
                            % Generate strain with Euler-Lagrange simulation ------
                            strainSet = eulerLagrangeConcatenate( par.theta_dist(th) , par.phi_dist(ph) ,par );
                            
                            % Apply neural filters to strain ----------------------
                            [X,G] = neuralEncoding(strainSet, par);

                            if par.setBaseZero == 1
                                X(1:par.chordElements,:) = 0;
                            end
                            % Find accuracy and optimal sensor locations  ---------
                            [acc,sensors ] = sparseWingSensors( X,G, par);

                            % Store data in 5D matrix -----------------------------
                            q = length(sensors);
                            prev = length(find( Datamat(jSTA,jNLD,th,ph,c,q,:) )  );
                            Datamat(jSTA,jNLD,th,ph,c,q, prev+1) = acc; 
                            Sensmat(jSTA,jNLD,th,ph,c,q, 1:q,prev+1) = sensors ; 

                            % Print accuracy in command window --------------------
                            fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.w_trunc,q,acc])
                        end
                    end
                end
            end
        end
    end
end
%% Save results 
save(  ['results/',par.savename,'_',date]  ,'Datamat','Sensmat','par')
fprintf('Saving as : %s.m \n',['results/',par.savename,'_',date])

%% Plot figures 
% run('run_disturbanceSensorlocs')
% run('run_disturbancePlot')
% run('run_disturbancePlot_noSTD')
% run('run_disturbanceHump')

run('run_filterPlot_STA')
% run('run_filterPlot_NLD')
%         


%%% unused code
%                     save(['test_code' filesep 'testdata_sparseWingSensors_2651strainy.mat'],'X','G','par')