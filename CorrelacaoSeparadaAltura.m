alturas = 50:20:110;
SF = [7 9 12];

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
nomes = {'SF7', 'SF9', 'SF12'};
categorias = {'HH', 'HV', 'VH', 'VV'};

% Criar um gráfico de barras
b1 = bar(correlacao1P, 'grouped');
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e pathloss - Bosque');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e pathloss - Referência');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e atenuação - Bosque-Referência');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e pathloss - Bosque');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e pathloss - Referência');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e atenuação - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação de Spearman')
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

%% Correlação de Kendall

figure
subplot(3,1,1)
b1 = bar(correlacao1K, 'grouped');
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e pathloss - Bosque');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e pathloss - Referência');
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
ylim([-1 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre altura e atenuação - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação de Kendall')
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

clearvars -except Tabela_Bosque Tabela_Referencia...
    Tabela_Bosque_Interpolada Tabela_Referencia_Interpolada Tabela_Atenuacao ...
    Tabela_Bosque_Janelada Tabela_Referencia_Janelada Tabela_Atenuacao_Janelada
