function [GAMMA]=glauert(b,a,c,incidence,twist,alpha0,Vinf,n,eta)
A = zeros(n);
theta = acos(-eta/b*2);%-pi/2;
for i=1:n;
    for j=1:n;
        A(i,j) = sin( j * theta(i) ) * ...
        (4 * b / (a * c(i)) * sin( theta(i) ) + j);
    end
end
B = ( (incidence - alpha0) * ones(n,1) + twist ) ...
     .* sin( theta );
x = A\B;
aux = zeros(n,1);
for i =1:n
    aux=aux+x(i)*sin(i*theta);
GAMMA = 2*b*Vinf*aux;
end
