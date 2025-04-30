function T = retirarOutliers(tabela,campo,quantidade)
    dados = tabela.(campo);
                
    % Calcula média e desvio padrão
    media = mean(dados, 'omitnan'); % Ignora NaN
    desvio = std(dados, 'omitnan'); 
    
    % Define os limites inferior e superior
    limite_inferior = media - quantidade * desvio;
    limite_superior = media + quantidade * desvio;
    
    % Filtra os dados da tabela dentro dos limites
    T = tabela(dados >= limite_inferior & dados <= limite_superior, :);
end