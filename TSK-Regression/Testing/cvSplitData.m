%% Cross Validation Data Split Test - Not Kfold NOT USED - Method Aborted
function [dataTrain,dataTest] = cvSplitData(data)
%CVSPLITDATA Summary of this function goes here
%   Detailed explanation goes here
% Different way to split data not used because of instructions
% % Cross varidation (train: 70%, test: 30%)
cv = cvpartition(size(data,1),'HoldOut',0.3);
idx = cv.test;
% Separate to training and test data
dataTrain = data(~idx,:);
dataTest  = data(idx,:);
end

