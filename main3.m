%% Define mesh
num_nodes_hor = 15;
num_nodes_ver = 10;
m_sep = 6;

%% Create data
cd 'data'
coords(num_nodes_hor, num_nodes_ver, m_sep, 1, 1, 1, 1);
elem(num_nodes_hor, num_nodes_ver, m_sep);
cd ..

%% Initial values
els = importdata('data2/element_new.dat');
el_types = importdata('data2/element_type.dat');
coords = importdata('data2/coord_new.dat');

static_nodes = 1: num_nodes_hor;
elast_mod = [5e9, 0.33];
elast_mod2 = [3e9, 0.33];
elast_mod_border = [5e11, 5e11];
tau_cr = 5e7;

nvar = 2;
dim = 4;

[ne, ~] = size(els);

% Solution
iter_num = 4
figure('units','normalized','outerposition',[0 0 0.6 1])
for ind = 1: iter_num
    
% Stiffness matrix
GG = matrix(els, coords, elast_mod, elast_mod2, elast_mod_border, nvar, dim, el_types);

% Boundary solution
[nc, ~] = size(coords);
FG = zeros(nc * nvar, 1);

nm = zeros(1, length(static_nodes) * nvar);
for i = 1:(length(static_nodes))
    n = static_nodes(i);
    nm(2 * i - 1) = 2 * n - 1;
    nm(2 * i) = 2 * n;
end

for i = nm
    GG(:, i) = 0;
    GG(i, :) = 0;
    GG(i, i) = 1;
end

FG((length(coords) - num_nodes_hor + 1) * 2 ) = 0.5e9; %right

% Solve
S = GG \ FG;
% Form matrix of displacements T from vector S
T = zeros(nvar, nc);
for j = 1:nc
    for i = 1:nvar
        T(i, j) = S((j - 1) * nvar + i);
    end
end

kk = 1;
dsigma = zeros(num_nodes_hor - 1, nvar*(nvar+1)/2);
for el = (num_nodes_hor - 1) * (m_sep - 2) + 1: (num_nodes_hor - 1) * (m_sep - 1)
    e = els(el, :);
    C = [coords(e(1), :); coords(e(2), :); coords(e(3), :); ...
        coords(e(4), :)];
    D = matrix_D(elast_mod(1), elast_mod(2));
    B = matrix_B(0, 0, C);
    el_S = zeros(dim*nvar, 1);
    for i = 1: dim
        el_S(nvar*i-1) = S(e(i)*nvar-1);
        el_S(nvar*i) = S(e(i)*nvar);
    end
    a = 0.577350269;
    s1 = (D * matrix_B(-a, a, C) * el_S)';
    s2 = (D * matrix_B( a, a, C) * el_S)';
    dsigma(kk,:) = -(s1+s2)/2;
    kk = kk + 1;
end
kk = 1;
for el = (num_nodes_hor - 1) * m_sep + 1: (num_nodes_hor - 1) * (m_sep + 1)
    e = els(el, :);
    C = [coords(e(1), :); coords(e(2), :); coords(e(3), :); ...
        coords(e(4), :)];
    D = matrix_D(elast_mod(1), elast_mod(2));
    B = matrix_B(0, 0, C);
    el_S = zeros(dim*nvar, 1);
    for i = 1: dim
        el_S(nvar*i-1) = S(e(i)*nvar-1);
        el_S(nvar*i) = S(e(i)*nvar);
    end
    a = 0.577350269;
    s1 = (D * matrix_B(-a, -a, C) * el_S)';
    s2 = (D * matrix_B( a, -a, C) * el_S)';
    dsigma(kk,:) = dsigma(kk,:) + (s1+s2)/2;
    if dsigma(kk,2) > 0
        el_types(el - num_nodes_hor + 1) = 4;
    end
    kk = kk + 1;
end

% Only actual configuration
title(strcat('Iteration  ',int2str(ind)))
hold on
grid on
box on
xlabel('x')
ylabel('y')
xlim([-1 18]);
ylim([0 16]);

act_coords = zeros(nc, 2);
for i = 1: nc
    act_coords(i, 1) = coords(i, 1) + T(1, i);
    act_coords(i, 2) = coords(i, 2) + T(2, i);
end

for i = 1: ne
    x1 = act_coords(els(i,1), 1);
    x2 = act_coords(els(i,2), 1);
    x3 = act_coords(els(i,3), 1);
    x4 = act_coords(els(i,4), 1);
    y1 = act_coords(els(i,1), 2);
    y2 = act_coords(els(i,2), 2);
    y3 = act_coords(els(i,3), 2);
    y4 = act_coords(els(i,4), 2);
    
    if el_types(i) < 3
        plot([x1 x2], [y1 y2], 'k-', 'LineWidth', 2, 'Color', 'b');
        plot([x1 x4], [y1 y4], 'k-', 'LineWidth', 2, 'Color', 'b');
        plot([x3 x2], [y3 y2], 'k-', 'LineWidth', 2, 'Color', 'b');
        plot([x3 x4], [y3 y4], 'k-', 'LineWidth', 2, 'Color', 'b');
    end
    
    if el_types(i) == 1
        fill([x1 x2 x3 x4], [y1 y2 y3 y4], 'r')
    elseif el_types(i) == 2
        fill([x1 x2 x3 x4], [y1 y2 y3 y4], 'b')
    end
end

for i = 1: ne
    x1 = act_coords(els(i,1), 1);
    x2 = act_coords(els(i,2), 1);
    x3 = act_coords(els(i,3), 1);
    x4 = act_coords(els(i,4), 1);
    y1 = act_coords(els(i,1), 2);
    y2 = act_coords(els(i,2), 2);
    y3 = act_coords(els(i,3), 2);
    y4 = act_coords(els(i,4), 2);
    
    plot(x1, y1, 'o', 'MarkerEdgeColor', 'b',...
        'MarkerFaceColor', 'r', 'MarkerSize', 6);
    plot(x2, y2, 'o', 'MarkerEdgeColor', 'b',...
        'MarkerFaceColor', 'r', 'MarkerSize', 6);
    plot(x3, y3, 'o', 'MarkerEdgeColor', 'b',...
        'MarkerFaceColor', 'r', 'MarkerSize', 6);
    plot(x4, y4, 'o', 'MarkerEdgeColor', 'b',...
        'MarkerFaceColor', 'r', 'MarkerSize', 6);
end

pause(1)
if (ind < iter_num)
    clf
end
end