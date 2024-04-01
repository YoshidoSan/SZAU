clear;
clc;
close all;

func = 1; %1 - Ackley, 2 - Himmelblau

disp('========Particle Swarm========')
options = optimoptions('particleswarm', 'PlotFcn', 'pswplotbestf');
values1 = [];
for i = 1:10
	if func == 1
		x = particleswarm(@(X) Ackley2(X), 2, [-5, -5], [5, 5], options);
		y = Ackley2(x);
	elseif func == 2
		x = particleswarm(@(X) Himmelblau2(X), 2, [-5, -5], [5, 5], options);
		y = Himmelblau2(x);
	end
	disp(x)
	disp(y)
    values1 = [values1; [y,x]];
end

disp('========Genetic Algoritm========')
options2 = optimoptions('ga', 'PlotFcn', 'gaplotbestf');
values2 = [];
for i = 1:10
	if func == 1
		x2 = ga(@(X) Ackley2(X), 2, [],[],[],[], [-5, -5], [5, 5], [],[], options2);
		y2 = Ackley2(x2);
	elseif func == 2
		x2 = ga(@(X) Himmelblau2(X), 2, [],[],[],[], [-5, -5], [5, 5], [],[], options2);
		y2 = Himmelblau2(x2);
	end
	disp(x2)
	disp(y2)
    values2 = [values2; [y2,x2]];
end
