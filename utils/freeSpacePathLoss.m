function pl = freeSpacePathLoss(f,d)

% Parâmetros da função:
% f -> Frequência em MHz
% d -> distância em Km
% Função considera ganho das antenas Rx e Tx unitário
% Retorna
% Path Loss (dB) no espaço livre
d = d./1000;
pl = (20*log10(f)) + (20*log10(d)) - (10*log10(1)) - (10*log10(1)) + 32.44 + 3+21;

%  pl(f,d) = pl(d0)+10 * n*log10(d/d0); % para regressão linear
% quando encontrar o valor do n, substituir na linha 9.

end