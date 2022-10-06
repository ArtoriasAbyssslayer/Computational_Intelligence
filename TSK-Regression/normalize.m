%% Normalize Data
% 9449 Charis Filis
% Tried to create normalize function based on lecture instructions
% (split_scale is used though cause this was given premade)
function data_normalized = normalize(data)
%NORMALIZE function is used to normalized given data so we escape
%unstabillities during training

% select all data exept last column which contains the target val(critical
% temprature column 82)  and for airfoil dataset is the 6 column
data_buffer = data(:,1:end-1);
%take the min and max value of each row of features (thus 1 in the last
%argument) 
xmin_r = min(data_buffer,[],1);
xmax_r = max(data_buffer,[],1);
% use repmat to maintain the shape of dataset matrix and substract min from
% max
% xnorm = x-x_min_r/(range_row=(xmax_r-xmin_r))
data_norm = (data_buffer - repmat(xmin_r,[size(data_buffer,1) 1]))./(repmat(xmax_r,[size(data_buffer,1) 1])-repmat(xmin_r,[size(data_buffer,1) 1]));
data_normalized = data_norm;
end

