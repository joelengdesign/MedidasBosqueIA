function Output = calcularSaidaNN(net, Data, dados, SF, altura, polarizacao)
    % Desnormalizar os dados
    dataDesnorm = Data .* (max(dados) - min(dados)) + min(dados);
    
    % Encontrar índices onde a altura corresponde ao valor fornecido
    ind = find(dataDesnorm(:,2) == SF & dataDesnorm(:,3) == altura & dataDesnorm(:,4) == polarizacao);
    
    % Calcular a saída do sistema fuzzy para o conjunto de entrada correspondente

    out = net(Data(ind, 1:end-1)');
    
    Output = out * (max(dados(:,end)) - min(dados(:,end))) + min(dados(:,end));
    
end