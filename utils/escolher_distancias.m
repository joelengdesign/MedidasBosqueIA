function dist_escolhida = escolher_distancias(D,PL, abordagem)

% % Extrair distâncias de todas as tabelas
% D = [tab1.distanciasR; tab2.distanciasR; tab3.distanciasR; ...
%     tab4.distanciasR; tab5.distanciasR; tab6.distanciasR];
% 
% PL = [tab1.pathloss; tab2.pathloss; tab3.pathloss; ...
%     tab4.pathloss; tab5.pathloss; tab6.pathloss];
% 
% % Determinar os limites do intervalo de distâncias
% minmax = min([max(tab1.distanciasR), max(tab2.distanciasR), max(tab3.distanciasR), ...
%     max(tab4.distanciasR), max(tab5.distanciasR), max(tab6.distanciasR)]);
% maxmin = max([min(tab1.distanciasR), min(tab2.distanciasR), min(tab3.distanciasR), ...
%     min(tab4.distanciasR), min(tab5.distanciasR), min(tab6.distanciasR)]);
% 
% % Filtrar as distâncias para estarem dentro do intervalo válido
% 
% 
% ind = (D >= maxmin & D <= minmax);
% 
% D = D(ind);
% PL = PL(ind);

% Definir número de pontos baseado na média do tamanho das tabelas
num_pontos = round(mean(D));

switch lower(abordagem)
    case 'linspace'
        % Criar pontos uniformemente espaçados dentro do intervalo válido
        dist_escolhida = linspace(min(D), max(D), num_pontos);

    case 'uniao'
        % Unir todas as distâncias sem repetição e dentro do intervalo válido
        dist_escolhida = unique(D);

    case 'pca'
        % Aplicar PCA para encontrar os componentes principais
        [~, score, ~] = pca([D, PL]);
        pc1 = score(:, 1); % Primeira componente principal

        % Ordenar a projeção da primeira componente
        [~, idx_sorted] = sort(pc1);

        % Selecionar índices espaçados ao longo da variabilidade
        idx_selected = round(linspace(1, length(idx_sorted), num_pontos));

        % Obter as distâncias correspondentes a esses índices
        dist_escolhida = D(idx_sorted(idx_selected));

        % Ordenar os pontos para garantir uma progressão natural
        dist_escolhida = sort(dist_escolhida);

    otherwise
        error('Abordagem inválida. Escolha entre ''linspace'', ''uniao'' ou ''pca''.');
end

end
