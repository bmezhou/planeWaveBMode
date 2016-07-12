clc;
clear;

nCh = 128;              % number of channels
reRoute = true;         % true: transducer element (correct image), false: DAQ element
chanls = ones(1, nCh);  % what channels to read (DAQ element), for each channel set to 1 
                        % if you want to read the data

% Folder path
% path = 'E:\DAQData\43angles'; %Carotid
% path = 'E:\DAQData\20150607   \Thyroid';
path = 'C:\DaqData\20160518';
if (path(end) ~= '\') 
    path = [path,'\'];
end



% load G:\2.2.MatlabWork\Ultrasonics\fieldExamples\psfMV\psfRF.mat; %rf_data

% RF = zeros(2*size(rf_data, 1)-1, size(rf_data,2));
% for i = 1:128
%     RF(:, i) = interp1(0:size(rf_data, 1)-1, rf_data(:, i), 0:0.5:size(rf_data, 1)-1, 'spline');
% end
% 
% [hdr, RF] = readDAQ(path, chanls, j, reRoute);  % 87
% RF = RF(1:1000, :);
% RF = RF/max(max(RF));
% figure;
% for i = 1: 128
%     plot(RF(:, i) + i);
%     hold on;
% end
% hold off;xlim([0, 250]);

% bfDas = delayProc(RF, 77, 0);
%%
pitch = 0.3048e-3;
c     = 1540;
% h0    = c/80e6;
 
% alphaB = atan(2*h0/pitch);
% alphaT = 0: alphaB/21: alphaB;
%%
% for j = 88 : 10 : 87 + 43 - 1
    j = 87;
    
    [hdr, RF] = readDAQ(path, chanls, j, reRoute);  % 87
%     load G:\2.2.MatlabWork\Ultrasonics\fieldExamples\psfMV\rfData\psfRF0.mat; %rf_data
%     RF = rf_data;
    
%     alpha = alphaT(round((j-87)/2) + 1);

    [bfDas1, bfDas2, apeSize] = delayProc(RF, 73);  % -42
%     bfDas2 = delayProc(RF, 73);  % -42
%     bfDas = Copy_of_delayProc(RF, -42, alpha);
    
%     cmd = ['save bfDas', num2str(j), '.mat bfDas;'];
%     eval(cmd);
%     save bfDas.mat bfDas;
%     save bfMVTisu.mat bfDas;
    save bfMVPhan2.mat bfDas1 bfDas2;
    
%     save bfDasPhan1.mat bfDas;
%     save bfDasTisu.mat bfDas;

%     figure;
    logEnvIntp1 = imageForm(bfDas1);
    logEnvIntp2 = imageForm(bfDas2);
    
    figure;
    image(logEnvIntp1);
    colormap(gray(256));
%     axis('image');
    ylim([0, 1800]);
    
    figure;
    image(logEnvIntp2);
    colormap(gray(256));
%     axis('image');
    ylim([0, 1800]);
    
    figure;
    plot(logEnvIntp1(:, 150));
    hold on
    plot(logEnvIntp2(:, 150) + 47, 'r');
