function  barPlots(Xcls, midLine, n_bins, backCol, edgeCol, barOpts1, barOpts2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    expo = round( - log10(max(abs(Xcls))));
    xLims = [ round(min(Xcls),expo+1)-10^(-expo-1), ( round(max(Xcls),expo+1) +10^(-expo-1)) ];
    
    rangeBins = linspace(xLims(1), xLims(2), n_bins);
    xstep = (xLims(2)-xLims(1))/n_bins; 
    binMids = rangeBins(1:end-1)+10^(-expo-1)*0.5;
    midWay = length(Xcls)/2;
    [aCounts] = histcounts(Xcls(1:midWay), rangeBins);
    [bCounts] = histcounts(Xcls(midWay+1:end), rangeBins);
    yLims = [ max(aCounts),-max(bCounts)];
    ystep = (yLims(1)-yLims(2))/n_bins;
    
    
    xLimsBase = xLims +[-1,1]*xstep*1;
    yLimsMid = yLims +[1,-1]*ystep*2;
    
    xLimsPatch = xLims +[-xstep*2.5,xstep*4];
    yLimsPatch = yLims+[1,-1]*ystep*3;
    
    x = [xLimsPatch(1) xLimsPatch(2) xLimsPatch(2) xLimsPatch(1)];
    y = [yLimsPatch(2),yLimsPatch(2),yLimsPatch(1),yLimsPatch(1)];
    pc = patch(x,y,backCol,'EdgeColor',edgeCol);
        hold on
        
    bar1 = bar(binMids,aCounts);
    bar2 = bar(binMids,-bCounts,'r');
    % baseline and midline 
    plot(xLimsBase,[0,0],'k','LineWidth',0.5)
    plot([1,1]*midLine,yLimsMid,'k-','LineWidth',0.5)
  
    set(bar1,barOpts1{:})
    set(bar2,barOpts2{:})
    set( bar1.BaseLine,'Visible','off')
    
    axis([xLimsPatch(1),xLimsPatch(2),yLimsPatch(2),yLimsPatch(1)])
    axis off
    
    text( xLimsBase(2),0,'$w$','FontSize',7)
    
end

