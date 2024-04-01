function [h1_out, h2_out] = obiekt_dyskretny(lin, t_sim, h1_0, h2_0, F1_in)
%stałe
global C1 C2 alfa1 alfa2
start = 2;

%startowe h1, h2
h1 = zeros(start+t_sim,1);
h1(1) = h1_0;
h2 = zeros(start+t_sim,1);
h2(1) = h2_0;

T = 1;
tau = 50;
Fd = 11;

for k=start:start+t_sim
   if k - tau < 1 || length(F1_in) < 51
	   F1 = F1_in(1);
   else
	   F1 = F1_in(k-tau);
   end

   if h1(k)<= 0
       h1(k) = 0.0001;
   end
   if h2(k)<= 0
       h2(k) = 0.0001;
   end
	
	if lin == 1
		h1_plin = h1_0;
		h2_plin = h2_0;
		h1(k) = (-alfa1 * sqrt(h1_plin) + Fd + F1) / (2*C1*h1_plin) + ...
            ((alfa1/(4*C1*h1_plin^(3/2))) - ((Fd+F1)/(2*C1*h1_plin^2))) * (h1(k-1) - h1_plin) + T * h1(k-1);
        h2(k) = (alfa1*sqrt(h1_plin) - alfa2*sqrt(h2_plin)) / (3*C2*h2_plin^2) + ...
			((alfa1)/(6*C2*sqrt(h1_plin)*h2_plin^2))*(h1(k-1) - h1_plin) + ...
			((-2*alfa1*sqrt(h1_plin))/(3*C2*h2_plin^3) + (alfa2)/(2*C2*h2_plin^(5/2)))*(h2(k-1) - h2_plin)  + T * h2(k-1);
    else
        % nieliniowy
        h1(k) = ((F1 + Fd - alfa2*sqrt(h1(k-1)))/(2*C1*h1(k-1))) * T + h1(k-1); 
        h2(k) = ((alfa1*sqrt(h1(k-1)) - alfa2*sqrt(h2(k-1))) / (3*C2*(h2(k-1)^2)))  * T + h2(k-1);
    end
end
h1_out = h1(1:end);
h2_out = h2(1:end);
end