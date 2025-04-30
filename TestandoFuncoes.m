clear,clc,close all

% fazer a regressão com o log distance (ultimo passo)
%% Carregar os dados

% CarregarDados
addpath('utils','Dados')
load('TabelasCenarios3.mat')

clear caminho_relativo

%% plotagem dos dados interpolados
close all
PlotagemDadosInterpolados

%% plotagem dos dados janelados (distancia)
close all
plotagemDistanciaJanelada 

%% plotagem da frequência na qual os dados possuem maior pathloss ou atenuação
close all
plotagemFrequencia

%% plotagem dos dados janelados (angulo)
close all
plotagemAnguloJanelado

%% maximizar os gráficos escolhidos
k = 3;

maximizarGraficos(k+12,figuras)
maximizarGraficos(k+8,figuras)
maximizarGraficos(k+4,figuras)
maximizarGraficos(k,figuras)

%% Plotar correlação Média dos dados
modo = 'janelado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

Correlacao

%% Plotar correlação Individual dos dados - Distância
modo = 'janelado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

CorrelacaoSeparadaDistancias

%% Plotar correlação Individual dos dados - Altura
modo = 'janelado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

CorrelacaoSeparadaAltura

%% Plotar correlação Individual dos dados - Polarização
modo = 'janelado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

CorrelacaoSeparadaPolarizacao

%% Plotar correlação Individual dos dados - pathloss de diferentes polarizações

modo = 'janelado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

CorrelacaoPolarizacoesAtravesdoPathloss

%% Plotar correlação Individual dos dados - SF
modo = 'interpolado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

CorrelacaoSeparadaSF

%% Plotar correlação Individual dos dados - pathloss de diferentes SFs
modo = 'interpolado';

if strcmp(modo, 'janelado')
    a = Tabela_Bosque_Janelada;
    b = Tabela_Referencia_Janelada;
    c = Tabela_Atenuacao_Janelada;

    path = 'pathloss_media';
    aten = 'atenuacao_media';
else
    if strcmp(modo, 'interpolado')
        a = Tabela_Bosque_Interpolada;
        b = Tabela_Referencia_Interpolada;
        c = Tabela_Atenuacao;
        path = 'pathloss';
        aten = 'atenuacao';
    end
end

CorrelacaoSFsAtravesdoPathloss

%% Plotar dados simples

% x = 'angulo';
x1 = 'distanciasR';
x2 = 'angulo';
y1 = 'pathloss';
y2 = 'RSSI';
y3 = 'SNR';

figure(1)
plotarDados(dadosEspecificos_Bosque_Interpolado,x1,y1,check);

figure(2)
plotarDados(dadosEspecificos_Bosque_Interpolado,x2,y1,check);
