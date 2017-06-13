


clc;clear all;close all
addpathFolderStructure()
load(['data' filesep 'ParameterList_CVXtestscript'])
par.varParNames = fieldnames(varParList_short);



% CVX_case = 1;
CVX_case = 8;
% n_s  = length(dir('s_files'));

fileNames = dir('s_files');
n_s  = length(fileNames);
sMat = nan(30,26*51,20);
for j = 1:n_s
    try
        aa = load( ['s_files' filesep fileNames(j).name]);
%         fileNames(j).name 
        a1 = findstr(fileNames(j).name,'wt');
        a2 = findstr(fileNames(j).name,'_');
%         
        wt = str2num(fileNames(j).name(a1+2:a2(2)-1));
%         
%         
        b1 = findstr(fileNames(j).name,'CVX');
%         b2 = findstr(fileNames(j).name,'_');
        CVX_s = str2num(fileNames(j).name(b1+3));
        
%         sMat( j,:)  = aa.s;
        
        if CVX_s == CVX_case
            iter(wt) = sum(  isfinite(sMat(wt,1,:))  );
%             sMat(wt,:,iter)
            sMat(wt,:,iter(wt)+1) = aa.s;
            
        end
        
%         fileNames(j).name(5
    end

end

%         saveName = sprintf('s_wt%g_dT%g_dP%g_CVX%g', par.wTrunc,  par.theta_dist , par.phi_dist,par.CVXcase ); 
%         save(  ['s_files',filesep, saveName '_',datestr(datetime('now'), 30),'.mat']  ,'s')
%% 
figure('Position',[100,100,1400,900])
for j = 1:30
    subplot(6,5,j)
        hold on 
    wt_picture = j;
    
    try 
        iters = sum(  isfinite(sMat(wt_picture,1,:) ) );
        
        for k = 1:iters
%             threshold(k) = norm(sMat(wt_picture,:,k),2) / 8;
            threshold(k) = norm(sMat(wt_picture,:,k),2) / 12;
%             threshold(k) = norm(sMat(wt_picture,:,k),2) / (4*wt_picture)
            
            plot( ones(2,1)*threshold(k),[0,100],'--')
        end
            
        histogram( abs(sMat(wt_picture,:,:) ) ,100);
        
        title(['r-truncation ', num2str(j), ' iters = ',num2str(iters)])
        axis([0,max(max( abs(sMat(wt_picture,:,:))))*1.1,0,size(sMat,1)])
    end
end

