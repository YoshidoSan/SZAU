function [h] = f_ciagla_zlin(t,h)
	global F1_in C1 C2 alfa1 alfa2 h1_pp h2_pp
	Fd = 11;
	tau = 50;

	if floor(t) - tau < 1
		F1 = F1_in(1);
	else
    	F1 = F1_in(floor(t) - tau);
	end
	
	h1_plin = h1_pp;
	h2_plin = h2_pp;

	h1 = (-alfa1 * sqrt(h1_plin) + Fd + F1) / (2*C1*h1_plin) + ...
        ((alfa1/(4*C1*h1_plin^(3/2))) - ((Fd+F1)/(2*C1*h1_plin^2))) * (h(1) - h1_plin);
    h2 = (alfa1*sqrt(h1_plin) - alfa2*sqrt(h2_plin)) / (3*C2*h2_plin^2) + ...
			((alfa1)/(6*C2*sqrt(h1_plin)*h2_plin^2))*(h(1) - h1_plin) + ...
			((-2*alfa1*sqrt(h1_plin))/(3*C2*h2_plin^3) + (alfa2)/(2*C2*h2_plin^(5/2)))*(h(2) - h2_plin);
	h = [h1;h2];
end


