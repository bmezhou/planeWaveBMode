load compDataMVL.mat;

figure;
env = abs(hilbert(compData(200:1300, :)));
env = env/max(env(:));
logEnvC = (20 * log10(env) + 60)/60 *255;
image(logEnvC);
colormap(gray(256));
xlim([150, 450])


load compDataL.mat;

figure;
env = abs(hilbert(compData(200:1300, :)));
env = env/max(env(:));
logEnvC = (20 * log10(env) + 60)/60 *255;
image(logEnvC);
colormap(gray(256));
xlim([150, 450])

%{
load compDataMV.mat;

figure;
env = abs(hilbert(compData(100:1800, :)));
env = env/max(env(:));
logEnvC = (20 * log10(env) + 68)/70 *255;
image(logEnvC);
colormap(gray(256));
% ylim([1350, 1450])
% xlim([45, 100])

load compDataDas.mat;

figure;
env = abs(hilbert(compData(100:1800, :)));
env = env/max(env(:));
logEnvC = (20 * log10(env) + 68)/70 *255;
image(logEnvC);
colormap(gray(256));
% ylim([1350, 1450])
% xlim([45, 100])
% load compDataDasSimFull.mat;
% 
% figure;
% env = abs(hilbert(compData(100:1300, :)));
% env = env/max(env(:));
% logEnvC = (20 * log10(env) + 50)/60 *255;
% image(logEnvC);
% colormap(gray(256));
%}