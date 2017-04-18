
%% Find nonzero elements in matrix 

if 0
%    load(['results' filesep  'ph_th_arraystest_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2_18-Apr-2017.mat'])
%    load(['results' filesep  'ph_th_arraytest2x2iter8_18-Apr-2017.mat'])
   load(['results' filesep  'ph_casestest_18-Apr-2017.mat'])
end

%% 
[ii,jj,kk,ll,mm]=ind2sub(size(Datamat),find(Datamat));
[~ ,~ ,~ ,~ ,mmm,nnn]=ind2sub(size(Sensmat),find(Sensmat));

%% create subplot routine

color_vec = {'-r','-k'};
figure()
for j = 1:length(unique(ii))
    for k = 1:length(unique(jj))
        subplot( length(unique(ii)), length(unique(jj)), (j-1)*length(unique(jj)) + k)
       
        legend_vec = [];
        for l = fliplr(1:length(par.cases))
            Meanvec = [];
            STDvec = [];
            
%             Datamat(j,k,l,:,:)
            
            [~,~,~,ll,~]=ind2sub(size(Datamat(j,k,l,:,:)),find(Datamat(j,k,l,:,:)));
            
            
            
            qs = unique(ll);

            for k2 = 1:length(qs)
               j2 = qs(k2);
               Meanvec(j2) = mean( nonzeros(Datamat(j,k,l,j2,:) )   );
               STDvec(j2) = std( nonzeros(Datamat(j,k,l,j2,:) )   );
            end

%             good_I = find(isfinite(Meanvec) & Meanvec~=0);
%             qs = good_I;

            % plot error line 
            a = shadedErrorBar(qs,Meanvec(qs),STDvec(qs),color_vec{l},0.1);
            hold on
            legend_vec = [legend_vec,a.mainLine];
        end
        axis([0,max(qs),0.4,1])
        title(['$\phi$* = ',num2str(par.phi_dist(k)), ' rad/s'] )
        ylabel(['\theta* = ',num2str(par.theta_dist(j)), ' rad/s'])
    end
end

% add legend to last plot of first row 
subplot( length(unique(ii)), length(unique(jj)), length(unique(jj)) )
legend(legend_vec,par.cases,'Location','Best')




%%  plot sensor locations 

% nStrains = par.xInclude + par.yInclude; 

   figure()
   q_sens = qs(3); 

%     binar = zeros(    par.chordElements * par.spanElements  );
    if par.xInclude == 1
        binar_x = zeros(    par.chordElements * par.spanElements,par.rmodes );
        for k = 1:length(qs)
            j = qs(k)
            n_it = length( nonzeros(Datamat(1,1,1,j,:) ));
            
            
            for kk = 1:n_it
                kk
                sensors = squeeze(Sensmat(1,1,1,j,1:j,kk));
                sensors_x = sensors(sensors<= (par.spanElements*par.chordElements));
                binar_x(sensors_x,j) = binar_x(sensors_x,j) + 1;
%                 binar( Sensmat(1,1,1,j,1:j,kk),j) = binar(Sensmat(1,1,1,j,1:j,kk),j) + 1;
            end
            binar_x(:,j) = binar_x(:,j)/n_it;
        end
        subplot(2,1,1)
%             plot_sensorlocsV4(binar_x(:,q_sens),par);
            plotSensorLocs(binar_x(:,q_sens),par);
            title('Strain in x')
    end 
    

    if par.yInclude == 1
        binar_y = zeros(    par.chordElements * par.spanElements,par.rmodes );
        for k = 1:length(qs)
            j = qs(k);
            n_it = length( nonzeros(Datamat(1,1,1,j,:) ));
            for kk = 1:n_it
                sensors = squeeze(Sensmat(1,1,1,j,1:j,kk));
                if par.xInclude == 1
                   sensors = sensors - par.chordElements*par.spanElements; 
                end
                pos_sensors = sensors(sensors>0);
                binar_y(pos_sensors,j) = binar_y(pos_sensors,j) + 1;
%                 binar( Sensmat(1,1,1,j,1:j,kk),j) = binar(Sensmat(1,1,1,j,1:j,kk),j) + 1;
            end
            binar_y(:,j) = binar_y(:,j)/n_it;
        end
    subplot(2,1,2)
            plotSensorLocs(binar_y(:,q_sens) ,par);
            title('Strain in y')
    end 
