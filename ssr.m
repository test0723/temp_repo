function [R,L] = ssr(X,hsiz, TH)
%% Default result


%% Parameter checking
if nargin == 1
    hsiz = 15;
    normalize = 1;
elseif nargin ==2
    if isempty(hsiz)
        hsiz = 15;
    end
    normalize = 1;
elseif nargin == 3
    if isempty(hsiz)
        hsiz = 15;
    end
end


%% Init. operations


[a,b,c]=size(X);
X1=X;
if c==3
    X2=rgb2ycbcr(X1);
    X1=X2(:,:,1);
end

X1=double(X1);

%% Filter construction

pri=8;
fs=ceil(sqrt(hsiz^2*log(10)));
cent=floor(fs/2+0.5);

if fs<128
    filt = zeros(ceil(fs/pri),ceil(fs/pri));
else
    filt = zeros(128/pri,128/pri);
    fs=128/pri;
    cent=64/pri;
end

for i=1:fs
    for j=1:fs
        radius = (pri*(ceil(cent)-i)^2+pri*(cent-j)^2);
        filt(i,j) = exp(-(radius/(hsiz^2)));
    end
end

filt=filt/sum(sum(filt));


%% Filter image and adjust for log operation 
Z = ceil(imfilter(X1,filt,'replicate','same'));
%% Single scale retinex
R=mlog(X,128)-mlog(Z,128);
