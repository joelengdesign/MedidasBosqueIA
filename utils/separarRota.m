function [tabela_ida, tabela_volta] = separarRota(tabela)
    % Extrai os dados de latitude e longitude
    lat = tabela.latitude;
    lon = tabela.longitude;

    % Calcular a distância do primeiro ponto ao longo do trajeto
    distancias = sqrt((lat - lat(1)).^2 + (lon - lon(1)).^2);
    
    % Criar um vetor de variação da distância para identificar inversão
    variacao_dist = [0;diff(distancias)];  

    idx_ida = find(variacao_dist >= 0);
    idx_volta = find(variacao_dist < 0);
    
    % Ajustar os tamanhos se a diferença for maior que 1
    while abs(length(idx_ida) - length(idx_volta)) > 1
        diferenca = round(abs(length(idx_ida) - length(idx_volta))/2);
        if length(idx_ida) > length(idx_volta)
            % Remover pontos de idx_ida de forma distribuída
            [idx_ida, pontos_removidos] = remover_pontos_distribuidos(idx_ida, diferenca);
            idx_volta = [idx_volta;pontos_removidos];
        else
            % Remover pontos de idx_volta de forma distribuída
            [idx_volta,pontos_removidos] = remover_pontos_distribuidos(idx_volta, diferenca);
            idx_ida = [idx_ida;pontos_removidos];
        end
    end
    
    % Garantir que todos os pontos sejam atribuídos corretamente
    idx_restantes = setdiff(1:height(tabela), [idx_ida; idx_volta]);
    idx_restantes = idx_restantes(:); % Garante que seja um vetor coluna
    
    if ~isempty(idx_restantes)
        if length(idx_ida) < length(idx_volta)
            idx_ida = [idx_ida; idx_restantes];
        else
            idx_volta = [idx_volta; idx_restantes];
        end
    end
    
    tabela_ida = tabela(idx_ida, :);
    tabela_volta = tabela(idx_volta, :);

    function [idx_ajustado,pontos_removidos]  = remover_pontos_distribuidos(idx, num_remover)
        if num_remover <= 0
            idx_ajustado = idx;
            return;
        end

        % Calcula os índices a serem removidos de forma distribuída
        passos = round(linspace(1, length(idx), num_remover + 2));
        passos(1) = []; % Remove primeiro ponto para evitar remover sempre o primeiro
        passos(end) = []; % Remove último ponto para evitar remover sempre o último
        
        idx_ajustado = idx;
        pontos_removidos = idx_ajustado(passos);
        idx_ajustado(passos) = []; % Remove os pontos selecionados
    end
%% 
end


