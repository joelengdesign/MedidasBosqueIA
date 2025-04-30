function Output = calcularSaidaGRNN(netGRNN, Data, dados, SF, altura, polarizacao)
    % Desnormalizar os dados
    dataDesnorm = Data .* (max(dados) - min(dados)) + min(dados);
    
    % Calcular a saída do sistema fuzzy para o conjunto de entrada correspondente
    out = sim(netGRNN,dadosTesteNorm(:,1:4)');
    
    Output = out * (max(dados(:,end)) - min(dados(:,end))) + min(dados(:,end));
end