%% DMC rozmyty
% zmiany wyjścia
% close all;
global C1 C2 alfa1 alfa2
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
Ts = 7500;
Fd(1:Ts) = 11;
yzad(1:500)= 9.9225;
yzad(501:1500)= 12.5;
yzad(1501:2500)= 8;
yzad(2501:3500)= 10;
yzad(3501:6000)= 5;
yzad(6001:7500)= 14;

% 4 obszary bo błąd dla 4 ma 'dołek'
wektorDMCR = [300,1,0.1, 300,1,1, 500,1,0.5];
[E_dmc_r, y_dmc_r, yzad_dmc_r, u_dmc_r] = DMC_ana_rozmyty(wektorDMCR, 3, 'gaus', yzad, Ts, Fd);
disp(E_dmc_r);
figure(1);
stairs(y_dmc_r);
hold on;
grid on;
stairs(yzad);
legend('h2','h2 zad', 'Location', 'SE');
title('Wyjście');
% print("DMC_roz_wyj.png","-dpng","-r400")
figure(2);
stairs(u_dmc_r);
hold on;
grid on;
title('Sterowanie');
% print("DMC_roz_ster.png","-dpng","-r400")

%% zmiany zakłóceń
global C1 C2 alfa1 alfa2
wektorDMCR = [300,1,0.1, 300,1,1, 500,1,0.5];
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
Ts = 7500;
yzad(1:Ts)= 9.9225;
Fd(1:1000)= 11;
Fd(1001:2000)= 15;
Fd(2001:Ts)= 5;
[E_dmc_r, y_dmc_r, yzad_dmc_r, u_dmc_r] = DMC_ana_rozmyty(wektorDMCR, 3, 'gaus', yzad, Ts, Fd);

figure(3);
stairs(y_dmc_r);
hold on;
grid on;
stairs(Fd);
legend('h2','Fd')
title('Zakłócone wyjście')
% print("DMC_roz_wyj_zak.png","-dpng","-r400")
figure(4);
stairs(u_dmc_r);
hold on;
grid on;
title('Zakłócone sterowanie');
% print("DMC_roz_ster_zak.png","-dpng","-r400")