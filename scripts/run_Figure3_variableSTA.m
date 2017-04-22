
%% Find nonzero elements in matrix 
clc;clear all; close all 
scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])

%% 

Datamat = rand(size(Datamat))*0.2 + 0.6;

%% see which simulations belong to this parameter set 
test = ( [varParList.phi_dist] == 0)& ...
            ( [varParList.theta_dist] == 0);
figure();plot(test)


%% 
bin_SSPOCon = ( [varParList.phi_dist] == 0) & ...
            ( [varParList.theta_dist] == 0) & ...
            ( [varParList.SSPOCon] == 1 ) & ...
            ( [varParList.xInclude] == 0) & ...%%%%% note error in assignment of yinlude~!!
            ( [varParList.yInclude] == 0) & ...%%%%% note error in assignment ofyinlude~!!
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
bin_SSPOCoff = ( [varParList.phi_dist] == 0)  & ...
            ( [varParList.theta_dist] == 0) & ...
            ( [varParList.SSPOCon] == 0 ) & ...
            ( [varParList.xInclude] == 0) & ...    %%%%% note error in assignment of yinlude~!!
            ( [varParList.yInclude] == 0) & ...%%%%% note error in assignment ofyxinlude~!!
            ( [varParList.NLDshift] == 0.5) & ...
            ( [varParList.NLDsharpness] == 10);
figure();plot(bin_SSPOCon,'-o')
hold on;plot(bin_SSPOCoff,'-o')

ind_SSPOCon = find(bin_SSPOCon);
ind_SSPOCoff = find(bin_SSPOCoff);

par.STAwidthList = [1:2:10];
par.STAshiftList = [-11:-2:-20];% 
% n_plots = 16; 
n_x = (length(par.STAwidthList) + 1);
n_y = (length(par.STAshiftList) +1); 
n_plots = n_x*n_y; 
col = {'-k','-r'};
dotcol = {'.k','.r'}; 
%% create subplot routine


mat_1 = reshape(1:n_x*n_y,[n_x,n_y])';
mat_2 = mat_1(2:end,2:end);
vec_3 = sort(mat_2(:));
vec_v = mat_1(2:end,1);

% color_vec = {'-r','-k'};
fig2=figure();
for j = 1:length(vec_3)
    subplot(n_y,n_x, vec_3(j))

    
%     Datamat( ind_SSPOCon(j),k,:)
   % plot sspoc off
        Dat_I = ind_SSPOCon( j);
        for k2 = 1:size(Datamat,2)
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
            if iters > 0
                meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
                stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
            else
                meanVec(k2) = 0;
                stdVec(k2) = 0;
            end
%             scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{1})
            hold on
        end
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1},0.8);
        
    % plot sspoc on 
        Dat_I = ind_SSPOCoff(j);
        for k2 = 1:size(Datamat,2)
            meanVec(k2) = mean(  nonzeros(Datamat(Dat_I,k2,:))   );
            stdVec(k2) = std(  nonzeros(Datamat(Dat_I,k2,:))   );
% 
            iters = length(nonzeros(Datamat(Dat_I,k2,:)) );
            scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{2})
            hold on
    
        end
        realNumbers = find(~isnan(meanVec));
        a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{1},0.8);
        axis([0,20,0.4,1])
        axis off
end

for j = 2:n_x
   subplot(n_y,n_x,j )
   par.STAwidth = par.STAwidthList(j-1);
   par.STAshift = par.STAshiftList(1);
%    a = par.STAshiftList(j-1)
%    par.STAshiftList(1)
   t_sta = -39:0;
      par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
            ./ (2*par.STAwidth ^2) ) ...
            ./ (sqrt(3*par.STAwidth) *pi^1/4)...
            .* ( 1-(t-par.STAshift).^2/par.STAwidth^2);
        par.STAfilt = par.STAFunc(t_sta);   
        
   plot(  t_sta,par.STAfilt)
   axis off
end
for j = 1:length(vec_v)
   subplot(n_y,n_x,vec_v(j) )
   par.STAwidth = par.STAwidthList(1);
   par.STAshift = par.STAshiftList(j);

   t_sta = -39:0;
      par.STAFunc = @(t)  2 * exp( -(t-par.STAshift) .^2 ...
            ./ (2*par.STAwidth ^2) ) ...
            ./ (sqrt(3*par.STAwidth) *pi^1/4)...
            .* ( 1-(t-par.STAshift).^2/par.STAwidth^2);
        par.STAfilt = par.STAFunc(t_sta);   
        
   plot(  t_sta,par.STAfilt)
   axis off
end


saveas(fig2,['figs' filesep 'Figure3_variableSTA'], 'png')

