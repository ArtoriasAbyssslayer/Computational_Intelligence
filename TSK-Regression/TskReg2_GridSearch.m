% Computational Intelligence 2022 
% Charis Filis 9449
%% Sugeno TSK RegressionTask 2 - ANFIS
clc
clear all
close all 
format compact
disp("Starting Tsk on high-dimensonallity dataset");

%Load and preproccess data 

data = csvread('./datasets/superconduct/train.csv',1,0);
% idx=randperm(length(data));
% trnIdx=idx(1:round(length(idx)*0.6));
% chkIdx=idx(round(length(idx)*0.6)+1:round(length(idx)*0.8));
% tstIdx=idx(round(length(idx)*0.8)+1:end);
% trnX=data(trnIdx,1:end-1);
% chkX=data(chkIdx,1:end-1);
% tstX=data(tstIdx,1:end-1);
% traindata=[trnX data(trnIdx,end)];
% valata=[chkX data(chkIdx,end)];
% testata=[tstX data(tstIdx,end)];
% trainData = normalize(traindata);
% validationData = normalize(valdata);
% testData = normalize(testdata);
% *above method aborted because we want to normalize data based on train
% set*
%Split and suffle data
preproc = 1;
[trainData,validationData,testData] = split_scale(data,preproc);
%Cost/evaluation function 
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);


%% Grid Search 
% I define a 4by 7 by 2 matrix Params from which numberoffeature and clustering
% radius will be selected
%% Number of  Features Params
Params(1,1) = 10;
Params(2,1) = 15; 
Params(3,1) = 20;
Params(4,1) = 25;
%% Clustering Radius Params
Params(:,1,2) = 0.3;
Params(:,2,2) = 0.4;
Params(:,3,2) = 0.5;
Params(:,4,2) = 0.6;
Params(:,5,2) = 0.7;
Params(:,6,2) = 0.8;
Params(:,7,2) = 0.9;
fprintf("\nFeature Selection Params ")
FeatureParams = Params(:,1)'
fprintf("\n Clusterring Radius Selection Params %4f \n ");
RadIIParams = Params(1,:,2)
%% errors in grid buffer
error_grid = zeros(size(Params,1),size(Params,2),2);
rule_grid = zeros(size(Params,1),size(Params,2));
%% CrossValidationDataSplit
k = 5;
%% Grid Search
% start counting time too 
tic 
% Rank Normalized data and get the indeces of ranking in idx array -
% Features that have stronger correlation with target val 
[ranking,~] = relieff(data(:,1:end-1),data(:,end),100);
disp("Beginning Grid Search")
for f = 1:size(Params,1)
    for r = 1:size(Params,2)
        fprintf("\n ---Number of features: %d", Params(f,1));
        fprintf("\n ---Clustering Radius: %4f", Params(1,r,2));
        numberOfSelectedFeatures = Params(f,1);
        r_a = Params(1,r,2);
        % k-iter cross val
        % create data
        c = cvpartition(trainData(:, end), 'KFold', 5);
        
        cv_temp_error = zeros(c.NumTestSets,2);
        % genfis r_a clustering influense range
        opt = genfisOptions('SubtractiveClustering',...
                    'ClusterInfluenceRange',r_a);
        sc_fis = genfis(trainData(:,ranking(1:numberOfSelectedFeatures)),trainData(:,end),opt);
        rule_grid(f,r) = length(sc_fis.rule);
        if (rule_grid(f, r) == 1 || rule_grid(f,r) > 100) % if there is only one rule we cannot create a fis, so continue to next values
            continue; % or more than 100, continue, for speed reason
        end
       
        for iter = 1:c.NumTestSets
            fprintf('\n %d -Fold \n',iter);
            train_index = c.training(iter);
            test_index = c.test(iter);
            
            % Split Data to chunk1 and chunk2 depending on cvpartioning
            % iteration
            trainDataChunk1 = trainData(train_index,ranking(1:numberOfSelectedFeatures));
            trainDataChunk2 = trainData(train_index,end);
            
            validationDataChunk1 = trainData(test_index,ranking(1:numberOfSelectedFeatures));
            validataionDataChunk2 = trainData(test_index, end);
            
            %% ANFIS section - Training
            disp("Start FIS Training")
            anfisOpt = anfisOptions('InitialFIS', sc_fis, 'EpochNumber', 40, 'DisplayANFISInformation', 0, 'DisplayErrorValues', 0, 'DisplayStepSize', 0, 'DisplayFinalResults', 0, 'ValidationData', [validationDataChunk1  validataionDataChunk2]);
            [trnFis,trnError,~,valFis,valError]=anfis([trainDataChunk1 trainDataChunk2],anfisOpt);
            figure(iter*5);
            title("Learning Curve ADFIS optim #iter %d",iter)
            plot([trnError valError],'LineWidth',2); grid on;
            xlabel('# of Iterations'); ylabel('Error');
            legend('TrainError' ,'ValError');
            disp('CV train end');

            %Eval
            Y = evalfis(validationData(:,ranking(1:Params(f,1))),valFis);
            R_2 =Rsq(Y,validationData(:,end));
            RMSE = sqrt(mse(Y,validationData(:,end)));
            NMSE = 1 - R_2;
            NDEI  = sqrt(NMSE);
            fprintf("End of training %d iteration",iter);
            % R_2 and RMSE are stored to temp buffer to make
            % model ranking afterwards
            cv_temp_error(iter,1)  = R_2;
            cv_temp_error(iter,2) = RMSE;



            figure('Name',"#Iteration PredError-CrossVal");
            % Prediction Error Plot
            Pred_error_temp(iter,:)= validationData(:,end) - Y;    
            plot(Pred_error_temp(iter,:),'LineWidth',2); grid on;
            xlabel('input');ylabel('Error');
            legend('Prediction Error');
            title('kfold Prediction Error Iteration #',iter);
        end
        cross_val_errorR2 = sum(cv_temp_error(:,1))/k;
        cross_val_errorRMSE = sum(cv_temp_error(:,2))/k;
        error_grid(f,r,1) = cross_val_errorR2;
        error_grid(f,r,2) = cross_val_errorRMSE;
    end
    r=1;
end
save error_grid
% stop counter and print elapsed time for grid search
toc
bar3(rule_grid);
ylabel('Number of features');
yticklabels({'10','15','20','25'});
xlabel('Radii values');
xticklabels({'1st','2nd','3rd','4th','5th','6th','7th'});
zlabel('Number of rules created');
title('Rules created for different number of features and radii');
saveas(gcf, 'rules_wrt_f_r.png');
% values below selected based on error grid evaluation
fprintf("\nBest Number Of Features: %d,\n",Params(4,1));
fprintf("\nBest Radius %4f\n",Params(4,3,2));
disp("Grid Search End");
