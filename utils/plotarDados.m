function plotarDados(varargin)

numArgs = nargin;
dados = varargin{1};
variavel_x = varargin{2};
variavel_y = varargin{3};
tipoplot = varargin{4};
if numArgs == 5
    modelos = varargin{5};
elseif numArgs ~=4 && numArgs~=5
    error('Número de parâmetros de entrada inválido para a função plotarGraficoSimples')
end
% Função de plotar gráficos
%
% DADOS - dados filtrados com o cenário, SF e Altura
%
% CENARIO - 'bosque' ou 'floresta' - apenas para título do gráfico
%
% VARIAVEL_X - string que representa a variável x e pode ser: 'distancia' ou 'angulo'
%
% VARIAVEL_Y - string que representa a variável y e pode ser: 'pathloss', 'RSSI' ou 'SNR'
%
% TIPOPLOT - booleano que representa o tipo de plot: 1 para SUBPLOT (todos os plots em uma única janela) ou
% 0 para FIGURE (todos os plots em janelas diferentes
%
% MODELOS - vetor de strings que fiz quais modelos devem ser incluídos nas  janelas de plotagem
% essa argumento de entrada deve ser usado desde que o outro argumento dados contenha campos relacionados aos modelos
%
% EXEMPLOS
% DADOS = Tabela_Bosque;
% X = 'distancias'
% Y = 'RSSI'
% TIPOPLOT = 1; % plotar gráficos em subplot
%
% plotarGraficoSimples()



ind1 = find(dados.polarizacaoNum == 1); % HH
ind2 = find(dados.polarizacaoNum == 2); % HV
ind3 = find(dados.polarizacaoNum == 3); % VH
ind4 = find(dados.polarizacaoNum == 4); % VV
ind = {ind1,ind2,ind3,ind4};

titulo = dados.cenario(1);

% if strcmp(variavel_x, 'distancia') && strcmp(variavel_y, 'pathloss')
%     x = dados.distancias;
%     y = dados.pathloss;
% elseif strcmp(variavel_x, 'distancia') && strcmp(variavel_y, 'RSSI')
%     x = dados.distancias;
%     y = dados.RSSI;
% elseif strcmp(variavel_x, 'distancia') && strcmp(variavel_y, 'SNR')
%     x = dados.distancias;
%     y = dados.SNR;
% elseif strcmp(variavel_x, 'angulo') && strcmp(variavel_y, 'pathloss')
%     x = dados.angulo;
%     y = dados.pathloss;
% elseif strcmp(variavel_x, 'angulo') && strcmp(variavel_y, 'RSSI')
%     x = dados.angulo;
%     y = dados.RSSI;
% elseif strcmp(variavel_x, 'angulo') && strcmp(variavel_y, 'SNR')
%     x = dados.angulo;
%     y = dados.SNR;
% end
x = dados.(variavel_x);
y = dados.(variavel_y);

polarizacoes_labels = {'HH', 'HV', 'VH', 'VV'};
if tipoplot
    for i=1:4
        subplot(2,2,i)
        plot(x(ind{i}), y(ind{i}), 'b*')
        if strcmp(variavel_x, 'angulo')
            set(gca, 'XDir', 'reverse');
        end
        xlabel(variavel_x);
        ylabel(variavel_y);
        title(polarizacoes_labels{i});
        grid on;
        grid minor

        if numArgs == 6
            hold on
            for i = 1:length(modelos)
                campo = modelos{i};  % Nome da coluna
                yModelo = dados.(campo);  % Acessando a coluna correspondente
                plot(x(ind{i}), yModelo(ind{i}), 'b*')
            end
            legend('Dados Reais',modelos)
        end
    end
else
    for i=1:4
        figure(i)
        scatter(x(ind{i}), y(ind{i}), 'b','filled');
        if strcmp(variavel_x, 'angulo')
            set(gca, 'XDir', 'reverse');
        end
        xlabel(variavel_x);
        ylabel(variavel_y);
        title(sprintf('Dados %s - SF%d/%s',dados.cenario(1,:),dados.SF(1), polarizacoes_labels{i}));
        grid on;
        grid minor

        if numArgs == 5
            hold on
            for i = 1:length(modelos)
                campo = modelos{i};  % Nome da coluna
                yModelo = dados.(campo);  % Acessando a coluna correspondente
                scatter(x(ind{i}),yModelo(ind{i}),'filled')
            end
            legend('Dados Reais',modelos)
        end
    end
end
end