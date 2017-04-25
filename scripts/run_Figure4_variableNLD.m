
%% Find nonzero elements in matrix 
clc;clear all; close all 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()
% 
% load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])
load(['results' filesep 'analysis_FigR1toR4_XXYY_270Par'])
%% 

% Datamat = rand(size(Datamat))*0.2 + 0.6;

%% see which simulations belong to this parameter set 
test = ( [varParList.phi_dist] == 0)& ...
            ( [varParList.theta_dist] == 0);
figure();plot(test)


%% 
bin_SSPOCon = ( [varParList.phi_dist] == 0) & ...
            ( [varParList.theta_dist] == 0) & ...
            ( [varParList.SSPOCon] == 1 ) & ...
            ( [varParList.xInclude] == 1) & ...%%%%% note error in assignment of yinlude~!!
            ( [varParList.yInclude] == 1) & ...%%%%% note error in assignment ofyinlude~!!
            ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10);
bin_SSPOCoff = ( [varParList.phi_dist] == 0)  & ...
            ( [varParList.theta_dist] == 0) & ...
            ( [varParList.SSPOCon] == 0 ) & ...
            ( [varParList.xInclude] == 1) & ...    %%%%% note error in assignment of yinlude~!!
            ( [varParList.yInclude] == 1) & ...%%%%% note error in assignment ofyxinlude~!!
            ( [varParList.STAwidth] == 3) & ...
            ( [varParList.STAshift] == -10);
figure();plot(bin_SSPOCon,'-o')
hold on;plot(bin_SSPOCoff,'-o')

ind_SSPOCon = find(bin_SSPOCon);
ind_SSPOCoff = find(bin_SSPOCoff);

ind_SSPOCon = ind_SSPOCon(2:end);
ind_SSPOCoff = ind_SSPOCoff(2:end);


par.NLDshiftList = [-0.2:0.2:0.8];
par.NLDsharpnessList = [5:2:15];
% n_plots = (length(par.NLDshiftList) + 1) *...
%             (length(par.NLDsharpnessList) +1); 
n_x = (length(par.NLDshiftList) + 1);
n_y = (length(par.NLDsharpnessList) +1); 
n_plots = n_x*n_y; 

col = {'-k','-r'};
dotcol = {'.k','.r'}; 
%% create subplot routine

mat_1 = reshape(1:n_x*n_y,[n_x,n_y])';
mat_2 = mat_1(2:end,2:end);
vec_3 = sort(mat_2(:));
vec_v = mat_1(2:end,1);

% color_vec = {'-r','-k'};
fig2=figure('Position', [100, 100, 1000, 800]);
for j = 1:length(vec_3)
    subplot(n_y,n_x, vec_3(j))

    
       
    % plot sspoc on 
        Dat_I = ind_SSPOCoff(j);
        for k2 = 1:size(Datamat,2)
            meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
% 
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{2})
            hold on
    
        end
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1},0.8);
        
        
        
   % plot sspoc off
        Dat_I = ind_SSPOCon( j);
        for k2 = 1:size(Datamat,2)
            meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
%             scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{1})
            hold on
        end
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.8);
     
        axis([0,20,0.4,1])
        axis off
end

for j = 2:n_x
   subplot(n_y,n_x,j )
   par.NLDshift = par.NLDshiftList(j-1);
   par.NLDsharpness = par.NLDsharpnessList(1);
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
        x = -1:0.02:1;
        
   plot(  x,par.NLD(x))
   axis off
end
for j = 1:length(vec_v)
   subplot(n_y,n_x,vec_v(j) )
   par.NLDshift = par.NLDshiftList(1);
   par.NLDsharpness = par.NLDsharpnessList(j);
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
        x = -1:0.02:1;
        
   plot(  x,par.NLD(x))
   axis off
end



saveas(fig2,['figs' filesep 'Figure4_variableNLD'], 'png')

