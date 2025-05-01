clear; clc; close all

fig = figure('Visible', 'off');
fig.Position = [100, 100, 1280, 720];  % Resolução do vídeo

outputFolder = fullfile(pwd, 'videos');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

videoPath = fullfile(outputFolder, 'aaaa.mp4');
video = VideoWriter(videoPath, 'MPEG-4');
video.FrameRate = 15;
open(video);

theta = linspace(0, 2*pi, 360);
frames = 150;

% ---------- Curva 1: fixa ----------
ruido1 = 0.4 * randn(1, length(theta));
suav1 = smoothdata(ruido1, 'gaussian', 15);
r1 = abs(cos(theta)).^2 + suav1;
r1 = max(r1, 0);

% ---------- Inicialização do gráfico polar ----------
polarplot(theta, r1, 'LineWidth', 2, 'Color', [0.1 0.5 1]);  % Curva fixa (azul)
hold on
p2 = polarplot(theta, zeros(size(theta)), 'LineWidth', 2, 'Color', [1 0.3 0.3]);  % Curva variável (vermelha)
rlim([0 1.2]);
title('Gráfico Polar com 2 Curvas', 'FontSize', 14);

for i = 1:frames
    % Atualiza apenas a segunda curva
    ruido2 = 0.4 * randn(1, length(theta));
    suav2 = smoothdata(ruido2, 'gaussian', 15);
    r2 = abs(sin(theta)).^2 + suav2;
    r2 = max(r2, 0);

    set(p2, 'RData', r2);  % Atualiza a curva vermelha
    drawnow;

    frame = getframe(fig);
    writeVideo(video, frame);
end

close(video);
