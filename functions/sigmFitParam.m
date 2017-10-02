function [q ] = sigmFitParam( x,y,varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%     varargin
%     varargin{2}
    
%     length(varargin)
%     varargin
    
    p = inputParser; 
    p.addRequired('x', @isfloat);
    p.addRequired('y', @isfloat);
    p.addOptional('plot_show',false, @islogical);
    p.parse(x,y, varargin{:});
    inputs = p.Results; 
% 
%     p 
%     p.plot_show
%     plot_on =0;
    x = [-5:0,x];
    y = [ones(1,6)*0.5,y];
    modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
    
%     modelfun = @(c,x)( c(1) + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    beta0 = [0.5;0.5;10;1];

    trheshold = 0.75;
    lastQ = 40;
%     try
        beta = nlinfit(x,y,modelfun,beta0,opts);
%         beta
        syms xs 
        xa = eval(solve(modelfun(beta,xs) == trheshold));

%         if isreal( modelfun(beta,xa)  ) == 1 && xa <=30 && xa> 0 ;
        if isreal( modelfun(beta,xa)  ) == 1 && xa <=lastQ && xa> 0 ;
            q = xa;
        elseif ~any(modelfun(beta,x) <=trheshold)
            q = x(1);
        else
            q = nan;
        end
        
        if inputs.plot_show == true
            hold on 
            plot(x,modelfun(beta,x),'k--','LineWidth',1)
            plot([0,lastQ],[trheshold,trheshold],':k','LineWidth',1)
            if ~isnan(q)
                plot([q,q],[0.4,1],':k','LineWidth',1)
            end
        end
%     catch
%        q = nan;
%     end

end

