function Output = calcularSaidaITU_R(f, dados)
    d = dados(:,1);
    fspl = freeSpacePathLoss(f,d/1000);
    %função para cálculo da atenuação devido a presença de folhagem utilizando
    %o modelo de FITU_R
    %Parâmetros da função:
    %f -> frequência em MHz
    %d -> distância em metros
    %L -> Leaves(folhas) 1 - se tiver folhas | 0 - caso contrário
     Output = 0.2 * (f^0.3) * (d.^0.6)+fspl;
end