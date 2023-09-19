Imax = 20;  % peak current (A)
f = 50;    % frequency electric supply in (Hz)
T = 1/f;    % electrical period
s = 100; % sampling per period

for   i = 1:s;  % electrical time for 1 period
    t(i) = i*(T/s);
    i_A = Imax*sin(2*pi*f*t); 
    i_B = Imax*sin(2*pi*f*t - 2*pi/3) ;
    i_C = Imax*sin(2*pi*f*t + 2*pi/3);
end

figure
plot(t, i_A)
hold
plot(t, i_B)
plot(t, i_C)
grid
legend('i_A','i_B','i_C')