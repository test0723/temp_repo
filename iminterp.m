function f=iminterp(im,scf,method)
im=double(im);
[ver,hor,depth]=size(im);
if depth == 1
    f=zeros(ver*scf,hor*scf);
    for i=1:scf
        for j=1:scf
            f(i:scf:ver*scf,j:scf:hor*scf)=im;
        end
    end
    [x,y] = meshgrid(1:hor,1:ver);
    [xi,yi] = meshgrid(1:1/scf:hor,1:1/scf:ver);
    g=interp2(x,y,im,xi,yi,method);
    [sv,sh]=size(g);
    f(1:sv,1:sh)=g(1:sv,1:sh);
else
    f=zeros(ver*scf,hor*scf,depth);
    for i=1:scf
        for j=1:scf
            f(i:scf:ver*scf,j:scf:hor*scf,1)=im(:,:,1);
            f(i:scf:ver*scf,j:scf:hor*scf,2)=im(:,:,2);
            f(i:scf:ver*scf,j:scf:hor*scf,3)=im(:,:,3);
        end
    end
    for i=1:3
        [x,y] = meshgrid(1:hor,1:ver);
        [xi,yi] = meshgrid(1:1/scf:hor,1:1/scf:ver);
        g=interp2(x,y,im(:,:,i),xi,yi,method);
        [sv,sh]=size(g);
        f(1:sv,1:sh,i)=g(1:sv,1:sh);
    end
end
% f=uint8(f);