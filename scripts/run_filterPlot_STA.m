
%% Find nonzero elements in matrix 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

if 0
%    load(['results' filesep  'ph_th_arraystest_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2iter8_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_casestest_18-Apr-2017.mat'])
   load(['results' filesep 'test_STAvariation_19-Apr-2017.mat'])
end

%% 
[iSTA,iNLD,ii,jj,kk,ll,mm]=ind2sub(size(Datamat),find(Datamat));
[~ ,~ ,~ ,~ ,~ ,~ ,mmm,nnn]=ind2sub(size(Sensmat),find(Sensmat));

%% create subplot routine

color_vec = {'-r','-k'};

subplotI = [5,6,8,9];
figure()
for j = 1: length(unique(iSTA))
%     j
        subplot( 2+1,2+1, subplotI(j))
        hold on
        legend_vec = [];
        for l = fliplr(1:length(par.cases))
            Meanvec = [];
            STDvec = [];
%             
            [~,~,~,~,~,ll,~]=ind2sub(size(Datamat(j,1,1,1,l,:,:)),find(Datamat(j,1,1,1,l,:,:)));
%             
            qs = unique(ll);
% 
            if l == 2
                for k2 = 1:length(qs)
                   j2 = qs(k2);
                   Meanvec(j2) = mean( nonzeros(Datamat(j,1,1,1,l,j2,:) )   );
                   STDvec(j2) = std( nonzeros(Datamat(j,1,1,1,l,j2,:) )   );
                end
% 
%                 % plot error line 
                a = shadedErrorBar(qs,Meanvec(qs),STDvec(qs),color_vec{l},0.1);

%                 a = plot(qs,Meanvec(qs),'k');
%                 hold on
            elseif l==1
                for k2 = 1:length(qs)
                   j2 = qs(k2);
%                    nonzeros(Datamat(j,k,l,j2,:) )   
                   elem = length(nonzeros(Datamat(j,1,1,1,l,j2,:) )   );
                   b=  scatter(ones(elem,1)*j2,nonzeros(Datamat(j,1,1,1,l,j2,:) ) ,'.r');
                   Meanvec(j2) = mean( nonzeros(Datamat(j,1,1,1,l,j2,:) )   );
                end
%                 c = plot(qs,Meanvec(qs),'r');
            end
%             
        end
        axis([0,20,0.4,1])
%         title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
%         ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
%     end
end





    par.STAwidth = [3,3,3,6];
    par.STAshift = [-10,-15,-10,-10];% 
%     par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
%         ./ (2*par.STAwidth(par.jSTA) ^2) ) ...
%         ./ (sqrt(3*par.STAwidth(par.jSTA)) *pi^1/4)...
%         .* ( 1-(t-par.STAshift).^2/par.STAwidth(par.jSTA)^2);
%     par.STAt = -39:0;   
%     par.STAfilt = par.STAFunc(par.STAt);    


% par.NLDshift = [0,0.5,0,0];
% par.NLDsharpness = [5,5,5,10];
subplotI = [2,3,4,7];
% proj = -1:0.01:1;
for j = 1:4
   subplot(3,3,subplotI(j))
    par.STAFunc = @(t)  2 * exp( -(t-par.STAshift(j) ) .^2 ...
        ./ (2*par.STAwidth(j) ^2) ) ...
        ./ (sqrt(3*par.STAwidth(j)) *pi^1/4)...
        .* ( 1-(t-par.STAshift(j) ).^2/par.STAwidth(j)^2);
    par.STAt = -39:0;   
    par.STAfilt = par.STAFunc(par.STAt);    
        plot(par.STAt,par.STAfilt);hold on;drawnow; grid on;
end

subplot(3,3,1);
        text(0,0.3,['STA variation']);
        axis off
% 
% %                 legend_vec = [b,a.mainLine];
%                 legend_vec = [b,c,a];
% % add legend to last plot of first row 
% subplot( length(unique(ii)), length(unique(jj)), length(unique(jj)) )
% % legend(legend_vec,par.cases,'Location','Best')
% legend(legend_vec,{par.cases{1},'mean SSPOC filt',par.cases{2}},'Location','Best')
% 


