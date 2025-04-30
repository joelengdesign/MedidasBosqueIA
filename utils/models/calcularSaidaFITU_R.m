function Output = calcularSaidaFITU_R(f, dados,L)
    % Encontrar índices onde a altura corresponde ao valor fornecido
    d = dados(:,1);
    %função para cálculo da atenuação devido a presença de folhagem utilizando
    %o modelo de FITU_R
    %Parâmetros da função:
    %f -> frequência em MHz
    %d -> distância em metros
    %L -> Leaves(folhas) 1 - se tiver folhas | 0 - caso contrário
    fspl = freeSpacePathLoss(f,d/1000);
    if L
        Output = 0.39 * (f^0.39) * (d.^0.25)+fspl;
    else
        Output = 0.37 * (f^0.18) * (d.^0.59)+fspl;
    end
end