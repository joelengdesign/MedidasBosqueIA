clc,close all
a = Tabela_Bosque;
b = Tabela_Referencia;
c = Tabela_Bosque_Interpolada;
d = Tabela_Referencia_Interpolada;
e = Tabela_Atenuacao;
f = Tabela_Bosque_Janelada;
g = Tabela_Referencia_Janelada;
h = Tabela_Atenuacao_Janelada;

variavel_x = 'distanciasR';
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
deslocamento = 12;
for k = 1:4
    for j=1:4
        figuras(contador) = figure(contador);
        t = tiledlayout(3,1);
        t.Padding = 'compact';
        t.TileSpacing = 'compact';
        handles = gobjects(1, 3);

        ind1 = c.altura == altura(k); % filtrando altura
        c_aux = c(ind1,:);
        ind = c_aux.polarizacaoNum == polarizacoes(j); % filtrando polarizacao
        c_interna = c_aux(ind,:);
        in1 = find(c_interna.SF == 7);
        in2 = find(c_interna.SF == 9);
        in3 = find(c_interna.SF == 12);

        x4 = c_interna.distanciasR(in1);
        x5 = c_interna.distanciasR(in2);
        x6 = c_interna.distanciasR(in3);

        y1 = c_interna.pathloss(in1);
        y2 = c_interna.pathloss(in2);
        y3 = c_interna.pathloss(in3);

        xmin = min([min(x4) min(x5) min(x6)]);
        xmax = max([max(x4) max(x5) max(x6)]);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);

        nexttile;
        % h1= plot(x4, y1, 'Marker', 's', 'Color', colors(1,:), ...
        %     'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF7');
        h1= plot(x4, y1, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF7');
        hold on
        h2 = plot(x5, y2, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF9');

        h3 = plot(x6, y3, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'SF12');
        % set(gca, 'XDir', 'reverse');
        hold off
        grid on
        grid minor
        xlabel('Distancia entre Tx e RX (metros)')
        ylabel('pathloss')
        xlim([xmin-10 xmax+10])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Bosque',deslocamento)

        handles(1) = h1;
        handles(2) = h2;
        handles(3) = h3;

        ind1 = d.altura == altura(k); % filtrando altura
        d_aux = d(ind1,:);
        ind = d_aux.polarizacaoNum == polarizacoes(j); % filtrando polarizacao
        d_interna = d_aux(ind,:);
        in7 = find(d_interna.SF == 7);
        in8 = find(d_interna.SF == 9);
        in9 = find(d_interna.SF == 12);

        x1 = d_interna.distanciasR(in7);
        x2 = d_interna.distanciasR(in8);
        x3 = d_interna.distanciasR(in9);

        y1 = d_interna.pathloss(in7);
        y2 = d_interna.pathloss(in8);
        y3 = d_interna.pathloss(in9);

        nexttile;
        plot(x1, y1, 'Marker', 's', 'Color', colors(1,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        hold on
        plot(x2, y2, 'Marker', 'o', 'Color', colors(2,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);

        plot(x3, y3, 'Marker', '*', 'Color', colors(5,:), ...
            'MarkerSize', 8, 'LineWidth', 1.5);
        % set(gca, 'XDir', 'reverse');
        hold off
        grid on
        grid minor
        xlabel('Distancia entre Tx e RX (metros)')
        ylabel('pathloss')
        xlim([xmin-10 xmax+10])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Referência',deslocamento)

        ind1 = find(e.altura == altura(k)); % filtrando altura
        e_aux = e(ind1,:);
        ind = find(e_aux.polarizacaoNum == polarizacoes(j)); % filtrando polarizacao
        e_interna = e_aux(ind,:);
        in4 = find(e_interna.SF == 7);
        in5 = find(e_interna.SF == 9);
        in6 = find(e_interna.SF == 12);

        x1 = e_interna.distanciasR(in4);
        x2 = e_interna.distanciasR(in5);
        x3 = e_interna.distanciasR(in6);

        y1 = e_interna.atenuacao(in4);
        y2 = e_interna.atenuacao(in5);
        y3 = e_interna.atenuacao(in6);

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
        % set(gca, 'XDir', 'reverse');
        % h4 = plot(x, y, 'Marker', '*', 'Color', colors(6,:), ...
        %   'MarkerSize', 8, 'LineWidth', 1.5);
        % legend(h4, 'Free-Space', 'Location', 'southwest')
        hold off
        grid on
        grid minor
        xlabel('Distancia entre Tx e RX (metros)')
        ylabel('Atenuação')
        xlim([xmin-10 xmax+10])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Bosque-Referência',deslocamento)

        lgd = legend(handles, 'Orientation', 'horizontal');
        lgd.Layout.Tile = 'south';
        lgd.Box = 'off';
        lgd.FontSize = 12;
        sgtitle(sprintf('%im / %s', altura(k),polarizacao_label{j}))
        contador = contador + 1;
    end
end




