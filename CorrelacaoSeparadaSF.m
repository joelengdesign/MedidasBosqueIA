alturas = 50:20:110;
SF = [7 9 12];

for i=1:4
    for k=1:4
        ind1 = (a.altura == alturas(i)) & (a.polarizacaoNum == k);
        ind2 = (b.altura == alturas(i))  & (b.polarizacaoNum == k);
        ind3 = (c.altura == alturas(i))  & (c.polarizacaoNum == k);
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
        
        % Número de amostras mínimas para evitar erro de indexação
        num_samples = min([height(A1), height(A2), height(A3)]);
        
        
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
        correlacao1P(i,k) = mean(correlacoes1P);
        correlacao2P(i,k) = mean(correlacoes2P);
        correlacao3P(i,k) = mean(correlacoes3P);

        % Média das correlações Spearman
        correlacao1S(i,k) = mean(correlacoes1S);
        correlacao2S(i,k) = mean(correlacoes2S);
        correlacao3S(i,k) = mean(correlacoes3S);

        % Média das correlações de Kendall
        correlacao1K(i,k) = mean(correlacoes1K);
        correlacao2K(i,k) = mean(correlacoes2K);
        correlacao3K(i,k) = mean(correlacoes3K);
    end
end

%% Correlação Linear
figure

subplot(3,1,1)
% Parâmetros que serão plotados
nomes = {'HH', 'HV', 'VH', 'VV'};
categorias = {'50m', '70m', '90m', '110m'};

% Criar um gráfico de barras
b1 = bar(correlacao1P, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e pathloss - Bosque');
ylabel('Correlação Linear')
grid on
grid minor
nSeries = size(correlacao1P, 2); % Número de grupos de barras
azuis = linspace(0.2, 1, nSeries); % Tons de azul do mais escuro ao mais claro

for i = 1:nSeries
    b1(i).FaceColor = [0 0 azuis(i)]; % Aplica tons de azul
end

subplot(3,1,2)

% Criar um gráfico de barras
b2 = bar(correlacao2P, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e pathloss - Referência');
ylabel('Correlação Linear')
grid on
grid minor
nSeries = size(correlacao2P, 2); % Número de grupos de barras
tonsVermelho = linspace(0.2, 1, nSeries); 

for i = 1:nSeries
    b2(i).FaceColor = [tonsVermelho(i) 0 0]; % Tons de vermelho puro
end

subplot(3,1,3)

% Criar um gráfico de barras
b3 = bar(correlacao3P, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e atenuação - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação Linear')
grid on
grid minor

nSeries = size(correlacao3P, 2); % Número de grupos de barras
tons = linspace(0.2, 1, nSeries); 

for i = 1:nSeries
    b3(i).FaceColor = [tons(i) tons(i) 0]; % Tons de amarelo
end

hL1 = legend(b1, nomes, 'Orientation', 'vertical');
set(hL1, 'Position', [0.89, 0.73, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL2 = legend(b2, nomes, 'Orientation', 'vertical');
set(hL2, 'Position', [0.89, 0.43, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL3 = legend(b3, nomes, 'Orientation', 'vertical');
set(hL3, 'Position', [0.89, 0.14, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);


%% Correlação de Spearman

figure
subplot(3,1,1)
b1 = bar(correlacao1S, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e pathloss - Bosque');
ylabel('Correlação  de Spearman')
grid on
grid minor
nSeries = size(correlacao1P, 2); % Número de grupos de barras
azuis = linspace(0.2, 1, nSeries); % Tons de azul do mais escuro ao mais claro

for i = 1:nSeries
    b1(i).FaceColor = [0 0 azuis(i)]; % Aplica tons de azul
end

subplot(3,1,2)

% Criar um gráfico de barras
b2 = bar(correlacao2S, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e pathloss - Referência');
ylabel('Correlação de Spearman')
grid on
grid minor
nSeries = size(correlacao2P, 2); % Número de grupos de barras
tonsVermelho = linspace(0.2, 1, nSeries); 

for i = 1:nSeries
    b2(i).FaceColor = [tonsVermelho(i) 0 0]; % Tons de vermelho puro
end

subplot(3,1,3)

% Criar um gráfico de barras
b3 = bar(correlacao3S, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e atenuação - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação de Spearman')
grid on
grid minor
nSeries = size(correlacao3P, 2); % Número de grupos de barras
tons = linspace(0.2, 1, nSeries); 

for i = 1:nSeries
    b3(i).FaceColor = [tons(i) tons(i) 0]; % Tons de amarelo
end

% Criar uma legenda única
hL = legend(b3, nomes, 'Orientation', 'horizontal');
newPosition = [0.71, 0.02, 0.2, 0.05]; % Move a legenda mais para a direita
set(hL, 'Position', newPosition, 'Box', 'off');

%% Correlação de Kendall

figure
subplot(3,1,1)
b1 = bar(correlacao1K, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e pathloss - Bosque');
ylabel('Correlação  de Kendall')
grid on
grid minor
nSeries = size(correlacao1P, 2); % Número de grupos de barras
azuis = linspace(0.2, 1, nSeries); % Tons de azul do mais escuro ao mais claro

for i = 1:nSeries
    b1(i).FaceColor = [0 0 azuis(i)]; % Aplica tons de azul
end

subplot(3,1,2)

% Criar um gráfico de barras
b2 = bar(correlacao2K, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e pathloss - Referência');
ylabel('Correlação de Kendall')
grid on
grid minor
nSeries = size(correlacao2P, 2); % Número de grupos de barras
tonsVermelho = linspace(0.2, 1, nSeries); 

for i = 1:nSeries
    b2(i).FaceColor = [tonsVermelho(i) 0 0]; % Tons de vermelho puro
end

subplot(3,1,3)

% Criar um gráfico de barras
b3 = bar(correlacao3K, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre SF e atenuação - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação de Kendall')
grid on
grid minor
nSeries = size(correlacao3P, 2); % Número de grupos de barras
tons = linspace(0.2, 1, nSeries); 

for i = 1:nSeries
    b3(i).FaceColor = [tons(i) tons(i) 0]; % Tons de amarelo
end

% Criar uma legenda única
hL = legend(b3, nomes, 'Orientation', 'horizontal');
newPosition = [0.71, 0.02, 0.2, 0.05]; % Move a legenda mais para a direita
set(hL, 'Position', newPosition, 'Box', 'off');

clearvars -except Tabela_Bosque Tabela_Referencia...
    Tabela_Bosque_Interpolada Tabela_Referencia_Interpolada Tabela_Atenuacao ...
    Tabela_Bosque_Janelada Tabela_Referencia_Janelada Tabela_Atenuacao_Janelada
