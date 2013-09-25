
input = zeros(512,512);
output = zeros(512,512);
output_cnt = zeros(512,512);


in = fopen('d:/training/boat_lq.raw', 'rb');
temp_input = fread(in, [512,512], 'uint8');
fclose(in);
for m = 1:1:512;
    for n = 1:1:512;
        input(m,n) = temp_input(n,m);
    end
end

output_patch = zeros(5,5);
output = zeros(512,512);
count = 0;


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
            tempsum = 0;
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
                    input_patch(m,n)= temp;
                    tempsum = tempsum + abs(input_patch(m,n));  
                    
                end
            end
            meanabs =tempsum/49;
            normalized_input(:,:) = input_patch(:,:) / (meanabs+1);
            normalized_output(:,:) = output_patch(:,:) / (meanabs+1);     
            temp_sqsum1 = 0;
            for m = 1:1:7;
                for n = 1:1:7;
                    temp_sqsum1 = temp_sqsum1 + normalized_input(m,n)^2;
                end
            end
            
            for l = 1:1:9;
                
                if (l < 6)
                    temp_sqsum1 = temp_sqsum1 +  normalized_output(l,1)^2;
                else
                    temp_sqsum1 = temp_sqsum1 + normalized_output(1,l-4)^2;
                end
            end
            
            L2norm = sqrt(temp_sqsum1);
            min = 100000;
            temp_index = 0;
            for k = 1:1:cnt;
                diff = abs(L2norm - L2norm_set(k));
                if diff < min
                    min = diff;
                    temp_index = k;
                end
            end
            output_patch(:,:) = hq_patch(:,:,temp_index);
      
      
      
            
        else
            output_patch(:,:) = zeros(5,5);
        end
        
        
        for m = 1:1:5;
            for n = 1:1:5;
                output(i+m,j+n) = output(i+m,j+n) + output_patch(m,n);
                output_cnt(i+m,j+n) = output_cnt(i+m,j+n)+1;
            end
        end
        count = count+1;
        fprintf('%d \n',count);
    end
end
            
            
            
            
            
            
            
            
            
% 
% for m = 1:1:512;
%     for n = 1:1:512;
%         temp = (-9)*input(m,n);
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
%                  temp = temp + input(l1,r1);
%             end
%                    
%         end
%         hq_input(m,n) = temp;
%     end
% end
% 
% 
% output_patch = zeros(5,5);
% output = zeros(512,512);
% count = 0;
% for i= 1:2:512-6;
%     for j = 1:2:512-6; 
%         tempsum = 0;
%        for m = 1:1:7;           
%             for n = 1:1:7;
%                 input_patch(m,n) = hq_input(i+m-1, j+n-1);
%                 tempsum = tempsum + abs(input_patch(m,n));                
%             end
%        end
%   
%        meanabs =tempsum/49;
%        normalized_input(:,:) = input_patch(:,:) / (meanabs+1);
%        normalized_output(:,:) = output_patch(:,:) / (meanabs+1);     
%        temp_sqsum1 = 0;
%       for m = 1:1:7;
%         for n = 1:1:7;
%             temp_sqsum1 = temp_sqsum1 + normalized_input(m,n)^2;
%         end
%       end
%     
% %       for l = 1:1:9;
% %         if (l < 6)
% %            temp_sqsum1 = temp_sqsum1 +  normalized_output(l,1)^2;
% %         else
% %             temp_sqsum1 = temp_sqsum1 + normalized_output(1,l-4)^2;
% %         end
% %     end
%       %L2 norm - 
%       L2norm = sqrt(temp_sqsum1);
%       
%       min = 100000;
%       temp_index = 0;
%       for k = 1:1:cnt;
%           diff = abs(L2norm - L2norm_set(k));
%           if diff < min
%               min = diff;
%               temp_index = k;
%               
%           end
%       end
% 
%       
%       output_patch(:,:) = hq_patch(:,:,temp_index);
%       
%       for m = 1:1:5;
%           for n = 1:1:5;
%               output(i+m,j+n) = output(i+m,j+n) + output_patch(m,n);
%               output_cnt(i+m,j+n) = output_cnt(i+m,j+n)+1;
%           end
%       end 
%       count = count+1;
%      fprintf('%d \n',count);
%     end
% end

for i = 1:1:512;
    for j = 1:1:512;
        if output_cnt(i,j) == 0
            output_cnt(i,j) = 1;
        end
    end    
end


for i = 1:1:512;
    for j = 1:1:512;
        output(i,j) = output(i,j)/output_cnt(i,j);
    end
end




final_output = input+output;

imtool(final_output, []);

        