
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

%% plot hump for theta disturbance

figure()
x = par.theta_dist; 
MeanMat = zeros(max(ii),max(ll));
for j = unique(ii)'
    
    [~,~,~,ll,~]=ind2sub(  size(Datamat(j,1,1,:,:)) , find(Datamat(j,1,1,:,:))) ;
%     unique(ll)
%     length(unique(ll))
    % suspicious, all same length, would expect at least some q's to drop out 
    for k = unique(ll)'
%        nonzeros(Datamat(j,1,1,k,:))
       MeanMat(j,k) = mean(nonzeros(Datamat(j,1,1,k,:)));
    end
end

x(1) = 0.01;
figure()
semilogx( (ones(max(ll),1)*x)',MeanMat)
axis([min(x)*0.5,max(x)*1.5,0.4,1])
xlabel(['\theta',char(39),'-disturbance'])
ylabel('accuracy')


% try coloring groups 
groups = 6;
col = ceil( ((1:max(ll))/max(ll)*  (groups))   );
cols = linspecer( max(unique(col)));
figure();
legend_vec  = [];
legend_namevec = [];
for q = 1:groups
    mask = (col==q);
    tempLine = semilogx( (ones(sum(mask),1)*x)',MeanMat(:,mask),'Color',cols(q,:));
    hold on
    I_temp = find(mask);
    legend_name = {['q= ',num2str(min(I_temp)),' to ',num2str(max(I_temp))]};
    legend_vec = [legend_vec, tempLine(1)];
    legend_namevec = [legend_namevec, legend_name];
end
axis([min(x)*0.5,max(x)*1.5,0,1])
% axis([min(x)*0.5,max(x)*1.5,0.4,1])
xlabel(['\theta',char(39),'-disturbance'])
ylabel('accuracy')
legend(legend_vec,legend_namevec,'Location','NorthEastOutside')




%% plot hump for phi disturbance

figure()
x = par.phi_dist; 
MeanMat = zeros(max(jj),max(ll));
for j = unique(jj)'
    
    [~,~,~,ll,~]=ind2sub(  size(Datamat(1,j,1,:,:)) , find(Datamat(1,j,1,:,:))) ;
%     unique(ll)
%     length(unique(ll))
    % suspicious, all same length, would expect at least some q's to drop out 
    for k = unique(ll)'
%        nonzeros(Datamat(1,j,1,k,:))
       MeanMat(j,k) = mean(nonzeros(Datamat(1,j,1,k,:)));
    end
end

x(1) = 0.01;
figure()
semilogx( (ones(max(ll),1)*x)',MeanMat)
axis([min(x)*0.5,max(x)*1.5,0.4,1])
xlabel(['\phi',char(39),'-disturbance'])
ylabel('accuracy')


% try coloring groups 
groups = 6;
col = ceil( ((1:max(ll))/max(ll)*  (groups))   );
cols = linspecer( max(unique(col)));
figure();
legend_vec  = [];
legend_namevec = [];
for q = 1:groups
    mask = (col==q);
    tempLine = semilogx( (ones(sum(mask),1)*x)',MeanMat(:,mask),'Color',cols(q,:));
    hold on
    I_temp = find(mask);
    legend_name = {['q= ',num2str(min(I_temp)),' to ',num2str(max(I_temp))]};
    legend_vec = [legend_vec, tempLine(1)];
    legend_namevec = [legend_namevec, legend_name];
end
axis([min(x)*0.5,max(x)*1.5,0,1])
% axis([min(x)*0.5,max(x)*1.5,0.4,1])
xlabel(['\phi',char(39),'-disturbance'])
ylabel('accuracy')
legend(legend_vec,legend_namevec,'Location','NorthEastOutside')