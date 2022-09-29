clear all
clc
fis = readfis('FZPI.fis');
plotfis(fis);
%% Plotting Rule Firing Strength
[x1,y1]=plotmf(fis,'input',1);
[x2,y2]=plotmf(fis,'input',2);
RuleStrength=zeros(length(y1),length(y2));
count=1;
for i=1:3
    for j=1:3
        figure(count);
        subplot(3,3,[1 4]);
        plot(y2(:,j),x2(:,j),'LineWidth',2); grid on;
        legend(fis.input(2).mf(j).name);
        xlabel(fis.input(2).name);
        subplot(3,3,[8 9])
        plot(x1(:,i),y1(:,i),'LineWidth',2); grid on;
        legend(fis.input(1).mf(i).name);
        xlabel(fis.input(1).name);
        Y1=repmat(y1(:,i),[1 length(y1)]);
        Y2=repmat(y2(:,j),[1 length(y2)])';
        Y=min(Y1,Y2);
        subplot(3,3,[2 3 5 6]);
        surf(x1(:,i),x2(:,j),Y);
        title(['Rule #' num2str(count) 'firing Strength']);
        count=count+1;
        RuleStrength=max(RuleStrength,Y);
    end
end

%% Plot Overall Rule Base
figure;
subplot(3,3,[1 4]);
plot(y2,x2,'LineWidth',2); grid on;
legend(fis.input(2).mf(1).name,fis.input(2).mf(2).name,fis.input(2).mf(3).name);
ylabel(fis.input(2).name);
xlabel('ì');
title('Du');
subplot(3,3,[8 9]);
plot(x1,y1,'LineWidth',2); grid on;
legend(fis.input(1).mf(1).name,fis.input(1).mf(2).name,fis.input(1).mf(3).name);
xlabel(fis.input(1).name);
ylabel('ì');
title('Dc Motor Speed Error');
subplot(3,3,[2 3 5 6]);
surf(linspace(0,10,length(y1)),linspace(0,10,length(y2)),RuleStrength);
xlabel('Error');
ylabel('Input Voltage');
zlabel('ì');
title('Rule Activation Surface');
zlim([0 1]);
input = ['NV' 'NS';
         'PV' 'PL';
         'NS' 'NL'];
output = evalfis(fis,input);
gensurf(fis);
