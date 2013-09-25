
down = zeros(512,512);
org = zeros(512,512);


in = fopen('d:/training/boat_lq.raw', 'rb');
temp_down = fread(in, [512,512], 'uint8');
fclose(in);
for m = 1:1:512;
    for n = 1:1:512;
        down(m,n) = temp_down(n,m);
    end
end
%figure(1)
%imshow(down, []);

in = fopen('d:/training/boat.raw', 'rb');
temp_org = fread(in, [512,512], 'uint8');
fclose(in);
for m = 1:1:512;
    for n = 1:1:512;
        org(m,n) = temp_org(n,m);
    end
end
%figure(2)
%imshow(org, []);

hq = org - down;

%figure(3)
%imshow(hq, []);

% aa = 0;
cnt = 0;
for i = 1:2:512-6;
    for  j = 1:2:512-6;
        sum = 0;
        sqsum = 0;
      %  aa = aa+1;
        for m = 1:7;
            for n = 1:7;
                sum = sum + down(i+m-1, j+n-1);
                sqsum = sqsum + down(i+m-1, j+n-1)^2;
            %    patch(m,n,aa) = down(i+m-1, j+n-1);
            end
        end
        mean = sum/49;
        sqmean = sqsum/49;
         %  var(aa) = sqmean - mean^2;
        var = sqmean - mean^2;
        
      
        if var >= 10
            cnt = cnt+1;
            for m = 1:7;
                for n = 1:7;
                   
                    temp = (-9)*down(i+m-1, j+n-1);
                    for k= -1:1:1
                        for l= -1:1:1
                            l1 = i+m+k-1;
                            if (l1 < 1) 
                                l1 = 1; 
                            end
                            if (l1 > 512)
                                l1 = 512; 
                            end                           
                            r1 = j+n+l-1;
                            if (r1<1 )
                                r1 = 1; 
                            end
                            if (r1>512)
                                r1 = 512; 
                            end
                            
                            temp = temp + down(l1,r1);
                        end
                    end
                    input_patch(m,n,cnt) = temp;
                end
            end
            for m  = 1:1:9;
                if m<6
                    ref_patch(m,cnt) = hq(i+1,j+m);
                else
                    ref_patch(m,cnt) = hq(i+m-4,j+1);
                end
            end
            
            for m = 1:1:5;
                for n = 1:1:5;
                    hq_patch(m,n,cnt)= hq(i+m,j+n);
                end
            end
        end
                        
            
    end
end


        
for i = 1:1:cnt;
    tempabssum = 0; 
    
    for m = 1:1:7;    
        for n = 1:1:7;
            tempabssum = tempabssum + abs(input_patch(m,n,i));  
             
        end
    end
    meanabs(i) =tempabssum/49;
       
end

a = 0.1*(7^2) / (2*5-1);

ref_patch = ref_patch*a;

for i = 1:1:cnt;
    temp_sqsum = 0;
    normalized_patch(:,:,i) = input_patch(:,:,i) / (meanabs(i)+1);
    normalized_ref_patch(:,i) = ref_patch(:,i) / (meanabs(i)+1);
    
    for m = 1:1:7;
        for n = 1:1:7;
            temp_sqsum = temp_sqsum + normalized_patch(m,n,i)^2;
        end
    end
    
%     for m = 1:1:9
%        temp_sqsum = temp_sqsum + normalized_ref_patch(m,i)^2;
%     end
    
    L2norm_set(i) = sqrt(temp_sqsum);
    
end


% for m = 1:1:512;
%     for n = 1:1:512;
%         temp = (-9)*down(m,n);
%         for k= -1:1:1
%             for l= -1:1:1
%                 l1 = m+k;
%                 
%                 if (l1 < 1) 
%                     l1 = 1; end
%                 if (l1 > 512)
%                     l1 = 512; end
%                 
%                 r1 = n+l;
%                 if (r1<1 )
%                     r1 = 1; end
%                 if (r1>512)
%                     r1 = 512; end
%                         
%                  temp = temp + down(l1,r1);
%             end
%                    
%         end
%         hq_down(m,n) = temp;
%     end
% end
% 
% figure(4)
% 
% imshow(hq_down, []);
% 
% 
% q = 0;
% 
% for i= 1:2:512-6;
%     for j = 1:2:512-6; 
%         q = q+1;
%         tempabssum = 0;
%        tempsum = 0;
%        sqsum = 0;
%        
%         for m = 1:1:7;
%             for n = 1:1:7;
%                 down_patch(m,n,q) = hq_down(i+m-1, j+n-1);
%                tempabssum = tempabssum + abs(down_patch(m,n,q));  
%                tempsum = tempsum + down_patch(m,n,q);
%                sqsum = sqsum + down_patch(m,n,q)^2;
%             end
%         end
%   
%             meanabs(q) =tempabssum/49;
%            mean(q) = tempsum/49;
%            sqmean(q) = sqsum/49;
%            var(q) = sqmean(q) - mean(q)^2;
%         for m = 1:1:5;
%             for n = 1:1:5;
%                 hq_patch(m,n,q)= hq(i+m,j+n);
%             end
%         end
%         
%      
%     end
% end
% 
% a = 0.1*(7^2) / (2*5-1);
% ref_hq = zeros(9,1);
% for i = 2:1:q;
%     for j = 1:1:9;
%         if (j < 6)
%             ref_hq(j,i) = hq_patch(j,1,i-1);
%         else
%             ref_hq(j,i) = hq_patch(1,j-4,i-1);
%         end
%     end
% end
% 
% 
% for i = 1:1:q;
%     temp_sqsum = 0;
%     normalized_patch(:,:,i) = down_patch(:,:,i) / (meanabs(i)+1);
%     normalized_ref_patch(:,i) = ref_hq(:,i) / (meanabs(i)+1);
%     
%     for m = 1:1:7;
%         for n = 1:1:7;
%             temp_sqsum = temp_sqsum + normalized_patch(m,n,i)^2;
%         end
%     end
%     
%     for m = 1:1:9
%        temp_sqsum = temp_sqsum + normalized_ref_patch(m,i)^2;
%     end
%     
%     L2norm_set(i) = sqrt(temp_sqsum);
%     
% end
