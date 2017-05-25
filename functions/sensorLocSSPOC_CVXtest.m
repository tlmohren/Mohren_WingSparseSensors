function  [  sensors  ] = sensorLocSSPOC_CVXtest(  Xtrain,Gtrain , par)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% [  sensors  ] = SensorLocSSPOC_april(   Xtrain,Gtrain,r,SSPOC_on,w_trunc , par)
    n =  size(Xtrain,1);
    classes = unique(Gtrain); 
    c = numel(classes); 
    if par.SSPOCon == 1 && par.wTrunc~= 0
    % LDA
        [w_r, Psi, centroid] = PCA_LDA(Xtrain, Gtrain, 'nFeatures',par.rmodes);

%         if par.wTrunc ~= 0 
        [~,Iw ] =sort( abs(w_r) , 'descend');
        %---optionlal-----------------------
            [~,Sigma, ~] = svd(Xtrain, 'econ' );
            sing_vals = diag(Sigma(1:length(w_r),1:length(w_r)));

            if par.singValsMult == 1
                [~,Iw]=sort(abs(w_r).*sing_vals,'descend');  
            else
                [~,Iw]=sort(abs(w_r),'descend');  
            end
        % -------------------------
        big_modes = Iw(1:par.wTrunc);
        w_t = w_r(big_modes);
        Psi = Psi(:,big_modes);
%         end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        s = SSPOC_CVXtest(Psi,w_t,par);
            
%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        s = sum(s, 2);   

        [~, I_top] = sort( abs(s));
        I_top2 = flipud(I_top);
        sensors_sort = I_top2(1:par.rmodes);

        cutoff_lim = norm(s, 'fro')/c/par.rmodes/2;
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );

    else
        randloc = randperm(n);
        sensors = randloc(1:par.wTrunc);
    end
    
    
     % ------------------------------------------------------------------
    if par.showFigure == 1 && par.SSPOC_on == 1
        figure();
            subplot(211)
            plot(w_r)
            subplot(212)
            plot(w_r.*sing_vals)
        %---------------------------------------------------------------------
    end
end

