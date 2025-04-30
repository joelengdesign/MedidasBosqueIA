function T = retirarOutliersPorJanela(tabela, campo, janela, quantidade)
    distancias = tabela.distanciasR;
    
    % Ordena a tabela pela distância (caso não esteja ordenada)
    [~, idx] = sort(distancias);
    tabelaOrdenada = tabela(idx, :);
    
    % Inicializa a tabela final que armazenará os dados filtrados
    
    % Percorre as distâncias em janelas
    numLinhas = height(tabelaOrdenada);
    i = 1;
    cont = 1;
    while i <= numLinhas
        % Definir o intervalo da janela
        limiteInferiorJanela = tabelaOrdenada.distanciasR(i); 
        limiteSuperiorJanela = limiteInferiorJanela + janela;
        
        % Encontra os dados dentro da janela atual
        janelaDados = tabelaOrdenada(tabelaOrdenada.distanciasR >= limiteInferiorJanela & ...
                                     tabelaOrdenada.distanciasR < limiteSuperiorJanela, :);
        
        % Calcula a média e o desvio padrão dentro da janela
        dadosJanela = janelaDados.(campo);
        mediaJanela = mean(dadosJanela, 'omitnan');
        desvioJanela = std(dadosJanela, 'omitnan');
        
        % Definir limites de outliers para a janela
        limiteInferior = mediaJanela - quantidade * desvioJanela;
        limiteSuperior = mediaJanela + quantidade * desvioJanela;
        
        % Filtrar os dados da janela dentro dos limites
        janelaFiltrada = janelaDados(dadosJanela >= limiteInferior & dadosJanela <= limiteSuperior, :);
        
        % Adiciona os dados filtrados à tabela final
        TCell{cont} = janelaFiltrada;
        
        % Atualiza o índice para a próxima janela
        i = find(tabelaOrdenada.distanciasR >= limiteSuperiorJanela, 1);
        cont = cont+1;
    end
    T = vertcat(TCell{:});
end
