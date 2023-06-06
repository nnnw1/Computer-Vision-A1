function [newX, newY] = iterate(Ainv, x, y, Eext, gamma, kappa)

% Get fx and fy
[fx, fy] = gradient(Eext);

% Iterate
x = x';
y = y';
newX = Ainv*(gamma*x + kappa*interp2(fx, x, y));
newY = Ainv*(gamma*y + kappa*interp2(fy, x, y));

% Clamp to image size
[rows, columns] = size(Eext);

newX(newX < 1) = 2;
newX(newX > columns) = columns - 1;
newY(newY < 1) = 2;
newY(newY > rows) = rows - 1;


newX = newX';
newY = newY';

end

