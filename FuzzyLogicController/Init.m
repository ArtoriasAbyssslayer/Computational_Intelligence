% Charis Filis 9449
% Initialization File for parameters and for priting rules and rule
% surfaces
clc
clear all
fis  = readfis('FZPI_codegenerated.fis');
rule_sets = fis.Rules
f = figure();
gensurf(fis)
title('Controller Input-Output Area')
saveas(f, 'img/Area.png', 'png')


% Requirments for Simulation
MaxError = 150;
Ts = 0.01;
N = 10 / Ts;

% Tunned PI
disp("Linear PI Controller Values")
Kp=0.269318149004613
Ki=7.8383722787092
Ti = Kp / Ki;

% Fuzzy controller values (initial)
a_i = Ti;
Ke_i = 1;
Kd_i = a_i*Ke_i;
Ki = Kp/evalfis(a_i*Ke_i, fis);


tunned = true;
if(tunned)
    c = 2.6;
    K = c * Ki;
    Ke = c * Ke_i;
    a = 0.03;
    Kd = a * Ke;
else
    K = K_i;
    Kd = Kd_i;
    Ke = Ke_i;
end
    
% Input signals for the simulation
t = (0:Ts:(30-Ts))';
InputCase1 = [t [150*ones(N+500, 1); 80*ones(N, 1); 150*ones(N-500, 1)]];
InputCase2 = [t [15*(0:Ts:10)'; 150*ones(N-2, 1); 150-15*(0:Ts:10)']];
InputCase3 = [t 150*ones(3*N, 1)];
DisturbCase3 = [t [0*ones(N, 1); 1*ones(N, 1); 0*ones(N, 1)]];