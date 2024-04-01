function [E, y, yzad, u]=DMC_ana_rozmyty(wektor, liczba_regulatorow, typ_funkcji, yzad, Ts, Fd)
%Definicja horyzontów i parametrów
% wektor = [N1, Nu1, lambda1, N2, Nu2, lambda2, ...];
N(1:length(wektor)/3) = wektor(1:3:length(wektor));
N_u(1:length(wektor)/3) = wektor(2:3:length(wektor));
lambda(1:length(wektor)/3) = wektor(3:3:length(wektor));

s = pobranie_modelu_rozmyte(liczba_regulatorow);
M = cell(1,liczba_regulatorow);
u_min = 0;
u_max = 200;
y_min = 0;
y_max = 15;
functions = funkcje_podzialu(liczba_regulatorow, typ_funkcji, y_min, y_max);

D = 600;
start= D+1;
E = 0;

%stałe
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
tau = 50;
T = 1;

%deklaracja początkowych wektorów -> punkt pracy
u = 52 * ones(Ts , 1);
h1 = 9.9221 * ones(Ts , 1);
h2 = 9.9225 * ones(Ts , 1);
dUp = zeros(D-1, 1);


%Obliczenie części macierzy DMC
for i=1:liczba_regulatorow
    M{i} = zeros(N(i), N_u(i));
    for column=1:N_u(i)
        for row=1:N(i)
           if (row>=column)
             if(row-column+1<=D)
                    M{i}(row,column)=s{i}(row-column+1);
                  else
                   M{i}(row,column)=s{i}(D);
             end
          end
        end
    end
end

K = cell(1,liczba_regulatorow);
for i=1:liczba_regulatorow
    K{i} = (M{i}'*M{i}+lambda(i)*eye(N_u(i), N_u(i)))^(-1)*M{i}';
end

Mp = cell(1, liczba_regulatorow);
for i=1:liczba_regulatorow
    Mp{i} = zeros(N(i), D-1);
    for column=1:(D-1)
        for row=1:N(i)
            if row + column > D
                if column>D
                    Mp{i}(row, column) = 0;
                else
                    Mp{i}(row, column) = s{i}(D) - s{i}(column);
                end
            else
                Mp{i}(row, column) = s{i}(row + column) - s{i}(column);
            end
        end
    end
end

Ku = cell(1,liczba_regulatorow);
for i=1:liczba_regulatorow
    Ku{i} = K{i}(1,:)*Mp{i};
end
Ke = cell(1,liczba_regulatorow);
for i=1:liczba_regulatorow
    Ke{i} = sum(K{i}(1,:));
end

for k=start:Ts
    %symulacja obiektu
    F1 = u(k-tau);
    h1(k) = ((F1 + Fd(k) - alfa1*sqrt(h1(k-1)))/(2*C1*h1(k-1))) * T + h1(k-1); 
    h2(k) = ((alfa1*sqrt(h1(k-1)) - alfa2*sqrt(h2(k-1))) / (3*C2*(h2(k-1)^2)))  * T + h2(k-1);

    ek=yzad(k)-h2(k);

    %Obliczenie dU_p
    for d=1:(D-1)
        dUp(d) = u(k-d) - u(k-d-1);
    end
    
    %Rozmywanie i bliczenie sterowania
    sum_ster = 0;
    for i=1:liczba_regulatorow
        sum_ster = sum_ster + functions{i}(h2(k));
    end

    dU = cell(1,liczba_regulatorow);
    for i=1:liczba_regulatorow
        dU{i}=Ke{i}*ek-Ku{i}*dUp;

        if dU{i} < -(u(k-1)-u_min)
            dU{i} = -(u(k-1)-u_min);
        elseif dU{i} > u_max-u(k-1)
            dU{i} = u_max-u(k-1);
        end

    end
    
    U=0;
    for i =1:liczba_regulatorow
        U = U + (functions{i}(h2(k))/sum_ster)*dU{i}; 
    end

    u(k) = u(k-1) + U;
    
    if u(k)>u_max
        u(k) = u_max;
    elseif u(k)<u_min
        u(k) = u_min;
    end
    
    E = E + (yzad(k)-h2(k))^2;
end
%wyniki
y = h2(1:end);
u = u(1:end);
yzad = yzad(1:end);
end