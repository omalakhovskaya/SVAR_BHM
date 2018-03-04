a = sym('a','real');
b = sym('b','real');
c = sym('c','real');
d = sym('d','real');
e = sym('e','real');
f = sym('f','real');
rho = sym('rho','real');
phi = sym('phi','real');
tau = sym('tau','real');

A=[a b c; b d e; c e f]

%{
rho = -b/a; 
tau = (b*c-a*e)/(a*d-b^2);
phi = (-c-b*tau)/a;
%}

Gam = [1, 0, 0; rho 1 0; phi tau 1]
B= Gam*A*Gam'