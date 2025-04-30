function plotarPredominanciaBar(vetor1, vetor2, vetor3)
% Inicializa um vetor para contar quantas vezes cada vetor teve o maior valor
predominancia = zeros(1,3);

% Define o limiar de diferença para considerar valores próximos
limiar = 7;

% Percorre cada índice dos vetores
for i = 1:length(vetor1)
    valores = [vetor1(i), vetor2(i), vetor3(i)]; % Obtém os valores no índice atual
    [~, ~] = max(valores); % Determina o maior valor e seu índice
    
    % Calcula as diferenças entre todas as combinações possíveis (2 a 2)
    diff12 = abs(vetor1(i) - vetor2(i));
    diff13 = abs(vetor1(i) - vetor3(i));
    diff23 = abs(vetor2(i) - vetor3(i));
    
    % Caso todas as diferenças sejam menores ou iguais ao limiar, conta para todos
    if diff12 <= limiar && diff13 <= limiar && diff23 <= limiar
        predominancia = predominancia + 1;
    
    % Caso duas amostras sejam próximas, mas a terceira seja significativamente maior
    elseif diff12 <= limiar && valores(3) - valores(1) > limiar && valores(3) - valores(2) > limiar
        % fprintf('Distância %d\nDiferença entre SF7 e SF9: %f\nDiferença entre SF7 e SF12: %f\nDiferença entre SF9 e SF12: %f\n\n', i, diff12, diff13, diff23);
    elseif diff13 <= limiar && valores(2) - valores(1) > limiar && valores(2) - valores(3) > limiar
        % fprintf('Distância %d\nDiferença entre SF7 e SF9: %f\nDiferença entre SF7 e SF12: %f\nDiferença entre SF9 e SF12: %f\n\n', i, diff12, diff13, diff23);
        predominancia(2) = predominancia(2) + 1;
    elseif diff23 <= limiar && valores(1) - valores(2) > limiar && valores(1) - valores(3) > limiar
        % fprintf('Distância %d\nDiferença entre SF7 e SF9: %f\nDiferença entre SF7 e SF12: %f\nDiferença entre SF9 e SF12: %f\n\n', i, diff12, diff13, diff23);
        predominancia(1) = predominancia(1) + 1;
    
    % Caso duas sejam as maiores e a outra seja significativamente menor
    elseif diff12 <= limiar && valores(3) < valores(1) - limiar && valores(3) < valores(2) - limiar
        % fprintf('Distância %d\nDiferença entre SF7 e SF9: %f\nDiferença entre SF7 e SF12: %f\nDiferença entre SF9 e SF12: %f\n\n', i, diff12, diff13, diff23);
        predominancia(1) = predominancia(1) + 1;
        predominancia(2) = predominancia(2) + 1;
    elseif diff13 <= limiar && valores(2) < valores(1) - limiar && valores(2) < valores(3) - limiar
        % fprintf('Distância %d\nDiferença entre SF7 e SF9: %f\nDiferença entre SF7 e SF12: %f\nDiferença entre SF9 e SF12: %f\n\n', i, diff12, diff13, diff23);
        predominancia(1) = predominancia(1) + 1;
        predominancia(3) = predominancia(3) + 1;
    elseif diff23 <= limiar && valores(1) < valores(2) - limiar && valores(1) < valores(3) - limiar
        % fprintf('Distância %d\nDiferença entre SF7 e SF9: %f\nDiferença entre SF7 e SF12: %f\nDiferença entre SF9 e SF12: %f\n\n', i, diff12, diff13, diff23);
        predominancia(2) = predominancia(2) + 1;
        predominancia(3) = predominancia(3) + 1;
    end
end

% Plota o gráfico de barras para mostrar a frequência de predominância de cada vetor
hold on;
for i = 1:length(predominancia)
    bar(i, predominancia(i), 'BarWidth', 0.5, 'EdgeColor', 'none');
end
hold off;

% Configurações do gráfico
set(gca, 'XTick', []);  % Remove os números do eixo X
title('Frequência de maior pathloss considerando diferenças <= 6dB');
grid on
grid minor
hold off
end