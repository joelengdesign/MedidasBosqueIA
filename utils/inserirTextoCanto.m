function inserirTextoCanto(texto,deslocamento)

% Pegar os limites dos eixos
x_limits = xlim;
y_limits = ylim;

% Calcular a posição do texto no canto inferior direito
x_pos = x_limits(2) - (x_limits(2) - x_limits(1)) * 0.05+deslocamento; % 5% da largura à esquerda do canto
y_pos = y_limits(1) + (y_limits(2) - y_limits(1)) * 0.05; % 5% da altura acima do limite inferior

% Inserir texto com caixa ao redor
text(x_pos, y_pos, texto, ...
    'FontSize', 10, 'Color', 'black', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black', 'LineWidth', 1.5, ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')

end
