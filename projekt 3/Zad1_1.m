clear;
close all;

figure(1)
fsurf(@(x1,x2) Ackley(x1,x2), [-5 5 -5 5])
title('Funkcja Ackleya')
xlabel('x1')
ylabel('x2')
zlabel('y')
% print("zdj/Ackley",'-dpng','-r800');

figure(2)
fcontour(@(x1,x2) Ackley(x1,x2), [-5 5 -5 5], 'LevelStep',1)
title('Funkcja Ackleya')
xlabel('x1')
ylabel('x2')
grid on;
% print("zdj/Ackley_izo",'-dpng','-r800');


figure(3)
fsurf(@(x1,x2) Himmelblau(x1,x2), [-5 5 -5 5])
title('Funkcja Himmelblau')
xlabel('x1')
ylabel('x2')
zlabel('y')
% print("zdj/Himmelblau",'-dpng','-r800');


figure(4)
fcontour(@(x1,x2) Himmelblau(x1,x2), [-5 5 -5 5], 'LevelStep',10)
title('Funkcja Himmelblau')
xlabel('x1')
ylabel('x2')
set(gca, 'ytick', -5:1:5);
grid on
% print("zdj/Himmelblau_izo",'-dpng','-r800');
