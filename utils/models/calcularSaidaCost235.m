function Output = calcularSaidaCost235(f, dados, L)
    d = dados(:,1);
    fspl = freeSpacePathLoss(f,d/1000);
    %função para cálculo da atenuação devido a presença de folhagem utilizando
    %o modelo de FITU_R
    %Parâmetros da função:
    %f -> frequência em MHz
    %d -> distância em metros
    %L -> Leaves(folhas) 1 - se tiver folhas | 0 - caso contrário
      if L
        Output = 15.6 * (f^-0.009) * (d.^0.26)+fspl;
    else
        Output = 26.6 * (f^-0.2) * (d.^0.5)+fspl;
    end 
end