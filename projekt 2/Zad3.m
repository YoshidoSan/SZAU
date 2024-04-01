clear all;
close all;

load("dane_uczace.mat")
load("dane_weryfikujace.mat")


X_UCZ = zeros(4, length(u_ucz));
Y_UCZ = zeros(1,length(y_ucz));

X_UCZ(1,5:end) = u_ucz(1:end-4);
X_UCZ(2,4:end) = u_ucz(1:end-3);
X_UCZ(3,2:end) = y_ucz(1:end-1);
X_UCZ(4,3:end) = y_ucz(1:end-2);
Y_UCZ(1:end) = y_ucz(1:end);



K = 8; % liczba neuronów ukrytych

% alguczenia='trainlm';%alg. Levenberga-Marquardta
alguczenia='traincgp';%alg. gradientów sprzężonych Poljaka-Polaka-Ribiery

sn=feedforwardnet(K,alguczenia);

sn.performFcn ='sse';
sn.trainParam.show = 10;
sn.trainParam.showCommandLine = 1;
sn.trainParam.epochs = 800;
sn.trainParam.goal = 0.00001;
sn.trainParam.showWindow = 0;

%dane: tylko zbiór uczący
sn.divideFcn = 'divideind';
sn.divideParam.trainInd = [1:length(Y_UCZ)];
sn.divideParam.valInd = [];
sn.divideParam.testInd = [];

sn.input.processFcns = { };
sn.output.processFcns= { };

[sn,uczenie]=train(sn,X_UCZ, Y_UCZ);

ymod_ucz=sim(sn,X_UCZ);

Eucz=(Y_UCZ-ymod_ucz)*(Y_UCZ-ymod_ucz)';



y_mod_ucz_oe(1:5) = y_ucz(1:5);
y_mod_ucz_arx(1:5) = y_ucz(1:5);

y_mod_wer_oe(1:5) = y_wer(1:5);
y_mod_wer_arx(1:5) = y_wer(1:5);

Ts = length(u_ucz);
for k = 6:Ts
	%dane uczące
	q_oe_ucz = [u_ucz(k-4); u_ucz(k-5); y_mod_ucz_oe(k-1); y_mod_ucz_oe(k-2)];
	q_arx_ucz = [u_ucz(k-4); u_ucz(k-5); y_ucz(k-1); y_ucz(k-2)];
	

	y_mod_ucz_oe(k) = sn(q_oe_ucz);
	y_mod_ucz_arx(k) = sn(q_arx_ucz);

	%dane weryfikujące
	q_oe_wer = [u_wer(k-4); u_wer(k-5); y_mod_wer_oe(k-1); y_mod_wer_oe(k-2)];
	q_arx_wer = [u_wer(k-4); u_wer(k-5); y_wer(k-1); y_wer(k-2)];
	
	y_mod_wer_oe(k) = sn(q_oe_wer);
	y_mod_wer_arx(k) = sn(q_arx_wer);
end


figure(1)
hold on
plot(y_ucz)
plot(y_mod_ucz_oe)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'northwest')
title('Wyjście modelu OE dla danych uczących')
% print("zad3_porownanie_uczace_OE_2alg_2","-dpng","-r800")

figure(2)
hold on
plot(y_wer)
plot(y_mod_wer_oe)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'southwest')
title('Wyjście modelu OE dla danych weryfikuyjących')
% print("zad3_porownanie_weryfikujace_OE_2alg_2","-dpng","-r800")

figure(3)
scatter(y_mod_ucz_oe, y_ucz)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu OE z danymi uczącymi ')
% print("zad3_relacja_uczace_OE_2alg_2","-dpng","-r800")


figure(4)
scatter(y_mod_wer_oe, y_wer)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu OE z danymi weryfikującymi ')
% print("zad3_relacja_weryfikujace_OE_2alg_2","-dpng","-r800")


figure(5)
hold on
plot(y_ucz)
plot(y_mod_ucz_arx)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'northwest')
title('Wyjście modelu ARX dla danych uczących')
% print("zad3_porownanie_uczace_ARX_2alg_2","-dpng","-r800")

figure(6)
hold on
plot(y_wer)
plot(y_mod_wer_arx)
xlabel('k')
ylabel('y')
legend('dane', 'model', 'Location', 'southwest')
title('Wyjście modelu ARX dla danych weryfikuyjących')
% print("zad3_porownanie_weryfikujace_ARX_2alg_2","-dpng","-r800")

figure(7)
scatter(y_mod_ucz_arx, y_ucz)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu ARX z danymi uczącymi ')
% print("zad3_relacja_uczace_ARX_2alg_2","-dpng","-r800")


figure(8)
scatter(y_mod_wer_arx, y_wer)
ylabel('dane')
xlabel('model')
title('Relacja wyjścia modelu ARX z danymi weryfikującymi ')
% print("zad3_relacja_weryfikujace_ARX_2alg_2","-dpng","-r800")


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

fprintf("E_oe_wer = %f \n", Error_wer_oe);
fprintf("E_oe_ucz = %f \n", Error_ucz_oe);

