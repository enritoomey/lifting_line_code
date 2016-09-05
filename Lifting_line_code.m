%% Lifting-line method
% Enrique C. Toomey, 2013 - 2016
addpath(genpath(pwd))
close all; clear all; clc;

%% Inputs
Vinf = 1; % Free stream velocity [m/s]
Altitude = 0; %[m]
[temperatureISA,pressure,density,viscosity,sound] = atmosfera_estandar(Altitude);
delta_tempISA = 10;%[K]
temperature = temperatureISA+delta_tempISA;
k = 1.4; % gaz constant [N/(m*K)]
R = 287;
Re= 10^6; % Reynolds number (in case of working with standard roughness, Re='St')
b = 15; % Span [m]
Sw =10; % Wing Surface [m^2]
% incidence = 5*pi/180; % angle of attack

%% Discretization
% Two way of dicretizing the span: - (1)homogeneously
%                                  - (2)cosine distribution (for Glauert)
n = 10; % Number of partitions
case1 = 'cosine';%'homogeneourly'; %
solution = 'iterative';%'glauert';%
profile_name = 'NACA_63015';%'NACA_0012';
type_twist = 'lineal';%'hiperbolic';%'none';%
chord_law = 'tappered';%'eliptical';%
lambda = 1;
y = linspace(-b/2,b/2,n+1);
switch  case1
 case 'homogeneourly'
 case 'cosine'
     y = -cos((2*y/b+1)*pi/2)*b/2;
    otherwise
     disp('error = discretization option non existant')
end

eta = zeros(n,1);
for i = 1: n;
    eta(i) = (y(i+1)+y(i))/2;
end

%% Profile data

% Profile 1 -> Cl(alpha), Cd(alpha), Re
load(profile_name);
if Re<5*10^4
    alpha_CL = alpha_CL_Re3;
    CL_CD = CL_CD_Re3;
elseif Re<5*10^7;
    alpha_CL = alpha_CL_Re6;
    CL_CD = CL_CD_Re6;
elseif Re>5*10^7;
    alpha_CL = alpha_CL_Re9;
    CL_CD = CL_CD_Re9;
else
    alpha_CL = alpha_CL_SR;
    CL_CD = CL_CD_SR;
end
[aux2,~] = size(alpha_CL);
aux1 = polyfit(alpha_CL(3:aux2-8,1),alpha_CL(3:aux2-8,2),1);
a = aux1(1)*180/pi;
alpha0 = aux1(2)/a;

plot_airfoil_data(CL_CD_Re3(:,1),CL_CD_Re3(:,2),...
    CL_CD_Re6(:,1),CL_CD_Re6(:,2),...
    CL_CD_Re9(:,1),CL_CD_Re9(:,2),...
    CL_CD_SR(:,1),CL_CD_SR(:,2))
title('Curva de Cd vs. Cl')
xlabel('Cl')
ylabel('Cd')
plot_airfoil_data(alpha_CL_Re3(:,1),alpha_CL_Re3(:,2),...
    alpha_CL_Re6(:,1),alpha_CL_Re6(:,2),...
    alpha_CL_Re9(:,1),alpha_CL_Re9(:,2),...
    alpha_CL_SR(:,1),alpha_CL_SR(:,2))
title('Curva de alpha vs. Cl')
xlabel('alpha')
ylabel('Cl')

%% Twist
    twist075 = -3*pi/180; %[radian]
    switch type_twist
        case 'lineal'
            twist = abs(2*eta/b)*twist075*4/3;
        case 'hiperbolic'
            twist = twist075*(0.75./(2*eta/b));
            aux = round(0.33*n);
            twist(aux:(n-aux)) = twist(aux);
        case 'none'
            twist = zeros(n,1);
        otherwise
            disp('Error = Not a type of twist')
    end
    
%     plot(eta,twist)
%     title('twist');

%% Chord law
switch chord_law
    case 'eliptical'
        cr = 4*Sw/pi/b;
        c = cr*sqrt(1-(2*eta/b).^2);%[m]
    case 'tappered'
        cr = 2*Sw/b/(lambda+1);
        c = cr*abs(1-2*(1-lambda)/b*eta);%[m]
end


%% Solution
% The solution can be obtain with an iterative procedure ('iterative') o
% using Glauert's Method ('glauert')
incidence = (-10:1:25) * pi / 180;
L = zeros(size(incidence));
Di = zeros(size(incidence));
Cl3D = zeros(size(incidence));
Cdi = zeros(size(incidence));
gamma = zeros(n,1);
figure;
for i=1:length(incidence)
    switch solution
        case 'iterative'
            [gamma, induce_angle] = iterative(b, c, incidence(i), twist, Vinf, n, y, eta, alpha_CL, CL_CD);
        case 'glauert'
            [gamma, induce_angle] = glauert(b,a,c,incidence(i),twist,alpha0,Vinf,n,eta);
    end
    plot(eta,gamma,'-*r'); grid on; axis([-b/2,b/2,-0.5,0.8]);
    xlabel('Envergadura [m]'); ylabel('Circulación [m^3/s]'); title('Distribución de circulación')
    L(i) = trapz([-b/2;eta;b/2],[0;gamma;0])*density*Vinf; %[N]
    Di(i) = trapz([-b/2;eta;b/2],[0;gamma;0].*[incidence(i)-alpha0; induce_angle; incidence(i)-alpha0])*density*Vinf; %[N]
    Cl3D(i) = 2 * L(i) / ( density * Vinf^2 * Sw);
    Cdi(i) = 2 * Di(i) / ( density * Vinf^2 * Sw);
    disp('Angle of attack: ')
    disp(incidence(i)*180/pi)
    
    waitforbuttonpress;
end
figure;
plot(incidence*180/pi,Cl3D); grid on;
xlabel('incidencia [deg]'); ylabel('Cl [-]'); title('Cl 3D vs alpha')
figure;
plot(incidence*180/pi,Cdi); grid on;
xlabel('incidencia [deg]'); ylabel('Cd_i [-]'); title('Cd_i vs alpha')
    % Me falta calcular alpha_i en iterative y glauert
    %Di = trapz([-b/2;eta;b/2],[0;gamma.*alpha_i;0])*density*Vinf; %[N]