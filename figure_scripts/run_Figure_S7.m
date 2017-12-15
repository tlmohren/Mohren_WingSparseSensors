%------------------------------
% run_paperAnalysis
% Runs simulations and analysis for the paper:
% Sparse wing sensors for optimal classification using neural filters(...)
% Mohren T.L., Daniel T.L., Brunton B.W.
% Submitted to (...)
%   Last updated: 2017/07/03  (TLM)

%------------------------------
clear all, close all, clc

scriptLocation = fileparts(fileparts(mfilename('fullpath') ));
addpath([scriptLocation filesep 'scripts']);
addpathFolderStructure()

parameterSetName    = ' ';
iter                = 1;
figuresToRun        = {'subSetTest'};
width = 6;
height = 6;

% Build struct that specifies all parameter combinations to run 
[fixPar,~ ,varParStruct ] = createParListTotal( parameterSetName,figuresToRun,iter );
varParStruct = varParStruct(45);
varPar = varParStruct(1);

strainSet = load(['eulerLagrangeData', filesep 'strainSet_th0.1ph0.312it2harm0.2.mat']);
%% Test neural encoding effert

fixPar.STAdelay = 5;

G = [];
fn = {'strain_0','strain_10'};

[STAFunc,NLDFunc ] = createNeuralFilt(fixPar,varPar);

if fixPar.subSamp == 1
    STAt = -39:0;   
else
    STAt = linspace(-39,0,40*fixPar.subSamp);
end
STAfilt = STAFunc( STAt) ; 

% Remove startup phase from strain, but leave a piece the lenght of the
convMat = [];
n_conv = ( fixPar.simStartup  *fixPar.sampFreq*fixPar.subSamp +2 -length(STAt) )...
        : fixPar.simEnd*fixPar.sampFreq*fixPar.subSamp;
n_out = (fixPar.simEnd-fixPar.simStartup) * fixPar.sampFreq*fixPar.subSamp;
t = (1:size(strainSet.(fn{1}),2))/fixPar.sampFreq;
tNew = linspace(t(1),t(end),size(strainSet.(fn{1}),2)*fixPar.subSamp);
%     end
m = size(strainSet.(fn{1}),1);

% Part1) For each individual sensor, convolve strain with match filter over time.
for j = 1:numel(fn)
%         [m,~] = size( strainSet.(fn{j}) );
    strainConv = zeros(m,n_out);
    for jj = 1:m
        if fixPar.subSamp == 1
            strainConv(jj,:) = conv(  strainSet.(fn{j})(jj,n_conv)  , (STAfilt),'valid');
        else
            strainSub = interp1(t,strainSet.(fn{j})(jj,:),tNew,'spline');
            strainConv(jj,:) = conv(  strainSub(n_conv)  , STAfilt,'valid');
        end
    end
    convMat = [convMat , strainConv];
    Gtemp = ones(1, n_out); % For each iteration, a class of magnitude j is added to G
    G = [G Gtemp*j];
end

X = NLDFunc( convMat/fixPar.normalizeVal/fixPar.subSamp );


if fixPar.determineNorm == 1
    X.tempNorm = max(convMat(:));
end



%% 
fig_S7 = figure();
% subplot(5,3,4:15)
set(fig_S7, 'Position', [100 100 width*100, height*100]); %<- Set size



inoffensiveBlue =[247,252,240
224,243,219
204,235,197
168,221,181
123,204,196
78,179,211
43,140,190
8,104,172
8,64,129];
strainScheme = colorSchemeInterp(inoffensiveBlue/255, 500);

fireRed = [255,247,236
254,232,200
253,212,158
253,187,132
252,141,89
239,101,72
215,48,31
179,0,0
127,0,0];

fireScheme = colorSchemeInterp(fireRed/255, 500);

t_show = 2196;
sensor = 455;
[Is,Js] = ind2sub([26,51],sensor);

I_strain = 2000:t_show;
t = (1:length(I_strain) );

STAopts = {'XLim',[-50,0],...
    'XTick',-40:40:0,...
    };
strainOpts = {'XLim',[0,250],...
    'XTick',0:50:250,...
    'box','off',...
    };
NLDopts = {'XTick',-1:1:1,...
    };

pX = 4;
pY = 6; 
subMat = reshape( 1:pX*pY,pX,pY)';

sb1 = subplot(pY,pX, reshape( subMat(1,2:3),1,[] ) );
    dim_wing = [26,51,4000];
    sensorSpec = [10,10];
    strain10 = reshape( strainSet.strain_10,dim_wing);
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    pcOpts = {'FaceColor','flat'};
    colormap(sb1, flipud(strainScheme) )
    pc1 = pcolor(strain10(:,:,t_show));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off

    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',1)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',0.5)
    h = colorbar;
    barOpts = {'Limits',[-6,0]*1e-4,...
        'Ticks',[-6:3:0]*1e-4,...
        };
    set(h,barOpts{:})   
    ylabel(h, 'Strain','Interpreter','Latex','Rotation',0)
    scatter(Js,Is,'ok','filled')
    

subplot(pY,pX, reshape( subMat(2,:),1,[] ) )
    text(0,0,'Strain ')
    % strainSet.strain_10
    plot(t, strainSet.strain_10( sensor, I_strain)  ,'k')
    strainAx = gca();
    set(strainAx, strainOpts{:})
    hold on
    scatter( t(end), strainSet.strain_10( sensor, I_strain(end) ) ,'ok','filled') 
    xlabel('Time (ms)'); ylabel('Strain ($\Delta L / L$','Rotation',0)

subplot(pY,pX, reshape( subMat(3,3),1,[] ) )
    text(0,0,'STA')
    t_STA = -40:0.01:0;
    STA = STAFunc(t_STA);
    plot(t_STA, STA ,'k')
    axSTA = gca();
    set(axSTA, STAopts{:})
    xlabel('Time (ms)');     ylabel('Strain ($\Delta L/L$)')

    text(-20,0.5,'STA (t)')
    
subplot(pY,pX, reshape( subMat(4,3),1,[] ) )

    similarity = convMat/fixPar.normalizeVal/fixPar.subSamp;
    similarity_inst = similarity(sensor,3e3+t_show-1e3);
    text(0,0,'NLD')
    s = -1:0.01:1;
    NLD = NLDFunc(s);
    plot(s, NLD ,'k')
    hold on
    scatter( similarity_inst,0,'ok','filled')
    NLDval = NLDFunc(similarity_inst);
    plot( [-1,similarity_inst],[1,1]*NLDval,'k:')
    plot( [1,1]*similarity_inst,[0,1]*NLDval,'k:')
    scatter(-1,NLDval,'ok','filled')
    xlabel('$\xi$'); ylabel('Prob. fire')
    
    axNLD = gca();
    set( axNLD, NLDopts{:})
    text( -1, NLDval ,num2str( round(NLDval,2) ) )

    text(0,0.5,'NLD ($\xi$)')
    
subplot(pY,pX, reshape( subMat(5,:),1,[] ) )
    plot(t, X( sensor, 3e3+ I_strain-1e3)  ,'k')
    strainAx = gca();
    set(strainAx, strainOpts{:})
    text( 1 ,NLDval ,num2str( round(NLDval,2) ) )
    hold on
    plot( [t(1),t(end)], [1,1]*NLDval,'k:')
    scatter( t(end), NLDval,'ko','filled')
    xlabel('Time (ms)'); ylabel('Prob. fire','Rotation',0) 

sb = subplot(pY,pX, reshape( subMat(6,2:3),1,[] ) );
    colormap(sb,fireScheme)
    dim_wing = [26,51,6000];
    sensorSpec = [10,10];
    pfire10 = reshape( X,dim_wing);
    axOpts = {'DataAspectRatio',[1,1,1],'PlotBoxAspectRatio',[3,4,4]};
    pcOpts = {'FaceColor','flat'};
    colormap(strainScheme)
    pc1 = pcolor( pfire10(:,:,t_show-1e3));
    ax1 = gca();
    set(ax1,axOpts{:})
    set(pc1,pcOpts{:})
    axis off

    hold on
    scatter(1,13,100,'.k')
    plot([1,1]*1,[0,26],'k','LineWidth',1)
    plot([1,51,51,1],[1,1,26,26],'k','LineWidth',0.5)
    h = colorbar;
    barOpts = {'Limits',[0,1],...
%         'Ticks',[-6:3:0]*1e-4,...
        };
    set(h,barOpts{:})
    ylabel(h, 'Prob. Fire','Interpreter','Latex','Rotation',0)
    scatter(Js,Is,'ok','filled')
   
    
    
    

%% Setting paper size for saving 
set(gca, 'LooseInset', get(gca(), 'TightInset')); % remove whitespace around figure
tightfig;

set(fig_S7,'InvertHardcopy','on');
set(fig_S7,'PaperUnits', 'inches');
papersize = get(fig_S7, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(fig_S7, 'PaperPosition', myfiguresize);

% Saving figure 
print(fig_S7, ['figs' filesep 'Figure_S7' ], '-dpng', '-r600');

% total hack, why does saving to svg scale image up???
stupid_ratio = 15/16;
myfiguresize = [left, bottom, width*stupid_ratio, height*stupid_ratio];
set(fig_S7, 'PaperPosition', myfiguresize);

print(fig_S7, ['figs' filesep 'Figure_S7' ], '-dsvg');


