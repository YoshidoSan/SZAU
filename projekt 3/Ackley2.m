function [y] = Ackley2(X)
	x1 = X(1);
	x2 = X(2);
	e1 = exp(-0.2 * sqrt(0.5 * (x1^2 + x2^2)));
	e2 = exp(0.5*( cos(2 * pi * x1) + cos(2 * pi * x2)));
	y = -20 * e1 - e2 + exp(1) + 20;
end

