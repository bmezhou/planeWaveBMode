pitch = 0.3048e-3;
c     = 1540;
h0    = c/80e6;
 
alphaB = atan((0:2)*h0/pitch);
%%
numOfAng = 22;  % Number of steer angles including the zero beam.
init = atan(2*h0/pitch);  % The maximum steered angle.

%%
delta = init / (numOfAng - 1);

alphaM = zeros(1, numOfAng);
m1 = zeros(1, numOfAng);
n1 = zeros(1, numOfAng);

for i = 2:numOfAng - 1
    angTest = (i-1) * delta;
    temp = 10;
    for m = 1:20
        for n = 1:8
            alpha = atan(m*h0/pitch/n);
            dev = abs(alpha - angTest);
            if (dev < 0.05/180 * pi)
                break;
            end
            if dev < temp
                temp = dev;
                alphaM(i) = alpha;
                m1(i) = m;
                n1(i) = n;
            end
        end
    end
end
m1(numOfAng) = 2;
n1(numOfAng) = 1;
alphaM(numOfAng) = init;

%%
figure;
plot(0:numOfAng - 1, alphaM/pi*180, 'o-');
hold on
plot([0 numOfAng - 1], [0, init/pi*180], 'r')
xlim([0, numOfAng - 1])
hold off;