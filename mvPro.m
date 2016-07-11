function [mvData] = mvPro(steerData)
%% steerData = transpose(steerData);
N_ele     = size(steerData, 1);      % N_ele/2;
% 
% if size(steerData, 2) ~= 1
%     
%     winlen   = N_ele; %floor(N_ele/2);
%     e        = ones(winlen, 1);         %初始化方向向量    
%     FR       = zeros(winlen, winlen);
%     datatemp = zeros(winlen, 1);
%     for kk = 1 : N_ele - winlen + 1
%         for i = 1 : 3
%             Ftemp    = steerData(kk: kk + winlen - 1, i);
%             FR       = FR + Ftemp*(Ftemp');   %winlen*winlen
%         end
%         datatemp = datatemp + steerData(kk: kk + winlen - 1, 2);
%     end
% else
    
% if N_ele < 10
%     winlen   = N_ele;
%     e        = ones(winlen, 1);         %初始化方向向量
%     FR       = steerData * steerData';
%     datatemp = steerData;
%     
%     wm = 1;
% else
%     steerData0 = flipud(steerData);
    
    winlen   = round(N_ele / 2);
    e        = ones(winlen, 1);         %初始化方向向量
    FR       = zeros(winlen, winlen);
    datatemp = zeros(winlen, 1);
    
    for kk = 1 : N_ele - winlen + 1
        Ftemp    = steerData(kk: kk + winlen - 1);
%         Ftemp0   = flipud(Ftemp); 
        FR       = FR + Ftemp*(Ftemp');%+ Ftemp0 * (Ftemp0');            % $winlen \times winlen$
        datatemp = datatemp + Ftemp;
    end
    
%     wm = 0;
% end
% end

% R = (FR + BR)/2;
Rfb = FR/(N_ele - winlen + 1);     % winlen*winlen

%% 对角加载
% delta = ;           % 常量，需要满足     delta<1/winlen       
lamda = 1/(100 * winlen) * trace(Rfb);        % 加载因子或加载量              
Rdl   = Rfb + lamda * eye(winlen); % 对角加载后的空间协方差矩阵

%% Ape design
R1 = Rdl\e;
w = (R1)/(transpose(e) * R1);            % winlen*1
% disp(w);
%
if isnan(w)
    w = zeros(winlen,1);
end

%% Beamform  %%%%%%%%%%%%%%%%%%%%%
mvData = (w')*datatemp/(N_ele - winlen + 1); %sum(W*X)

end


