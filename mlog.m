function out = mlog(X,TH)
[ver hor]=size(X);
out=zeros(ver,hor);
X=double(X);
for i=1:ver
    for j=1:hor
        if TH>X(i,j)
            out(i,j)=(TH/255*log(256)/log(TH+1)*log(X(i,j)+1))*1+log(256)*X(i,j)/255*.0;
        else
           out(i,j)=(-(1-TH/255)*log(256)/log(256-TH)*log(256-X(i,j))+log(256))*1+log(256)*X(i,j)/255*.0;
        end
    end
end
out=(out+X)/2;