% Charis Filis 9449
%% COA defuzzification method implementation
% mf_x is the vector of values in the membership function input range
% mf_y is the value of the membership function at xmf
function COA = COA(mf_x,mf_y)
   %% Find local max values and the location (triangle peaks)
   [peaks,x_locs] = findpeaks(mf_y,mf_x);
   
   % sum1 corresponds to the x*f(x) weighted area sum
   sum1 = 0;
   % sum2 corresponds to the actual area 
   sum2 = 0;
   % base measurement
   area = zeros(size(peaks));
   A = 0.66; 
   for i=1:size(peaks)
        %calculate the area of the MFs
        area(i) = 1/2*A*peaks(i);
        sum2 = sum2 + area(i);
        sum1 = sum1 + area(i)*x_locs(i);
   end
   % Cases where the base area is different
%     start_index = 1;
%     end_index = start_index + length(mf_y(mf_y == mf_y(start_index)));
%    if(mf_y(1) == 0)
%       
%        NV_area = 1/2*A/2*mf_y(1);
%        NL_area = 1/2*A*mf_y(2);
%        NV_function =  @(x)((-mf_y(1)*3)*x.^2-2*mf_y(1)*x);
%        NL_function =  @(x)((-mf_y(2)*3)*x.^2-2*mf_y(2)*x);
%        q = (integral(NV_function,-1,-0.33)+integral(NL_function,-1,0.66))/2;
%        new_centroid_of_area = q/(NV_area+NL_area);
%        sum2 = sum2 + NV_area;
%        sum1 = sum1 + new_centroid_of_area*NV_area;
%    end
%    if (mf_y(end_index)~=0)                            %for U=PV
%         PV_area = (1/2)*A/2*mf_y(end_index);%triangle MFs with 0.33 base
%         PL_area = (1/2)*A*mf_y(end_index-1);
%         fun_PV = @(w) ((mf_y(end_index)*3)*w.^2-2*mf_y(end_index)*w);
%         fun_PL = @(w) ((mf_y(end_index-1)*3)*w.^2-2*mf_y(end_index-1)*w);
%         q = (integral(fun_PV,0.33,1) + integral(fun_PL,0.66,1))/2;       
%         centroid_of_area = q/(PV_area+PL_area);
%         sum2 = sum2+PV_area;
%         sum1 = sum1 + centroid_of_area*(PV_area+PL_area);
%    end
    
 COA = sum1/sum2;
end

%   Python code reference 
%   
%     
%     f = fis.mf
%     [left,right] = A.domain
%     x = left 
%     sum1,sum2 = 0,0
%     
%     while x <= right:
%         sum1 += x*f(x).value
%         sum2 += f(x).value
%         x += step
%         
%         return sum1/sum2 