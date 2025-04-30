function [n, curva_regressao] = calcularN(distancias, perdas, d0)

% Função para calcular o expoente de perda de caminho n baseado em dados medidos
% distancias: vetor de distâncias (em metros)
% perdas: vetor de perdas de caminho (em dB)
% d0: distância de referência (em metros), por exemplo, 1 metro

% Transformação logarítmica
x = log10(distancias / d0);  % x = log10(d / d0)
y = perdas - perdas(1);      % y = L(d) - L(d0)

% Realizar regressão linear (ajuste dos dados)
p = polyfit(x, y, 1);  % Ajuste linear (1º grau)

% O coeficiente angular m corresponde a 10n
m = p(1);

% Calcule o valor de n
n = m / 10;

% Gerar a curva da regressão para as distâncias fornecidas
curva_regressao = polyval(p, x);

% Plotar os dados medidos e a curva de regressão
figure;
plot(distancias, perdas, 'bo', 'DisplayName', 'Dados Medidos');
hold on;
plot(distancias, perdas(1) + curva_regressao, 'r-', 'DisplayName', 'Curva de Regressão');
xlabel('Distância (m)');
ylabel('Perda de Caminho (dB)');
title('Regressão Log-Distância');
legend;
grid on;

end
