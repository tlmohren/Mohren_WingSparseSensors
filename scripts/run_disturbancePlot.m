
%% Find nonzero elements in matrix 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

if 1
%    load(['results' filesep  'ph_th_arraystest_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2iter8_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_casestest_18-Apr-2017.mat'])
   load(['results' filesep 'disturbanceResults3x3_iter20_yonly_18-Apr-2017.mat'])
end

%% 
[ii,jj,kk,ll,mm]=ind2sub(size(Datamat),find(Datamat));
[~ ,~ ,~ ,~ ,mmm,nnn]=ind2sub(size(Sensmat),find(Sensmat));

%% create subplot routine

Meanvec00 = [];
qs00 = [];
color_vec = {'-r','-k'};
figure()
for j = 1:length(unique(ii))
    for k = 1:length(unique(jj))
        subplot( length(unique(ii)), length(unique(jj)), (j-1)*length(unique(jj)) + k)
        a0 = plot(qs00,Meanvec00(qs00),'LineWidth',[4]);
        hold on
        legend_vec = [];
        for l = fliplr(1:length(par.cases))
            Meanvec = [];
            STDvec = [];
            
            [~,~,~,ll,~]=ind2sub(size(Datamat(j,k,l,:,:)),find(Datamat(j,k,l,:,:)));
            
            qs = unique(ll);

            for k2 = 1:length(qs)
               j2 = qs(k2);
               Meanvec(j2) = mean( nonzeros(Datamat(j,k,l,j2,:) )   );
               STDvec(j2) = std( nonzeros(Datamat(j,k,l,j2,:) )   );
            end

            % plot error line 
            a = shadedErrorBar(qs,Meanvec(qs),STDvec(qs),color_vec{l},0.1);
            hold on
            legend_vec = [legend_vec,a.mainLine];
            
            if j == 1 && k == 1 && l ==2
               Meanvec00 = Meanvec;
               qs00 = qs;
            end
            
        end
        axis([0,max(qs),0.4,1])
        title(['$\phi$',char(39),' = ',num2str(par.phi_dist(k)), ' rad/s'] )
        ylabel(['\theta',char(39),' = ',num2str(par.theta_dist(j)), ' rad/s'])
    end
end

legend_vec = [a0,legend_vec];
% add legend to last plot of first row 
subplot( length(unique(ii)), length(unique(jj)), length(unique(jj)) )
legend(legend_vec,{'Randon, no disturbance',par.cases{1},par.cases{2}},'Location','Best')



