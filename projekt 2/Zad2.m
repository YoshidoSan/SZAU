clc;
clear all;
close all

% Zlołdowanie modelu
run("sieci\model.m")
% run("model_best_zad22.m")

load("dane_uczace.mat")
load("dane_weryfikujace.mat")

Ts = 4000;

%obliczenie wyjścia 
y_mod_ucz_oe(1:5) = y_ucz(1:5);
y_mod_ucz_arx(1:5) = y_ucz(1:5);

y_mod_wer_oe(1:5) = y_wer(1:5);
y_mod_wer_arx(1:5) = y_wer(1:5);

for k = 6:Ts
	%dane uczące
	q_oe_ucz = [u_ucz(k-4); u_ucz(k-5); y_mod_ucz_oe(k-1); y_mod_ucz_oe(k-2)];
	q_arx_ucz = [u_ucz(k-4); u_ucz(k-5); y_ucz(k-1); y_ucz(k-2)];
	
	y_mod_ucz_oe(k) = w20 + w2*tanh(w10+ w1*q_oe_ucz);
	y_mod_ucz_arx(k) = w20 + w2*tanh(w10+ w1*q_arx_ucz);

	%dane weryfikujące
	q_oe_wer = [u_wer(k-4); u_wer(k-5); y_mod_wer_oe(k-1); y_mod_wer_oe(k-2)];
	q_arx_wer = [u_wer(k-4); u_wer(k-5); y_wer(k-1); y_wer(k-2)];
	
	y_mod_wer_oe(k) = w20 + w2*tanh(w10+ w1*q_oe_wer);
	y_mod_wer_arx(k) = w20 + w2*tanh(w10+ w1*q_arx_wer);
end




Error_ucz_arx = 0;
Error_ucz_oe = 0;

Error_wer_arx = 0;
Error_wer_oe = 0;
for k = 1:Ts
	Error_ucz_arx = Error_ucz_arx + (y_ucz(k) - y_mod_ucz_arx(k))^2;
	Error_ucz_oe = Error_ucz_oe + (y_ucz(k) - y_mod_ucz_oe(k))^2;

	Error_wer_arx = Error_wer_arx + (y_wer(k) - y_mod_wer_arx(k))^2;
	Error_wer_oe = Error_wer_oe + (y_wer(k) - y_mod_wer_oe(k))^2;
end

figure(1)
hold on
plot(y_ucz)
plot(y_mod_ucz_oe)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'northwest')
title('Wyjście modelu dla danych uczących')
% print("zad2_7_porownanie_uczace_naj","-dpng","-r800")

figure(2)
hold on
plot(y_wer)
plot(y_mod_wer_oe)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'southwest')
title('Wyjście modelu dla danych weryfikuyjących')
% print("zad2_7_porownanie_weryfikujace_naj","-dpng","-r800")

figure(3)
scatter(y_mod_ucz_oe, y_ucz)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu z danymi uczącymi ')
% print("zad2_7_relacja_uczace_naj","-dpng","-r800")


figure(4)
scatter(y_mod_wer_oe, y_wer)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu z danymi weryfikującymi ')
% print("zad2_7_relacja_weryfikujace_naj","-dpng","-r800")

% print("blad_uczenie_8_1","-dpng","-r800")

fprintf("E_oe_wer = %f \n", Error_wer_oe);
fprintf("E_oe_ucz = %f \n", Error_ucz_oe);


