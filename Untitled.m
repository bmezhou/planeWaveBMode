dyn = 60;

load bfDasTisu.mat;
% bfDas0 = bfDas;
% 
[xq, yq] = demod(bfDas, 5e6, 40e6, 'qam');
bfDas0 = abs(xq + 1i * yq);

bfDas0 = bfDas0(400:end, :);

bfDas0 = bfDas0 - min(min(bfDas0));
bfDas0 = bfDas0/max(max(bfDas0));
bfDas0 = 20*log10(bfDas0) + dyn;
% bfDas0 = bfDas0(961,:);
% 
% x = 0:509;
% x = x * 0.3048e-3/4;

logEnv = (bfDas0) / dyn * 255;
logEnv(logEnv <= 0) = 0;
figure;
image(logEnv);
colormap(gray(256));
ylim([1, 1350])

% load bfDasPhan2.mat;
% load bfMVTisu.mat;
% bfDas1 = bfDas;
[xq, yq] = demod(bfDas, 5e6, 40e6, 'qam');
bfDas1 = abs(xq + 1i * yq);

bfDas1 = bfDas1(400:end, :);

bfDas1 = bfDas1 - min(min(bfDas1));
bfDas1 = bfDas1/max(max(bfDas1));
bfDas1 = 20*log10(bfDas1) + dyn;

[m, n] = size(bfDas1);

for i = 1:n
    bfDas1(:, i) = bfDas1(:, i) .* (1 + 0.3 * (1:m)'./m);
end

logEnv = (bfDas1) / dyn * 255;
logEnv(logEnv <= 0) = 0;
figure;
image(logEnv);
colormap(gray(256));
ylim([1, 1350])
% %{
figure;
plot(bfDas0(1107,:));
hold on
plot(bfDas1(1107,:), 'r');
ylim([-20, 50])

figure;
plot(bfDas0(:, 400));
hold on
plot(bfDas1(:, 400), 'r');
%{
figure;
plot(bfDas0(:, 255));
hold on
plot(bfDas1(:, 255), 'r');
ylim([-120, 0.5])

figure;
plot(bfDas0(862, :));  % 186
hold on
plot(bfDas1(862, :), 'r');
ylim([-120, 0.5])
% load compData.mat;
% 
% figure;
% env = abs(hilbert(compData(50:1300, :)));
% env = env/max(env(:));
% logEnvCM = (20 * log10(env) + 60)/60 *255;
% image(logEnvCM);
% colormap(gray(256));
%}