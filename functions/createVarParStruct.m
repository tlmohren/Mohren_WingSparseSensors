function [ varParChild, simulation_menu] = createVarParStruct( fixPar, sim_to_run)
% createVarParStruct creates a struct based on selected simulations from
% the menu, such as: {'R1','R2','R3','R4','S1','S2'};
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

% R1, also to be the standard values for other sims if not overwritten 
simulation_menu. R1_standard. wTruncList = 1:fixPar.rmodes;
simulation_menu. R1_standard. SSPOConList = [0,1];
simulation_menu. R1_standard. theta_distList = 0.1;
simulation_menu. R1_standard. phi_distList = 0.312;
simulation_menu. R1_standard. STAwidthList = [4];
simulation_menu. R1_standard. STAfreqList = 1;
simulation_menu. R1_standard. NLDshiftList = [0.5];
simulation_menu. R1_standard. NLDgradList = [10];
% R1 all sensors, filt 
simulation_menu. R1_all_filt = simulation_menu.R1_standard;
simulation_menu. R1_all_filt. SSPOConList = [0] ;
simulation_menu. R1_all_filt. wTruncList = [1326] ;
% R1 all sensors, no filter/encoding 
simulation_menu. R1_all_nofilt = simulation_menu.R1_standard;
simulation_menu. R1_all_nofilt. SSPOConList = [0] ;
simulation_menu. R1_all_nofilt. wTruncList = [1326] ;
simulation_menu. R1_all_nofilt. NLDgradList = -1; 
simulation_menu. R1_all_nofilt. STAfreqList = 1;
simulation_menu. R1_all_nofilt. STAwidthList = 0.01;
% R2
simulation_menu. R2_q = simulation_menu.R1_standard;
simulation_menu. R2_q. theta_distList = [0.001,0.01,0.1,1] * 10;
simulation_menu. R2_q. phi_distList =[0.001,0.01,0.1,1] * 31.2;
% R2 all sensors, filt
simulation_menu. R2_all_filt = simulation_menu.R1_standard;
simulation_menu. R2_all_filt. theta_distList = [0.001,0.01,0.1,1] * 10;
simulation_menu. R2_all_filt. phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
simulation_menu. R2_all_filt. wTruncList = 1326;
simulation_menu. R2_all_filt. SSPOConList = [0];
% R2 all sensors, no filt
simulation_menu. R2_all_nofilt = simulation_menu.R1_standard;
simulation_menu. R2_all_nofilt. theta_distList = [0.001,0.01,0.1,1] * 10;
simulation_menu. R2_all_nofilt. phi_distList =[0.001,0.01,0.1,1] * 31.2 ;
simulation_menu. R2_all_nofilt. wTruncList = 1326;
simulation_menu. R2_all_nofilt. SSPOConList = [0];
simulation_menu. R2_all_nofilt. NLDgradList = -1;
simulation_menu. R2_all_nofilt. STAfreqList = 1;
simulation_menu. R2_all_nofilt. STAwidthList = 0.01;
%R3 
simulation_menu. R3 = simulation_menu.R1_standard;
simulation_menu. R3. STAfreqList = linspace(0,2,11);        
simulation_menu. R3. STAwidthList = linspace(0,20,11);
simulation_menu. R3. STAwidthList(1) = 0.1;
%R4
simulation_menu. R4 = simulation_menu.R1_standard;
tempVec = linspace(-1 ,1,11);
simulation_menu. R4. NLDshiftList  = [tempVec(1:8), 0.5, tempVec(9:end)];
simulation_menu. R4. NLDgradList = spa_sf( linspace(1,5.4,11).^2 ,2 );
%S1
%S2 
simulation_menu. S3A_phiDist = simulation_menu.R1_standard;
simulation_menu. S3A_phiDist. phi_distList = spa_sf( 10.^[-2:0.1:2] ,2) * 3.12;

simulation_menu. S3B_thetaDist = simulation_menu.R1_standard;
simulation_menu. S3B_thetaDist. theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);


simulation_menu. S3C_phiDistnoSTA = simulation_menu.R1_standard;
simulation_menu. S3C_phiDistnoSTA. phi_distList = spa_sf( 10.^[-2:0.1:2] ,2) * 3.12;
simulation_menu. S3C_phiDistnoSTA. STAwidthList(1) = 0.1;

simulation_menu. S3D_thetaDistnoSTA = simulation_menu.R1_standard;
simulation_menu. S3D_thetaDistnoSTA. theta_distList = spa_sf( 10.^[-2:0.1:2] ,2);
simulation_menu. S3D_thetaDistnoSTA. STAwidthList(1) = 0.1;


simulation_menu. S4_vectorExtract = simulation_menu.R1_standard;
simulation_menu. S4_vectorExtract. theta_distList = 1;
simulation_menu. S4_vectorExtract. phi_distList = 31.2;

simultaion_menu. E1 = simulation_menu.R1_standard;
simulation_menu. E1. wTruncList = 10;
simulation_menu. E1. SSPOConList = [0,1];

%% Determine course selection from menu 
courses = fields(simulation_menu);
sim_run_boolean = zeros(size(courses) );

if ischar( sim_to_run )
   for k = 1:length(courses)
       if any( strfind( courses{k}, sim_to_run) );
            sim_run_boolean(k) = 1;
       end
   end
elseif  iscell( sim_to_run) 
    for j = 1:length(sim_to_run)
       for k = 1:length(courses)
           if any( strfind( courses{k}, sim_to_run{j}) );
                sim_run_boolean(k) = 1;
           end
       end
    end
else
    error('Incorrect sim_to_run input')
end

%% Created a structure with all parameter combinations 
varParChild = [];
childN = 0; 
I_sim_boolean = find( sim_run_boolean )';
for j = I_sim_boolean()
    % find what Lists to overwrite 
    changeLists = fields( simulation_menu.( courses{j}  ) ); 
    % determine how many simulations are already in varParChild
    childN = length( varParChild );
    % Load standard list 
    varParParent = simulation_menu. R1_standard; 
    standardLists = fields( simulation_menu. R1_standard);
    n = length(standardLists);
    % overwrite Lists that are not standard
    for k = 1:length(changeLists)
        varParParent.( changeLists{k}) = simulation_menu. (courses{j}). (changeLists{k});
    end
    % find dimensions of n-dimensional parameter hypercube
    dim_l = structfun(@length,varParParent)';
    total_l = prod(dim_l);
    % for every dimension in n, create hypercube of combinations 
    for k = 1:n
        oneBlock =  ones(dim_l);
        repVec = ones( n, 1 )';
        repVec(k) = length( varParParent.(standardLists{k}) );
        paramVec = varParParent.( standardLists{k});
        paramCube = bsxfun(@times, oneBlock,  reshape( paramVec, repVec)  );
        % for every parameter combination instance, set dimension k parameter 
        for k2 = 1:total_l
           varParChild( childN + k2).course = courses{j};
           varParChild( childN + k2).( standardLists{k}(1:end-4)) = paramCube(k2);
        end
    end
end
