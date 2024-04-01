clear all; 
close all;
clc;

% czas symulacji
Ts = 4000;

% wgranie danych ucz
load("dane_uczace.mat")
load("dane_weryfikujace.mat")

%macierz M
M = zeros(Ts - 5, 4);
for i=6: length ( y_ucz )
	row = [ u_ucz(i -4) u_ucz(i -5)  y_ucz(i -1)  y_ucz(i -2) ];
	M(i-5,:) = row;
end

Y = y_ucz(6:Ts)';
W = M\Y;

y_mod_ucz(1:Ts) = 0;
y_mod_wer(1:Ts) = 0;
for k = 6:Ts
	y_mod_ucz(k) = W(1)*u_ucz(k-4)+W(2)*u_ucz(k-5)+W(3)*y_mod_ucz(k-1)+W(4)*y_mod_ucz(k-2);
	y_mod_wer(k) = W(1)*u_wer(k-4)+W(2)*u_wer(k-5)+W(3)*y_mod_wer(k-1)+W(4)*y_mod_wer(k-2);
end

%liczenie błędu
Error_ucz = 0;
Error_wer = 0;

for k = 1:Ts
	Error_ucz = Error_ucz + (y_ucz(k) - y_mod_ucz(k))^2;
	Error_wer = Error_wer + (y_ucz(k) - y_mod_wer(k))^2;
end

figure(1)
hold on
plot(y_ucz)
plot(y_mod_ucz)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'northwest')
title('Wyjście modelu liniwego dla danych uczących')
print("zad2_8_porownanie_uczace","-dpng","-r800")

figure(2)
hold on
plot(y_wer)
plot(y_mod_wer)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'southwest')
title('Wyjście modelu liniwego dla danych weryfikuyjących')
print("zad2_8_porownanie_weryfikujace","-dpng","-r800")

figure(3)
scatter(y_mod_ucz, y_ucz)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu liniwego z danymi uczącymi ')
print("zad2_8_relacja_uczace","-dpng","-r800")


figure(4)
scatter(y_mod_wer, y_wer)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu liniwego z danymi weryfikującymi ')
print("zad2_8_relacja_weryfikujace","-dpng","-r800")

% print("blad_uczenie_8_1","-dpng","-r800")

fprintf("E_oe_ucz = %f \n", Error_ucz);
fprintf("E_oe_wer = %f \n", Error_wer);
