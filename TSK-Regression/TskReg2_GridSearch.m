% Computational Intelligence 2022 
% Charis Filis 9449
%% Sugeno TSK RegressionTask 2 - ANFIS
clc
clear all
format compact
disp("Starting Tsk on high-dimensonallity dataset");

%Load and preproccess data 

data = csvread('./datasets/superconduct/train.csv',1,0);
data = normalize(data);
preproc = 1;
[trainData,validationData,testData] = split_scale(data,preproc);
trainData = normalize(trainData);
validationData = normalize(validationData);
testData = normalize(testData);
%Cost/evaluation function 
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);


%% Grid Search 
% I define a 10 by 10 by 2 matrix Params from which numberoffeature and clustering
% radius will be selected
%% Number of  Features Params
Params(1,1) = 2; 
Params(2,1) = 5;
Params(3,1) = 10; 
Params(4,1) = 12;
Params(5,1) = 15;
Params(6,1) = 20;
Params(7,1) = 25;
Params(8,1) = 30;
Params(9,1) = 35;
Params(10,1)= 40;
%% Clustering Radius Params
Params(:,1,2) = 0.1;
Params(:,2,2) = 0.2;
Params(:,3,2) = 0.3;
Params(:,4,2) = 0.4;
Params(:,5,2) = 0.5;
Params(:,6,2) = 0.6;
Params(:,7,2) = 0.7;
Params(:,8,2) = 0.8;
Params(:,9,2) = 0.9;
disp("Feature Selection Params %d")
Params(:,:,1)
disp("Clusterring Radius Selection Params");
Params(:,:,2)
%% errors in grid buffer
error_grid = zeros(size(Params,1),size(Params,2));
rule_grid = zeros(size(Params,1),size(Params,2));
%% CrossValidationDataSplit
k = 5;
%% Grid Search
% start counting time too 
tic 
disp("Beginning Grid Search")
% Rank Normalized data and get the indeces of ranking in idx array
[ranking,weights] = relieff(data(:,1:end-1),data(:,end),100);

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
        opt = genfisOptions('SubtractiveClustering');
        opt.ClusterInfluenceRange = r_a;
        sc_fis = genfis(trainData(:,ranking(1:Params(f,1))),trainData(:,end),opt);
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
            figure(iter);
            plot([trnError,valError],'LineWidth',2);grid on;
            xlabel('# of Iterations'); ylabel('Error');
            legend('ANFIS CrossVal Data Training');
            disp('CV train end');

            %Eval
            Y = evalfis(validationData(:,ranking(1:numberOfSelectedFeatures)),valFis);
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
        error_grid(f,r) = cross_val_errorR2;
        error_grid(f,r) = cross_val_errorRMSE;
    end
    r=1;
end
% stop counter and print elapsed time for grid search
toc
figure;
subplot(2,2,1)
bar(error_grid(1,:));
xlabel('radii value');
ylabel('Mean Square Error');
legend('3 features')
subplot(2,2,2);
bar(error_grid(2,:));
xlabel('radii value');
ylabel('Mean Square Error');
legend('9 features')

% Select values 


