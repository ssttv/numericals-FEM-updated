function Ke = elmatrix(C, E, nu)

% Matrix of an element
%   C: matrix of element coordinates
%   E, nu: Young modulus and Poisson's ratio

f = @(e, n) func_K(e, n, E, nu, C);

% quadrature points
a = -0.577350269;
b = 0.577350269;

% calculate integral using quadrature formula
Ke = f(b, b) + f(a, b) + f(b, a) + f(a, a);