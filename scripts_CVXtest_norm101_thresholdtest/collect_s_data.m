


clc;clear all;close all
addpathFolderStructure()
load(['data' filesep 'ParameterList_CVXtestscript'])
par.varParNames = fieldnames(varParList_short);


% n_s  = length(dir('s_files'));

fileNames = dir('s_files');
n_s  = length(fileNames);
sMat = zeros(10,26*51);
for j = 1:n_s
    try
        aa = load( ['s_files' filesep fileNames(j).name]);
%         fileNames(j).name 
%         a1 = findstr(fileNames(j).name,'wt');
%         a2 = findstr(fileNames(j).name,'_');
%         
%         str2num(fileNames(j).name(a1+2:a2(2)-1))
%         
%         
%         b1 = findstr(fileNames(j).name,'CVX');
% %         b2 = findstr(fileNames(j).name,'_');
%         str2num(fileNames(j).name(b1+3))
        
        sMat( j,:)  = aa.s;
        
%         fileNames(j).name(5
    end

end

%         saveName = sprintf('s_wt%g_dT%g_dP%g_CVX%g', par.wTrunc,  par.theta_dist , par.phi_dist,par.CVXcase ); 
%         save(  ['s_files',filesep, saveName '_',datestr(datetime('now'), 30),'.mat']  ,'s')

figure();
histogram( abs(sMat(:)),100);axis([0,3,0,size(sMat,1)])