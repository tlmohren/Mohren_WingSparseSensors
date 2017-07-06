function  [  sensors  ] = sensorLocSSPOC(  Xtrain,Gtrain , par)
%[  sensors  ] = sensorLocSSPOC(  Xtrain,Gtrain , par)
%   Creates Psi and w_t vector and use to call SSPOC
%   Created: 2017/??/??  (TLM)
%   Last updated: 2017/07/03  (TLM)

    n =  size(Xtrain,1);
%     classes = unique(Gtrain); 
%     c = numel(classes); 
    
    if par.SSPOCon == 1
        % determine optimal sensors using SSPOC
        [w_r, Psi, singVals,~] = PCA_LDA_singVals(Xtrain, Gtrain, 'nFeatures',par.rmodes);
        singValsR = singVals(1:length(w_r));
        [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
        big_modes = Iw(1:par.wTrunc);
        w_t = w_r(big_modes);
        Psi = Psi(:,big_modes);
        
        s = SSPOC(Psi,w_t,par);
        s = sum(s, 2);   
        
        [~, I_top] = sort( abs(s));
        I_top2 = flipud(I_top);
        sensors_sort = I_top2(1:par.rmodes);

        % set cutoff limit
        % cutoff_lim = norm(s, 'fro')/c/par.rmodes/2;
        cutoff_lim = norm(s, 'fro')/par.rmodes;
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
    elseif par.SSPOCon == 2 
        % sensorset contains all possible sensors 
        sensors = 1:size(Xtrain,1);
    else
        % randomly placed sensors 
        randloc = randperm(n); 
        sensors = randloc(1:par.wTrunc);
    end

end

