% generate R1 figure, just 

clc;clear all;close all;

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()
%% 

if 1
   load(['results' filesep 'analysis_FigR1toR4_yOnly_87Par.mat'])
end



AA = ( [varParList.theta_dist] == 0) & ...
   ( [varParList.phi_dist] == 0);


col = {'-k','-r'};

figure();
for j = 1:2
    for k = 1:size(Datamat,2)
    meanVec(k) = mean(  nonzeros(Datamat(j,k,:))   );
    stdVec(k) = std(  nonzeros(Datamat(j,k,:))   );
    end
%     plot(meanVec);
%     hold on
%     plot(stdVec)
    realNumbers = find(~isnan(meanVec))
    shadedErrorBar(realNumbers, meanVec(realNumbers),stdVec(realNumbers),col{j},0.8);
    hold on
    
end
axis([0,40,0,1])


% shadedErrorBar(