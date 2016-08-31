function [GAMMA, induce_angle]=iterative(b, c, incidence, twist, Vinf, n, y, eta, alpha_CL, CL_CD)
% Input:
% b         = Wing span..................................(1x1 array)
% c         = chord distribution.........................(nx1 array)
% incidence = wind's angle of attack.....................(1x1 array)
% twist     = distibution of twist angle.................(nx1 array)
% Vinf      = wind speed.................................(1x1 array)
% n         = number of divisions along span.............(1x1 array)
% eta       = points along the wing span being evaluated.(nx1 array)
% alpha_CL  = airfoil alpha vs Cl curve..................(mx2 array, where m >= 2)
% Cl_CD     = airfoil Cl vs Cd curve.....................(mx2 array, where m >= 2)
%
% Output:
% gamma        = vortive intensity distribution.(nx1 array)
% induce_angle = induced angle distribution.....(nx1 array)
%% Initial solution
gamma0 = incidence*pi*c(floor(n/2))*Vinf;
gamma = sqrt(1-(2*eta/b).^2)*gamma0;

%% Calculation of \alpha_i
alpha_i = zeros(n,1);
convergence = 0;
criteria = 10^(-6);
itmax = 1000;
it = 1;
while (convergence == 0 && it < itmax); 
for i = 1:n
    aux = 0;
    for j = 2:n
        aux = aux + (gamma(j)-gamma(j-1))/(eta(i)-y(j));
    end
    aux = aux+gamma(1)/(eta(i)-y(1))-gamma(n)/(eta(i)-y(n+1));
    alpha_i(i) = -1/4/pi/Vinf*aux;
end
%plot(eta,alpha_i)
alpha_eff = incidence + twist + alpha_i;

cl = interp1(alpha_CL(:,1),alpha_CL(:,2),alpha_eff*180/pi);
cd = interp1(CL_CD(:,1),CL_CD(:,2),cl);

gamma_new = 0.5*Vinf*c.*cl;

% Test convergence
error = norm(gamma-gamma_new,2);
% disp(error)
if error < criteria
    convergence = 1;
end

gamma = gamma+0.05*(gamma_new-gamma);
it = it+1;
end
GAMMA = gamma;
induce_angle = -alpha_i;
