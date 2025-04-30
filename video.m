clear; clc; close all

fig = figure('Visible', 'off');
fig.Position = [100, 100, 1280, 720];  % Resolução do vídeo

outputFolder = fullfile(pwd, 'videos');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

videoPath = fullfile(outputFolder, 'diagrama_duplo.mp4');
video = VideoWriter(videoPath, 'MPEG-4');
video.FrameRate = 15;
open(video);

theta = linspace(0, 2*pi, 360);
frames = 150;

base_pattern1 = @(t) abs(cos(t)).^2;    % Padrão 1
base_pattern2 = @(t) abs(sin(t)).^2;    % Padrão 2

for i = 1:frames
    % Ruído e suavização
    ruido1 = 0.4 * randn(1, length(theta));
    suav1 = smoothdata(ruido1, 'gaussian', 15);
    r1 = base_pattern1(theta) + suav1;
    r1 = max(r1, 0);

    ruido2 = 0.4 * randn(1, length(theta));
    suav2 = smoothdata(ruido2, 'gaussian', 15);
    r2 = base_pattern2(theta) + suav2;
    r2 = max(r2, 0);

    % Gráfico 1 - lado esquerdo
    subplot(1,2,1);
    polarplot(theta, r1, 'LineWidth', 2, 'Color', [0.1 0.5 1]);
    rlim([0 1.2]);
    title(['Padrão 1 - Frame ', num2str(i)], 'FontSize', 12);

    % Gráfico 2 - lado direito
    subplot(1,2,2);
    polarplot(theta, r2, 'LineWidth', 2, 'Color', [1 0.3 0.3]);
    rlim([0 1.2]);
    title(['Padrão 2 - Frame ', num2str(i)], 'FontSize', 12);

    drawnow;

    frame = getframe(fig);
    writeVideo(video, frame);
end

close(video);
