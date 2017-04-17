
%% Find nonzero elements in matrix 
[ii,jj,kk,ll,mm]=ind2sub(size(Datamat),find(Datamat));
[~ ,~ ,~ ,~ ,mmm,nnn]=ind2sub(size(Sensmat),find(Sensmat));

%% Save matrix 
save(  ['results/',par.savename,'_',date]  ,'Datamat','Sensmat','par')
fprintf('Saving as : %s.m \n',['results/',par.savename,'_',date])


%         
%         sensors = [1,3,30,32,26*51+26];
%         binar(sensors,1) = 1;
%         plot_sensorlocsXXYYV3(binar(:,1));
        
%% Create accuracy plot 
Meanvec = [];
qs = unique(ll);
for k = 1:length(qs)
   j = qs(k);
   Meanvec(j) = mean( nonzeros(Datamat(1,1,1,j,:) )   );
   STDvec(j) = std( nonzeros(Datamat(1,1,1,j,:) )   );
end

figure();
plot(qs,Meanvec(qs),'k','Linewidth',3)
hold on
plot(qs,Meanvec(qs)+STDvec(qs),'r')
plot(qs,Meanvec(qs)-STDvec(qs),'r')

if length(qs) == 1
    scatter(qs,Meanvec(qs),'k','Linewidth',3)
    hold on
    scatter(qs,Meanvec(qs)+STDvec(qs),'r')
    scatter(qs,Meanvec(qs)-STDvec(qs),'r')
end

axis([0,30,0,1])
axis([0,30,0.4,1])

%%  plot sensor locations 

% par.chordElements
% par.spanElements
% par.xInclude
% par.yInclude 


% nStrains = par.xInclude + par.yInclude; 

   figure()
   q_sens = qs(1); 

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
            plot_sensorlocsV4(binar_x(:,q_sens),par);
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
            
%     
%     
%     subplot(2,1,2)
%     binar = zeros(    par.chordElements * par.spanElements  );
%     plot_sensorlocsXXYYV3(binar ,par);
% %     if par.xInclude == 1 
% %         
% %     end
%     
%     if par.xInclude == 1 && par.yInclude == 1
%         
%     
%     elseif par.xInclude == 0 &&  par.yInclude == 1 
%     
%     end
%     
%     
%     
% end

% binar = zeros(    par.chordElements * par.spanElements * (par.xInclude + par.yInclude) ,par.rmodes);
% 
% 
%     for k = 1:length(qs)
%         j = qs(k);
%         n_it = length( nonzeros(Datamat(1,1,1,j,:) )); 
%         for kk = 1:n_it
%             binar( Sensmat(1,1,1,j,1:j,kk),j) = binar(Sensmat(1,1,1,j,1:j,kk),j) + 1;
%         end
%         binar(:,j) = binar(:,j)/n_it;
%     end 
    
%% ------------------------------------------------
% Commands for unit testing
% eulerLangrangeConcatenate
%     strain_set(1:(51*26),:) = 0;