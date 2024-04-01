function E = NO(x, N, Nu, lambda, u, y, y_zad, k, d)
run("model_best_zad22.m")

for i = 0 : Nu -1
	u(k+i) = x(i+1);
end
u(k+Nu:k+N) = u(k+Nu-1);

for i=0:Nu-1
    dU(k+i) = u(k+i)-u(k+i-1);
end

Y(1) = w20 + w2*tanh(w10+w1*[u(k-3) u(k-4) y(k) y(k-1)]') + d;
Y(2) = w20 + w2*tanh(w10+w1*[u(k-2) u(k-3) Y(1) y(k)]') + d;
Y(3) = w20 + w2*tanh(w10+w1*[u(k-1) u(k-2) Y(2) Y(1)]') + d;
for i=4:N
    Y(i) = w20 + w2*tanh(w10+w1*[u(k -4+i) u(k-5+i) Y(i-1) Y(i-2)]') + d;
end

sum1 = 0;
sum2 = 0;

for i=1:N
    sum1 = sum1 + (y_zad(k) - Y(i))^2;
end

for i=0:Nu-1
   sum2 = sum2 + dU(k + i)^2; 
end

E = sum1 + lambda * sum2;
end

