function Output = calcularSaidaFuzzy(fis, Data)    
    % Calcular a saída do sistema fuzzy para o conjunto de entrada correspondente
    out = evalfis(fis, Data(:, 1:end-1));
    
    Output = out * (max(dados(:,end)) - min(dados(:,end))) + min(dados(:,end));
    
end