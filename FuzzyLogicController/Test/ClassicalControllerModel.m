clc;
clear all;
clear vars;
% Classical Controller Design Not Demanded from Task but implemented

%% K = \frac{Kp}{F{aKe}}
% a = Ti = \frac{Kp}{Ki} = 0.2
%K = \frac{1.75}{F{0.2*1} = 8.753
%Faster Response Tunning
% a=Ki/Kp=0.6
% K = 8.75;
% Ke = 1.2;


%% Initial Values Before Tunning
disp("Initial Parameters Before Tunning")
Plant_gain = 18.69
Plant_pole = 12.064
Kp = 1.75
Ki = 8.75
Ti = 0.2
disp("Fuzzy- PI K  parameter K=Kp/F{aKe}")
Ke = 1; % Normalization
TFControl = zpk(0,Ki,Kp);
TFPlant = zpk(0,Plant_pole,Plant_gain);

openLoop = TFControl*TFPlant;
figure('Name','OpenLoop root locus');
rlocus(openLoop);

closedLoop = feedback(openLoop,1,-1);
figure('Name','Closed loop Step Response');
t=1:0.01:30;
opt = stepDataOptions('InputOffset',-50,'StepAmplitude',150);
step(closedLoop,t,opt)
%% Model Tunning 
load("PI_Model_Tunned.mat")
Kp=0.269318149004613
Ki=7.8383722787092
Ke=1
TFControl = zpk(0,Ki,Kp);

openLoop =TFControl*TFPlant;
figure('Name','OpenLoop Root Locus');
rlocus(openLoop);

closedLoop = feedback(openLoop,1,-1);
figure('Name','Closed loop Step Response');
t=1:0.01:30;
opt = stepDataOptions('InputOffset',-50,'StepAmplitude',150);
step(closedLoop,t,opt)
