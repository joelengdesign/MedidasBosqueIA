clc,close all
a = Tabela_Bosque;
b = Tabela_Referencia;
c = Tabela_Bosque_Interpolada;
d = Tabela_Referencia_Interpolada;
e = Tabela_Atenuacao;
f = Tabela_Bosque_Janelada;
g = Tabela_Referencia_Janelada;
h = Tabela_Atenuacao_Janelada;a;

variavel_x = 'angulo';
variavel_y = 'pathloss';
polarizacao_label = {'HH', 'HV', 'VH', 'VV'};
% variavel_y = 'SNR'
% variavel_y = 'RSSI'

altura = 50:20:110;
polarizacoes = 1:4;
SFs = [7 9 12];
colors = lines(60);
%%

contador = 1;
deslocamento = -84;
for k = 1:4
    for j=1:4
        figuras(contador) = figure(contador);
        t = tiledlayout(3,2);
        t.Padding = 'compact';
        t.TileSpacing = 'compact';
        handles = gobjects(1, 3);

        ind1 = f.altura == altura(k); % filtrando altura
        f_aux = f(ind1,:);
        ind = f_aux.polarizacaoNum == polarizacoes(j); % filtrando polarizacao
        f_interna = f_aux(ind,:);
        in1 = find(f_interna.SF == 7);
        in2 = find(f_interna.SF == 9);
        in3 = find(f_interna.SF == 12);

        x4 = f_interna.angulo(in1);
        x5 = f_interna.angulo(in2);
        x6 = f_interna.angulo(in3);

        y1 = f_interna.pathloss_media(in1);
        y2 = f_interna.pathloss_media(in2);
        y3 = f_interna.pathloss_media(in3);

        y4 = f_interna.pathloss_desviopadrao(in1);
        y5 = f_interna.pathloss_desviopadrao(in2);
        y6 = f_interna.pathloss_desviopadrao(in3);

        xmin = min([min(x4) min(x5) min(x6)]);
        xmax = max([max(x4) max(x5) max(x6)]);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);

        nexttile;
        % h1= plot(x4, y1, 'Marker', 's', 'Color', colors(1,:), ...
        %     'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF7');
        h1= errorbar(x4, y1, y4, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF7');
        hold on
        h2 = errorbar(x5, y2, y5, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF9');

        h3 = errorbar(x6, y3, y6, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF12');
        set(gca, 'XDir', 'reverse');
        hold off
        grid on
        grid minor
        xlabel('Ângulo em (º)')
        ylabel('pathloss')
        xlim([0 90])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Bosque',deslocamento)

        handles(1) = h1;
        handles(2) = h2;
        handles(3) = h3;

        ind1 = h.altura == altura(k); % filtrando altura
        h_aux = h(ind1,:);
        ind = h_aux.polarizacaoNum == polarizacoes(j); % filtrando polarizacao
        h_interna = h_aux(ind,:);
        in7 = find(h_interna.SF == 7);
        in8 = find(h_interna.SF == 9);
        in9 = find(h_interna.SF == 12);

        x1 = h_interna.angulo(in7);
        x2 = h_interna.angulo(in8);
        x3 = h_interna.angulo(in9);

        y1 = h_interna.atenuacao_media(in7) + freeSpacePathLoss(915,x1);
        y2 = h_interna.atenuacao_media(in8) + freeSpacePathLoss(915,x2);
        y3 = h_interna.atenuacao_media(in9) + freeSpacePathLoss(915,x3);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);

        nexttile;
        plot(x1, y1, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        hold on
        plot(x2, y2, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);

        plot(x3, y3, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        set(gca, 'XDir', 'reverse');
        hold off
        grid on
        grid minor
        xlabel('Ângulo em (º)')
        ylabel('FSPL + Atenuação')
        xlim([0 90])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Pathloss Model Referência',deslocamento)

        ind1 = find(g.altura == altura(k)); % filtrando altura
        g_aux = g(ind1,:);
        ind = find(g_aux.polarizacaoNum == polarizacoes(j)); % filtrando polarizacao
        g_interna = g_aux(ind,:);
        in4 = find(g_interna.SF == 7);
        in5 = find(g_interna.SF == 9);
        in6 = find(g_interna.SF == 12);

        x1 = g_interna.angulo(in4);
        x2 = g_interna.angulo(in5);
        x3 = g_interna.angulo(in6);

        y1 = g_interna.pathloss_media(in4);
        y2 = g_interna.pathloss_media(in5);
        y3 = g_interna.pathloss_media(in6);

        y4 = g_interna.pathloss_desviopadrao(in4);
        y5 = g_interna.pathloss_desviopadrao(in5);
        y6 = g_interna.pathloss_desviopadrao(in6);

        x = sort([x1;x2;x3]);

        y = freeSpacePathLoss(915,x);

        % y = calcularN(x, perdas, d0)

        nexttile;
        errorbar(x1, y1, y4, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        hold on
        errorbar(x2, y2, y5, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);

        errorbar(x3, y3, y6, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        set(gca, 'XDir', 'reverse');
        % h4 = plot(x, y, 'Marker', '*', 'Color', colors(6,:), ...
        %   'MarkerSize', 8, 'LineWidth', 1.5);
        % legend(h4, 'Free-Space', 'Location', 'southwest')
        hold off
        grid on
        grid minor
        xlabel('Ângulo em (º)')
        ylabel('pathloss')
        xlim([0 90])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Referência',deslocamento)

        x1 = h_interna.angulo(in7);
        x2 = h_interna.angulo(in8);
        x3 = h_interna.angulo(in9);

        y1 = h_interna.atenuacao_media(in7);
        y2 = h_interna.atenuacao_media(in8);
        y3 = h_interna.atenuacao_media(in9);

        y4 = h_interna.atenuacao_desviopadrao(in7);
        y5 = h_interna.atenuacao_desviopadrao(in8);
        y6 = h_interna.atenuacao_desviopadrao(in9);

        xmin = min([min(x1) min(x2) min(x3)]);
        xmax = max([max(x1) max(x2) max(x3)]);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);


        nexttile;
        errorbar(x1, y1, y4, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        hold on
        errorbar(x2, y2, y5, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        errorbar(x3, y3, y6, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        set(gca, 'XDir', 'reverse');
        hold off
        grid on
        grid minor
        xlabel('Ângulo em (º)')
        ylabel('Atenuação Referência')
        xlim([0 90])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Bosque-Referência',deslocamento)

        y1 = f_interna.pathloss_media(in1) - freeSpacePathLoss(915,x4);
        y2 = f_interna.pathloss_media(in2) - freeSpacePathLoss(915,x5);
        y3 = f_interna.pathloss_media(in3) - freeSpacePathLoss(915,x6);

        xmin = min([min(x4) min(x5) min(x6)]);
        xmax = max([max(x4) max(x5) max(x6)]);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);

        nexttile;
        plot(x4, y1, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        hold on
        plot(x5, y2, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);

        plot(x6, y3, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        set(gca, 'XDir', 'reverse');
        hold off
        grid on
        grid minor
        xlabel('Ângulo em (º)')
        ylabel('Atenuação Espaço Livre')
        xlim([0 90])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Perda no Bosque - Perda Espaço Livre',deslocamento)

        lgd = legend(handles, 'Orientation', 'horizontal');
        lgd.Layout.Tile = 'south';
        lgd.Box = 'off';
        lgd.FontSize = 12;
        sgtitle(sprintf('%im / %s', altura(k),polarizacao_label{j}))
        contador = contador + 1;
    end
end




