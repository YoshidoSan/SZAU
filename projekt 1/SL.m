function [E, y, yzad, u]=SL(wektor, liczba_obszarow, typ_funkcji, yzad, Ts, Fd)
%Definicja horyzontów i parametrów
N = wektor(1);
N_u = wektor(2);
lambda = wektor(3);
u_min = 0;
u_max = 200;
y_min = 0;
y_max = 15;
s = pobranie_modelu_rozmyte(liczba_obszarow);
functions = funkcje_podzialu(liczba_obszarow, typ_funkcji, y_min, y_max);
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

for k=start:Ts
    %symulacja obiektu
    F1 = u(k-tau);
    h1(k) = ((F1 + Fd(k) - alfa2*sqrt(h1(k-1)))/(2*C1*h1(k-1))) * T + h1(k-1); 
    h2(k) = ((alfa1*sqrt(h1(k-1)) - alfa2*sqrt(h2(k-1))) / (3*C2*(h2(k-1)^2)))  * T + h2(k-1);

    %rozmywanie
    sum_ster = 0;
    for i=1:liczba_obszarow
        sum_ster = sum_ster + functions{i}(h2(k));
    end
    
    s_j = zeros(1, D);
    for j=1:D
        for i=1:liczba_obszarow
            s_j(j) = s_j(j) + (functions{i}(h2(k))/sum_ster)*s{i}(j);
        end
    end
    
    %lokalny model liniowy
    Mk = zeros(N, N_u);
    for column=1:N_u
        for row=1:N
           if (row>=column)
             if(row-column+1<=D)
                Mk(row,column)=s_j(row-column+1);
             else
               Mk(row,column)=s_j(D);
             end
          end
        end
    end

    M_pk = zeros(N, D-1);
    for column=1:(D-1)
        for row=1:N
            if row + column > D
                if column>D
                    M_pk(row, column) = 0;
                else
                    M_pk(row, column) = s_j(D) - s_j(column);
                end
            else
                M_pk(row, column) = s_j(row + column) - s_j(column);
            end
        end
    end

    %Obliczenie DU_p
    for d=1:(D-1)
        dUp(d) = u(k-d) - u(k-d-1);
    end

    %Obliczenie sterowania
    Y = ones(N, 1) * h2(k);
    Yzad = ones(N, 1) * yzad(k);
    Y0 =  M_pk * dUp + Y;
    L = lambda*eye(N_u);

    H = 2*((Mk')*Mk + L);
    F = -2*(Yzad - Y0)'*Mk;
    A =  [-1*ones(1,N_u); ones(1,N_u)];
    B = [u(k-1)-u_min; u_max-u(k-1)];
    dU = quadprog(H, F, A, B);

    u(k) = u(k-1) + dU(1);

    if u(k)>u_max
        u(k) = u_max;
    elseif u(k)<u_min
        u(k) = u_min;
    end

    E = E + (yzad(k)-h2(k))^2;

end
%wyniki
y = h2;
end
