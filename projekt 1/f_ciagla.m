function [h] = f_ciagla(t,h)
	global F1_in C1 C2 alfa1 alfa2
	Fd = 11;
	tau = 50;


	if floor(t) - tau < 1
		F1 = F1_in(1);
	else
    	F1 = F1_in(floor(t) - tau);
	end

	h = [((F1 + Fd - alfa2*sqrt(h(1)))/(2*C1*h(1))); ((alfa1*sqrt(h(1)) - alfa2*sqrt(h(2)))/(3*C2*(h(2)^2)))];
end

