% function [  ] = cfiDataLoad( ~ )
%CFIDATALOAD Summary of this function goes here
%   Detailed explanation goes here
% parameters
nCh = 128;              % number of channels
reRoute = true;         % true: transducer element (correct image), false: DAQ element
chanls = ones(1, nCh);  % what channels to read (DAQ element), for each channel set to 1 
                        % if you want to read the data

% Folder path
path = 'E:\DAQData\43angles'; %Carotid
if (path(end) ~= '\') 
    path = [path,'\'];
end

[hdr, RF] = readDAQ(path, chanls, 87, reRoute);  % 87

RF = RF/max(max(RF));
% figure;
% for i = 1: 128
%     plot(RF(:, i) + i);
%     hold on;
% end
% hold off;xlim([0, 250]);

bfDas = beamFormAngle(RF, 77, 0);

compData = zeros(size(bfDas));
% %{
%%
pitch = 0.3048e-3;
c     = 1540;
h0    = c/80e6;
 
alphaB = atan(2*h0/pitch);
alphaT = 0: alphaB/21: alphaB;
%%

[hdr, RF] = readDAQ(path, chanls, 87, reRoute);

bfDas = beamFormAngle(RF, 76, 0);
% save bfDasC.mat bfDasC;
compData = bfDas + compData;
% %{
% 92 : 12 : 87 + 43 - 1
% 88 : 10 : 87 + 43 - 1
% 88 :  2 : 87 + 43 - 1
for j = 88 : 10 : 87 + 43 - 1
    disp(j);
    [~, RF] = readDAQ(path, chanls, j, reRoute);
    
    alpha = alphaT(round((j-87)/2) + 1);
    
    bfDas = beamFormAngle(RF, 76, alpha);    
    compData = bfDas + compData;
    
    %
    [hdr, RF] = readDAQ(path, chanls, j+1, reRoute);
    
    RF = fliplr(RF);
    bfDas = beamFormAngle(RF, 76, alpha);
    bfDas = fliplr(bfDas);
    
    compData = bfDas + compData;

%     env = abs(hilbert(bfDas1));
%     env = env/max(env(:));
%     logEnv = (20 * log10(env) + 60)/60 *255;

%     figure;
%     image(logEnv);
%     colormap(gray(256));
%     title(j)
%     drawnow;
end

figure;
env = abs(hilbert(compData(50:1300, :)));
env = env/max(env(:));
logEnvC = (20 * log10(env) + 60)/60 *255;
image(logEnvC);
colormap(gray(256));

save compDataL.mat compData;

benchMark;
%}