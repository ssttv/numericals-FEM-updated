function [dNe, dNn, J] = Jac(e, n, C)

% Calculate Jacobi matrix and derivatives of basis functions
%   e, n: coordinates of the point
%   C: matrix of element coordinates

E = [-1 1 1 -1];
N = [-1 -1 1 1];

% dNe, dNn - derivatives of basis functions
% N_i = 0.25 * (1 + E(i)*e) * (1 + N(i)*n)
dNe = E;
dNn = N;
for i = 1:length(E)
    dNe(i) = 0.25 * E(i) * (1 + N(i) * n);
    dNn(i) = 0.25 * N(i) * (1 + E(i) * e);
end

% Jacobian
x_e = dNe * C(:, 1);
x_n = dNn * C(:, 1);
y_e = dNe * C(:, 2);
y_n = dNn * C(:, 2);

J = [x_e y_e; x_n y_n];