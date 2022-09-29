% Charis Filis 9449
% Linear PI controller test

%% clear console/workspace
clc;
clear all;
clear vars;
% Classical Controller Design Not Demanded from Task but implemented

%% Initial Values Before Tunning
 % Plant Parameters
disp("Initial Parameters Before Tunning")
Plant_gain = 18.69
Plant_pole = 12.064
% PI controller initial Selected Values
Kp = 1.75
Ki = 8.75
Ti = 0.2

TFControl = zpk([],Ki,Kp);
TFPlant = zpk(0,Plant_pole,Plant_gain);

%% open loop system
openLoop = series(TFControl,TFPlant);
figure('Name','OpenLoop root locus');
rlocus(openLoop);
%% closed loop system
closedLoop = feedback(openLoop,1,-1);
figure('Name','Closed Loop root locus');
rlocus(closedLoop);
figure('Name','Closed loop Step Response');
% opt = stepDataOptions('InputOffset',-50,'StepAmplitude',150);
% step(closedLoop,t,opt)
step(closedLoop)
%% Model Tunning 
load("PI_Model_Tunned.mat")
Kp=0.269318149004613
Ki=7.8383722787092
zeros = [-29];
poles = [ 0];
K = 0.27
disp("After tunning Gc(s) = Kp + Ki/s = 0.27(s+29)/s")
TFControl = zpk(zeros,poles,K);
%% open loop system
openLoop =series(TFControl,TFPlant);
figure('Name','OpenLoop Root Locus');
rlocus(openLoop);

closedLoop = feedback(openLoop,1,-1);
figure('Name','Closed Loop root locus');
rlocus(closedLoop);
figure('Name','Closed loop Step Response');
% opt = stepDataOptions('InputOffset',50,'StepAmplitude',150);
% step(closedLoop,t,opt)
step(closedLoop)
info = stepinfo(closedLoop);
if info.RiseTime > 0.6
    fprintf('Rise Time is : %d. Try another value.',info.RiseTime);
end
if info.Overshoot > 8
    fprintf('Overshoot is : %d. Try another value.',info.Overshoot);
end