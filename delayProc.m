function [arrayData1, arrayData2, apeSizeLine] = delayProc(RF, tTot)
% tTot = 76;
% alpha = 0;

[m, n] = size(RF);

fs = 40e6;
c  = 1540;

eleSpac = 0.3048e-3;

sapSpac = c/fs/2;

arrayData1 = zeros(m, 255);
arrayData2 = zeros(m, 255);

deltaZ = sapSpac;

apeSizeLine = zeros(1, 1791);

parfor i = 0: 254
%     disp(i);
    x = i * eleSpac/2;
    
    iIntep = round(x/eleSpac);
    
    for j = 10:1800
        z = 1e-3 + (j - 1) * deltaZ;
        
        ttx = z;
        apeSize = round(z/3.4/0.3048 * 1e3);  % 2.8
        
        if apeSize < 6
            apeSize = 6;
        end
%         if apeSize > 36  
%             apeSize = 36;
%         end
%         apeSize = 36;
        
%         if i == 1
%             apeSizeLine(j) = apeSize;
%         end

        steerData = zeros(apeSize * 2 + 1, 1);
        
        kBgn = 1;
        
        for k = -apeSize:apeSize
            
            if (k + iIntep < 0) || (k + iIntep >= n)
                continue;
            end
            
            xi  = (k + iIntep) * eleSpac;
            
            trx = sqrt((x - xi)^2 + z^2);
            delay = ((ttx + trx)/c) * fs + tTot;
            
            if (delay > m) || (delay < 1)
                continue;
            end
            
%             steerData(kBgn, 1) = ...
%                RF(floor(delay), k + iIntep + 1);

            steerData(kBgn) = ...
                (delay - floor(delay)) ...
                  * ( RF( ceil(delay), k + iIntep + 1) ...
                    - RF(floor(delay), k + iIntep + 1)) ...
               + RF(floor(delay), k + iIntep + 1);
           
%             steerData(kBgn, 3) = ...
%                RF(ceil(delay - 1), k + iIntep + 1);           
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


        arrayData1(j, i + 1) = steerData' * hanning(apeSize * 2 + 1);
        
        arrayData2(j, i + 1) = mvPro(steerData(1: kBgn - 1, :));
    end          
end

end