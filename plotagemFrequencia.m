clc,close all
f = Tabela_Bosque_Janelada;
g = Tabela_Referencia_Janelada;
h = Tabela_Atenuacao_Janelada;

variavel_x = 'distanciasR';
variavel_y = 'pathloss';
polarizacao_label = {'HH', 'HV', 'VH', 'VV'};

altura = 50:20:110;
polarizacoes = 1:4;
SFs = [7 9 12];
colors = lines(60);
%%
deslocamento = 10;
contador = 1;
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

        x4 = f_interna.distanciasR(in1);
        x5 = f_interna.distanciasR(in2);
        x6 = f_interna.distanciasR(in3);

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
        [h1, h2, h3] = plotarDiscreto(x4, y1,y2,y3);
        xlabel('Distancia entre Tx e RX (metros)')
        ylabel('pathloss discretizado')
        xlim([xmin-10 xmax+10])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Bosque',deslocamento)

        handles(1) = h1;
        handles(2) = h2;
        handles(3) = h3;

        nexttile;
        plotarPredominanciaBar(y1,y2,y3)
        title('Frequência de maior pathloss');
        grid on
        grid minor

        ind1 = g.altura == altura(k); % filtrando altura
        g_aux = g(ind1,:);
        ind = g_aux.polarizacaoNum == polarizacoes(j); % filtrando polarizacao
        g_interna = g_aux(ind,:);
        in1 = find(g_interna.SF == 7);
        in2 = find(g_interna.SF == 9);
        in3 = find(g_interna.SF == 12);

        x4 = g_interna.distanciasR(in1);
        x5 = g_interna.distanciasR(in2);
        x6 = g_interna.distanciasR(in3);

        y1 = g_interna.pathloss_media(in1);
        y2 = g_interna.pathloss_media(in2);
        y3 = g_interna.pathloss_media(in3);

        y4 = g_interna.pathloss_desviopadrao(in1);
        y5 = g_interna.pathloss_desviopadrao(in2);
        y6 = g_interna.pathloss_desviopadrao(in3);

        xmin = min([min(x4) min(x5) min(x6)]);
        xmax = max([max(x4) max(x5) max(x6)]);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);

        nexttile;
        plotarDiscreto(x4, y1,y2,y3)
        xlabel('Distancia entre Tx e RX (metros)')
        ylabel('pathloss discretizado')
        xlim([xmin-10 xmax+10])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Referência',deslocamento)

        nexttile;
        plotarPredominanciaBar(y1,y2,y3)
        title('Frequência de maior pathloss');
        grid on
        grid minor

        ind1 = find(h.altura == altura(k)); % filtrando altura
        h_aux = h(ind1,:);
        ind = find(h_aux.polarizacaoNum == polarizacoes(j)); % filtrando polarizacao
        h_interna = h_aux(ind,:);
        in1 = find(h_interna.SF == 7);
        in2 = find(h_interna.SF == 9);
        in3 = find(h_interna.SF == 12);

        x4 = h_interna.distanciasR(in1);
        x5 = h_interna.distanciasR(in2);
        x6 = h_interna.distanciasR(in3);

        y1 = h_interna.atenuacao_media(in1);
        y2 = h_interna.atenuacao_media(in2);
        y3 = h_interna.atenuacao_media(in3);

        y4 = h_interna.atenuacao_desviopadrao(in1);
        y5 = h_interna.atenuacao_desviopadrao(in2);
        y6 = h_interna.atenuacao_desviopadrao(in3);

        xmin = min([min(x4) min(x5) min(x6)]);
        xmax = max([max(x4) max(x5) max(x6)]);

        ymin = min([min(y1) min(y2) min(y3)]);
        ymax = max([max(y1) max(y2) max(y3)]);

        nexttile;
        plotarDiscreto(x4, y1,y2,y3)
        xlabel('Distancia entre Tx e RX (metros)')
        ylabel('atenuação discretizada')
        xlim([xmin-10 xmax+10])
        ylim([ymin-10 ymax+10])
        inserirTextoCanto('Bosque-Referência',deslocamento)

        nexttile;
        plotarPredominanciaBar(y1,y2,y3)
        title('Frequência de maior atenuação');
        grid on
        grid minor


        lgd = legend(handles, 'Orientation', 'horizontal');
        lgd.Layout.Tile = 'south';
        lgd.Box = 'off';
        lgd.FontSize = 12;
        sgtitle(sprintf('%im / %s', altura(k),polarizacao_label{j}))
        contador = contador + 1;
    end
end