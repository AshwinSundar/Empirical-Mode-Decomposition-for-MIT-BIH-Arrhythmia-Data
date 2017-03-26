% This is just to generate a diagram of what I'm doing in
% fDeviationMatrix.m. I'm basically finding the area between two curves.
% This function will generate a plot for me based on whatever two curves I
% pick. 

cd('Correlations'); % enter the correct directory
t = 0:1:72;
% [N,~,~] = xlsread('Correlations.xlsx',-1);
[AFIB,~,~] = xlsread('Correlations.xlsx',-1); 
AFIB = AFIB - (mean(AFIB) - mean(N));
t = [t,fliplr(t)];              
Y = [N,fliplr(AFIB)];
plot(Y);
legend('Normal sinus rhythm')
legend('Atrial fibrillation')
fill(t,Y,'r');  

cd ..; % go back a level