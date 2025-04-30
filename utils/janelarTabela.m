function [T,numJanelasVazias] = janelarTabela(tabela, passo)

% JANELARTABELA - Realiza um janelamento da tabela em função da distância
%
% Sintaxe:
%   T = janelarTabela(tabela, passo)
%
% Entradas:
%   tabela - Tabela de dados com os campos: distanciasR, RSSI, SNR, Latitude, Longitude, pathloss
%   passo - Valor do passo do janelamento (exemplo: 5 metros)
%
% Saída:
%   T - Tabela janelada com médias dos campos em cada intervalo de distância

% Definir os limites do janelamento
min_distanciasR = min(tabela.distanciasR); % Menor distância presente na tabela
max_distanciasR = max(tabela.distanciasR); % Maior distância presente na tabela

tam = ceil((max_distanciasR-min_distanciasR)/passo);

% Inicializar a nova tabela
T = table();
T_aux = table();

% Loop para criar os intervalos de distâncias
numJanelasVazias = 0;
for c = 1:tam
    % Definir os limites do intervalo atual
    limite_inferior = min_distanciasR+passo*(c-1);
    limite_superior = min_distanciasR+passo*c;

    idx = (tabela.distanciasR >= limite_inferior) & (tabela.distanciasR <= limite_superior);

    ind = find(idx == 1);
    if any(idx)
        tab = tabela(idx,:);
        cenario = tab.cenario(1,:);
        contido = contains(cenario, "Atenuação");

        if any(contido)
            camp = 'atenuacao';
        else
            camp = 'pathloss';
        end

        % tab = retirarOutliers(tab,'RSSI',2);
        % tab = retirarOutliers(tab,'SNR',2);
        % tab = retirarOutliers(tab,camp,2);

        latitude = mean(tab.latitude);
        longitude = mean(tab.longitude);
        SF = tab.SF(1);
        cenario = tab.cenario(1,:);
        altura = tab.altura(1);
        polarizacao = tab.polarizacao(1,:);
        polarizacaoNum = tab.polarizacaoNum(1);
        RSSI_media = mean(tab.RSSI);
        RSSI_desviopadrao = std(tab.RSSI);
        SNR_media = mean(tab.SNR);
        SNR_desviopadrao = std(tab.SNR);

        contido1 = contains(cenario, ["Bosque", "bosque"]);
        contido2 = contains(cenario, ["Referência", "Referencia"]);
        contido3 = contains(cenario, "Atenuação");

        if any(contido1)
            clear cenario
            cenario = "Dados Bosque Janelado";
        elseif any(contido2)
            cenario = "Dados Referência Janelado";
        elseif any(contido3)
            clear cenario
            cenario = "Dados Atenuação Janelado";
        end

        if any(contido3)
            campo = 'atenuacao';
        else
            campo = 'pathloss';
        end

        distanciaH = mean([tabela.distanciasH(ind(1)) tabela.distanciasH(ind(end))]);
        distanciaR = mean([tabela.distanciasR(ind(1)) tabela.distanciasR(ind(end))]);
        angulo = mean([tabela.angulo(ind(1)) tabela.angulo(ind(end))]);

        pathloss_media = mean(tab.(campo));
        pathloss_desviopadrao = std(tab.(campo));

        T_aux.cenario = cenario;
        T_aux.latitude = latitude;
        T_aux.longitude = longitude;
        T_aux.SF = SF;
        T_aux.altura = altura;
        T_aux.polarizacao = polarizacao;
        T_aux.polarizacaoNum = polarizacaoNum;

        T_aux.RSSI_media = RSSI_media;
        T_aux.RSSI_desviopadrao = RSSI_desviopadrao;

        T_aux.SNR_media = SNR_media;
        T_aux.SNR_desviopadrao = SNR_desviopadrao;

        T_aux.([campo, '_media']) = pathloss_media;
        T_aux.([campo, '_desviopadrao']) = pathloss_desviopadrao;


        T_aux.distanciasR = distanciaR;
        T_aux.distanciasH = distanciaH;
        T_aux.angulo = angulo;
        Tcell{c} = T_aux;
    else
        numJanelasVazias = numJanelasVazias+1;
    end
end

T = vertcat(Tcell{:});

end
