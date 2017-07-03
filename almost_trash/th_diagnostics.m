function  th_diagnostics( th_d )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    t = 0:0.001:3.999;
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

