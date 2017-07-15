function [q ] = sigmFitParam( x,y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

modelfun = @(c,x)( c(1) + c(2) ./ (1+ exp( - (x-c(3))./c(4) )  ) );

opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';
% Fit the nonlinear model using the robust fitting options.

beta0 = [1;1;10;1];

try
    beta = nlinfit(x,y,modelfun,beta0,opts);
    % beta = nlinfit(x,y,modelfun,beta0);

    
    syms xs 
    xa = eval(solve(modelfun(beta,xs) == 0.75));
        % modelfun(beta,xa)
% real( modelfun(beta,xa)  ) 
    if isreal( modelfun(beta,xa)  ) == 1;
        q = xa;
    %     display('real !')
    else
        q = 30;
    %     display('imag!')
    end
    
    hold on 
    plot(x,modelfun(beta,x),'k--','LineWidth',1)
    plot([1,30],[0.75,0.75],':k','LineWidth',1)
    plot([q,q],[0.4,1],':k','LineWidth',1)
catch
   q = 30;
end

        
% figure();
%     plot(x,y,'k--','LineWidth',1)

%     legend('noisy sigmoid','recovered sigmoid','75% line','threshold met','Location','Best')

end

