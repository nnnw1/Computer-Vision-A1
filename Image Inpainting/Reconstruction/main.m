clc;
clear;
close all;

imgin = im2double(imread('./large.jpg'));

[imh, imw, nb] = size(imgin);
assert(nb==1);
% the image is grayscale

V = zeros(imh, imw);
V(1:imh*imw) = 1:imh*imw;

% V(y,x) = (y-1)*imw + x
% use V(y,x) to represent the variable index of pixel (x,y)
% Always keep in mind that in matlab indexing starts with 1, not 0

%TODO: initialize counter, A (sparse matrix) and b.
counter = 1;
edgeX_c = 2*imh - 4;
edgeY_c = 2*imw - 4;
corner_c = 4;
pixel_c = imh*imw - (edgeX_c + edgeY_c + corner_c);
coe_c = 5*pixel_c + 3*edgeX_c + 3*edgeY_c + 4;

i = zeros(coe_c, 1);
j = zeros(coe_c, 1);
value = zeros(coe_c, 1);

b = zeros(imw*imh+4, 1);
counter_2 = 1;
edge_1 = 0;
edge_2 = 0;
Vt = V';

%TODO: fill the elements in A and b, for each pixel in the image

for y = 1 : imh
    for x = 1 : imw
        if(x==1 || x==imw)
            if(y~=1 && y~=imh)
                i(counter_2) = counter;
                j(counter_2) = V(y,x);
                value(counter_2) = 2;
                i(counter_2 + 1) = counter;
                j(counter_2 + 1) = V(y-1,x);
                value(counter_2 + 1) = -1;
                i(counter_2 + 2) = counter;
                j(counter_2 + 2) = V(y+1,x);
                value(counter_2 + 2) = -1;
                b(counter) = 2*imgin(y,x) - imgin(y-1,x) - imgin(y+1,x);
                
                counter_2  = counter_2 + 3;
            end
        elseif(y==1 || y==imh)
            if(x~=1 && x~=imw)
                i(counter_2) = counter;
                j(counter_2) = V(y,x);
                value(counter_2) = 2;
                i(counter_2 + 1) = counter;
                j(counter_2 + 1) = V(y,x-1);
                value(counter_2 + 1) = -1;
                i(counter_2 + 2) = counter;
                j(counter_2 + 2) = V(y,x+1);
                value(counter_2 + 2) = -1;
                b(counter) = 2*imgin(y,x) - imgin(y,x+1) - imgin(y,x-1);
                
                counter_2  = counter_2 + 3;
            end
        else
            i(counter_2) = counter;
            j(counter_2) = V(y,x);
            value(counter_2) = 4;
            i(counter_2 + 1) = counter;
            j(counter_2 + 1) = V(y,x+1);
            value(counter_2 + 1) = -1;
            i(counter_2 + 2) = counter;
            j(counter_2 + 2) = V(y,x-1);
            value(counter_2 + 2) = -1;
            i(counter_2 + 3) = counter;
            j(counter_2 + 3) = V(y+1,x);
            value(counter_2 + 3) = -1;
            i(counter_2 + 4) = counter;
            j(counter_2 + 4) = V(y-1,x);
            value(counter_2 + 4) = -1;
            b(counter) = 4*imgin(y,x) - imgin(y,x+1) - imgin(y,x-1) - imgin(y-1,x) - imgin(y+1,x);
            
            counter_2  = counter_2 + 5;
        end
        counter = counter + 1;
    end
end

%TODO: add extra constraints
i(counter_2) = counter;
j(counter_2) = 1;
value(counter_2) = 1;
b(counter) = imgin(1,1) + 0.35;
counter_2 = counter_2 + 1;
counter = counter + 1;

i(counter_2) = counter;
j(counter_2) = V(1,imw);
value(counter_2) = 1;
b(counter) = imgin(1,imw);
counter_2 = counter_2 + 1;
counter = counter + 1;

i(counter_2) = counter;
j(counter_2) = V(imh,1);
value(counter_2) = 1;
b(counter) = imgin(imh,1) + 0.35;
counter_2 = counter_2 + 1;
counter = counter + 1;

i(counter_2) = counter;
j(counter_2) = V(imh,imw);
value(counter_2) = 1;
b(counter) = imgin(imh,imw);

A = sparse(i,j,value);

%TODO: solve the equation
%use "lscov" or "\", please google the matlab documents
solution = A\b;
error = sum(abs(A*solution-b));
disp(error)
imgout = reshape(solution,[imh,imw]);

imwrite(imgout,'output.png');
figure(), hold off, imshow(imgout);

