%% Sugeno TSK Task 1 - ANFIS 
% 9449 Charis Filis
format compact
clear 
clc

%% Load Data - Data Preprocessing - Split Training-Test Set
data = load('./datasets/airfoil_self_noise.dat');
preproc = 1;
[Dtrn,Dval,Dtest] = split_scale(data,preproc);
%[trnData,chkData,tstData] = split_scale(data,preproc);
Perf=zeros(4,4);


%% Evaluation function
Rsq = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);


%% Feature Extraction from Dataset
numOfFeatures = 5;
DtrnFeatures = Dtrn(:,1:numOfFeatures);
Target = 6;
DtrnTargets = Dtrn(:,Target);


%% FIS with grid partitioning

genOpt = genfisOptions('GridPartition');
genOpt.NumMembershipFunctions = 2;
genOpt.InputMembershipFunctionType = ["gbellmf"];
genOpt.OutputMembershipFunctionType = ["constant"];
inFIS(1) = genfis(DtrnFeatures,DtrnTargets,genOpt);

% Plot Membership Function
figure(1)
[x,mf] = plotmf(inFIS(1),'input',1);
subplot(2,1,1)
plot(x,mf)
xlabel('input 1 (gbellmf)')
[x,mf] = plotmf(inFIS(1),'input',2);
subplot(2,1,2)
plot(x,mf)
xlabel('input 2 (gbellmf)')
xlabel('ouput 1 (constant)')
% [x,mf] = plotmf(inFIS(1),'output',1);
% subplot(2,1,3)
% plot(x,mf)

genOpt.NumMembershipFunctions = 3;
inFIS(2) = genfis(DtrnFeatures,DtrnTargets,genOpt);
% Plot Membership Function
figure(2)
[x,mf] = plotmf(inFIS(2),'input',1);
subplot(3,1,1)
plot(x,mf)
xlabel('input 1 (gbellmf)')
[x,mf] = plotmf(inFIS(2),'input',2);
subplot(3,1,2)
plot(x,mf)
xlabel('input 2 (gbellmf)')
[x,mf] = plotmf(inFIS(2),'input',3);
subplot(3,1,3)
plot(x,mf)

genOpt.NumMembershipFunctions = 2;
genOpt.OutputMembershipFunctionType = ["linear"];
inFIS(3) = genfis(DtrnFeatures,DtrnTargets,genOpt);
% Plot Membership Function 
figure(3)
[x,mf] = plotmf(inFIS(3),'input',1);
subplot(3,1,1)
plot(x,mf)
xlabel('input 1 (gbellmf)')
[x,mf] = plotmf(inFIS(3),'input',2);
subplot(3,1,2)
plot(x,mf)
xlabel('input 2 (gbellmf)')
[x,mf] = plotmf(inFIS(3),'input',3);
subplot(3,1,3)
plot(x,mf)

genOpt.NumMembershipFunctions = 3;
genOpt.OutputMembershipFunctionType = ["linear"];
inFIS(4) = genfis(DtrnFeatures,DtrnTargets,genOpt);
% Plot Membership Function 
figure(4)
[x,mf] = plotmf(inFIS(4),'input',1);
subplot(2,1,1)
plot(x,mf)
xlabel('input 1 (gbellmf)')
[x,mf] = plotmf(inFIS(4),'input',2);
subplot(2,1,2)
plot(x,mf)
xlabel('input 2 (gbellmf)')



%% ANFIS section
for i = 1:4
    % 100 epochs train the 1st - two fis for 100 epochs
    [trnFis,trnError,~,valFis,valError]=anfis(Dtrn,inFIS(i),[100 0 0.01 0.9 1.1],[],Dval);
    % Membership Functions lots
    tsk_id = int2str(i);
    disp_msg = strcat("TSK model ",tsk_id);
    disp_msg = strcat(disp_msg," membership functions for input ");
    for t = 1:size(Dtrn,2)-1
        input = int2str(t);
        Graph_Title = strcat(disp_msg,input);
        figure(i*100+t);
        plotmf(valFis,'input',t);
        title(Graph_Title);
    end
    
    % Learning Curve plot i*100+ 4 +i gets the number of figure we are
    % currently on 
    figure(i*100 + 4 + i);
    plot([trnError valError],'LineWidth',2); grid on;
    xlabel('# of Iterations'); ylabel('Error');
    legend('Training Error','Validation Error');
    disp_msg = "TSK model ";
    disp_msg = strcat(disp_msg,tsk_id);
    disp_msg = strcat(disp_msg," learning curve");
    title(disp_msg);
    Y = evalfis(Dtest(:,1:end-1), valFis);
%    plot(Dtrn(:,1:numOfFeatures),Dtrn(:,Target),'*r',Dtrn(:,1:numOfFeatures),Y,'.b')
    legend('Training Data','ANFIS Output','Location','NorthWest')
    % Calculate Metrics
    R_2 = Rsq(Y,Dtest(:,end));
    RMSE = sqrt(mse(Y,Dtest(:,end)));
    NMSE = 1 - R_2;
    NDEI  = sqrt(NMSE);
    %Store Metrics into a Vector
    Perf(i,:) = [R_2;RMSE;NMSE;NDEI];
     % Prediction Error plot
    predictionError = Dtest(:,end) - Y;
    figure(100*i + 20);
    plot(predictionError,'LineWidth',2); grid on;
    disp_msg = "TSK model ";
    disp_msg = strcat(disp_msg,tsk_id);
    disp_msg = strcat(disp_msg," prediction error");
    xlabel('input');ylabel('Error');
    title(disp_msg);
    
end

%Results Presentation
varnames={'TSK_model_1','TSK_model_2','TSK_model_3','TSK_model_4'};
rownames = {'Rsquared','RMSE','NMSE','NDEI'};
Perf= array2table(Perf,'VariableNames', varnames, 'Rownames',rownames)