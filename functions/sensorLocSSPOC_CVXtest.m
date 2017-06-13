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
%         saveName = sprintf(['TestfilesCVX_tresholdtest_highthresh' par.saveNameTest '_dT%g_dP%g_xIn%g_yIn%g_sOn%g_STAw%g_STAs%g_NLDs%g_NLDg%g_wT%g_'],...
%                             [ par.theta_dist , par.phi_dist , par.xInclude , par.yInclude , par.SSPOCon , ...
%                             par.STAwidth , par.STAshift , par.NLDshift , par.NLDsharpness , par.wTrunc ]);
%                         
        tic        
        s = SSPOC_CVXtest(Psi,w_t,singValsSort,par);
        SSPOC_runtime = toc;
        
        
        saveName = sprintf('s_wt%g_dT%g_dP%g_CVX%g', par.wTrunc,  par.theta_dist , par.phi_dist,par.CVXcase ); 
        save(  ['s_files',filesep, saveName '_',datestr(datetime('now'), 30),'.mat']  ,'s')
        
%         size(s)
%         figure();
%         subplot(211); plot( s); xlabel('j');ylabel('s(j)') 
%         subplot(212); histogram( abs(s) , 100) ; axis([0,2.5,0,6]); xlabel('|s|');ylabel('count')

%%%%%%%%%%%%%%%%%%%%%%%%%%TESTSECTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        s = sum(s, 2);   
        
%         nonzeros(s)
        
        [~, I_top] = sort( abs(s));
        I_top2 = flipud(I_top);
        sensors_sort = I_top2(1:par.rmodes);
        
        cutoff_lim = norm(s, 'fro')/par.rmodes;
%         cutoff_lim = norm(s, 'fro')/1e8
%         cutoff_lim = norm(s, 'fro')/20; % worked 
%         cutoff_lim = norm(s, 'fro')/10;
%         cutoff_lim = norm(s, 'fro')/5; % too small 
%         cutoff_test = max(abs(s))/8; 
%         hold on
        hold on
        plot(ones(2,1)*cutoff_lim,[0,100]) ; axis([0,2.5,0,6])
        
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

