
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

% old one 
% par.NLDshiftList = [-0.2:0.2:0.8];
% par.NLDsharpnessList = [5:2:15];

    % will be the new one
        par.NLDshiftList = [-0.1:0.2:0.9];
        par.NLDsharpnessList = [4:2:12];
        
        % just for now 
        par.NLDshiftList = [-0.1:0.2:0.9];
        par.NLDsharpnessList = [4:2:14];
n_x = (length(par.NLDshiftList) + 1);
n_y = (length(par.NLDsharpnessList) +1); 
n_plots = n_x*n_y; 

col = {ones(3,1)*0.5,'-r'};
dotcol = {'.k','.r'}; 
%% create subplot routine

mat_1 = reshape(1:n_x*n_y,[n_x,n_y])';
mat_2 = mat_1(2:end,2:end);
vec_3 = sort(mat_2(:));
vec_v = mat_1(2:end,1);

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
            scatter( ones(iters,1)*k2,nonzeros(Datamat(Dat_I,k2,:)) , dotcol{2})
            hold on
        end
        realNumbers = find(~isnan(meanVec));
        plot(realNumbers,meanVec(realNumbers),col{2})    
%         a = shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{2},0.8);
        ax = gca;
        ax.YTick = 0.4:0.2:1;
        axis([0,20,0.4,1])
end

for j = 2:n_x
   subplot(n_y,n_x,j )
   par.NLDshift = 0.5;
   par.NLDsharpness = par.NLDsharpnessList(j-1);
        par.NLD = @(s) 1./(  1 +...
            exp( -(s-par.NLDshift) * par.NLDsharpness)  );
        x = -1:0.02:1;
    if par.NLDsharpness == 8
        plot(  x,par.NLD(x),'k','LineWidth',2);hold on
    else
         plot(  x,par.NLD(x))
    end
            
            
               
   axis off
end


        x = -1:0.02:1;
        
for j = 1:length(vec_v)
   subplot(n_y,n_x,vec_v(j) )
   
   plot([0.5,0.5],[0,1],'Color',ones(1,3)*0.5,'LineWidth',[2])
   hold on 
   
   quiver( 0.5,0.5,par.NLDshiftList(j)-0.5,0,'m','LineWidth',3,'MaxHeadSize',1.5)

   plot([0,0]+ par.NLDshiftList(j),[0,1],'k','LineWidth',[2])
   
   
   
   
   par.NLDshift = par.NLDshiftList(j);
   for k = 1:length(par.NLDsharpnessList)
       par.NLDsharpness = par.NLDsharpnessList(k);
            par.NLD = @(s) 1./(  1 +...
                exp( -(s-par.NLDshift) * par.NLDsharpness)  );  
        if par.NLDsharpness == 8 && par.NLDshiftList(j) == 0.5
            plot(  x,par.NLD(x),'k','LineWidth',2);hold on
        else
             plot(  x,par.NLD(x),'Color',ones(1,3)*0.7,'LineWidth',0.5);hold on
        end
   end

    axis([-1,1,0,1])
   axis off
end

%% 

saveas(fig2,['figs' filesep 'Figure4_variableNLD'], 'png')

