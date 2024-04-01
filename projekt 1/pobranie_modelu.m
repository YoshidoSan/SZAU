function [step_response] = pobranie_modelu(u, u_pp)
%stabilizowanie obiektu w pp i skok sterowania
Ts = 3000;
uu(1:0.5*Ts) = u_pp;
uu(0.5*Ts+1:Ts) = u;
[h1, h2]=obiekt_dyskretny(1, Ts, 9.9225, 9.9221, uu);

h1_0 = h1(0.5*Ts);
h2_0 = h2(0.5*Ts);

%przeliczenie na skok jednostkowy
step_response_all = zeros(Ts,1);
for i=1:Ts
    step_response_all(i) = (h2(i) - h2_0) / ((u - u_pp));
end
step_response = step_response_all(0.5*Ts:Ts);

% figure(30);
% hold on;
% grid on;
% stairs(step_response);
% title('Model', u)
end

