function [strain] = eulerLagrange(frot, th,ph ,par )

% Function to solve ordinary differential equations for plate model of wing flapping with concurrent body rotation 
% Created by Annika Eberle % September 20, 2013
% Modified by Thomas Mohren, 2015-07-02
% Modified by Jared Callaham, 6/23/16
% Modified by Thomas Mohren, 2017-04-05

% Outputs: 
% x = x position
% y = y position 
% z = z position (equal to surface displacement, i.e. w(x,t,t)) 
% T = time; 
% flappingangle = input flapping; 
% rotation angle = input rotation; 
%
% Inputs: 
% flapamp = amplitude of flapping (in deg) 
% fflap = frequency of flapping (in Hz)
% frot = frequency of rotation (in rad/s)
% end_time = end time of simulation in seconds
% sampfreq = sampling frequency for output strains and displacements (in Hz)
% constant = toggle for type of angular velocity (if 1, then constant angular
%       velocity. If 0, load global angles from rotation_gen.m function)
% save_str = filename;


%% Parameterize model 
%Geometry and nodes
    nodes   = 4;
    a       = 1.25; %half chord in cm
    b       = 2.5; %half span in cm
    xpos    = [-a a a -a]; %x position of plate nodes
    ypos    = [0 0 2*b 2*b];%y position of plate nodes

%Material properties accrylic 
    E       = 3e9*10^-2;    %Young's modulus (converting from kg/m/s2 to kg/cm/s2) - currently for moth (500 GPa), but for acrylic:3e9*10^-2
    nu      = 0.35;         %Poisson's ratio for the plate - currently for moth. for acrylic: 0.35 
    G       = E / (2*(1+nu)); %Shear modulus for isotropic material
    h       = 1.27e-2;      %plate height in cm -- currently for moth, but for acrylic:1.27e-2
    density = 1180 * (1e-2)^3;%density of plate in kg/cm^3 (converting from m^3)
    
%Simulation parameters 
    dampingfactor = 63;    %multiplier for velocity-proportional damping via mass matrix 
    flapamp = 15; 

%% Kinematics of input angles for flapping and rotation 
%     syms x y t omega %create symbolic variables 
    syms x y t %create symbolic variables 
    
%Specify properties for sigmoidal startup
    sigprop = [1;10;3];
    sigd = sigprop(1);
    sigc = sigprop(2);
    sign = sigprop(3);
    sigmoid = (sigd.*(2*pi*par.flapFrequency*t).^sign) ./ (sigc+sigd.*(2*pi*par.flapFrequency*t).^sign);
%     sigmoid = 1;
% Generate flapping disturbance 
    freqs = rand(10,1)*10 +1;
    phase = rand(10,1)*2*pi;
    ph_d = 0;
    for j = 1:length(freqs)
        ph_d = ph_d + sin( 2*pi*t*freqs(j) + phase(j) );
    end
    ph_d = ph_d*ph/2;        % 2 is correction factor to achieve right std 
    phi_d = int(ph_d);
        
% Specify local flapping function
    phi = deg2rad(flapamp) ...
        .*(  sin(2*pi*par.flapFrequency*t) ...
        + par.harmonic*sin(2*pi*2*par.flapFrequency*t) ) .* sigmoid ...
        + phi_d;
    theta   = 0;
    gamma   = 0;

% Generate rotating disturbance 
    rot_vec = [0, 0, 1];
    freqs = rand(10,1)*9 +1;
    phase = rand(10,1)*2*pi;
    th_d = 0;
    for j = 1:length(freqs)
        th_d = th_d + sin(2*pi*t* freqs(j) + phase(j));
    end
    th_d = th_d*th/2;        % 2 is correction factor to achieve right std 
    thet_d = int(th_d);

% Specify global rotation function
    globalangle(1) = 0*t;
    globalangle(2) = 0*t;
    globalangle(3) = rot_vec(3)*frot*t.*sigmoid + thet_d;
   
%Velocity and acceleration of the body (i.e. center base of plate)
    v0  = [0 0 0];
    dv0 = [0 0 0];

%Shape functions and their spatial derivatives 
    N = shapefunc2(a,b,nodes,xpos,ypos); %generate shape functions 
    N = [N(3,:).';N(4,:).']; %put into matrix form 
    for i = 1:6
        dxi(:,i) = [diff(N(i),x,2);diff(N(i),y,2);2*diff(diff(N(i),x),y)]; %compute second spatial derivative 
    end

%% Generate function with equations for ODEs

% ensure no previous version of this ODE file exists 
if exist('functions/PlateODE.m') == 2
    display('PlateODE exists, deleting now ')
end
%     delete('functions/PlateODE.m')
clear('functions/PlateODE.m')
    
    
[M K Ma Ia Q] = createODEfile_rotvect(a,b,E,G,nu,h,density,dampingfactor,phi,theta,gamma,globalangle,N,dxi);

% pause(4) %make sure file saves before solving the ODE 
% this section is problematic
iter =1; 
while exist('functions/PlateODE.m', 'file') ~= 2 && iter<5
    pause(2)
    iter = iter+1; 
end 



%% Solve ODE 
%Specify initial conditions and damping matrix
    init = zeros(2*6,1);

%Solve ODE
    disp('solving ode')
    options = odeset('RelTol',1e-5);
    teval = 0: 1/par.sampFreq : (par.simEnd-1/par.sampFreq); 
    [~,Y] = ode45(@(t,y) PlateODE(t,y,v0,dv0,M,K,Ma,Ia,Q),teval,init,options);
% Delete PlateODE to ensure next simulation can create it's own 
    delete(['functions' filesep 'PlateODE.m'])
    
%% Postprocess results 



% locations are determined with deviation, based on gaussian 


%Specify spatial locations where the solution will be evaluated (26x51)
    disp('postprocessing')
    xeval = linspace(-a, a, par.chordElements);        % Previously -a:2*a/10:a
    yeval = linspace(0, 2*b, par.spanElements);
    [x,y]=meshgrid(xeval,yeval);
        
%Evaluate shape functions and their derivatives for strains, and spatial derivatives of strain
    for i = 1:6
        strainxi(i,:,:) = eval(dxi(1,i))'; %for normal strain along x axis
        strainyi(i,:,:) = eval(dxi(2,i))'; %for normal strain along y axis
    end
    
%Multiply by solution to ODE and sum over all components to solve for actual strains and displacements
    for j = 1:length(Y(:,1))
        %Multiply over all components
        for i = 1:6
            strainx1(i,:,:)= strainxi(i,:,:)*squeeze(Y(j,i));
            strainy1(i,:,:)= strainyi(i,:,:)*squeeze(Y(j,i));    
        end
        %Sum over all components
        strainx(j,:,:) = squeeze(sum(strainx1,1))*-h/2;
        strainy(j,:,:) = squeeze(sum(strainy1,1))*-h/2;       
    end
    if par.xInclude == 1 && par.yInclude == 0
        strain = [strainx(:,:)]';
    elseif par.xInclude == 0 && par.yInclude == 1
        strain = [strainy(:,:)]';
    elseif par.xInclude == 1 && par.yInclude == 1
        strain = [strainx(:,:), strainy(:,:)]';

    else
        error('Either par.xInclude or par.yInclude must be nonzero')
    end


