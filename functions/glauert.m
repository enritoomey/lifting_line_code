function [GAMMA, induce_angle] = glauert( b, a, c, incidence, twist, alpha0, Vinf, n, eta)
% Input:
% b         = Wing span..................................(1x1 array)
% a         = profile Cl vs alpha slope in 1/rad.........(1x1 array)
% c         = chord distribution.........................(nx1 array)
% incidence = wind's angle of attack.....................(1x1 array)
% twist     = distibution of twist angle.................(nx1 array)
% alpha0    = airfoil zero-lifting line angle............(1x1 array)
% Vinf      = wind speed.................................(1x1 array)
% n         = number of divisions along span.............(1x1 array)
% eta       = points along the wing span being evaluated.(nx1 array)
%
% Output:
% gamma        = vortive intensity distribution.(nx1 array)
% induce_angle = induced angle distribution.....(nx1 array)

A = zeros(n);
theta = acos( -eta / b * 2);%-pi/2;
for i = 1:n;
    for j = 1:n;
        A(i,j) = sin( j * theta(i) ) * ...
        (4 * b / (a * c(i)) * sin( theta(i) ) + j);
    end
end
B = ( (incidence - alpha0) * ones(n,1) + twist ) ...
     .* sin( theta );
x = A \ B;
aux = zeros(n,1);
induce_angle = zeros(n,1);

for i =1:n
    aux = aux + x(i) * sin( i * theta );
    induce_angle = induce_angle + i * x(i) * sin( i * theta ) ./ sin( theta );
GAMMA = 2 * b * Vinf * aux;
end
