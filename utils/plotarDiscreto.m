function [h1, h2, h3] = plotarDiscreto(x, vetor1, vetor2, vetor3)
% Definição dos marcadores para cada vetor

% Encontrar os limites absolutos
limite_inferior = max([min(vetor1), min(vetor2), min(vetor3)]);
limite_superior = min([max(vetor1), max(vetor2), max(vetor3)]);

% Definir número de níveis de discretização
niveis = 25;
% Discretizando os vetores
vetor1_discretizado = floor((vetor1 - limite_inferior) * niveis / (limite_superior - limite_inferior)) / niveis * (limite_superior - limite_inferior) + limite_inferior;
vetor2_discretizado = floor((vetor2 - limite_inferior) * niveis / (limite_superior - limite_inferior)) / niveis * (limite_superior - limite_inferior) + limite_inferior;
vetor3_discretizado = floor((vetor3 - limite_inferior) * niveis / (limite_superior - limite_inferior)) / niveis * (limite_superior - limite_inferior) + limite_inferior;

% Criando o gráfico
hold on;
grid on;
grid minor

% Plotando os vetores discretizados
h1 = plot(x, vetor1_discretizado, 's-', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'SF7');
hold on;
h2 = plot(x, vetor2_discretizado, '^-', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'SF9');
h3 = plot(x, vetor3_discretizado, 'o-', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'SF12');

% Exemplo para plotar os dados reais (sem discretização)
% Caso queira comparar com os dados reais, basta descomentar e usar
% as variáveis reais nos plots abaixo.

% Descomente para adicionar o gráfico do vetor1 real
% h1_real = plot(x, vetor1, 'r-', 'LineWidth', 2, 'DisplayName', 'Vetor 1 Real');

% Descomente para adicionar o gráfico do vetor2 real
% h2_real = plot(x, vetor2, 'b-', 'LineWidth', 2, 'DisplayName', 'Vetor 2 Real');

% Descomente para adicionar o gráfico do vetor3 real
% h3_real = plot(x, vetor3, 'g-', 'LineWidth', 2, 'DisplayName', 'Vetor 3 Real');

% Configuração do gráfico
hold off;
xlabel('Índice');
ylabel('Valor Discretizado');
title('Curvas Discretizadas');

if nargout == 0
    clear h1;
    clear h2;
    clear h3;
end
end
