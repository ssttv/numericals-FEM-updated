function f = func_K(e, n, E, nu, C)

% Calculate value of the function under integral K = int(...)
%   e, n: coordinates of the point
%   C: matrix of element coordinates
%   E, nu: Young modulus and Poisson's ratio

D = matrix_D(E, nu);
B = matrix_B(e, n, C);
[~, ~, J] = Jac(e, n, C);
f = B' * D * B * abs(det(J));

% G = matrix_G(e, n);
% B = matrix_B(G);
% T = B' * D * B * abs(det(G * C));