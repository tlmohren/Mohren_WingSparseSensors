
%% Find nonzero elements in matrix 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

if 1
%    load(['results' filesep  'ph_th_arraystest_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2iter8_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_casestest_18-Apr-2017.mat'])
   load(['results' filesep 'test_NLDvariation_19-Apr-2017.mat'])
end

%% 
[iSTA,iNLD,ii,jj,kk,ll,mm]=ind2sub(size(Datamat),find(Datamat));
[~ ,~ ,~ ,~ ,~ ,~ ,mmm,nnn]=ind2sub(size(Sensmat),find(Sensmat));

%% create subplot routine

color_vec = {'-r','-k'};

subplotI = [5,6,8,9];
figure()
for j = 1: length(unique(iNLD))
        subplot( 2+1,2+1, subplotI(j))
        hold on
        legend_vec = [];
        for l = fliplr(1:length(par.cases))
            Meanvec = [];
            STDvec = [];
%             
            [~,~,~,~,~,ll,~]=ind2sub(size(Datamat(1,j,1,1,l,:,:)),find(Datamat(1,j,1,1,l,:,:)));
%             
            qs = unique(ll);
% 
            if l == 2
                for k2 = 1:length(qs)
                   j2 = qs(k2);
                   Meanvec(j2) = mean( nonzeros(Datamat(1,j,1,1,l,j2,:) )   );
                   STDvec(j2) = std( nonzeros(Datamat(1,j,1,1,l,j2,:) )   );
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
                   elem = length(nonzeros(Datamat(1,j,1,1,l,j2,:) )   );
                   b=  scatter(ones(elem,1)*j2,nonzeros(Datamat(1,j,1,1,l,j2,:) ) ,'.r');
                   Meanvec(j2) = mean( nonzeros(Datamat(1,j,1,1,l,j2,:) )   );
                end
                c = plot(qs,Meanvec(qs),'r');
            end
%             
        end
        axis([0,20,0.4,1])
%         title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
%         ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
%     end
end

par.NLDshift = [0,0.5,0,0];
par.NLDsharpness = [5,5,5,10];
subplotI = [2,3,4,7];
proj = -1:0.01:1;
for j = 1:4
   subplot(3,3,subplotI(j))
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift(j)) * par.NLDsharpness(j) )  );
        plot(proj,par.NLD(proj));hold on;drawnow; grid on;
end

subplot(3,3,1);
        text(0,0.3,['NLD variation']);
        axis off
% 
% %                 legend_vec = [b,a.mainLine];
%                 legend_vec = [b,c,a];
% % add legend to last plot of first row 
% subplot( length(unique(ii)), length(unique(jj)), length(unique(jj)) )
% % legend(legend_vec,par.cases,'Location','Best')
% legend(legend_vec,{par.cases{1},'mean SSPOC filt',par.cases{2}},'Location','Best')
% 


