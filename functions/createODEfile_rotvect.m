function [M K Ma Ia Q] = createODEfile_rotvect(a,b,E,G,nu,h,density,dampingfactor,phi,theta,gamma,globalangle,N,dxi)
%% 
% Function generates a .m file called 'PlateODE.m' that contains the
% ordinary differential equations to be solved for a plate model of a wing
% flapping under concurrent rotation 
%
% Inputs: 
% nodes = number of nodes for the plate
% a = half chord (in cm)
% b = half span (in cm) 
% E = Young's modulus (in kg/cm/s2)
% G = shear modulus in (in kg/cm/s2)
% nu = Poisson's ratio
% h = plate thickness (in cm)
% density = plate density (in kg/cm^3)
% dampingfactor = multiplier for velocity-proportional damping factor on mass matrix 
% phi = flapping angle about x axis as function of time (in rad) 
% theta = flapping angle about y axis as function of time (in rad)
% gamma = flapping angle about z axis as function of time (in rad)
% gamma_global = global body rotation about z axis (in rad) 
% N = matrix of shape functions 
% dxi = matrix of shape function derivatives 
% s
% Outputs: 
% M = mass matrix
% K = stiffness matrix 
% Ma = angular vel mass matrix
% Ia = angular vel inertia matrix 
% Q = damping matrix 
% 
% Eberle et al (2015)
%------------------------------

%% Specify Parameters

% Create symbolic variables to solve for equations
syms x y t

% Matrix of material properties
D = [E E*nu 0;
    E*nu E 0;
    0 0 G];

 %% Generate angular velocities required to achieve the angles specified above
% %Compute derivatives of angular displacements
% dphi = diff(phi,t);         % difference in flapping angle 
% dtheta = diff(theta,t);     % elevation angle
% dgamma = diff(gamma,t);         
% 
% %Compute inverse rotation matrix to evaluate angular velocity - first rotation phi, then theta, then gamma
% inverserot = [cos(theta)*cos(gamma) -sin(gamma) 0;
%     cos(theta)*sin(gamma) cos(gamma) 0;
%     sin(theta) 0 1]
% 
% % Evaluate angular velocity and acceleration - comprised of local rotations (i.e. derivatives of phi, theta, gamma) plus derivative of global rotation
% w = inverserot*[dphi;dtheta;dgamma]+[diff(globalangle(1),t);diff(globalangle(2),t);diff(globalangle(3),t)]; %angular velocity
% 
% % local_v = [dphi;dtheta;dgamma]
% display(w)
% dw = diff(w,t); %angular acceleration
% display(dw)
% 
% 


%% FOR SINGLE AXIS : Generate angular velocities required to achieve the angles specified above
%Compute derivatives of angular displacements
dphi = diff(phi,t);         % difference in flapping angle 

% Evaluate angular velocity and acceleration - comprised of local rotations (i.e. derivatives of phi, theta, gamma) plus derivative of global rotation
w = [dphi;0;0]+[diff(globalangle(1),t);diff(globalangle(2),t);diff(globalangle(3),t)]; %angular velocity
dw = diff(w,t); %angular acceleration

% display(w)
% display(dw)

Q0 = w(2);
P0 = w(1);




%% Generate mass and stiffness matrices
for i = 1:6
    for j = 1:6
        M(i,j) = int(int(h*density*N(i)*N(j),x,-a,a),y,0,2*b); %mass matrix
        K(i,j) = int(int(h^3/12*dxi(:,i).'*D*dxi(:,j),x,-a,a),y,0,2*b); %stiffness matrix
    end
end

%% Generate additional mass and inertia matrices for rotation components
for i = 1:6
    Ma(i,:) = [0, 0, int(int(density*h*N(i),x,-a,a),y,0,2*b), int(int(density*h*N(i)*y,x,-a,a),y,0,2*b), -int(int(density*h*N(i)*x,x,-a,a),y,0,2*b), 0]; %additional mass
    Ia(i,:) = [int(int(density*h*N(i),x,-a,a),y,0,2*b),int(int(density*h*N(i)*x,x,-a,a),y,0,2*b),int(int(density*h*N(i)*y,x,-a,a),y,0,2*b)]; %additional inertia
end

%% Evaluate matrices before creating ODE function to reduce solve time (material properties and mass do not change over time)
M = eval(M);
K = eval(K);
Ma = eval(Ma);
Ia = eval(Ia);
Q = dampingfactor*M; %damping matrix as determined via experiment with moth wings
% - Ma*[0;0;0; 2*w(3)*sin(w(1));0;0] + Ma*[0;0;0; 2*w(3)*sin(w(1));0;0]% no
% effect found?, very strange right? 
%% Create function for ODE
disp('creating ode and substituing variables')
fid = fopen('functions/PlateODE.m','w');
fprintf(fid,'function dy = PlateODE(t,y,v0,dv0,M,K,Ma,Ia,Q,cycles,frot)');
fprintf(fid,'\n w =');
fprintf(fid,strrep(char(w),'matrix',''));
fprintf(fid,';\n dw=');
fprintf(fid,strrep(char(dw),'matrix',''));
fprintf(fid,';\n Q0 = w(2); \n P0 = w(1); \n Ca = funcCa(v0,w); \n dy(1:6,1) = y(7:end); \n dy(7:12,1) = mldivide(M,(-Q*dy(1:6) - K*y(1:6)+Ia*Ca*transpose(w)+(Q0^2+P0^2)*M*y(1:6)-Ma*[transpose(dv0);transpose(dw)]   )); \n t;');
%fprintf(fid,'\n 1\n Ia*Ca*transpose(w) \n w \n Ca\n Ia \n 2 \n  Ma*[0;0;0;0;w(3)*(w(1));0] \n w ');
fclose(fid);

pause(5)