liczba_obszarow = 4;
punkty_pracy = {[5,10, 5,10],[3.75,7.5,11.25, 3.75,7.5,11.25],[3,6,9,12, 3,6,9,12],[2.5,5,7.5,10,12.48, 2.5,5,7.5,10,12.5]};
punkty_pracy_lokalne = punkty_pracy{liczba_obszarow-1};
h1_pp_roz = punkty_pracy_lokalne(1:liczba_obszarow);
h2_pp_roz = punkty_pracy_lokalne(liczba_obszarow+1:end);
function_type = 'gaus';
global C1 C2 alfa1 alfa2
C1 = 0.75;
C2 = 0.55;
alfa1 = 20;
alfa2 = 20;
T = 1;

functions = funkcje_podzialu(liczba_obszarow, function_type, 0, 15);

% punkt pracy startowy
tau = 50;
Fd = 11;
F1_in(1:10000) = 52;
h1_pp_start = 9.9211;
h2_pp_start = 9.9225;

%skok sterowania
Ts = 30000;
F1_in(10001:Ts) = 54;

% obiekt dyskretny nlin i lin
[h1, h2] = obiekt_dyskretny(0, Ts, h1_pp_start, h2_pp_start, F1_in);
[h1_zlin, h2_zlin] = obiekt_dyskretny(1, Ts, h1_pp_start, h2_pp_start, F1_in);

%wektory startowe modelu rozmytego
h1_lok = h1_pp_roz;
h2_lok = h2_pp_roz;

h1_roz(1:Ts) = 9.9211;
h2_roz(1:Ts) = 9.9225;
% h2_roz = ones(1:Ts);
for k=2:Ts

    h1_lok_prew = h1_lok;
    h2_lok_prew = h2_lok;

    for i=1:liczba_obszarow

        if k - tau < 1 || length(F1_in) < 51
	       F1 = F1_in(1);
        else
	       F1 = F1_in(k-tau);

        end
        if h1_lok_prew(i) <= 0
            h1_lok_prew(i) = 0;
        end
        if h2_lok_prew(i) <= 0
            h2_lok_prew(i) = 0;
        end

        h1_plin = h1_pp_roz(i);
        h1_lok(i) = (-alfa1 * sqrt(h1_plin) + Fd + F1) / (2*C1*h1_plin) + ...
            ((alfa1/(4*C1*h1_plin^(3/2))) - ((Fd+F1)/(2*C1*h1_plin^2))) * (h1_lok_prew(i) - h1_plin) + T * h1_lok_prew(i);
        h2_plin = h2_pp_roz(i);
        h2_lok(i) = (alfa1*sqrt(h1_plin) - alfa2*sqrt(h2_plin)) / (3*C2*h2_plin^2) + ...
			((alfa1)/(6*C2*sqrt(h1_plin)*h2_plin^2))*(h1_lok_prew(i) - h1_plin) + ...
			((-2*alfa1*sqrt(h1_plin))/(3*C2*h2_plin^3) + (alfa2)/(2*C2*h2_plin^(5/2)))*(h2_lok_prew(i) - h2_plin)  + T * h2_lok_prew(i);
    end

    suma_wag = 0;
    for i=1:liczba_obszarow
        suma_wag = suma_wag + functions{i}(h2_roz(k-1));
    end
    
    h1_roz(k) = 0;
    h2_roz(k) = 0;
    for i=1:1:liczba_obszarow
        h1_roz(k) = h1_roz(k) + ( (functions{i}(h2_roz(k-1))/ suma_wag) * h1_lok(i) );
        h2_roz(k) = h2_roz(k) + ( (functions{i}(h2_roz(k-1))/ suma_wag) * h2_lok(i) );
    end
    % end

    E = abs(h2(k) - h2_roz(k))^2;

end

figure(1)
hold on
stairs(h2, 'r-');
stairs(h2_zlin, 'b-');
stairs(h2_roz,'k-.');
title('modele lokalne - funkcje')
legend('model nieliniowy', 'model zlinearyzowany', 'model rozmyty');



