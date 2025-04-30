function plotarGeo(T)

latitude = T.latitude; % Exemplo
longitude = T.longitude; % Exemplo
pathloss = T.pathloss; % Exemplo

% Criar o mapa de fundo
geobasemap satellite;
geoscatter(latitude, longitude, 50, pathloss, 'filled');
colorbar; % Adiciona a barra de cores
colormap(jet); % Define o mapa de cores
clim([min(pathloss) max(pathloss)]); % Define os limites da colorbar
geolimits([min(latitude) max(latitude)], [min(longitude) max(longitude)]); % Ajusta os limites do mapa
grid on;

end