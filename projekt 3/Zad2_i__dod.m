%particle swarm osiągnął lepsze wyniki ogólnie
global y_zad Ts
y_zad(1:100)= 0;
y_zad(101:300)= 0.32;
y_zad(301:500)= 0.13;
y_zad(501:700)= -0.27;
y_zad(701:900)= -0.45;
y_zad(901:1100)= 0.21;
y_zad(1101:1300)= -0.51;
y_zad(1301:1500)= 0.33;
y_zad(1501:1700)= 1.08;
y_zad(1701:1900)= 0.86;
y_zad(1901:2100)= 1.62;
y_zad(2101:2300)= 2;
Ts = length(y_zad);
%% zad 2
% paramtery_proj2 = [-0.9, 9, 2.25];
% paramtery optymalizatora
options = optimoptions('particleswarm');
options.Display = 'iter';
options.MaxIterations = 100;
options.SwarmSize = 50;

% values = [];
% for i=1:30
%     x = particleswarm(@(X) PID(X), 3, [0,0.001,0.001], [100,100,10], options);
%     values = [values; x];
% end
% 
% best_E = 1000;
% best_vals = [0,0,0];
% for i=1:30
%     [E, y, u] = PID(values(i,:));
%     if E < best_E
%         best_E = E;
%         best_vals = values(i,:);
%     end
% end

best_vals = [0.015, 5, 0.9];
[E, y, u] = PID(best_vals);
disp(E);
figure(1)
hold on; grid on;
plot(y); plot(y_zad);
xlim([0 Ts]);
print("zdj/PID_ekspert",'-dpng','-r800');


%% zadanie dodatkowe
% paramtery_proj2 = [-0.9, 9, 2.25];
% paramtery optymalizatora
options = optimoptions('particleswarm');
options.Display = 'iter';
options.MaxIterations = 10;
options.SwarmSize = 100;
options.MaxStallIterations = 1;
options.InitialSwarmSpan = 3000;

% values_NPL = [];
% for i=1:30
%     x = particleswarm(@(X) NPL(X), 3, [1,1,0.0001], [100,100,1000], options);
%     values_NPL = [values_NPL; x];
% end
% 
% best_E_NPL = 1000;
% best_vals_NPL = [0,0,0];
% for i=1:30
%     [E, y, u] = NPL(values(i,:));
%     if E < best_E_NPL
%         best_E_NPL = E;
%         best_vals_NPL = values(i,:);
%     end
% end
best_vals_NPL = [20, 10, 10];
[E, y, u] = NPL(best_vals_NPL);
disp(E);
figure(2)
hold on; grid on;
plot(y); plot(y_zad);
xlim([0 Ts]);
print("zdj/NPL_ekspert",'-dpng','-r800');