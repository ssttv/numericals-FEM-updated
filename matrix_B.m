function B = matrix_B(e, n, C)

% Calculate matrix of gradients of basis functions
%   e, n: coordinates of the point
%   C: matrix of element coordinates

[dNe, dNn, J] = Jac(e, n, C);
dNen = [dNe; dNn];
dNxy = dNen;
for i = 1:4
    dNxy(:, i) = J \ dNen(:, i);
end
dNx = dNxy(1, :);
dNy = dNxy(2, :);

B(1, :) = [dNx(1), 0, dNx(2), 0, dNx(3), 0, dNx(4), 0];
B(2, :) = [0, dNy(1), 0, dNy(2), 0, dNy(3), 0, dNy(4)];
B(3, :) = [dNy(1), dNx(1), dNy(2), dNx(2), dNy(3), dNx(3), dNy(4), dNx(4)];