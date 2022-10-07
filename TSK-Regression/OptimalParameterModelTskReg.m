clc;clear;
disp("Start of script");

% Read data and normalise
data = csvread('train.csv',1,0);

data = normalize(data);
preproc = 1;
[trainData,validationData,testData] = split_scale(data,preproc);
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);

% Optimal Model
fprintf("\nBest Number Of Features: %d,\n",25);
fprintf("\nBest Radius %4f\n",5);
numOfFeatures = 25;
ra = 0.5;

%k-fold cv 
k = 5;

for i = 1:c.NumOfTestSets
end