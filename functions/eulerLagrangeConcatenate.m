function [ strainSet ] = eulerLagrangeConcatenate(ph,th,par)
%eulerLagrangeConcatenate Simulates and concatenates strain data
%   strain = eulerLagrangeConcatenate() runs simulation eulerLagrange for
%   two different conditions, 1) flapping, 2) flapping & rotating. The
%   strain from these two cases is concatenated into a large matrix.
%   TLM 2017

%     simData = ['data' filesep 'strain_set_th' num2str(th),'ph',num2str(ph),'.mat'];
%     simData = ['data' filesep 'strainSet_th' num2str(th),'ph',num2str(ph),...
%         'chElem',num2str(par.chordElements),'spEl',num2str(par.spanElements),'.mat'];
%     simData = ['data' filesep 'strainSet_th' num2str(th),'ph',num2str(ph),...
%         'chEL',num2str(par.chordElements),'spEL',num2str(par.spanElements),...
%         'Ex',num2str(par.xInclude),'Ey',num2str(par.yInclude),'.mat']
    simData = sprintf('strainSet_th%gph%gcEl%2.0fsEl%2.0fEx%1.0fEy%1.0f.mat',...
        [th,ph,par.chordElements,par.spanElements,par.xInclude,par.yInclude]);
%     ['data' filesep simData]
%     if par.runSim == 1
%         % Run simulations for the given parameters 
%         fprintf(['Running simulations for:' simData '\n']); 
%         strain_0 = eulerLagrange(0,ph,th ,par);
%         strain_10 = eulerLagrange(10,ph,th ,par);
%         strainSet.strain_0 = strain_0;
%         strainSet.strain_10 = strain_10;
%         
% %         strain_set = [strain_0 , strain_10];
% %         fprintf('Completed simulations for ph = %4.1f, th = %4.1f done \n',[ph,th]); 
%         fprintf(['Completed simulations for: ' simData '\n']); 
%         
%         if (par.runSim == 1) && (par.saveSim == 1)
%             save(['data' filesep simData],'strain_0','strain_10')
%         end
%     else
%         % Load strain from a stored simulation
%         if exist(simData,'file')==2
% %             strain_set = loadSingleVariableMATFile(simData); 
%             strainSet = load(['data' filesep simData]);
%             display(['Loaded simulation data: ', simData]); 
%         else
%             error(['Simulation data not found: ' simData '   TLM 2017']); 
%         end
%         
%     end
    
    
    

    [dataDirectory,baseName] = fileparts(pwd);
    dataFolder = [dataDirectory filesep baseName,'Data'];
    
    
    
    
    if (par.runSim == 0) && (exist([dataFolder filesep simData],'file')==2) 
        % if exists and don't run: load data
            strainSet = load([dataFolder filesep simData]);
            display(['Loaded simulation data: ', simData]); 
    else
        % Run simulations for the given parameters 
        fprintf(['Running simulations for: ' simData '\n']); 
        strain_0 = eulerLagrange(0,ph,th ,par);
        strain_10 = eulerLagrange(10,ph,th ,par);
        strainSet.strain_0 = strain_0;
        strainSet.strain_10 = strain_10;
       
        fprintf(['Completed simulations for: ' simData '\n']); 
        
        if (par.saveSim == 1)
            save([dataFolder filesep simData],'strain_0','strain_10')
            fprintf(['saved simulations for: ' simData '\n']); 
        end
    end
    
    
    
    
    
    % set first row to zero of strain, does not work? 
    if par.baseZero == 1
        display('did this')
       strainSet.strain_0(1:par.chordElements,:)= 0;  
       strainSet.strain_10(1:par.chordElements,:)= 0;  
    end
    
    
end

