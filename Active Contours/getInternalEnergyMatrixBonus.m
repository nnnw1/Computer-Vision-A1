function [Ainv] = getInternalEnergyMatrixBonus(nPoints, alpha, beta, gamma)

num = nPoints;
A = sparse([], [], [], num, num, 5*num);
I = zeros(num,num);

for i = 1 : num
    if(i == 1)
        A(i,num-1) = beta;
        A(i,num) = -alpha - 4*beta;
        A(i,i) = 2 * alpha + 6 * beta;
        A(i,i+1) = -alpha - 4*beta;
        A(i,i+2) = beta;
    end
    if(i == 2)
        A(i,num) = beta;
        A(i,i-1) = -alpha - 4*beta;
        A(i,i) = 2 * alpha + 6 * beta;
        A(i,i+1) = -alpha - 4*beta;
        A(i,i+2) = beta;
    end
    if(i == num-1)
        A(i,i-2) = beta;
        A(i,i-1) = -alpha - 4*beta;
        A(i,i) = 2 * alpha + 6 * beta;
        A(i,i+1) = -alpha - 4*beta;
        A(i,1) = beta;
    end
    if(i == num)
        A(i,i-2) = beta;
        A(i,i-1) = -alpha - 4*beta;
        A(i,i) = 2 * alpha + 6 * beta;
        A(i,1) = -alpha - 4*beta;
        A(i,2) = beta;
    end
    if(i ~= 1 && i~= 2 && i ~= num-1 && i~= num)
        A(i,i-2) = beta;
        A(i,i-1) = -alpha - 4*beta;
        A(i,i) = 2 * alpha + 6 * beta;
        A(i,i+1) = -alpha - 4*beta;
        A(i,i+2) = beta;
    end  
    I(i,i) = 1;
end

Ainv = inv((A + gamma*I));

end

