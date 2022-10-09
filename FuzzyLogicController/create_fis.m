function [ sets ] = create_fis( v )

sets =  mamfis;
sets.andMethod = 'min';
sets.defuzzMethod = 'COA';
%sets.type = 'mamdani';
sets.orMethod = 'max';
% This adjustment to ImplicationMethod made later for using Larsen method
sets.ImplicationMethod = "prod";

A = 1;
sets = addvar(sets,'input', 'e',[-A,A]);
sets = addmf(sets, 'input', 1, 'NL', 'trimf', [-4*A/3 -A -2*A/3]);
sets = addmf(sets, 'input', 1, 'NM', 'trimf', [-A -2*A/3 -A/3]);
sets = addmf(sets, 'input', 1, 'NS', 'trimf', [-2*A/3 -A/3 0]);
sets = addmf(sets, 'input', 1, 'ZR', 'trimf', [-A/3 0 A/3]);
sets = addmf(sets, 'input', 1, 'PS', 'trimf', [0 A/3 2*A/3]);
sets = addmf(sets, 'input', 1, 'PM', 'trimf', [A/3 2*A/3 A]);
sets = addmf(sets, 'input', 1, 'PL', 'trimf', [2*A/3 A 4*A/3]);


sets = addvar(sets, 'input', 'De', [-A A]);
sets = addmf(sets, 'input', 2, 'NV', 'trimf', [-5*A/4 -A -3*A/4]);
sets = addmf(sets, 'input', 2, 'NL', 'trimf', [-A -3*A/4 -A/2]);
sets = addmf(sets, 'input', 2, 'NM', 'trimf', [-3*A/4 -A/2 -A/4]);
sets = addmf(sets, 'input', 2, 'NS', 'trimf', [-A/2 -A/4 0]);
sets = addmf(sets, 'input', 2, 'ZR', 'trimf', [-A/4 0 A/4]);
sets = addmf(sets, 'input', 2, 'PS', 'trimf', [0 A/4 A/2]);
sets = addmf(sets, 'input', 2, 'PM', 'trimf', [A/4 A/2 3*A/4]);
sets = addmf(sets, 'input', 2, 'PL', 'trimf', [A/2 3*A/4 A]);
sets = addmf(sets, 'input', 2, 'PV', 'trimf', [3*A/4 A 5*A/4]);



sets = addvar(sets, 'output', 'Du', [-A A]);
sets = addmf(sets, 'output', 1, 'NV', 'trimf', [-5*A/4 -A -3*A/4]);
sets = addmf(sets, 'output', 1, 'NL', 'trimf', [-A -3*A/4 -A/2]);
sets = addmf(sets, 'output', 1, 'NM', 'trimf', [-3*A/4 -A/2 -A/4]);
sets = addmf(sets, 'output', 1, 'NS', 'trimf', [-A/2 -A/4 0]);
sets = addmf(sets, 'output', 1, 'ZR', 'trimf', [-A/4 0 A/4]);
sets = addmf(sets, 'output', 1, 'PS', 'trimf', [0 A/4 A/2]);
sets = addmf(sets, 'output', 1, 'PM', 'trimf', [A/4 A/2 3*A/4]);
sets = addmf(sets, 'output', 1, 'PL', 'trimf', [A/2 3*A/4 A]);
sets = addmf(sets, 'output', 1, 'PV', 'trimf', [3*A/4 A 5*A/4]);
ruleBase =[
        'If (e is NL) and (De is PV) then (Du is PS) (1)';
        'If (e is NM) and (De is PV) then (Du is PM) (1)';
        'If (e is NS) and (De is PV) then (Du is PL) (1)';
        'If (e is ZR) and (De is PV) then (Du is PV) (1)';
        'If (e is PS) and (De is PV) then (Du is PV) (1)';
        'If (e is PM) and (De is PV) then (Du is PV) (1)';
        'If (e is PL) and (De is PV) then (Du is PV) (1)';
        'If (e is NL) and (De is PL) then (Du is ZR) (1)';
        'If (e is NM) and (De is PL) then (Du is PS) (1)';
        'If (e is NS) and (De is PL) then (Du is PM) (1)';
        'If (e is ZR) and (De is PL) then (Du is PL) (1)';
        'If (e is PS) and (De is PL) then (Du is PV) (1)';
        'If (e is PM) and (De is PL) then (Du is PV) (1)';
        'If (e is PL) and (De is PL) then (Du is PV) (1)';
        'If (e is NL) and (De is PM) then (Du is NS) (1)';
        'If (e is NM) and (De is PM) then (Du is ZR) (1)';
        'If (e is NS) and (De is PM) then (Du is PS) (1)';
        'If (e is ZR) and (De is PM) then (Du is PM) (1)';
        'If (e is PS) and (De is PM) then (Du is PL) (1)';
        'If (e is PM) and (De is PM) then (Du is PV) (1)';
        'If (e is PL) and (De is PM) then (Du is PV) (1)';
        'If (e is NL) and (De is PS) then (Du is NM) (1)';
        'If (e is NM) and (De is PS) then (Du is NS) (1)';
        'If (e is NS) and (De is PS) then (Du is ZR) (1)';
        'If (e is ZR) and (De is PS) then (Du is PS) (1)';
        'If (e is PS) and (De is PS) then (Du is PM) (1)';
        'If (e is PM) and (De is PS) then (Du is PL) (1)';
        'If (e is PL) and (De is PS) then (Du is PV) (1)';
        'If (e is NL) and (De is ZR) then (Du is NL) (1)';
        'If (e is NM) and (De is ZR) then (Du is NM) (1)';
        'If (e is NS) and (De is ZR) then (Du is NS) (1)';
        'If (e is ZR) and (De is ZR) then (Du is ZR) (1)';
        'If (e is PS) and (De is ZR) then (Du is PS) (1)';
        'If (e is PM) and (De is ZR) then (Du is PM) (1)';
        'If (e is PL) and (De is ZR) then (Du is PL) (1)';
        'If (e is NL) and (De is NS) then (Du is NV) (1)';
        'If (e is NM) and (De is NS) then (Du is NL) (1)';
        'If (e is NS) and (De is NS) then (Du is NM) (1)';
        'If (e is ZR) and (De is NS) then (Du is NS) (1)';
        'If (e is PS) and (De is NS) then (Du is ZR) (1)';
        'If (e is PM) and (De is NS) then (Du is PS) (1)';
        'If (e is PL) and (De is NS) then (Du is PM) (1)';
        'If (e is NL) and (De is NM) then (Du is NV) (1)';
        'If (e is NM) and (De is NM) then (Du is NV) (1)';
        'If (e is NS) and (De is NM) then (Du is NL) (1)';
        'If (e is ZR) and (De is NM) then (Du is NM) (1)';
        'If (e is PS) and (De is NM) then (Du is NS) (1)';
        'If (e is PM) and (De is NM) then (Du is ZR) (1)';
        'If (e is PL) and (De is NM) then (Du is PS) (1)';
        'If (e is NL) and (De is NL) then (Du is NV) (1)';
        'If (e is NM) and (De is NL) then (Du is NV) (1)';
        'If (e is NS) and (De is NL) then (Du is NV) (1)';
        'If (e is ZR) and (De is NL) then (Du is NL) (1)';
        'If (e is PS) and (De is NL) then (Du is NM) (1)';
        'If (e is PM) and (De is NL) then (Du is NS) (1)';
        'If (e is PL) and (De is NL) then (Du is ZR) (1)';
        'If (e is NL) and (De is NV) then (Du is NV) (1)';
        'If (e is NM) and (De is NV) then (Du is NV) (1)';
        'If (e is NS) and (De is NV) then (Du is NV) (1)';
        'If (e is ZR) and (De is NV) then (Du is NV) (1)';
        'If (e is PS) and (De is NV) then (Du is NL) (1)';
        'If (e is PM) and (De is NV) then (Du is NM) (1)';
        'If (e is PL) and (De is NV) then (Du is NS) (1)';];
    sets = parsrule(sets, ruleBase);
    v = 1;
    if(v)
        f = figure('pos',[10 10 800 600]);
        subplot(3,1,1)
        plotmf(sets,'input',1)
        title('Fuzzy Set of the e variable')
        subplot(3,1,2)
        plotmf(sets,'input',2)
        title('Fuzzy Set of the Δe variable')
        subplot(3,1,3)
        title('Fuzzy Set of the Δu variable')
        plotmf(sets,'output',1)
        saveas(f,'./img/Fuzzy_Sets.png','png')
        showrule(sets)
    end
    writeFIS(sets,'FZPI_codegenerated.fis');
end
   