function  [  sensors  ] = sensorLocSSPOC(  Xtrain,Gtrain ,fixPar, varPar)
%[  sensors  ] = sensorLocSSPOC(  Xtrain,Gtrain , par)
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

    n =  size(Xtrain,1);
%     classes = unique(Gtrain); 
%     c = numel(classes); 
    
    if varPar.SSPOCon == 1
        % determine optimal sensors using SSPOC
        [w_r, Psi, singVals,~] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',fixPar.rmodes);
        singValsR = singVals(1:length(w_r));
        if fixPar.singValsMult == 1
            [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
        else
            [~,Iw]=sort(abs(w_r),'descend');  
        end
        big_modes = Iw(1:varPar.wTrunc);
        w_t = w_r(big_modes);
        Psi = Psi(:,big_modes);
        
        
%         a = Psi'*Xtrain;
%         w_t = LDA_n(a, Gtrain);
%         
        
        s = SSPOCelastic(Psi,w_t,'alpha',fixPar.elasticNet);
        s = sum(s, 2);   
        
%         [~, I_top] = sort( abs(s));
%         I_top2 = flipud(I_top);
        [~, I_top2] = sort( abs(s),'descend');
        sensors_sort = I_top2(1:fixPar.rmodes);

        % set cutoff limit
        % cutoff_lim = norm(s, 'fro')/c/par.rmodes/2;
        if isfield(fixPar,'sThreshold')
%             wTrunc = varPar.wTrunc;
%             cutoff_lim = norm(s, 'fro')/varPar.wTrunc;
%             sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
            
            sensors = I_top2(1:varPar.wTrunc);
%             [~,I3] = max(s);
%             sensors = I3
        else
            cutoff_lim = norm(s, 'fro')/fixPar.rmodes;
            sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
        end
%     elseif varyPar.SSPOCon == 2 
%         % sensorset contains all possible sensors 
%         sensors = 1:size(Xtrain,1);
    else
        % randomly placed sensors 
        randloc = randperm(n); 
        sensors = randloc(1:varPar.wTrunc);
    end

end

