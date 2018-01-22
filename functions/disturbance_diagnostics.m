function  disturbance_diagnostics( th_d )
%disturbance_diagnostics evaluates the band limited white noise disturbance
% and plots it 
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------
    t = 0:0.001:4;
    meanval = mean(eval(th_d))
    stdev = std(eval(th_d))
    
    figure();
    plot(t, eval(th_d))
    hold on;
    plot([t(1),t(end)],[1,1]*meanval)
    plot([t(1),t(end)],[1,1]*stdev)
    plot([t(1),t(end)],-[1,1]*stdev)
    drawnow

end

