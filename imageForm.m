function [logEnvIntp] = imageForm(bfDas)


[xq, yq] = demod(bfDas, 5e6, 40e6, 'qam');
    

env = abs(xq + 1i*yq);
env = env/max(env(:));
logEnvC = (20 * log10(env) + 60)/60 *255;
    
logEnvC(logEnvC < 0) = 0;

dx = 0.3048e-3/2;
dy = 1540/40e6/2;
    
x0 = 0:dx:(size(env,2) - 1)*dx;
y0 = 0:dy:(size(env,1) - 1)*dy;
    
x1 = 0:0.1e-3:max(x0);
y1 = 0:0.1e-3:max(y0);
    
[xo, yo] = meshgrid(x0, y0);
[xi, yi] = meshgrid(x1, y1);
    
logEnvIntp = interp2(xo, yo, logEnvC, xi, yi);

end