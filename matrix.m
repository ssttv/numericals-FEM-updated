function K = matrix(els, coords, elast_mod, elast_mod2, elast_mod_border, nvar, dim, el_types)

[ne, ~] = size(els);
[nc, ~] = size(coords);

K = zeros(nc * nvar, nc * nvar);

for el = 1:ne
    e = els(el, :);
    C = [coords(e(1), :); coords(e(2), :); coords(e(3), :); ...
        coords(e(4), :)];
    
    if el_types(el) == 1
        Ke = elmatrix(C, elast_mod(1), elast_mod(2));
    elseif el_types(el) == 2
        Ke = elmatrix(C, elast_mod2(1), elast_mod2(2));
    elseif el_types(el) == 3 %shift
        Ke = elmatrix_border(0, elast_mod_border(2));
    elseif el_types(el) == 4 %break
        Ke = elmatrix_border(0, 0);
    else
        Ke = elmatrix_border(elast_mod_border(1), elast_mod_border(2));
    end
    %display(Ke, 'el');
    
    for i = 1:dim
        for j = 1:dim
            for ii = 1:nvar
                for jj = 1:nvar
                    i_g = (e(i) - 1) * nvar + ii;
                    j_g = (e(j) - 1) * nvar + jj;
                    i_e = (i - 1) * nvar + ii;
                    j_e = (j - 1) * nvar + jj;
                    K(i_g, j_g) = K(i_g, j_g) + Ke(i_e, j_e);
                end
            end
        end
    end
end