function responses = pobranie_modelu_rozmyte(ilosc_obszarow)
    responses = cell(1, ilosc_obszarow);

    if ilosc_obszarow == 2
        u_pp = [41.5, 52.5];
        u = [42, 53];
    elseif ilosc_obszarow == 3
        u_pp = [39.9, 45.8, 57];
        u = [40.5, 46, 58];
    elseif ilosc_obszarow == 4
        u_pp = [39, 43, 49.3, 60.4];
        u = [40, 44, 50, 61];
    elseif ilosc_obszarow == 5
        u_pp = [38.5, 41.5, 45.8, 52.5, 63];
        u = [39, 42, 46, 53, 64];
    end

    % figure(21)
    % title('Rozmyte odpowiedzi skokowe')
    for i=1:length(u)
        responses{i} = pobranie_modelu(u(i), u_pp(i));
    %    hold on
    %    stairs(responses{i})
    end
    % print("Odpowiedzi_SL.png","-dpng","-r400")
end