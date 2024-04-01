function[E, y, u] = PID(paramtery)
global y_zad Ts
% paramtery regulatora
K_PID = paramtery(1); 
Ti_PID = paramtery(2); 
Td_PID = paramtery(3); 
T = 1;
r2 = (K_PID * Td_PID) / T;
r1 = K_PID * ((T / (2 * Ti_PID)) - ((2 * Td_PID) / T)  - 1);
r0 = K_PID * (1 + (T / (2 * Ti_PID)) + (Td_PID / T));
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
E = zeros(1, Ts);
start = 6;
% symulacja
for k=start:Ts
    % obiekt
    x1(k) = -alfa1*x1(k-1)+x2(k-1)+beta1*g1(u(k-4));
    x2(k) = -alfa2*x1(k-1)+beta2*g1(u(k-4));
    y(k) = g2(x1(k));
    
    u(k) = r2 * E(k-2) + r1 * E(k-1) + r0 * E(k) + u(k-1);
    E(k) = y_zad(k) - y(k);

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