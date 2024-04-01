%% SL
global C1 C2 alfa1 alfa2
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;

% zmiany wyjścia
Ts = 6000;
wektorSL = [500, 1, 0.1];
Fd(1:Ts) = 11;
yzad(1:550)= 9.9225;
yzad(551:1000)= 12.5;
yzad(1001:2000)= 8;
yzad(2001:3000)= 10;
yzad(3001:4500)= 4;
yzad(4501:6000)= 15;
[E, y, yzad, u] = SL(wektorSL, 3, 'gaus', yzad, Ts, Fd);
disp(E);
figure(1);
stairs(y);
hold on;
grid on;
stairs(yzad);
legend('h2', 'h2 zad', 'Location', 'SE')
title('Wyjście')
% print("Wyjscie_SL.png","-dpng","-r400")
figure(2);
stairs(u);
hold on;
grid on;
title('Sterowanie')
% print("Sterowanie_SL.png","-dpng","-r400")

% zmiany zakłóceń
clear workspace;
Ts = 6000;
yzad(1:Ts)= 9.9225;
Fd(1:1000)= 11;
Fd(1001:2000)= 15;
Fd(2001:Ts)= 5;
wektorSL = [500, 1, 0.1];
[E, y, yzad, u] = SL(wektorSL, 3, 'gaus', yzad, Ts, Fd);

figure(3);
stairs(y);
hold on;
grid on;
stairs(yzad);
legend('h2', 'h2 zad', 'Location', 'SE')
title('Zakłócone wyjście')
% print("ZakW_SL.png","-dpng","-r400")
figure(4);
stairs(u);
hold on;
grid on;
title('Zakłócone sterowanie')
% print("ZakS_SL.png","-dpng","-r400")

%% SL vs DMC
clear workspace;
global C1 C2 alfa1 alfa2
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
% zmiany wyjścia
Ts = 7500;
Fd(1:Ts) = 11;
yzad(1:500)= 9.9225;
yzad(501:1500)= 12.5;
yzad(1501:2500)= 8;
yzad(2501:3500)= 10;
yzad(3501:6000)= 5;
yzad(6001:7500)= 14;

wektorSL = [500, 1, 0.1];
wektorDMCR = [300,1,0.1, 300,1,1, 500,1,0.1, 300,1,0.1];
wektorDMC = [300, 2, 0.1];
[E_sl, y_sl, yzad_sl, u_sl] = SL(wektorSL, 3, 'gaus', yzad, Ts, Fd);
[E_dmc_r, y_dmc_r, yzad_dmc_r, u_dmc_r] = DMC_ana_rozmyty(wektorDMCR, 3, 'gaus', yzad, Ts, Fd);
[E_dmc, y_dmc, yzad_dmc, u_dmc] = DMC_ana(wektorDMC, yzad, Ts, Fd);

figure(5);
stairs(y_sl);
hold on;
grid on;
stairs(y_dmc_r);
stairs(y_dmc);
stairs(yzad_sl);
legend('h2 sl', 'h2 dmc rozmyty', 'h2 dmc','h2 zad', 'Location', 'SE');
title('Wyjście');
% print("Porownanie_wyjscie.png","-dpng","-r400")

figure(6);
stairs(u_sl);
hold on;
grid on;
stairs(u_dmc_r);
stairs(u_dmc);
legend('u sl', 'u dmc rozmyty', 'u dmc', 'Location', 'SE');
title('Sterowanie');
% print("Porownanie_sterowanie.png","-dpng","-r400")

% zmiany zakłóceń
clear workspace;
global C1 C2 alfa1 alfa2
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
yzad(1:Ts)= 9.9225;
Fd(1:1000)= 11;
Fd(1001:2000)= 15;
Fd(2001:Ts)= 5;

wektorSL = [500, 1, 0.1];
wektorDMCR = [300,1,0.1, 300,1,10, 500,1,0.1, 300,1,0.1];
wektorDMC = [300, 2, 0.1];
[E_sl, y_sl, yzad_sl, u_sl] = SL(wektorSL, 3, 'gaus', yzad, Ts, Fd);
[E_dmc_r, y_dmc_r, yzad_dmc_r, u_dmc_r] = DMC_ana_rozmyty(wektorDMCR, 3, 'gaus', yzad, Ts, Fd);
[E_dmc, y_dmc, yzad_dmc, u_dmc] = DMC_ana(wektorDMC, yzad, Ts, Fd);

figure(7);
stairs(y_sl);
hold on;
grid on;
stairs(y_dmc_r);
stairs(y_dmc);
stairs(Fd);
legend('h2 sl', 'h2 dmc rozmyty', 'h2 dmc','Fd')
title('Zakłócone wyjscie')
% print("Porownanie_wyjscie_zak.png","-dpng","-r400")

figure(8);
stairs(u_sl);
hold on;
grid on;
stairs(u_dmc_r);
stairs(u_dmc);
legend('u sl', 'u dmc rozmyty', 'u dmc');
title('Zakłócone sterowanie');
% print("Porownanie_sterowanie_zak.png","-dpng","-r400")