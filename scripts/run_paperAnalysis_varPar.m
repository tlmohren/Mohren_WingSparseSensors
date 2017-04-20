%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry throughout simulation

% set up fixed parameters 
par = setParameters_DisturbanceSweep;
par.iter = 1;
par.wList = [15];
par.savename = 'test_varPar';
varParList = setVariableParameters(par);
par.varParNames = fieldnames(varParList);

% Initialize results matrices, 3D matrix=
Datamat = zeros( length(varParList) , par.rmodes ,  par.iter);
Sensmat = zeros( length(varParList) ,  par.rmodes , par.rmodes , par.iter);
%% Run simulation and Sparse sensor placement for combinations of 4 parameters, over a set number of iterations
tic 
for j = 1:length(varParList)
    fprintf('Running varPar=%g, toc = %g \n',[j,toc])
    % adjust parameters for this set of iterations----------------------
    varPar = varParList(j)
    for k = 1:length(par.varParNames)
        par.(par.varParNames{k}) = varPar.(par.varParNames{k});
    end
%     par
    % run for w-trunc---------------------------------------------------
    for j2 = 1:length(par.wList)
        par.w_trunc = par.wList(j2);
        for k = 1:par.iter
            % Generate strain with Euler-Lagrange simulation ----------
            strainSet = eulerLagrangeConcatenate( varPar.theta_dist , varPar.phi_dist ,par);
    % % 
            % Apply neural filters to strain --------------------------
            [X,G] = neuralEncoding(strainSet, par );
    % % 
            % Find accuracy and optimal sensor locations  ---------
            [acc,sensors ] = sparseWingSensors( X,G, par);
    % 
    %         Store data in 3D matrix -----------------------------
            q = length(sensors);
            prev = length(find( Datamat(j,q,:) )  );
            Datamat(j,q, prev+1) = acc; 
            Sensmat(j,q, 1:q,prev+1) = sensors ;    
            % Print accuracy in command window --------------------
            fprintf('W_trunc = %1.0f, q = %1.0f, giving accuracy =%4.2f \n',[par.w_trunc,q,acc])
        end
    end
end
%% Save results 
save(  ['results/',par.savename,'_',date]  ,'Datamat','Sensmat','par','varParList')
fprintf('Saving as : %s.m \n',['results/',par.savename,'_',date])
