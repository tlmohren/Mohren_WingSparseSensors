clc;clear all;close all

addpathFolderStructure()
par.CVXcase = 8;
load(['test_code' filesep 'Psiwsave'])

[n, r] = size(Psi); 
c = size(w, 2);



% par.CVXcase = 1;
% [s1] = SSPOC_CVXtest(Psi, w,par);
% par.CVXcase = 6;
% [s6] = SSPOC_CVXtest(Psi, w,par);
% par.CVXcase = 8;
% [s8] = SSPOC_CVXtest(Psi, w,par );
% par.CVXcase = 9;
% [s9] = SSPOC_CVXtest(Psi, w,par );
par.CVXcase = 10;
par.CVXiter = 10;
[s10] = SSPOC_CVXtest(Psi, w,par );


%     figure();
% %     plot(s, '-o'); 
% %     hold on; plot(s1, '-o')
% %     hold on; plot(s6, '-o')
% %     hold on; plot(s8, '-o')
% %     hold on; plot(s9, '-o')
    hold on; plot(s10, '-o')
% %     
% % size(s((abs(s)>0.001)))
% % size(s((abs(s1)>0.001)))
% % size(s((abs(s6)>0.001)))
% % size(s((abs(s8)>0.001)))
% % size(s((abs(s9)>0.001)))
size(s10((abs(s10)>0.001)))

sensors = find((abs(s10)>0.001))'

%     figure();
%     plot(s); 
%     
    
    
    
% v = randn(100,1);
% 
% figure();plot(v)
% 
% gamma = mean(abs(v))
% 
% v(v<gamma) = 0;
% figure();plot(v)