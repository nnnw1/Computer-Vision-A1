function [Eext] = getExternalEnergy(I,Wline,Wedge,Wterm)

% Eline
Eline = double(I);

% Eedge
%[Gmag, Gdir] = imgradient(I);
[fx, fy] = gradient(I);
Gmag = sqrt(fx.^2 + fy.^2);
%Gmag = fx.^2 + fy.^2;
Eedge = -Gmag;

% Eterm
Cx_mask = [1 -1];
Cy_mask = [1; -1];
Cxy_mask = [1 -1; 1 -1];
Cxx_mask = [1 -2 1];
Cyy_mask = [1; -2; 1];

Cx = conv2(I, Cx_mask, 'same');
Cy = conv2(I, Cy_mask, 'same');
Cxy = conv2(I, Cxy_mask, 'same');
Cxx = conv2(I, Cxx_mask, 'same');
Cyy = conv2(I, Cyy_mask, 'same');

Cx2 = Cx.^2;
Cy2 = Cy.^2;

Eterm = (Cyy.*Cx2 - 2*Cxy.*Cx.*Cy + Cxx.*Cy2) ./ ((1 + Cx2 + Cy2).^1.5);

% Eext
Eext = Wline*Eline + Wedge*Eedge + Wterm*Eterm;

end

