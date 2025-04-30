alturas = 50:20:110;
polarizacoes = [1 2 3 4];

for k=1:4 % polarização
    for i=1:4 % Altura
        ind1 = (a.altura == alturas(i)) & (a.polarizacaoNum == polarizacoes(k));
        ind2 = (b.altura == alturas(i))  & (b.polarizacaoNum == polarizacoes(k));
        ind3 = (c.altura == alturas(i))  & (c.polarizacaoNum == polarizacoes(k));
        A = a(ind1,:);
        B = b(ind2,:);
        C = c(ind3,:);
        
        A_SF7 = A.SF == 7;
        A_SF9 = A.SF == 9;
        A_SF12 = A.SF == 12;

        B_SF7 = B.SF == 7;
        B_SF9 = B.SF == 9;
        B_SF12 = B.SF == 12;

        C_SF7 = C.SF == 7;
        C_SF9 = C.SF == 9;
        C_SF12 = C.SF == 12;
        
        % ======================== Correlação de Pearson  ========================%
        Corr_SF7_SF91P(i) = corr(A.(path)(A_SF7),A.(path)(A_SF9), 'Type', 'Pearson');
        Corr_SF7_SF121P(i) = corr(A.(path)(A_SF7),A.(path)(A_SF12), 'Type', 'Pearson');
        Corr_SF9_SF121P(i) = corr(A.(path)(A_SF9),A.(path)(A_SF12), 'Type', 'Pearson');

        Corr_SF7_SF92P(i) = corr(B.(path)(B_SF7),B.(path)(B_SF9), 'Type', 'Pearson');
        Corr_SF7_SF122P(i) = corr(B.(path)(B_SF7),B.(path)(B_SF12), 'Type', 'Pearson');
        Corr_SF9_SF122P(i) = corr(B.(path)(B_SF9),B.(path)(B_SF12), 'Type', 'Pearson');

        Corr_SF7_SF93P(i) = corr(C.(aten)(C_SF7),C.(aten)(C_SF9), 'Type', 'Pearson');
        Corr_SF7_SF123P(i) = corr(C.(aten)(C_SF7),C.(aten)(C_SF12), 'Type', 'Pearson');
        Corr_SF9_SF123P(i) = corr(C.(aten)(C_SF9),C.(aten)(C_SF12), 'Type', 'Pearson');



        % ======================== Correlação de Spearman  ========================%
        Corr_SF7_SF91S(i) = corr(A.(path)(A_SF7),A.(path)(A_SF9), 'Type', 'Spearman');
        Corr_SF7_SF121S(i) = corr(A.(path)(A_SF7),A.(path)(A_SF12), 'Type', 'Spearman');
        Corr_SF9_SF121S(i) = corr(A.(path)(A_SF9),A.(path)(A_SF12), 'Type', 'Spearman');

        Corr_SF7_SF92S(i) = corr(B.(path)(B_SF7),B.(path)(B_SF9), 'Type', 'Spearman');
        Corr_SF7_SF122S(i) = corr(B.(path)(B_SF7),B.(path)(B_SF12), 'Type', 'Spearman');
        Corr_SF9_SF122S(i) = corr(B.(path)(B_SF9),B.(path)(B_SF12), 'Type', 'Spearman');

        Corr_SF7_SF93S(i) = corr(C.(aten)(C_SF7),C.(aten)(C_SF9), 'Type', 'Spearman');
        Corr_SF7_SF123S(i) = corr(C.(aten)(C_SF7),C.(aten)(C_SF12), 'Type', 'Spearman');
        Corr_SF9_SF123S(i) = corr(C.(aten)(C_SF9),C.(aten)(C_SF12), 'Type', 'Spearman');


        % ======================== Correlação de Kendall  ========================%
        Corr_SF7_SF91K(i) = corr(A.(path)(A_SF7),A.(path)(A_SF9), 'Type', 'Kendall');
        Corr_SF7_SF121K(i) = corr(A.(path)(A_SF7),A.(path)(A_SF12), 'Type', 'Kendall');
        Corr_SF9_SF121K(i) = corr(A.(path)(A_SF9),A.(path)(A_SF12), 'Type', 'Kendall');

        Corr_SF7_SF92K(i) = corr(B.(path)(B_SF7),B.(path)(B_SF9), 'Type', 'Kendall');
        Corr_SF7_SF122K(i) = corr(B.(path)(B_SF7),B.(path)(B_SF12), 'Type', 'Kendall');
        Corr_SF9_SF122K(i) = corr(B.(path)(B_SF9),B.(path)(B_SF12), 'Type', 'Kendall');

        Corr_SF7_SF93K(i) = corr(C.(aten)(C_SF7),C.(aten)(C_SF9), 'Type', 'Kendall');
        Corr_SF7_SF123K(i) = corr(C.(aten)(C_SF7),C.(aten)(C_SF12), 'Type', 'Kendall');
        Corr_SF9_SF123K(i) = corr(C.(aten)(C_SF9),C.(aten)(C_SF12), 'Type', 'Kendall');
    end
    SF7_SF91P(k)   = mean(Corr_SF7_SF91P);
    SF7_SF121P(k)  = mean(Corr_SF7_SF121P);
    SF9_SF121P(k) = mean(Corr_SF9_SF121P);

    SF7_SF92P(k)   = mean(Corr_SF7_SF92P);
    SF7_SF122P(k)  = mean(Corr_SF7_SF122P);
    SF9_SF122P(k)  = mean(Corr_SF9_SF122P);

    SF7_SF93P(k)   = mean(Corr_SF7_SF93P);
    SF7_SF123P(k)  = mean(Corr_SF7_SF123P);
    SF9_SF123P(k)  = mean(Corr_SF9_SF123P);

    SF7_SF91S(k)   = mean(Corr_SF7_SF91S);
    SF7_SF121S(k)  = mean(Corr_SF7_SF121S);
    SF9_SF121S(k)  = mean(Corr_SF9_SF121S);

    SF7_SF92S(k)   = mean(Corr_SF7_SF92S);
    SF7_SF122S(k)  = mean(Corr_SF7_SF122S);
    SF9_SF122S(k)  = mean(Corr_SF9_SF122S);

    SF7_SF93S(k)   = mean(Corr_SF7_SF93S);
    SF7_SF123S(k)  = mean(Corr_SF7_SF123S);
    SF9_SF123S(k)  = mean(Corr_SF9_SF123S);

    SF7_SF91K(k)   = mean(Corr_SF7_SF91K);
    SF7_SF121K(k)  = mean(Corr_SF7_SF121K);
    SF9_SF121K(k)  = mean(Corr_SF9_SF121K);

    SF7_SF92K(k)   = mean(Corr_SF7_SF92K);
    SF7_SF122K(k)  = mean(Corr_SF7_SF122K);
    SF9_SF122K(k)  = mean(Corr_SF9_SF122K);

    SF7_SF93K(k)   = mean(Corr_SF7_SF93K);
    SF7_SF123K(k)  = mean(Corr_SF7_SF123K);
    SF9_SF123K(k)  = mean(Corr_SF9_SF123K);
end
%% Correlação Linear


figure

subplot(3,1,1)
% Parâmetros que serão plotados
categorias = {'50m', '70m', '90m', '110m'};
nomes = {'SF7/SF9', 'SF7/SF12', 'SF9/SF12'};

% Criar um gráfico de barras
grafico = [SF7_SF91P' SF7_SF121P' SF9_SF121P'];

b1 = bar(grafico, 'grouped');

ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de pathloss em diferentes polarizações - Bosque');
ylabel('Correlação Linear')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0 0 0.2]; 
cor_meio = [0 0 1]; 
cor_fim = [0.6 0.6 1]; 

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b1(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end


subplot(3,1,2)

grafico = [SF7_SF92P' SF7_SF122P' SF9_SF122P'];
% Criar um gráfico de barras

b2 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de pathloss em diferentes polarizações - Referência');
ylabel('Correlação Linear')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0.2 0 0];
cor_meio = [1 0 0];
cor_fim = [1 0.6 0.6]; 

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];


for i = 1:nSeries
    b2(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,3)

grafico = [SF7_SF93P' SF7_SF123P' SF9_SF123P'];
% Criar um gráfico de barras
b3 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de atenuações em diferentes polarizações - Bosque-Referência');
xlabel('Altura');
ylabel('Correlação Linear')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0.5 0.5 0];
cor_meio = [1 1 0];
cor_fim = [1 1 0.6];

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b3(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end


hL1 = legend(b1, nomes, 'Orientation', 'vertical');
set(hL1, 'Position', [0.90, 0.73, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL2 = legend(b2, nomes, 'Orientation', 'vertical');
set(hL2, 'Position', [0.90, 0.43, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL3 = legend(b3, nomes, 'Orientation', 'vertical');
set(hL3, 'Position', [0.90, 0.14, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);


%% Correlação de Spearman

figure
subplot(3,1,1)

grafico = [SF7_SF91S' SF7_SF121S' SF9_SF121S'];

b1 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de pathloss em diferentes polarizações - Bosque');
ylabel('Correlação  de Spearman')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0 0 0.2];     % azul escuro
cor_meio = [0 0 1];      % azul puro
cor_fim = [0.6 0.6 1];   % azul claro

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b1(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,2)

grafico = [SF7_SF92S' SF7_SF122S' SF9_SF122S'];
% Criar um gráfico de barras
b2 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de pathloss em diferentes polarizações - Referência');
ylabel('Correlação de Spearman')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0.2 0 0];
cor_meio = [1 0 0];
cor_fim = [1 0.6 0.6]; 

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];


for i = 1:nSeries
    b2(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,3)

grafico = [SF7_SF93S' SF7_SF123S' SF9_SF123S'];
% Criar um gráfico de barras
b3 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de atenuações em diferentes polarizações - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação de Spearman')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0.5 0.5 0];   % amarelo escuro (meio oliva)
cor_meio = [1 1 0];      % amarelo puro
cor_fim = [1 1 0.6];     % amarelo claro

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b3(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end


hL1 = legend(b1, nomes, 'Orientation', 'vertical');
set(hL1, 'Position', [0.90, 0.73, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL2 = legend(b2, nomes, 'Orientation', 'vertical');
set(hL2, 'Position', [0.90, 0.43, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL3 = legend(b3, nomes, 'Orientation', 'vertical');
set(hL3, 'Position', [0.90, 0.14, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

%% Correlação de Kendall

figure
subplot(3,1,1)

grafico = [SF7_SF91K' SF7_SF121K' SF9_SF121K'];

b1 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de pathloss em diferentes polarizações - Bosque');
ylabel('Correlação  de Kendall')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0 0 0.2]; 
cor_meio = [0 0 1]; 
cor_fim = [0.6 0.6 1]; 

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b1(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,2)

grafico = [SF7_SF92K' SF7_SF122K' SF9_SF122K'];
% Criar um gráfico de barras
b2 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de pathloss em diferentes polarizações - Referência');
ylabel('Correlação de Kendall')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0.2 0 0];
cor_meio = [1 0 0];
cor_fim = [1 0.6 0.6]; 

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];


for i = 1:nSeries
    b2(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,3)

grafico = [SF7_SF93K' SF7_SF123K' SF9_SF123K'];
% Criar um gráfico de barras
b3 = bar(grafico, 'grouped');
ylim([0 1])

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlações de atenuações em diferentes polarizações - Bosque-Referência');
xlabel('Polarização');
ylabel('Correlação de Kendall')
grid on
grid minor

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

nSeries = size(grafico, 2);
meio = ceil(nSeries / 2);

cor_ini = [0.5 0.5 0];
cor_meio = [1 1 0];
cor_fim = [1 1 0.6];  

tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio);

tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b3(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

hL1 = legend(b1, nomes, 'Orientation', 'vertical');
set(hL1, 'Position', [0.90, 0.73, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL2 = legend(b2, nomes, 'Orientation', 'vertical');
set(hL2, 'Position', [0.90, 0.43, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

hL3 = legend(b3, nomes, 'Orientation', 'vertical');
set(hL3, 'Position', [0.90, 0.14, 0.1, 0.15], 'Box', 'off', 'ItemTokenSize', [30, 3]);

clearvars -except Tabela_Bosque Tabela_Referencia...
    Tabela_Bosque_Interpolada Tabela_Referencia_Interpolada Tabela_Atenuacao ...
    Tabela_Bosque_Janelada Tabela_Referencia_Janelada Tabela_Atenuacao_Janelada
