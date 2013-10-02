function R = sdmsr(X)
%% Parameter checking and initialization
hsiz=[20 83 256 512];

[a, b, color]=size(X);

if color==3
    P=rgb2ycbcr(X);
    X=P(:,:,1);
end
X2=X;
T=brightness(X);
%% Lacal detail weight function
LSD=zeros(a,b);

for i=1:a
    for j=1:b
        if (i>3&&j>3)&&(i<(a-2)&&j<(b-2))
            LSD(i,j)=abs(X(i,j)-X(i,j-1))+abs(X(i,j)-X(i-1,j));
        end
    end
end

LSD=imfilter(LSD,ones(5));
q=LSD/max(max(LSD));
m=mean2(q);

DAF=zeros(a,b);
for i=1:a
    for j=1:b
        if q(i,j)<m
            DAF(i,j)=1-((q(i,j)-m)/m)^2;
        else
            DAF(i,j)=1-((q(i,j)-m)/(1-m))^2;
        end
    end
end


R1=double(ssr(X2,hsiz(1)));
R2=double(ssr(X2,hsiz(2)));
R3=double(ssr(X2,hsiz(3)));
R4=mlog(X2,128)*2;

R4=R4-R3;
R3=R3-R2;
R2=R2-R1;

NK1=abs(R1)/max(max(abs(R1)));
NK2=abs(R2)/max(max(abs(R2)));
NK3=abs(R3)/max(max(abs(R3)));
NK4=abs(R4)/max(max(abs(R4)));

% 
g1=(1./(NK1+0.1)).^(1-sqrt((hsiz(1)+2*hsiz(4))/(3*hsiz(4))));
g2=(1./(NK2+0.1)).^(1-sqrt((hsiz(2)+2*hsiz(4))/(hsiz(4)*3)));
g3=(1./(NK3+0.1)).^(1-sqrt((hsiz(3)+2*hsiz(4))/(hsiz(4)*3)));
g4=(1./(NK4+0.1)).^(1-sqrt(hsiz(4)/(hsiz(4))));

% R=R1.*g1.*DAF+R2.*g2+R3.*g3+R4.*g4;
% R=1.2*R1.*g1.*DAF+1.6*R2.*g2+1.2*R3.*g3+R4.*g4;
R=(1.2+(1-T)/1.3).*R1.*g1.*DAF+(1.1+T/2).*R2.*g2+(2.2-T).*R3.*g3+R4.*g4;

if color==3
    P(:,:,1)=R;
    R=ycbcr2rgb(P);
end

R=uint8(R);
