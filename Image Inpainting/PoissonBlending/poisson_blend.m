function imgout = poisson_blend(im_s, mask_s, im_t)
% -----Input
% im_s     source image (object)
% mask_s   mask for source image (1 meaning inside the selected region)
% im_t     target image (background)
% -----Output
% imgout   the blended image

[imh, imw, nb] = size(im_s);

%TODO: consider different channel numbers

%TODO: initialize counter, A (sparse matrix) and b.
%Note: A don't have to be k¡Ák,
%      you can add useless variables for convenience,
%      e.g., a total of imh*imw variables
%-----
%-----

V = zeros(imh, imw);
V(1:imh*imw) = 1:imh*imw;
M = mask_s;
b = zeros(imw*imh, nb);
imgout = zeros(imh, imw, nb);

%TODO: fill the elements in A and b, for each pixel in the image
%-----
%-----

for channel = 1 : nb
    
    counter = 1;
    imgin = im_t(:,:,channel);
    im_ob = im_s(:,:,channel);
    i_sum = [];
    j_sum = [];
    value_sum = [];
    
for y = 1 : imh
    for x = 1 : imw
        if(x==1 || x==imw)
            if(y~=1 && y~=imh)
                if(M(y,x) == 1)
                    i1 = counter;
                    j1 = V(y,x);
                    value1 = 2;
                    i2 = counter;
                    j2 = V(y-1,x);
                    value2 = -M(y-1,x);
                    i3 = counter;
                    j3 = V(y+1,x);
                    value3 = -M(y+1,x);
                        
                    i_sum = [i_sum,i1,i2,i3];
                    j_sum = [j_sum,j1,j2,j3];
                    value_sum = [value_sum,value1,value2,value3];
                    b(counter,channel) = 2*im_ob(y,x) - im_ob(y-1,x) - im_ob(y+1,x) + (1-M(y-1,x))*imgin(y-1,x) + (1-M(y+1,x))*imgin(y+1,x);
                end
            end
        elseif(y==1 || y==imh)
                if(x~=1 && x~=imw)
                    if(M(y,x) == 1)
                        i1 = counter;
                        j1 = V(y,x);
                        value1 = 2;
                        i2 = counter;
                        j2 = V(y,x-1);
                        value2 = -M(y,x-1);
                        i3 = counter;
                        j3 = V(y,x+1);
                        value3 = -M(y,x+1);
                   
                        i_sum = [i_sum,i1,i2,i3];
                        j_sum = [j_sum,j1,j2,j3];
                        value_sum = [value_sum,value1,value2,value3];
                        b(counter,channel) = 2*im_ob(y,x) - im_ob(y,x+1) - im_ob(y,x-1) + (1-M(y,x+1))*imgin(y,x+1) + (1-M(y,x-1))*imgin(y,x-1);       
                    end
                end
        else
            if(M(y,x) == 1)
                i1 = counter;
                j1 = V(y,x);
                value1 = 4;
                i2 = counter;
                j2 = V(y,x+1);
                value2 = -M(y,x+1);
                i3 = counter;
                j3 = V(y,x-1);
                value3 = -M(y,x-1);
                i4 = counter;
                j4 = V(y+1,x);
                value4 = -M(y+1,x);
                i5 = counter;
                j5 = V(y-1,x);
                value5 = -M(y-1,x);
                
                i_sum = [i_sum,i1,i2,i3,i4,i5];
                j_sum = [j_sum,j1,j2,j3,j4,j5];
                value_sum = [value_sum,value1,value2,value3,value4,value5];
                b(counter,channel) = 4*im_ob(y,x) - im_ob(y,x+1) - im_ob(y,x-1) - im_ob(y-1,x) - im_ob(y+1,x) + (1-M(y,x+1))*imgin(y,x+1) + (1-M(y,x-1))*imgin(y,x-1) + (1-M(y-1,x))*imgin(y-1,x) + (1-M(y+1,x))*imgin(y+1,x);
            end
        end
        if(M(y,x) == 0)
            i1 = counter;
            j1 = V(y,x);
            value1 = 1;
            i_sum = [i_sum,i1];
            j_sum = [j_sum,j1];
            value_sum = [value_sum,value1];
%             A(counter, V(y,x)) = 1;
            b(counter,channel) = imgin(y,x);
        end
        counter = counter + 1;    
    end
end
A = sparse(i_sum,j_sum,value_sum);
solution = A\b(:,channel);
error = sum(abs(A*solution-b(:,channel)));
disp(error)
imgout(:,:,channel) = reshape(solution,[imh,imw]);
end
%-----

