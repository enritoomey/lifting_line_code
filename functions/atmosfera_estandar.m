function [ temperatura, presion, densidad, viscocidad, sonido ] = atmosfera_estandar( h )
%ATOMOSFERA_ESTANDAR Calcula los parametros de la atmosfera estandar
%   Se ingresa con la variable h (altura), que debe estar especificada en
%   metros.

% Parametros internos

b_suth = 1.458*10^-6; % Kg/(m*s*sqrt(Kelvin))
s_suth = 110.4; % Kelvin
g = 9.8; % m/s^2
R = 287; % J/(kg*Kelvin)
k = 1.4;
z =[0;
    11000;
    20100;
    32200;
    52400;
    61600;
    80000;
    95000]; % metros
t= [288;
    216.5;
    216.5;
    228.5;
    270.5;
    252.5;
    180.5;
    180.5]; %Kelvin
p = [101325;
    22628.3618858033;
    5386.81170754315;
    840.764461763294;
    52.6255554553125;
    15.8220215380573;
    0.845487850703855;
    0.0495146058575412]; %pascales

% Decisión
n = 2;
c = 0;
while c == 0
    if h <z(n);
        c = 1;
    elseif n == 8
        c = 1;
    else n = n+1;
    end
end

if t(n) == t(n-1)
    temperatura = t(n);
    presion = p(n-1)*exp(g*(h-z(n-1))/(R*temperatura));
    densidad = presion/temperatura/R;
else m = (t(n)-t(n-1))/(z(n)-z(n-1));
    temperatura = m *(h-z(n-1))+t(n-1);
    presion = p(n-1)*(temperatura/t(n-1))^-(g/m/R);
    densidad = presion/temperatura/R;
end

viscocidad = b_suth*sqrt(temperatura)/(1+s_suth/temperatura);
sonido = sqrt(k*R*temperatura);

end

