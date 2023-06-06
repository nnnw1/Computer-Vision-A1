function [x, y] = initializeSnake(I)

% Show figure
figure;
imshow(I);
hold on;

[imh, imw] = size(I);

% Get initial points
[x_in, y_in] = getpts();

cPoly = [x_in y_in];
x_1 = cPoly(1,1);
y_1 = cPoly(1,2);
cPoly = [cPoly; [x_1, y_1]];
%hold on;

% Interpolate
[rows,columns] = size(cPoly);
count = 1 : rows;
count_s = 1:0.05:rows;
cPoly = cPoly';
xy_inter = spline(count, cPoly, count_s);
xpts = xy_inter(1,:);
ypts = xy_inter(2,:);
nums = size(xpts,2);

% Clamp points to be inside of image

for i = 1:nums
    if(xpts(1,i) < 2)
        xpts(1,i) = 2;
    end
    if(xpts(1,i) > imw-1)
        xpts(1,i) = imw-1;
    end
    if(ypts(1,i) < 2)
        ypts(1,i) = 2;
    end
    if(ypts(1,i) > imh-1)
        ypts(1,i) = imh-1;
    end
end

plot(cPoly(1,:), cPoly(2,:), 'b*', xpts, ypts, 'c.');

x = xpts;
y = ypts;

end

