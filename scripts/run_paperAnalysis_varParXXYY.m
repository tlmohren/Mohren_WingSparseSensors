%------------------------------
% R23_analysis_set
% Runs simulations and analysis for the paper Sparse wing sensors (...) 
% TLM 2017
%------------------------------
clear all, close all, clc
addpathFolderStructure()

%%  Build struct with parameters to carry throughout simulation

saveName = 'analysis_FigR1toR4_XXYY_270Par';

if  exist(['results', filesep , saveName,'.mat']) == 2 
   load(['results', filesep ,saveName,'.mat'])
   display('loaded previous data')
else
    varPar_end = 1;
    wTrunc_end = 1;
    iter_end = 1;
    
    % set up fixed parameters 
    par = setParameters;
    varParList = setVariableParameters_MultipleSetsXXYY(par);
    par.varParNames = fieldnames(varParList);
    
    % initialize data matrices 
    Datamat = zeros( length(varParList) , par.rmodes ,  par.iter);
    Sensmat = zeros( length(varParList) ,  par.rmodes , par.rmodes , par.iter);
end
par.saveName = saveName; 
par.iter = 5;
par.wList = 5:1:20;
%% Run simulation and Sparse sensor placement for combinations of 4 parameters, over a set number of iterations
% start were the simulation ended last time 
varPar_start = varPar_end
wTrunc_start = wTrunc_end
iter_start = iter_end
nonzeros_inDatamat = nnz(Datamat)

tic 
for j = varPar_start:length(varParList)
    fprintf('Running varPar=%g, toc = %g \n',[j,toc])
    % adjust parameters for this set of iterations----------------------
    varPar = varParList(j);
    for k = 1:length(par.varParNames)
        par.(par.varParNames{k}) = varPar.(par.varParNames{k});
    end
    
    % run for w-trunc---------------------------------------------------
    for j2 = wTrunc_start:length(par.wList)
        par.w_trunc = par.wList(j2);
        for k = iter_start:par.iter
            
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
        iter_start = 1; 
    end
    wTrunc_start = 1;
end


%% Save results 
varPar_end = j
wTrunc_end = j2
iter_end = k
nonzeros_inDatamat = nnz(Datamat)
save(  ['results/', saveName]  ,'Datamat','Sensmat','par','varParList','varPar_end','wTrunc_end','iter_end')
fprintf('Saving as : %s.mat \n',['results' filesep saveName])
