nCh = 128;              % number of channels
reRoute = true;         % true: transducer element (correct image), false: DAQ element
chanls = ones(1, nCh);  % what channels to read (DAQ element), for each channel set to 1 
                        % if you want to read the data

% Folder path
% path = 'E:\DAQData\20150507\CarotidArtery'; %Carotid
path = 'E:\DAQData\20150507\Thyroid';
if (path(end) ~= '\') 
    path = [path,'\'];
end

j = 87;

[hdr, RF] = readDAQ(path, chanls, j, reRoute);  % 87
RF = RF(1:1000, :);
RF = RF/max(max(RF));
figure;
for i = 1: 128
    plot(RF(:, i) + i);
    hold on;
end
hold off;xlim([0, 250]);