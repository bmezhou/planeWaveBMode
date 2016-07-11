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

% load G:\2.2.MatlabWork\Ultrasonics\fieldExamples\psfMV\psfRF.mat; %rf_data

% RF = [zeros(round(tstart * 40e6), 128); rf_data];

bfDas = beamFormAngle(RF, 77, 0);

% bfDas = zeros(size(bfDasT));
% bfDas(200:800, 1:251) = bfDasT(200:800, 1:251);

env = abs(hilbert(bfDas(50:1400, :)));
env = env/max(env(:));
logEnvC0 = (20 * log10(env) + 55)/60 *255;

logEnvC0(logEnvC0 < 0) = 0;

% dx = 0.3048e-3/4;
% dy = 1540/40e6/2;
% 
% if dx > dy
%     di = dy;
% else
%     di = dx;
% end

% [xo, yo] = meshgrid(0:dx:(size(env,2) - 1)*dx, 0:dy:(size(env,1)-1)*dy);
% [xi, yi] = meshgrid(0:di:(size(env,2) - 1)*dx, 0:di:(size(env,1)-1)*dy);
% logEnvC0 = interp2(xo, yo, logEnvC0, xi, yi);

figure;
image(logEnvC0);
colormap(gray(256));

% xlim([1, 250]);
% ylim([150, 750])
% axis('image');
% figure;
% plot(logEnvC(608,:))
% hold on
% plot(logEnvC0(608,:), 'r')
