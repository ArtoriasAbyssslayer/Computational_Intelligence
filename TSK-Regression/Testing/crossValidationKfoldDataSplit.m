%% CrossValidation Data Split with kfold algorithm 
function [trnData,valData,testData,c] = crossValidationKfoldDataSplit(k,data)
% This function creates the crossValDatasets
% dataSets are already preprocessed with split_scale to 60%/20%/20% 
%20% for validation    
nOf = size(data,1);
t = randi(nOf);
cvp = cvpartition(data(n,'Holdout',0.2);
valData = data(cvp.test,end);
trnData = data(cvp.training);
cvp3 = cvpartition(trnData(:,:),'Holdout',0.2);
testData = data(cvp3.test);
trnData = data(cvp.training);
cvp2 = cvpartition(trnData(:,:),'KFold',5,'Stratify', true);
c = cvp2;
end

