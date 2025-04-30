function maximizarGraficos(idx,figuras)

% Maximiza o segundo gráfico na Tela 2
figure(figuras(idx));
set(gcf, 'WindowState', 'maximized');
movegui(gcf, 'east'); % Move para a tela da direita
set(gcf, 'WindowState', 'maximized');

end