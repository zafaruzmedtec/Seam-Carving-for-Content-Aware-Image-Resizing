% function G = costfunction(im)
%     
%     [row,col,n] = size(im);
%     if(n == 3)
%         im = rgb2gray(im);
%     end
%     im = double(im)/255;
% 
%     [grad_x,grad_y] = gradient(im);
%     G = grad_x + grad_y;
%     G = abs(G);
% end

function G=costfunction(im)
            G=zeros(size(im,1),size(im,2));
            for ii=1:size(im,3)
                G=G+(filter2([.5 1 .5; 1 -6 1; .5 1 .5],im(:,:,ii))).^2;
            end
end

% function E = costfunction(Img)
% [m,n,z] = size(Img);
% [Gx(:,:,1), Gy(:,:,1)] = gradient(Img(:,:,1)); 
% [Gx(:,:,2), Gy(:,:,2)] = gradient(Img(:,:,2));
% [Gx(:,:,3), Gy(:,:,3)] = gradient(Img(:,:,3));
% [Gx, Gy] = gradient(Img);
% G = abs(Gx) + abs(Gy);
% 
% G = sum(G,3);
% E = abs(G); 
% end
        