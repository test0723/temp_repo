 function output = clipping(input, CE_input,n)


if nargin == 2
   
    n = 2;
elseif nargin == 3
    if n > 8
        n = 8;
    end

end


[ver hor] = size(input);
line = ver/16;
MAX = zeros(1,ver);
MAX_CE = zeros(1,ver);
temp = zeros(16,hor);
output = zeros(ver,hor);
temp_output = zeros(1,hor);




for i = 0:1:line-1;
    temp = input(16*i+1:16*(i+1), :);
    MAX(i*16+1:(i+1)*16) = max(max(temp));   
    temp_CE = CE_input(16*i+1:16*(i+1), :);
    MAX_CE(i*16+1:(i+1)*16) = max(max(temp_CE));      
end
% temp = input(11:16, :);
% MAX(1:16) = max(max(input(11:16, :)));   
% temp_CE = CE_input(1:16, :);
% MAX_CE(1:16) = max(max(CE_input(1:16, :)));    



for i = 1:1:line-1;
    MAX(i*16+1:(i+1)*16) = max(max(input(16*i+1:16*(i+1), :))); 
    MAX_CE(i*16+1:(i+1)*16) = max(max(CE_input(16*i+1:16*(i+1), :)));  
    diff_max = MAX(i*16) - MAX((i*16)+1);
    dd =abs( diff_max);
    if diff_max > 0
       
        for j = 0:1:n-1;
            dd = dd/2;
            MAX((i*16)-(j) )= MAX(i*16+1-j) + dd;
        end
    elseif diff_max < 0
   
        for j = 0:1:n-1;
            dd = dd/2;
            MAX((i*16)+1+(j)) = MAX(i*16+j) + dd;
        end
    end
end

      
for ii = 1:1:ver;
    MAX = round(MAX);
    Th = 2*(MAX(ii)) - MAX_CE(ii);
    Th = round(Th);
    b = MAX(ii) - Th;
    a = 1/(4*b);
    
    x = 0:1:2*b;
    y = a*x.^2; % clipping function y = ax^2;
    
    for i = 1:1:2*b+1; 
        yy(i) =b- y(2*b+2-i);
    end
    
     
    for i = 1:1:256;
        if  i <= Th
            y(i) = i-1;
        elseif i >Th && i < Th+ 2*(MAX(ii)-Th)
            y(i)= yy(i-Th) + Th;
        else
            y(i) = MAX(ii);
        end
    end
    
    
    for j = 1:1:hor;            
        for k = 1:1:256;               
            if CE_input(ii,j) == k-1;
                temp_output(j) = y(k);                
            end
        end            
    end
    
    
    output(ii, :) = temp_output;
end


