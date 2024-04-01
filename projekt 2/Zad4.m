clear; 
close all;

run("model_best_zad22.m")

% parametry;
alfa1 = -1.413505;
alfa2 = 0.462120;
beta1 = 0.016447;
beta2 = 0.012722;


Ts = 1000;
start = 6;

% wybór regulatora
% NPL = 1, GPC = 2, PID = 3, NO = 4
regulator = 1;


% nastawy 
% NPL,GPC
if regulator == 1 || regulator == 2 || regulator == 4
    D = 100;
    N = 20;
    Nu = 10;
    lambda = 1;
end
%PID
if regulator == 3
    K_PID = -0.9;
    Ti_PID = 9;
    Td_PID = 2.25;
    T = 1;
end

%% inicjalizacje
% NPL
if regulator == 1
    delta = 0.000001;
end


% GPC
if regulator == 2

    % paramtery modelu liniowego
    ts = 4000;
    load("dane_uczace.mat")
    load("dane_weryfikujace.mat")
    M = zeros(ts - 5, 4);
    for i=6: length ( y_ucz )
	    row = [ u_ucz(i -4) u_ucz(i -5)  y_ucz(i -1)  y_ucz(i -2) ];
	    M(i-5,:) = row;
    end    
    Y = y_ucz(6:ts)';
    W = M\Y;
    
    % symulacja odpowiedzi skokowej modelu
    sym_GPC_y(1:D+6) = 0;
    sym_GPC_u(1:D+6) = 0;
    sym_GPC_u(6:end) = 1;
    for k=start:D+6
        sym_GPC_y(k) = W(1)*sym_GPC_u(k-4)+W(2)*sym_GPC_u(k-5)+W(3)*sym_GPC_y(k-1)+W(4)*sym_GPC_y(k-2);
    end
    S_GPC = sym_GPC_y(6:end);

    % macierz M
    M_GPC = zeros(N,Nu);
    for i=1:N
        for j=1:Nu
            if(i>=j)
                M_GPC(i,j) = S_GPC(i-j+1);
            end
        end
    end

    % K
    K_GPC = ((M_GPC' * M_GPC + eye(Nu) * lambda)^-1) * M_GPC';
end


% PID
if regulator == 3
	r2 = (K_PID * Td_PID) / T;
    r1 = K_PID * ((T / (2 * Ti_PID)) - ((2 * Td_PID) / T)  - 1);
	r0 = K_PID * (1 + (T / (2 * Ti_PID)) + (Td_PID / T));
end



y(1:Ts) = 0;
u(1:Ts) = 0;
x1(1:Ts) = 0;
x2(1:Ts) = 0;
E(1:Ts) = 0;
d(1:Ts) = 0;

% wartość zadana
y_zad(1:Ts) = 0;
y_zad(10:Ts) = 1.5;
y_zad(200:Ts) = 2;
y_zad(400:Ts) = -0.1;
y_zad(600:Ts) = 0.2;
y_zad(800:Ts) = -0.5;

% symulacja
for k=start:Ts
    % obiekt
    x1(k) = -alfa1*x1(k-1)+x2(k-1)+beta1*g1(u(k-4));
    x2(k) = -alfa2*x1(k-1)+beta2*g1(u(k-4));
    y(k) = g2(x1(k));
    
    E(k) = y_zad(k) - y(k);
    
    
    if regulator == 1 % NPL
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


    elseif regulator == 2 % GPC
        % dokładność modelu
        d(k) = y(k) - (W(1) * u(k-4) + W(2) * u(k-5) + W(3) * y(k-1) + W(4) * y(k-2));

        % predykcja
        y(k+1) = W(1)*u(k-3)+W(2)*u(k-4)+W(3)*y(k)+W(4)*y(k-1) + d(k);
        y(k+2) = W(1)*u(k-2)+W(2)*u(k-3)+W(3)*y(k+1)+W(4)*y(k) + d(k);
        y(k+3) = W(1)*u(k-1)+W(2)*u(k-2)+W(3)*y(k+2)+W(4)*y(k+1) + d(k);
        for i=4:N
            y(k+i) = W(1)*u(k-1)+W(2)*u(k-1)+W(3)*y(k+i-1)+W(4)*y(k+i-2) + d(k);
		end

        % sterowanie
        d_u_GPC = K_GPC*(ones(N,1) * y_zad(k) - y(k+1:k+N)');
        u(k) = d_u_GPC(1) + u(k-1);

	
	% PID
    elseif regulator == 3 
        u(k) = r2 * E(k-2) + r1 * E(k-1) + r0 * E(k) + u(k-1);


	% NO 
	elseif regulator == 4 
        u0 = u(k-1) * ones(1,Nu);
		opts = optimset('TolFun', 1e-10, 'TolX', 1e-10, 'Display', 'off');
		U = fmincon(@(x) NO(x, N, Nu, lambda, u, y, y_zad, k, d(k)), u0, [], [], [], [], -1*ones(1, Nu), 1*ones(1, Nu), [], opts);
		u(k) = U(1);
	end

    
    % ograniczenia sterowania
	if u(k) > 1
        u(k) = 1;
	end
	if u(k) <  -1
        u(k) =  -1;
	end
end

E = (norm(E))^2;
fprintf("E = %f \n", E);

figure(1);
subplot(2,1,1);
hold on;
plot(y(1:Ts));
plot(y_zad);
xlabel('k')
ylabel('wyjście')
legend('NO','y_z');
subplot(2,1,2);
hold on;
plot(u(1:Ts));

xlabel('k')
ylabel('sterowanie')
% print("NO",'-dpng','-r800');