clc;clear;
close all;
format compact
tic

disp("Start of script");

% Read data and normalise
data = csvread('./datasets/superconduct/train.csv',1,0);

preproc = 1;
[trainData,validationData,testData] = split_scale(data,preproc);
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
% Optimal Model
fprintf("\n ---Number of features:: %d,\n",25);
fprintf("\n---Clustering Radius %f\n",0.5);
numOfFeatures = 25;
r_a = 0.5;

%k-fold cv 
k = 5; 
% Rank Normalized data and get the indeces of ranking in idx array -
% Features that have stronger correlation with target val 
[ranking,~] = relieff(data(:,1:end-1),data(:,end),100);
% k-iter cross val
% create data
c = cvpartition(trainData(:, end), 'KFold', 5);
cv_temp_error = zeros(c.NumTestSets,2);
% genfis r_a clustering influense range
opt = genfisOptions('SubtractiveClustering',...
            'ClusterInfluenceRange',r_a);
sc_fis = genfis(trainData(:,ranking(1:numOfFeatures)),trainData(:,end),opt);

placeholderstring = "Optimal Parameter TSK membership functions Input";

disp("Start Training with CV");
for iter = 1:c.NumTestSets
    fprintf('\n %d -Fold \n',iter);
    train_index = c.training(iter);
    test_index = c.test(iter);

    % Split Data to chunk1 and chunk2 depending on cvpartioning
    % iteration
    trainDataChunk1 = trainData(train_index,ranking(1:numOfFeatures));
    trainDataChunk2 = trainData(train_index,end);

    valDataChunk1 = trainData(test_index,ranking(1:numOfFeatures));
    valDataChunk2 = trainData(test_index, end);
    %% Plot mf input before training
    figure(1);
    plotmf(sc_fis,'input',1);
    title_str = strcat(placeholderstring,'1');
    title_str = strcat(title_str,'before training');
    title(title_str);
    figure(2)
    mf_num = int2str(size(trainDataChunk1,2));
    plotmf(sc_fis,'input',size(trainDataChunk1,2));
    title_str = strcat(placeholderstring,mf_num);
    title_str = strcat(title_str,'before training');
    title(title_str);
    %% ANFIS section - Training
    disp("Start FIS Training")
    anfisOpt = anfisOptions('InitialFIS', sc_fis, 'EpochNumber', 100, 'DisplayANFISInformation', 1, 'DisplayErrorValues', 1, 'DisplayStepSize', 0, 'DisplayFinalResults', 1, 'ValidationData', [valDataChunk1  valDataChunk2]);
    [trnFis,trnError,~,valFis,valError]=anfis([trainDataChunk1 trainDataChunk2],anfisOpt);
    figure(3);
    title("Learning Curve ADFIS Optimal")
    plot([trnError valError],'LineWidth',2); grid on;
    xlabel('# of Iterations'); ylabel('Error');
    legend('TrainError' ,'ValError');
    disp('CV train end');

    %% Model Evaluation
    Y = evalfis(testData(:,ranking(1:numOfFeatures)),valFis);
    R_2 =Rsq(Y,testData(:,end));
    RMSE = sqrt(mse(Y,testData(:,end)));
    NMSE = 1 - R_2;
    NDEI  = sqrt(NMSE);
    fprintf("End of training %d iteration",iter);
    % R_2 and RMSE are stored to temp buffer to make
    % model ranking afterwards
    cv_temp_error(iter,1)  = R_2;
    cv_temp_error(iter,2) = RMSE;
    %% Plot prediction,prediction error, score
    figure(6)
    plot(Y,'LineWidth',2); grid on;
    xlabel('input');
    legend('Prediction');
    title('Model predictions')
    figure(7)
    plot(validationData(:,end),'LineWidth',2); grid on;
    xlabel('input');
    legend('Target Data');
    title('Ground Truth Data from test set');
    figure(8)
    % Prediction Error Plot
    Pred_error_temp = testData(:,end) - Y;      
    plot(Pred_error_temp,'LineWidth',2); grid on;
    xlabel('input');ylabel('Error');
    legend('Prediction Error');
    title('Optimal model Prediction Error');
    
    % Plot mf after training
    figure(4)
    plotmf(valFis,'input',1);
    title_str = strcat(placeholderstring,'1');
    title_str = strcat(title_str,'after training');
    title(title_str);
    figure(5)
    plotmf(valFis,'input',size(trainDataChunk1,2));
    mf_num = int2str(size(trainDataChunk1,2));
    title_str = strcat(placeholderstring,mf_num);
    title_str = strcat(title_str,'after training');
    title(title_str);
end
cross_val_R2 = sum(cv_temp_error(:,1))/k;
cross_val_RMSE = sum(cv_temp_error(:,2))/k;
NMSE = 1 - cross_val_RMSE;
NDEI = sqrt(NMSE);
disp("......")
Perd = [cross_val_R2; cross_val_RMSE; NMSE; NDEI]
toc
disp("End")
