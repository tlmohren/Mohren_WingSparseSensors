function [q ] = sigmFitParam( x,y,varargin )
%[q ] = sigmFitParam( x,y,varargin )
%   Detailed explanation goes here

    p = inputParser; 
    p.addRequired('x', @isfloat);
    p.addRequired('y', @isfloat);
    p.addOptional('plot_show',false);
    p.parse(x,y, varargin{:});
    inputs = p.Results; 

    
    threshold = 0.8;
        
        
    if isempty(x) || ~any(y>threshold)
        q = nan;
    else
        xadd = [-5:0,x];
        yadd = [ones(1,6)*0.5,y];
        
        modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
        opts = statset('nlinfit');
        opts.RobustWgtFun = 'bisquare';
        
        beta0 = [0.5;0.5;10;1];
        lastQ = 30;
        
%         beta = nlinfit(xadd,yadd,modelfun,beta0,opts);
        beta = nlinfit(x,y,modelfun,beta0,opts);
        
        syms xs 
        xa = eval(solve(modelfun(beta,xs) == threshold));

        if ~any(y<threshold)
            q =x(1);
            display('~any(y<threshold)')
        elseif isreal( modelfun(beta,xa)  ) == 1 && xa <=lastQ && xa> 0 ;
            q = xa;
%             display('q = xa')
%             modelfun(beta,q)
        elseif ~any(modelfun(beta,x) <=threshold)
            q = x(1);
%             display('q = x(1)')
        else
            q = nan;
        end
        if q<x(1)
            q = x(1);
            
        end
        
        if inputs.plot_show == true
            hold on 
            x_int = 0:0.1:30;
            plot(x_int,modelfun(beta,x_int),'k--','LineWidth',1)
            plot([0,lastQ],[threshold,threshold],':k','LineWidth',1)
            if ~isnan(q)
                plot([q,q],[0.4,1],':k','LineWidth',1)
            end
        elseif inputs.plot_show == 2
            hold on 
            x_int = 0:0.1:30;
            plot(x_int,modelfun(beta,x_int),'r','LineWidth',1)
            
        end
    end
end

