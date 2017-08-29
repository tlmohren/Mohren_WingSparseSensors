
% folder =  'D:\Mijn_documenten\Dropbox\Just For You\Base Unit Encoding Properties Results';
folder =  'D:\Mijn_documenten\Dropbox\Just For You\NonBase Unit Encoding Results';



nameMatches = dir([folder filesep 'STAs' filesep 'STA*']);
% load('D:\Mijn_documenten\Dropbox\Just For You\Base Unit Encoding Properties Results\STA and StdM30 N1')

% figure()
% nx = 4;
% ny = ceil(length(nameMatches)/nx);
% 
% for j = 1:length(nameMatches)
%     subplot(nx,ny,j)
%     STAstruct = load([folder filesep 'STAs' filesep nameMatches(j).name ]);
%     plot(STAstruct.STA)
%     axis
% end

%% 

x = -39:0.1:0;
STAdelay = 3.6;
% STAdelay = 10;
freq = 1;
width = 12;
eta = 20;
shift = 0.5;
s = - 1:0.01:1;
figure('Position',[100,100,1200,300]);
    % figure()
for j = 24
    subplot(121)
    hold on
    STAstruct = load([folder filesep nameMatches(j).name ])
    plot(linspace(-40,0,1600),STAstruct.STA)
    axis
    
    subplot(122)
    hold on
    NLDstruct = load([folder filesep 'NLDM4 N2.mat'])
    plot(NLDstruct.Bin_Centers_Store{:},NLDstruct.fire_rate{:}/max(NLDstruct.fire_rate{:}))
end


subplot(121)
    func = @(t) cos( freq*(t+STAdelay )  ).*exp(-(t+STAdelay ).^2 / width);
    plot(x,func(x)*1.2 )
subplot(122)
    funNLD = @(s) ( 1./ (1+ exp(-eta.*(s-shift)) ) - 0.5) + 0.5; 
    plot(s,funNLD(s))
    


legend('Experimental STA (Pratt, M4 N2)','Function form')
