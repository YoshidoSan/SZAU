function [h1_out, h2_out, t] = obiekt_ciagly(lin, t_sim, h1_0, h2_0)
%stałe
global F1_in C1 C2 alfa1 alfa2

%punkt pracy
if lin == 1
	%liniowy
	[t, h_out] = ode23s(@(t,h) f_ciagla_zlin(t,h), [0 t_sim], [h1_0 h2_0]);
else
    % nieliniowy
    [t, h_out] = ode23s(@(t,h) f_ciagla(t,h), [0 t_sim], [h1_0 h2_0]);
end
%zakres czasu i punkty początkowe
h1_out = h_out(:,1);
h2_out = h_out(:,2);
end