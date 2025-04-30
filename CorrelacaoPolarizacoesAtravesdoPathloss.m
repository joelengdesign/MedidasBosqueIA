alturas = 50:20:110;
SF = [7 9 12];

for k=1:3 % SF
    for i=1:4 % Altura
        ind1 = (a.altura == alturas(i)) & (a.SF == SF(k));
        ind2 = (b.altura == alturas(i))  & (b.SF == SF(k));
        ind3 = (c.altura == alturas(i))  & (c.SF == SF(k));
        A = a(ind1,:);
        B = b(ind2,:);
        C = c(ind3,:);
        
        A_HH = A.polarizacaoNum == 1;
        A_HV = A.polarizacaoNum == 2;
        A_VH = A.polarizacaoNum == 3;
        A_VV = A.polarizacaoNum == 4;

        B_HH = B.polarizacaoNum == 1;
        B_HV = B.polarizacaoNum == 2;
        B_VH = B.polarizacaoNum == 3;
        B_VV = B.polarizacaoNum == 4;

        C_HH = C.polarizacaoNum == 1;
        C_HV = C.polarizacaoNum == 2;
        C_VH = C.polarizacaoNum == 3;
        C_VV = C.polarizacaoNum == 4;
        
        % ======================== Correlação de Pearson  ========================%
        Corr_HH_HV1P(i) = corr(A.(path)(A_HH),A.(path)(A_HV), 'Type', 'Pearson');
        Corr_HH_VH1P(i) = corr(A.(path)(A_HH),A.(path)(A_VH), 'Type', 'Pearson');
        Corr_HH_VV1P(i) = corr(A.(path)(A_HH),A.(path)(A_VV), 'Type', 'Pearson');
        Corr_HV_VH1P(i) = corr(A.(path)(A_HV),A.(path)(A_VH), 'Type', 'Pearson');
        Corr_VV_VH1P(i) = corr(A.(path)(A_VV),A.(path)(A_VH), 'Type', 'Pearson');
        Corr_VV_HV1P(i) = corr(A.(path)(A_VV),A.(path)(A_VH), 'Type', 'Pearson');

        Corr_HH_HV2P(i) = corr(B.(path)(B_HH),B.(path)(B_HV), 'Type', 'Pearson');
        Corr_HH_VH2P(i) = corr(B.(path)(B_HH),B.(path)(B_VH), 'Type', 'Pearson');
        Corr_HH_VV2P(i) = corr(B.(path)(B_HH),B.(path)(B_VV), 'Type', 'Pearson');
        Corr_HV_VH2P(i) = corr(B.(path)(B_HV),B.(path)(B_VH), 'Type', 'Pearson');
        Corr_VV_VH2P(i) = corr(B.(path)(B_VV),B.(path)(B_VH), 'Type', 'Pearson');
        Corr_VV_HV2P(i) = corr(B.(path)(B_VV),B.(path)(B_VH), 'Type', 'Pearson');

        Corr_HH_HV3P(i) = corr(C.(aten)(C_HH),C.(aten)(C_HV), 'Type', 'Pearson');
        Corr_HH_VH3P(i) = corr(C.(aten)(C_HH),C.(aten)(C_VH), 'Type', 'Pearson');
        Corr_HH_VV3P(i) = corr(C.(aten)(C_HH),C.(aten)(C_VV), 'Type', 'Pearson');
        Corr_HV_VH3P(i) = corr(C.(aten)(C_HV),C.(aten)(C_VH), 'Type', 'Pearson');
        Corr_VV_VH3P(i) = corr(C.(aten)(C_VV),C.(aten)(C_VH), 'Type', 'Pearson');
        Corr_VV_HV3P(i) = corr(C.(aten)(C_VV),C.(aten)(C_VH), 'Type', 'Pearson');
        
       
        
        % ======================== Correlação de Spearman  ========================%
        Corr_HH_HV1S(i) = corr(A.(path)(A_HH),A.(path)(A_HV), 'Type', 'Spearman');
        Corr_HH_VH1S(i) = corr(A.(path)(A_HH),A.(path)(A_VH), 'Type', 'Spearman');
        Corr_HH_VV1S(i) = corr(A.(path)(A_HH),A.(path)(A_VV), 'Type', 'Spearman');
        Corr_HV_VH1S(i) = corr(A.(path)(A_HV),A.(path)(A_VH), 'Type', 'Spearman');
        Corr_VV_VH1S(i) = corr(A.(path)(A_VV),A.(path)(A_VH), 'Type', 'Spearman');
        Corr_VV_HV1S(i) = corr(A.(path)(A_VV),A.(path)(A_VH), 'Type', 'Spearman');

        Corr_HH_HV2S(i) = corr(B.(path)(B_HH),B.(path)(B_HV), 'Type', 'Spearman');
        Corr_HH_VH2S(i) = corr(B.(path)(B_HH),B.(path)(B_VH), 'Type', 'Spearman');
        Corr_HH_VV2S(i) = corr(B.(path)(B_HH),B.(path)(B_VV), 'Type', 'Spearman');
        Corr_HV_VH2S(i) = corr(B.(path)(B_HV),B.(path)(B_VH), 'Type', 'Spearman');
        Corr_VV_VH2S(i) = corr(B.(path)(B_VV),B.(path)(B_VH), 'Type', 'Spearman');
        Corr_VV_HV2S(i) = corr(B.(path)(B_VV),B.(path)(B_VH), 'Type', 'Spearman');

        Corr_HH_HV3S(i) = corr(C.(aten)(C_HH),C.(aten)(C_HV), 'Type', 'Spearman');
        Corr_HH_VH3S(i) = corr(C.(aten)(C_HH),C.(aten)(C_VH), 'Type', 'Spearman');
        Corr_HH_VV3S(i) = corr(C.(aten)(C_HH),C.(aten)(C_VV), 'Type', 'Spearman');
        Corr_HV_VH3S(i) = corr(C.(aten)(C_HV),C.(aten)(C_VH), 'Type', 'Spearman');
        Corr_VV_VH3S(i) = corr(C.(aten)(C_VV),C.(aten)(C_VH), 'Type', 'Spearman');
        Corr_VV_HV3S(i) = corr(C.(aten)(C_VV),C.(aten)(C_VH), 'Type', 'Spearman');


        % ======================== Correlação de Kendall  ========================%
        Corr_HH_HV1K(i) = corr(A.(path)(A_HH),A.(path)(A_HV), 'Type', 'Kendall');
        Corr_HH_VH1K(i) = corr(A.(path)(A_HH),A.(path)(A_VH), 'Type', 'Kendall');
        Corr_HH_VV1K(i) = corr(A.(path)(A_HH),A.(path)(A_VV), 'Type', 'Kendall');
        Corr_HV_VH1K(i) = corr(A.(path)(A_HV),A.(path)(A_VH), 'Type', 'Kendall');
        Corr_VV_VH1K(i) = corr(A.(path)(A_VV),A.(path)(A_VH), 'Type', 'Kendall');
        Corr_VV_HV1K(i) = corr(A.(path)(A_VV),A.(path)(A_VH), 'Type', 'Kendall');

        Corr_HH_HV2K(i) = corr(B.(path)(B_HH),B.(path)(B_HV), 'Type', 'Kendall');
        Corr_HH_VH2K(i) = corr(B.(path)(B_HH),B.(path)(B_VH), 'Type', 'Kendall');
        Corr_HH_VV2K(i) = corr(B.(path)(B_HH),B.(path)(B_VV), 'Type', 'Kendall');
        Corr_HV_VH2K(i) = corr(B.(path)(B_HV),B.(path)(B_VH), 'Type', 'Kendall');
        Corr_VV_VH2K(i) = corr(B.(path)(B_VV),B.(path)(B_VH), 'Type', 'Kendall');
        Corr_VV_HV2K(i) = corr(B.(path)(B_VV),B.(path)(B_VH), 'Type', 'Kendall');

        Corr_HH_HV3K(i) = corr(C.(aten)(C_HH),C.(aten)(C_HV), 'Type', 'Kendall');
        Corr_HH_VH3K(i) = corr(C.(aten)(C_HH),C.(aten)(C_VH), 'Type', 'Kendall');
        Corr_HH_VV3K(i) = corr(C.(aten)(C_HH),C.(aten)(C_VV), 'Type', 'Kendall');
        Corr_HV_VH3K(i) = corr(C.(aten)(C_HV),C.(aten)(C_VH), 'Type', 'Kendall');
        Corr_VV_VH3K(i) = corr(C.(aten)(C_VV),C.(aten)(C_VH), 'Type', 'Kendall');
        Corr_VV_HV3K(i) = corr(C.(aten)(C_VV),C.(aten)(C_VH), 'Type', 'Kendall');
    end

    HH_HV1P(k) = mean(Corr_HH_HV1P);
    HH_VH1P(k) = mean(Corr_HH_VH1P);
    HH_VV1P(k) = mean(Corr_HH_VV1P);
    HV_VH1P(k) = mean(Corr_HV_VH1P);
    VV_VH1P(k) = mean(Corr_VV_VH1P);
    VV_HV1P(k) = mean(Corr_VV_HV1P);

    HH_HV2P(k) = mean(Corr_HH_HV2P);
    HH_VH2P(k) = mean(Corr_HH_VH2P);
    HH_VV2P(k) = mean(Corr_HH_VV2P);
    HV_VH2P(k) = mean(Corr_HV_VH2P);
    VV_VH2P(k) = mean(Corr_VV_VH2P);
    VV_HV2P(k) = mean(Corr_VV_HV2P);

    HH_HV3P(k) = mean(Corr_HH_HV3P);
    HH_VH3P(k) = mean(Corr_HH_VH3P);
    HH_VV3P(k) = mean(Corr_HH_VV3P);
    HV_VH3P(k) = mean(Corr_HV_VH3P);
    VV_VH3P(k) = mean(Corr_VV_VH3P);
    VV_HV3P(k) = mean(Corr_VV_HV3P);

    HH_HV1S(k) = mean(Corr_HH_HV1S);
    HH_VH1S(k) = mean(Corr_HH_VH1S);
    HH_VV1S(k) = mean(Corr_HH_VV1S);
    HV_VH1S(k) = mean(Corr_HV_VH1S);
    VV_VH1S(k) = mean(Corr_VV_VH1S);
    VV_HV1S(k) = mean(Corr_VV_HV1S);

    HH_HV2S(k) = mean(Corr_HH_HV2S);
    HH_VH2S(k) = mean(Corr_HH_VH2S);
    HH_VV2S(k) = mean(Corr_HH_VV2S);
    HV_VH2S(k) = mean(Corr_HV_VH2S);
    VV_VH2S(k) = mean(Corr_VV_VH2S);
    VV_HV2S(k) = mean(Corr_VV_HV2S);

    HH_HV3S(k) = mean(Corr_HH_HV3S);
    HH_VH3S(k) = mean(Corr_HH_VH3S);
    HH_VV3S(k) = mean(Corr_HH_VV3S);
    HV_VH3S(k) = mean(Corr_HV_VH3S);
    VV_VH3S(k) = mean(Corr_VV_VH3S);
    VV_HV3S(k) = mean(Corr_VV_HV3S);

    HH_HV1K(k) = mean(Corr_HH_HV1K);
    HH_VH1K(k) = mean(Corr_HH_VH1K);
    HH_VV1K(k) = mean(Corr_HH_VV1K);
    HV_VH1K(k) = mean(Corr_HV_VH1K);
    VV_VH1K(k) = mean(Corr_VV_VH1K);
    VV_HV1K(k) = mean(Corr_VV_HV1K);

    HH_HV2K(k) = mean(Corr_HH_HV2K);
    HH_VH2K(k) = mean(Corr_HH_VH2K);
    HH_VV2K(k) = mean(Corr_HH_VV2K);
    HV_VH2K(k) = mean(Corr_HV_VH2K);
    VV_VH2K(k) = mean(Corr_VV_VH2K);
    VV_HV2K(k) = mean(Corr_VV_HV2K);

    HH_HV3K(k) = mean(Corr_HH_HV3K);
    HH_VH3K(k) = mean(Corr_HH_VH3K);
    HH_VV3K(k) = mean(Corr_HH_VV3K);
    HV_VH3K(k) = mean(Corr_HV_VH3K);
    VV_VH3K(k) = mean(Corr_VV_VH3K);
    VV_HV3K(k) = mean(Corr_VV_HV3K);
end
%% Correlação Linear


figure
subplot(3,1,1)
% Parâmetros que serão plotados
categorias = {'SF7', 'SF9', 'SF12'};
nomes = {'HH/HV', 'HH/VH', 'HH/VV', 'HV/VH', 'VV/VH', 'VV/HV'};

% Criar um gráfico de barras
grafico = [HH_HV1P' HH_VH1P' HH_VV1P'...
    HV_VH1P' VV_VH1P' VV_HV1P'];

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

% Cores: azul escuro -> azul puro -> azul claro
cor_ini = [0 0 0.3];       % azul escuro
cor_meio = [0 0 1];        % azul puro
cor_fim = [0.5 0.75 1];    % azul claro

% Parte escura até o azul puro (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Parte azul puro até claro (excluindo repetição)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover repetição da cor do meio
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Combinar gradientes
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];


for i = 1:nSeries
    b1(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,2)

grafico = [HH_HV2P' HH_VH2P' HH_VV2P'...
    HV_VH2P' VV_VH2P' VV_HV2P'];
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

% Cores: vermelho escuro -> vermelho puro -> vermelho claro
cor_ini = [0.2 0 0];
cor_meio = [1 0 0];
cor_fim = [1 0.6 0.6];

% Do escuro até o meio (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Do meio até o claro (excluindo a cor do meio repetida)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover a primeira cor de tons2 (que repete a do meio)
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Concatenar os dois pedaços
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b2(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,3)

grafico = [HH_HV3P' HH_VH3P' HH_VV3P'...
    HV_VH3P' VV_VH3P' VV_HV3P'];
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

% Cores: amarelo escuro -> amarelo puro -> amarelo claro
cor_ini = [0.3 0.3 0];     % amarelo escuro (meio mostarda)
cor_meio = [1 1 0];        % amarelo puro
cor_fim = [1 1 0.6];       % amarelo claro (com leve branco)

% Parte escura até o amarelo puro (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Parte amarelo puro até claro (excluindo repetição)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover a repetição da cor do meio
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Combinar os tons
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b3(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
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

grafico = [HH_HV1S' HH_VH1S' HH_VV1S'...
    HV_VH1S' VV_VH1S' VV_HV1S'];

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

% Cores: azul escuro -> azul puro -> azul claro
cor_ini = [0 0 0.3];       % azul escuro
cor_meio = [0 0 1];        % azul puro
cor_fim = [0.5 0.75 1];    % azul claro

% Parte escura até o azul puro (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Parte azul puro até claro (excluindo repetição)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover repetição da cor do meio
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Combinar gradientes
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];


for i = 1:nSeries
    b1(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,2)

grafico = [HH_HV2S' HH_VH2S' HH_VV2S'...
    HV_VH2S' VV_VH2S' VV_HV2S'];
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

% Cores: vermelho escuro -> vermelho puro -> vermelho claro
cor_ini = [0.2 0 0];
cor_meio = [1 0 0];
cor_fim = [1 0.6 0.6];

% Do escuro até o meio (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Do meio até o claro (excluindo a cor do meio repetida)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover a primeira cor de tons2 (que repete a do meio)
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Concatenar os dois pedaços
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b2(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end


subplot(3,1,3)

grafico = [HH_HV3S' HH_VH3S' HH_VV3S'...
    HV_VH3S' VV_VH3S' VV_HV3S'];
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

% Cores: amarelo escuro -> amarelo puro -> amarelo claro
cor_ini = [0.3 0.3 0];     % amarelo escuro (meio mostarda)
cor_meio = [1 1 0];        % amarelo puro
cor_fim = [1 1 0.6];       % amarelo claro (com leve branco)

% Parte escura até o amarelo puro (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Parte amarelo puro até claro (excluindo repetição)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover a repetição da cor do meio
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Combinar os tons
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b3(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
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

grafico = [HH_HV1K' HH_VH1K' HH_VV1K'...
    HV_VH1K' VV_VH1K' VV_HV1K'];

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

% Cores: azul escuro -> azul puro -> azul claro
cor_ini = [0 0 0.3];       % azul escuro
cor_meio = [0 0 1];        % azul puro
cor_fim = [0.5 0.75 1];    % azul claro

% Parte escura até o azul puro (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Parte azul puro até claro (excluindo repetição)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover repetição da cor do meio
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Combinar gradientes
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];


for i = 1:nSeries
    b1(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,2)

grafico = [HH_HV2K' HH_VH2K' HH_VV2K'...
    HV_VH2K' VV_VH2K' VV_HV2K'];
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

% Cores: vermelho escuro -> vermelho puro -> vermelho claro
cor_ini = [0.2 0 0];
cor_meio = [1 0 0];
cor_fim = [1 0.6 0.6];

% Do escuro até o meio (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Do meio até o claro (excluindo a cor do meio repetida)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover a primeira cor de tons2 (que repete a do meio)
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Concatenar os dois pedaços
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b2(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
end

subplot(3,1,3)

grafico = [HH_HV3K' HH_VH3K' HH_VV3K'...
    HV_VH3K' VV_VH3K' VV_HV3K'];
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

% Cores: amarelo escuro -> amarelo puro -> amarelo claro
cor_ini = [0.3 0.3 0];     % amarelo escuro (meio mostarda)
cor_meio = [1 1 0];        % amarelo puro
cor_fim = [1 1 0.6];       % amarelo claro (com leve branco)

% Parte escura até o amarelo puro (inclusive)
tonsR1 = linspace(cor_ini(1), cor_meio(1), meio);
tonsG1 = linspace(cor_ini(2), cor_meio(2), meio);
tonsB1 = linspace(cor_ini(3), cor_meio(3), meio);

% Parte amarelo puro até claro (excluindo repetição)
tonsR2 = linspace(cor_meio(1), cor_fim(1), nSeries - meio + 1);
tonsG2 = linspace(cor_meio(2), cor_fim(2), nSeries - meio + 1);
tonsB2 = linspace(cor_meio(3), cor_fim(3), nSeries - meio + 1);

% Remover a repetição da cor do meio
tonsR2 = tonsR2(2:end);
tonsG2 = tonsG2(2:end);
tonsB2 = tonsB2(2:end);

% Combinar os tons
tonsR = [tonsR1, tonsR2];
tonsG = [tonsG1, tonsG2];
tonsB = [tonsB1, tonsB2];

for i = 1:nSeries
    b3(i).FaceColor = [tonsR(i), tonsG(i), tonsB(i)];
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
