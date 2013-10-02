function T=brightness(y)
[ver hor color]=size(y);
if color==3
    ycbcr=rgb2ycbcr(y);
    y=ycbcr(:,:,1);
end

out=zeros(ver/16,hor/16);
T=ones(ver/16,hor/16);

minimum=double(min(min(y)));
maximum=double(max(max(y)));
for i=1:ver/16
    for j=1:hor/16
        out(i,j)=mean2(y((i-1)*16+1:i*16,(j-1)*16+1:j*16));
        if out(i,j)<45
            T(i,j)=(out(i,j)-minimum)/(45-minimum);
        end
        if out(i,j)>200
            T(i,j)=(maximum-out(i,j))/(maximum-200);
        end
    end
end

T=iminterp(T,16,'bicubic');
% imshow(T)