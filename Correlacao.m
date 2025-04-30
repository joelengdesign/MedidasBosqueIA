%% Correlação entre distância e pathloss
contador=1;
alturas = 50:20:110;
SF = [7 9 12];
for i=1:4
    for j=1:4
        for k=1:3
            ind1 = (a.polarizacaoNum == i) & (a.altura == alturas(j)) & (a.SF == SF(k));
            ind2 = (b.polarizacaoNum == i) & (b.altura == alturas(j)) & (b.SF == SF(k));
            ind3 = (c.polarizacaoNum == i) & (c.altura == alturas(j)) & (c.SF == SF(k));
            A = a(ind1,:);
            B = b(ind2,:);
            C = c(ind3,:);
            correlacao1P(contador) = corr(A.distanciasR,A.(path));
            correlacao2L(contador) = corr(B.distanciasR,B.(path));
            correlacao3L(contador) = corr(C.distanciasR,C.(aten));

            correlacao1S(contador) = corr(A.distanciasR,A.(path), 'Type', 'Spearman');
            correlacao2S(contador) = corr(B.distanciasR,B.(path), 'Type', 'Spearman');
            correlacao3S(contador) = corr(C.distanciasR,C.(aten), 'Type', 'Spearman');

            correlacao1K(contador) = corr(A.distanciasR,A.(path), 'Type', 'Kendall');
            correlacao2K(contador) = corr(B.distanciasR,B.(path), 'Type', 'Kendall');
            correlacao3K(contador) = corr(C.distanciasR,C.(aten), 'Type', 'Kendall');
            contador = contador+1;
        end
    end
end


matriz(:,1) = [mean(correlacao1P);mean(correlacao2L);mean(correlacao3L)];
matriz(:,2) = [mean(correlacao1S);mean(correlacao2S);mean(correlacao3S)];
matriz(:,3) = [mean(correlacao1K);mean(correlacao2K);mean(correlacao3K)];

clear correlacao1P correlacao2P correlacao3P correlacao1S correlacao2S correlacao3S correlacao1K correlacao2K correlacao3K...
    correlacoes1P correlacoes2P correlacoes3P correlacoes1S correlacoes2S correlacoes3S correlacoes1K correlacoes2K correlacoes3K

%% Correlação entre altura e pathloss
contador=1;
for i=1:4
    for k=1:3
        ind1 = (a.polarizacaoNum == i) & (a.SF == SF(k));
        ind2 = (b.polarizacaoNum == i)  & (b.SF == SF(k));
        ind3 = (c.polarizacaoNum == i)  & (c.SF == SF(k));
        A = a(ind1,:);
        B = b(ind2,:);
        C = c(ind3,:);
        
        A1 = A(A.altura == 50,:);
        A2 = A(A.altura == 70,:);
        A3 = A(A.altura == 90,:);
        A4 = A(A.altura == 110,:);

        B1 = B(B.altura == 50,:);
        B2 = B(B.altura == 70,:);
        B3 = B(B.altura == 90,:);
        B4 = B(B.altura == 110,:);

        C1 = C(C.altura == 50,:);
        C2 = C(C.altura == 70,:);
        C3 = C(C.altura == 90,:);
        C4 = C(C.altura == 110,:);
        
        % Número de amostras mínimas para evitar erro de indexação
        num_samples = min([height(A1), height(A2), height(A3), height(A4)]);
        
        
        % ======================== Correlação de Pearson  ========================%
        correlacoes1P = arrayfun(@(k) corr([A1.altura(k), A2.altura(k), A3.altura(k), A4.altura(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k), A4.(path)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2P = arrayfun(@(k) corr([B1.altura(k), B2.altura(k), B3.altura(k), B4.altura(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k), B4.(path)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3P = arrayfun(@(k) corr([C1.altura(k), C2.altura(k), C3.altura(k), C4.altura(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k), C4.(aten)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);


        % ======================== Correlação de Spearman  ========================%
        correlacoes1S = arrayfun(@(k) corr([A1.altura(k), A2.altura(k), A3.altura(k), A4.altura(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k), A4.(path)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2S = arrayfun(@(k) corr([B1.altura(k), B2.altura(k), B3.altura(k), B4.altura(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k), B4.(path)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3S = arrayfun(@(k) corr([C1.altura(k), C2.altura(k), C3.altura(k), C4.altura(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k), C4.(aten)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        
        % ======================== Correlação de Kendall  ========================%
        correlacoes1K = arrayfun(@(k) corr([A1.altura(k), A2.altura(k), A3.altura(k), A4.altura(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k), A4.(path)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2K = arrayfun(@(k) corr([B1.altura(k), B2.altura(k), B3.altura(k), B4.altura(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k), B4.(path)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3K = arrayfun(@(k) corr([C1.altura(k), C2.altura(k), C3.altura(k), C4.altura(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k), C4.(aten)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);


        % Média das correlações de Pearson
        correlacao1P(contador) = mean(correlacoes1P);
        correlacao2P(contador) = mean(correlacoes2P);
        correlacao3P(contador) = mean(correlacoes3P);

        % Média das correlações Spearman
        correlacao1S(contador) = mean(correlacoes1S);
        correlacao2S(contador) = mean(correlacoes2S);
        correlacao3S(contador) = mean(correlacoes3S);

        % Média das correlações de Kendall
        correlacao1K(contador) = mean(correlacoes1K);
        correlacao2K(contador) = mean(correlacoes2K);
        correlacao3K(contador) = mean(correlacoes3K);
        contador = contador+1;
    end
end


matriz(:,4) = [mean(correlacao1P);mean(correlacao2P);mean(correlacao3P)];
matriz(:,5) = [mean(correlacao1S);mean(correlacao2S);mean(correlacao3S)];
matriz(:,6) = [mean(correlacao1K);mean(correlacao2K);mean(correlacao3K)];

clear correlacao1P correlacao2P correlacao3P correlacao1S correlacao2S correlacao3S correlacao1K correlacao2K correlacao3K...
    correlacoes1P correlacoes2P correlacoes3P correlacoes1S correlacoes2S correlacoes3S correlacoes1K correlacoes2K correlacoes3K
%% Correlação entre polarização e pathloss


contador = 1;

for i=1:4
    for k=1:3
        ind1 = (a.altura == alturas(i)) & (a.SF == SF(k));
        ind2 = (b.altura == alturas(i))  & (b.SF == SF(k));
        ind3 = (c.altura == alturas(i))  & (c.SF == SF(k));

        A = a(ind1,:);
        B = b(ind2,:);
        C = c(ind3,:);

        A1 = A(A.polarizacaoNum == 1,:);
        A2 = A(A.polarizacaoNum == 2,:);
        A3 = A(A.polarizacaoNum == 3,:);
        A4 = A(A.polarizacaoNum == 4,:);

        B1 = B(B.polarizacaoNum == 1,:);
        B2 = B(B.polarizacaoNum == 2,:);
        B3 = B(B.polarizacaoNum == 3,:);
        B4 = B(B.polarizacaoNum == 4,:);

        C1 = C(C.polarizacaoNum == 1,:);
        C2 = C(C.polarizacaoNum == 2,:);
        C3 = C(C.polarizacaoNum == 3,:);
        C4 = C(C.polarizacaoNum == 4,:);
        
        % ======================== Correlação de Pearson  ========================%
        correlacoes1P = arrayfun(@(k) corr([A1.polarizacaoNum(k), A2.polarizacaoNum(k), A3.polarizacaoNum(k), A4.polarizacaoNum(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k), A4.(path)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2P = arrayfun(@(k) corr([B1.polarizacaoNum(k), B2.polarizacaoNum(k), B3.polarizacaoNum(k), B4.polarizacaoNum(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k), B4.(path)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3P = arrayfun(@(k) corr([C1.polarizacaoNum(k), C2.polarizacaoNum(k), C3.polarizacaoNum(k), C4.polarizacaoNum(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k), C4.(aten)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        % ======================== Correlação de Spearman  ========================%
        correlacoes1S = arrayfun(@(k) corr([A1.polarizacaoNum(k), A2.polarizacaoNum(k), A3.polarizacaoNum(k), A4.polarizacaoNum(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k), A4.(path)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2S = arrayfun(@(k) corr([B1.polarizacaoNum(k), B2.polarizacaoNum(k), B3.polarizacaoNum(k), B4.polarizacaoNum(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k), B4.(path)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3S = arrayfun(@(k) corr([C1.polarizacaoNum(k), C2.polarizacaoNum(k), C3.polarizacaoNum(k), C4.polarizacaoNum(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k), C4.(aten)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);
        
        % ======================== Correlação de Kendall  ========================%
        correlacoes1K = arrayfun(@(k) corr([A1.polarizacaoNum(k), A2.polarizacaoNum(k), A3.polarizacaoNum(k), A4.polarizacaoNum(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k), A4.(path)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2K = arrayfun(@(k) corr([B1.polarizacaoNum(k), B2.polarizacaoNum(k), B3.polarizacaoNum(k), B4.polarizacaoNum(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k), B4.(path)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3K = arrayfun(@(k) corr([C1.polarizacaoNum(k), C2.polarizacaoNum(k), C3.polarizacaoNum(k), C4.polarizacaoNum(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k), C4.(aten)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);
        % Média das correlações de Pearson
        correlacao1P(contador) = mean(correlacoes1P);
        correlacao2P(contador) = mean(correlacoes2P);
        correlacao3P(contador) = mean(correlacoes3P);

        % Média das correlações Spearman
        correlacao1S(contador) = mean(correlacoes1S);
        correlacao2S(contador) = mean(correlacoes2S);
        correlacao3S(contador) = mean(correlacoes3S);

        % Média das correlações de Kendall
        correlacao1K(contador) = mean(correlacoes1K);
        correlacao2K(contador) = mean(correlacoes2K);
        correlacao3K(contador) = mean(correlacoes3K);
        contador = contador+1;
    end
end

matriz(:,7) = [mean(correlacao1P);mean(correlacao2P);mean(correlacao3P)];
matriz(:,8) = [mean(correlacao1S);mean(correlacao2S);mean(correlacao3S)];
matriz(:,9) = [mean(correlacao1K);mean(correlacao2K);mean(correlacao3K)];

clear correlacao1P correlacao2P correlacao3P correlacao1S correlacao2S correlacao3S correlacao1K correlacao2K correlacao3K...
    correlacoes1P correlacoes2P correlacoes3P correlacoes1S correlacoes2S correlacoes3S correlacoes1K correlacoes2K correlacoes3K
%% Correlação entre SF e pathloss
contador = 1;
for i=1:4
    for j=1:4
        ind1 = (a.altura == alturas(i)) & (a.polarizacaoNum == j);
        ind2 = (b.altura == alturas(i))  & (b.polarizacaoNum == j);
        ind3 = (c.altura == alturas(i))  & (c.polarizacaoNum == j);
        A = a(ind1,:);
        B = b(ind2,:);
        C = c(ind3,:);

        A1 = A(A.SF == 7,:);
        A2 = A(A.SF == 9,:);
        A3 = A(A.SF == 12,:);

        B1 = B(B.SF == 7,:);
        B2 = B(B.SF == 9,:);
        B3 = B(B.SF == 12,:);

        C1 = C(C.SF == 7,:);
        C2 = C(C.SF == 9,:);
        C3 = C(C.SF == 12,:);

        
        % ======================== Correlação de Pearson  ========================%
        correlacoes1P = arrayfun(@(k) corr([A1.SF(k), A2.SF(k), A3.SF(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2P = arrayfun(@(k) corr([B1.SF(k), B2.SF(k), B3.SF(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3P = arrayfun(@(k) corr([C1.SF(k), C2.SF(k), C3.SF(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k)]'), ...
            (1:num_samples)', 'UniformOutput', true);

        % ======================== Correlação de Spearman  ========================%
        correlacoes1S = arrayfun(@(k) corr([A1.SF(k), A2.SF(k), A3.SF(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2S = arrayfun(@(k) corr([B1.SF(k), B2.SF(k), B3.SF(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3S = arrayfun(@(k) corr([C1.SF(k), C2.SF(k), C3.SF(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k)]', ...
            'Type', 'Spearman'), ...
            (1:num_samples)', 'UniformOutput', true);
        
        % ======================== Correlação de Kendall  ========================%
        correlacoes1K = arrayfun(@(k) corr([A1.SF(k), A2.SF(k), A3.SF(k)]', ...
            [A1.(path)(k), A2.(path)(k), A3.(path)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes2K = arrayfun(@(k) corr([B1.SF(k), B2.SF(k), B3.SF(k)]', ...
            [B1.(path)(k), B2.(path)(k), B3.(path)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        correlacoes3K = arrayfun(@(k) corr([C1.SF(k), C2.SF(k), C3.SF(k)]', ...
            [C1.(aten)(k), C2.(aten)(k), C3.(aten)(k)]', ...
            'Type', 'Kendall'), ...
            (1:num_samples)', 'UniformOutput', true);

        % Média das correlações de Pearson
        correlacao1P(contador) = mean(correlacoes1P);
        correlacao2P(contador) = mean(correlacoes2P);
        correlacao3P(contador) = mean(correlacoes3P);

        % Média das correlações Spearman
        correlacao1S(contador) = mean(correlacoes1S);
        correlacao2S(contador) = mean(correlacoes2S);
        correlacao3S(contador) = mean(correlacoes3S);

        % Média das correlações de Kendall
        correlacao1K(contador) = mean(correlacoes1K);
        correlacao2K(contador) = mean(correlacoes2K);
        correlacao3K(contador) = mean(correlacoes3K);
        contador = contador+1;
    end
end

matriz(:,10) = [mean(correlacao1P);mean(correlacao2P);mean(correlacao3P)];
matriz(:,11) = [mean(correlacao1S);mean(correlacao2S);mean(correlacao3S)];
matriz(:,12) = [mean(correlacao1K);mean(correlacao2K);mean(correlacao3K)];

clear correlacao1P correlacao2P correlacao3P correlacao1S correlacao2S correlacao3S correlacao1K correlacao2K correlacao3K...
    correlacoes1P correlacoes2P correlacoes3P correlacoes1S correlacoes2S correlacoes3S correlacoes1K correlacoes2K correlacoes3K
%% plotagem da correlação

dados(1,:) = [matriz(1,1), matriz(1,4), matriz(1,7), matriz(1,10)];
dados(2,:) = [matriz(2,1), matriz(2,4), matriz(2,7), matriz(2,10)];
dados(3,:) = [matriz(3,1), matriz(3,4), matriz(3,7), matriz(3,10)];
figure
plotarCorrelacaoBar(dados,'linear')
ylim([-1 1])

% ================================================ %
dados(1,:) = [matriz(1,2), matriz(1,5), matriz(1,8), matriz(1,11)];
dados(2,:) = [matriz(2,2), matriz(2,5), matriz(2,8), matriz(2,11)];
dados(3,:) = [matriz(3,2), matriz(3,5), matriz(3,8), matriz(3,11)];
figure
plotarCorrelacaoBar(dados,'spearman')
ylim([-1 1])

% ================================================ %
dados(1,:) = [matriz(1,3), matriz(1,6), matriz(1,9), matriz(1,12)];
dados(2,:) = [matriz(2,3), matriz(2,6), matriz(2,9), matriz(2,12)];
dados(3,:) = [matriz(3,3), matriz(3,6), matriz(3,9), matriz(3,12)];
figure
plotarCorrelacaoBar(dados,'kendall')
ylim([-1 1])

clearvars -except Tabela_Bosque Tabela_Referencia...
    Tabela_Bosque_Interpolada Tabela_Referencia_Interpolada Tabela_Atenuacao ...
    Tabela_Bosque_Janelada Tabela_Referencia_Janelada Tabela_Atenuacao_Janelada