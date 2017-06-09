function  [  sensors  ] = sensorLocSSPOC_CVXtest(  Xtrain,Gtrain , par)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% [  sensors  ] = SensorLocSSPOC_april(   Xtrain,Gtrain,r,SSPOC_on,w_trunc , par)
    n =  size(Xtrain,1);
    classes = unique(Gtrain); 
    c = numel(classes); 
    if par.SSPOCon == 1 && par.wTrunc~= 0
    % LDA
        [w_r, Psi, singVals,centroid] = PCA_LDA_CVXtest(Xtrain, Gtrain, 'nFeatures',par.rmodes);

        singValsR = singVals(1:length(w_r));
        
%         [~,Sigma, ~] = svd(Xtrain, 'econ' ); % remove for more speed? 
%         sing_vals = diag(Sigma(1:length(w_r),1:length(w_r)));
%         singValsR = sing_vals
        
        if par.singValsMult == 1
            [~,Iw]=sort(abs(w_r).*singValsR,'descend');  
            
        else
            [~,Iw]=sort(abs(w_r),'descend');  
        end
        % -------------------------
        big_modes = Iw(1:par.wTrunc);
        
        singValsSort = singValsR(big_modes);
        w_t = w_r(big_modes);
        Psi = Psi(:,big_modes);
%         end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             size(Psi)
%             size(w_t)
%             size(singValsR)
        s = SSPOC_CVXtest(Psi,w_t,singValsSort,par);
        
%         figure();
%         subplot(211); plot( s); xlabel('j');ylabel('s(j)') 
%         subplot(212); histogram( abs(s) , 100) ; axis([0,2.5,0,6]); xlabel('|s|');ylabel('count')


%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        s = sum(s, 2);   
        
        [~, I_top] = sort( abs(s));
        I_top2 = flipud(I_top);
        sensors_sort = I_top2(1:par.rmodes);
        
%         cutoff_lim = norm(s, 'fro')/c/par.rmodes/2
        cutoff_lim = norm(s, 'fro')/20;
%         cutoff_test = max(abs(s))/8;
        
        sensors = sensors_sort(  abs(s(sensors_sort))>= cutoff_lim );
        given_q = length(sensors); 

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
            plot(w_r.*singValsR)
        %---------------------------------------------------------------------
    end
end

