function [q ] = sigmFitParam( x,y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    x = [-5:0,x];
    y = [ones(1,6)*0.5,y];
    modelfun = @(c,x)( 0.5 + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
    
%     modelfun = @(c,x)( c(1) + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );
    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    beta0 = [0.5;0.5;10;1];

    try
        beta = nlinfit(x,y,modelfun,beta0,opts);
%         beta
        syms xs 
        xa = eval(solve(modelfun(beta,xs) == 0.7));

%         if isreal( modelfun(beta,xa)  ) == 1 && xa <=30 && xa> 0 ;
        if isreal( modelfun(beta,xa)  ) == 1 && xa <=40 && xa> 0 ;
            q = xa;
        elseif ~any(modelfun(beta,x) <=0.7)
            q = x(1);
        else
            q = nan;
        end

        hold on 
        plot(x,modelfun(beta,x),'k--','LineWidth',1)
        plot([0,50],[0.75,0.75],':k','LineWidth',1)
        if ~isnan(q)
            plot([q,q],[0.4,1],':k','LineWidth',1)
        end
    catch
       q = nan;
    end

end

