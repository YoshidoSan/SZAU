function [E, y, yzad, u] = DMC_ana(wektor, yzad, Ts, Fd)
%Definicja horyzontów i parametrów
N = round(wektor(1));
N_u = round(wektor(2));
lambda = wektor(3);
D = 500;
start= D+1;
E = 0;

%stałe
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
tau = 50;
T = 1;

%model
s = pobranie_modelu(55, 52);

%deklaracja początkowych wektorów -> punkt pracy
u = 52 * ones(Ts , 1);
h1 = 9.9221 * ones(Ts , 1);
h2 = 9.9225 * ones(Ts , 1);
dUp = zeros(D-1, 1);

%Obliczenie części macierzy DMC
M = zeros(N, N_u);
for column=1:N_u
    for row=1:N
        if row - column + 1 >= 1
            M(row, column) = s(row - column + 1);
        else
            M(row, column) = 0;
        end
    end
end
L = lambda * eye(N_u);
K = (M.' * M + L) \ M.';
Mp = zeros(N, D-1);
for column=1:(D-1)
    for row=1:N
        Mp(row, column) = s(row + column) - s(column);
    end
end
Ku=K(1,:)*Mp;
Ke=sum(K(1,:));

for k=start:Ts
    %symulacja obiektu
    F1 = u(k-tau);
    h1(k) = ((F1 + Fd(k) - alfa1*sqrt(h1(k-1)))/(2*C1*h1(k-1))) * T + h1(k-1); 
    h2(k) = ((alfa1*sqrt(h1(k-1)) - alfa2*sqrt(h2(k-1))) / (3*C2*(h2(k-1)^2)))  * T + h2(k-1);

    %Obliczenie dUp
    for d=1:(D-1)
        dUp(d) = u(k-d) - u(k-d-1);
    end

    ek=yzad(k)-h2(k);
    
    %Obliczenie sterowania
    dU=Ke*ek-Ku*dUp;
    u(k) = u(k-1) + dU(1);

    E = E + (yzad(k)-h2(k))^2; 
end
%wyniki
y = h2(1:end);
u = u(1:end);
yzad = yzad(1:end);
end