function errorCheckPar( par)
%errorCheckPar check validity of provided parameter values
%   check bounds etc 

% Check bounds of par.theta_dist
    if par.theta_dist < 0 
        error('par.theta_dist cannot be negative')
    elseif any((par.theta_dist ~= 0) & (par.theta_dist < 1e-4) | (par.theta_dist > 1e2) )
        error('par.theta_dist must be 0 or within 0.0001 and 10')
    end
    
% Check bounds of par.phi_dist
    if par.phi_dist  < 0 
        error('par.theta_dist cannot be negative')
    elseif any((par.phi_dist  ~= 0) & (par.phi_dist  < 1e-4) | (par.phi_dist  > 1e2) )
        error('par.theta_dist must be 0 or within 0.0001 and 10')
    end

    
    
    
end

