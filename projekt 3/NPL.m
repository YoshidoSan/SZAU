function[E, y, u] = NPL(paramtery)
run("model_NPL.m")
global y_zad Ts
% paramtery regulatora
D = 100;
N = round(paramtery(1)); 
Nu = round(paramtery(2)); 
lambda = round(paramtery(3)); 
delta = 0.000001;
% parametry obiektu;
alfa1 = -1.413505;
alfa2 = 0.462120;
beta1 = 0.016447;
beta2 = 0.012722;
%inicjalizacja wektorów
x1 = zeros(1, Ts);
x2 = zeros(1, Ts);
y = zeros(1, Ts);
u = zeros(1, Ts);
d = zeros(1, Ts);
E = zeros(1, Ts);
start = 6;
% symulacja
for k=start:Ts
    % obiekt
    x1(k) = -alfa1*x1(k-1)+x2(k-1)+beta1*g1(u(k-4));
    x2(k) = -alfa2*x1(k-1)+beta2*g1(u(k-4));
    y(k) = g2(x1(k));
    
    E(k) = y_zad(k) - y(k);

    % dokładność modelu
    d(k) = y(k) - (w20 + w2*tanh(w10+w1*[u(k-4) u(k-5) y(k-1) y(k-2)]'));
    %linearyzacja
	f = (w20 + w2*tanh(w10+w1*[u(k-4) u(k-5) y(k-1) y(k-2)]'));
    NPL_b4 = ((w20 + w2*tanh(w10 + w1 * [u(k-4) + delta u(k-5) y(k-1) y(k-2)]'))  - f) / delta;
    NPL_b5 = ((w20 + w2*tanh(w10 + w1* [u(k-4) u(k-5) + delta y(k-1) y(k-2)]'))  - f) / delta;
    NPL_a1 = ((w20 + w2*tanh(w10 + w1* [u(k-4) u(k-5) y(k-1) + delta y(k-2)]'))  - f) / delta;
    NPL_a2 = ((w20 + w2*tanh(w10 + w1* [u(k-4) u(k-5) y(k-1) y(k-2) + delta]'))  - f) / delta;

    % symulacja odpowiedzi skokowej
    sym_NPL_y(1:D+6) = 0;
    sym_NPL_u(1:D+6) = 0;
    sym_NPL_u(6:end) = 1;
    for i=7:D+6
        sym_NPL_y(i) = NPL_b4 * sym_NPL_u(i-4) + NPL_b5 * sym_NPL_u(i-5) + NPL_a1*sym_NPL_y(i-1) + NPL_a2*sym_NPL_y(i-2);
    end
    S_NPL = sym_NPL_y(6:end);

    % macierz M
    M_NPL = zeros(N,Nu);
    for i=1:N
        for j=1:Nu
            if(i>=j)
                M_NPL(i,j) = S_NPL(i-j+1);
            end
        end
    end

    % K
    K_NPL = ((M_NPL'  * M_NPL + eye(Nu) * lambda)^-1) * M_NPL';

    % nieliniowa predykcja
    y(k+1) = w20 + w2*tanh(w10+w1*[u(k-3) u(k-4) y(k) y(k-1)]') + d(k);
    y(k+2) = w20 + w2*tanh(w10+w1*[u(k-2) u(k-3) y(k+1) y(k)]') + d(k);
    y(k+3) = w20 + w2*tanh(w10+w1*[u(k-1) u(k-2) y(k+2) y(k+1)]') + d(k);
    for i=3:N
        y(k+i) = w20 + w2*tanh(w10+w1*[u(k-1) u(k-1) y(k+i-1) y(k+i-2)]') + d(k);
    end

    % sterowanie
    d_u_NPL = K_NPL*(ones(N,1) * y_zad(k) - y(k+1:k+N)');
    u(k) = d_u_NPL(1) + u(k-1);

    % ograniczenia sterowania
	if u(k) > 1
        u(k) = 1;
	end
	if u(k) <  -1
        u(k) =  -1;
    end

end
E = (norm(E))^2;
end