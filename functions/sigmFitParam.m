function [q ] = sigmFitParam( x,y,varargin )
% sigmFitParam fits sigmoid to data and determines when it crosses the
% threshold line of 0.8
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

p = inputParser; 
p.addRequired('x', @isfloat);
p.addRequired('y', @isfloat);
p.addOptional('plot_show',false);
p.parse(x,y, varargin{:});
inputs = p.Results; 
threshold = 0.75;


modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );

if isempty(x) 
    q = nan;
    bet = [0,0,0,0];
    lastQ = 30;
else
    xadd = [0,x];
    yadd = [0.5,y];
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    beta0 = [0.5;0.5;10;1];
    lastQ = 30;
    bet = nlinfit(xadd,yadd,modelfun,beta0,opts);
    syms xs 
    xa = eval(solve(modelfun(bet,xs) == threshold));

    if ~any(y>threshold) 
        q = nan;
    elseif ~any(y<threshold)
        q =x(1);
        display('~any(y<threshold)')
    elseif isreal( modelfun(bet,xa)  ) == 1 && xa <=lastQ && xa> 0 ;
        q = xa;
    elseif ~any(modelfun(bet,x) <=threshold)
        q = x(1);
    else
        q = nan;
    end
    if q<x(1)
        q = x(1);

    end

end

if inputs.plot_show == true
    hold on 
    x_int = 0:0.1:30;
%     plot(x_int,modelfun(bet,x_int),'k--','LineWidth',1)
    plot(x_int,modelfun(bet,x_int),'r','LineWidth',1)
    plot([0,lastQ],[threshold,threshold],':k','LineWidth',1)
    if ~isnan(q)
        plot([q,q],[0.4,1],':k','LineWidth',1)
    end
elseif inputs.plot_show == 2
    hold on 
    x_int = 0:0.1:30;
    plot(x_int,modelfun(bet,x_int),'r','LineWidth',1)
end


