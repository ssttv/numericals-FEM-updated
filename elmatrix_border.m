function Ke = elmatrix_border(cs, cn)

Shift = [cs; cn; cs; cn];

L = [2, 0, 1, 0;
     0, 2, 0, 1;
     1, 0, 2, 0;
     0, 1, 0, 2] .* Shift;
R = [-1,  0, -2,  0;
      0, -1,  0, -2;
     -2,  0, -1,  0;
      0, -2,  0, -1] .* Shift;

Ke = zeros(8);

Ke(1:4, 1:4) = L;
Ke(5:8, 1:4) = R;
Ke(1:4, 5:8) = R;
Ke(5:8, 5:8) = L;