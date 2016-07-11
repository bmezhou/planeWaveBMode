function [arrayData] = Copy_of_delayProc(RF, tTot, alpha)
% tTot = 76;
% alpha = 0;

m = size(RF, 1);

fs = 40e6;
c  = 1540;

eleSpac = 0.3048e-3;

sapSpac = c/fs/2;

arrayData = zeros(m, 509);

deltaZ = sapSpac;


apeSize = 128;

for i = 0: 509
    
    x = i * eleSpac/4;
    
    for j = 150:1300
        z = 1e-3 + (j - 1) * deltaZ;
        
        ttx = z * cos(alpha) + x * sin(alpha);
        steerData = zeros(apeSize, 1);
        
        kBgn = 0;
        for k = 0:127
            
            xi  = k * eleSpac;
            
            trx = sqrt((x - xi)^2 + z^2);
            delay = ((ttx + trx)/c) * fs + tTot;
            
            if (delay > m) || (delay < 1)
                continue;
            end

            steerData(kBgn + 1) = ...
                (delay - floor(delay)) ...
                    * ( RF( ceil(delay), k + 1) - RF(floor(delay), k + 1)) ...
                + RF(floor(delay), k + 1);
%             
            kBgn = kBgn + 1;
            
%             steerData(k + apeSize + 1) = ...
%                 (delay - floor(delay)) ...
%                     * ( RF( ceil(delay), k + iIntep + 1) ...
%                       - RF(floor(delay), k + iIntep + 1)) ...
%                 + RF(floor(delay), round(k + iIntep + 1));
        end
%         figure;
%         plot(steerData); %hold on
        steerData = steerData(1: kBgn);

%         arrayData(j, i + 1) = steerData' * hamming(apeSize);
        arrayData(j, i + 1) = mvPro(steerData);

%         mvPro;        
%         arrayData(j, i + 1) = mvData;
    end          
   
end

end