% function [  ] = cfiDataLoad( ~ )
%CFIDATALOAD Summary of this function goes here
%   Detailed explanation goes here
% parameters
clc
clear;

nCh = 128;              % number of channels
reRoute = true;         % true: transducer element (correct image), false: DAQ element
chanls = ones(1, nCh);  % what channels to read (DAQ element), for each channel set to 1 
                        % if you want to read the data

% Folder path
path = 'E:\DAQData\43angles'; %Carotid
if (path(end) ~= '\') 
    path = [path,'\'];
end

cmd = 'load G:\2.2.MatlabWork\Ultrasonics\fieldExamples\psfMV\rfData\psfRF0.mat;';
eval(cmd);
RF = rf_data;
bfDas = delayProc(RF, -42, 0);
% %{
%%
pitch = 0.3048e-3;
c     = 1540;
h0    = c/80e6;

alphaB = atan(2*h0/pitch);
alphaT = 0: alphaB/21: alphaB;
%%
compData = bfDas;

[m, n] = size(compData);
% %{
% 92 : 12 : 87 + 43 - 1
% 88 : 10 : 87 + 43 - 1
% 88 :  2 : 87 + 43 - 1
for j = 1 : 2 : 42
    disp(j);

    cmd = ['load G:\2.2.MatlabWork\Ultrasonics\fieldExamples\psfMV\rfData\psfRF',num2str(j),'.mat;'];
    eval(cmd);

    alpha = alphaT(round((j)/2) + 1);
    
    bfDas = delayProc(rf_data, -round(tstart * 40e6), alpha);
    bfDas = bfDas(1:m, :);
    
    compData = bfDas + compData;
    
    %
    cmd = ['load G:\2.2.MatlabWork\Ultrasonics\fieldExamples\psfMV\rfData\psfRF',num2str(j+1),'.mat;'];
    eval(cmd);

    rf_data = fliplr(rf_data);
    bfDas = delayProc(rf_data, -round(tstart * 40e6), alpha);
    bfDas = fliplr(bfDas);
    bfDas = bfDas(1:m, :);
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

% save compDataMVSim.mat compData;
% save compDataDasSim.mat compData;
save compDataDasSimFull.mat compData;

figure;
env = abs(hilbert(compData(50:1300, :)));
env = env/max(env(:));
logEnvC = (20 * log10(env) + 55)/60 *255;
image(logEnvC);
colormap(gray(256));

benchMark;
%}