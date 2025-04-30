function plotarCorrelacaoBar(dados,legendaY)

% Parâmetros que serão plotados
categorias = {'Distancia', 'Altura', 'Polarizacao', 'SF'};
nomes = {'Floresta', 'Referencia', 'Atenuacao'};

% Criar um gráfico de barras
bar(dados', 'grouped');

% Configurar o gráfico
set(gca, 'XTickLabel', categorias); % Definir os rótulos no eixo X
set(gca, 'XTick', 1:4); % Marcar as posições das categorias no eixo X

% Adicionar título e rótulos aos eixos
title('Correlação entre variáveis e pathloss');
xlabel('Parâmetros');

if strcmp(legendaY,'linear')
    ylabel('Valores de Correlação Linear');
elseif strcmp(legendaY,'spearman')
    ylabel('Valores de Correlação de Spearman');
elseif strcmp(legendaY,'kendall')
    ylabel('Valores de Correlação de Kendall');
else
    error('opção inválida')
end


legend(nomes, 'Location', 'Best');

% Personalização da aparência
colormap([0.8 0.1 0.1; 0.1 0.8 0.1; 0.1 0.1 0.8]); % Cores para Floresta, Referência e Atenuação
grid on;

end