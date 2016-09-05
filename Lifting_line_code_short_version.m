%% flight conditions
Vinf = 150; % Free stream velocity [m/s]
incidence = 5 * pi / 180;% [rad]

%% wing data
b = 15; % Span [m]
Sw =10; % Wing Surface [m^2]
twist075 = -1*pi/180; %[radian]
lambda = 0.7;
cr = 2*Sw/b/(lambda+1); %[]

%% Airfoil data
% En el caso de glauert, el perfil esta definido por solo dos parametros:
% la pendiente bidimensional y el ángulo de sustentación nula. La parte no
% lineal de la curva de sustentación no se tiene en cuenta. En este
% ejemplo, se emplea un mismo perfil para toda la envergadura, pero bien
% podria variar, al igual que la cuerda y el alabeo geometrico.
a = 5.7; %
alpha0 = 1.5 * pi / 180; %

%% Wing span discretization
%Discretizamos el ala usando una ley cosenoidal para y, lo que
%significa una distribución constante para theta [y = cos(theta)]
n = 10; % Number of partitions
y = linspace(-b/2,b/2,n)';
eta = -cos((2*y/b+1)*pi/2)*b/2;
eta(1) = 0.75*eta(1)+0.25*eta(2);
eta(end) = 0.75*eta(end)+0.25*eta(end-1);
% eta = zeros(n,1);
% for i = 1: n;
%     eta(i) = (y(i+1)+y(i))/2;
% end
% usamos el angulo de alabeo geometrico al 75% de la envergadura para
% definir el alabeo geometrico lineal.
twist = abs(2*eta/b)*twist075*4/3;
figure;
plot(eta,twist*180/pi);grid on;
xlabel('Envergadura [m]'); ylabel('Twist [^o]'); title('Alabeo Geometrico')
% función analitica para la distribución de cuerda de un ala trapezoidal
% de ahusamiento lambda.
c = cr*(1-(1-lambda)*2*abs(eta)/b);%[m]
figure;
plot(eta,c); grid on;
xlabel('Envergadura [m]'); ylabel('Cuerda [m]'); title('Distrubución de cuerda')


%% Solution
% Llamamos a la función glauert (definida en galuert.m) para armar el
% sistema de ecuaciones y resolverlo. glauert.m tiene que estar en el mismo
% directorio que este archivo, o dentro del path de matlab.
[gamma, induce_angle] = glauert(b, a, c, incidence,...
    twist, alpha0, Vinf, n, eta);
figure;
plot([-b/2;eta;b/2],[0;gamma;0],'-*r'); grid on;
xlabel('Envergadura [m]'); ylabel('Circulación [m^3/s]'); title('Distribución de circulación')

% Integramos numericamente distribución de sustentación (L = rho*V*Gamma),
% empleando el método de los trapecios. Lo mismo para la resistencia
% inducida (dDi = dL * alpha_i)
L = trapz([-b/2;eta;b/2],[0;gamma;0])*density*Vinf; %[N]
Di = trapz([-b/2;eta;b/2],[0;gamma;0].*[incidence-alpha0; induce_angle; incidence-alpha0])*density*Vinf; %[N]
Cl3D = 2 * L / ( density * Vinf^2 * Sw);
Cdi = 2 * Di / ( density * Vinf^2 * Sw);

% Se puede comparar estos resultados con los obtenidos directamente de los
% coeficientes de la distribución de vorticidad (An), usando las formulas
% propuestas en el apunte.
