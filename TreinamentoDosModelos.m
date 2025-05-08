clear,clc,close all

%% Carregar os dados

% CarregarDados
addpath(genpath('..'))
load('SeparateDataStruct.mat')
DataTrain = DataTrain{1};
DataTest = DataTest{1};
DataValid = DataValid{1};

clear caminho_relativo

% PRÓXIMO PASSO:
% UTILIZAR PSO PARA ESCOLHER AS MELHORES CONFIGURAÇÕES DE CADA MODELO 
% UTILIZANDO K-FOLD E VARIAÇÃO DO RNG

%% MLP com EPSO

addpath(genpath('utils'))

global ff_par;

ff_par.D = 2; % Quantidade de variáveis de decisão
ff_par.Xmin = 0; % limite inferior
ff_par.Xmax = 10; % limite superior

popSize = 20;  % Um pouco maior que 20 para mais diversidade
mutationRate = 0.7; % Aumentado para garantir exploração razoável
communicationProbability = 0.4; % Um pouco menor para não convergir rápido demais
maxGen = 200;  % Seu critério principal de parada
maxGenWoChangeBest = 20; % Para detectar estagnação, mas sem parar cedo demais
numSeeds = 1; % numero de avaliações de uma mesma partícula

vetor1 = [14 4:5 12]; % distanlplcia, SF, Altura
nome1 = 'EvoluçãoPSO_dist_SF_altura';

tic
dadosMLP = EPSO(DataTrain, DataValid, DataTest, popSize, mutationRate, ...
    communicationProbability, maxGen, maxGenWoChangeBest, numSeeds, vetor1, nome1);
tempo = toc;

horas = floor(tempo / 3600);
minutos = floor(mod(tempo, 3600) / 60);
segundos = mod(tempo, 60);
dadosMLP.time = [horas minutos segundos];

%% Modelo 1 - MLP

num_particles = 15;
max_epochs = 100;
vetor1 = [14 4:5 12]; % distanlplcia, SF, Altura
nome1 = 'EvoluçãoPSO_dist_SF_altura';
vetor2 = [14 4:5 7 12]; % distancia, SF, Altura, polarização
nome2 = 'EvoluçãoPSO_dist_SF_altura_polarizacao';
vetor3 = [14 4 7 12]; % distancia, SF, polarização
nome3 = 'EvoluçãoPSO_dist_SF_polarizacao';

tic
dadosMLP1 = PSO_MLP(DataTrain, DataValid, DataTest,...
    num_particles, max_epochs, vetor1, nome1);
tempo = toc;

horas = floor(tempo / 3600);
minutos = floor(mod(tempo, 3600) / 60);
segundos = mod(tempo, 60);
dadosMLP1.time = [horas minutos segundos];

fprintf('Tempo de Execução: %dh%dmin%dseg\n\n',dadosMLP1.time(1),dadosMLP1.time(2),dadosMLP1.time(3))
%%
tic
dadosMLP2 = PSO_MLP(DataTrain, DataValid, DataTest,...
    num_particles, max_epochs, vetor2, nome2);
tempo = toc;

horas = floor(tempo / 3600);
minutos = floor(mod(tempo, 3600) / 60);
segundos = mod(tempo, 60);
dadosMLP2.time = [horas minutos segundos];

fprintf('Tempo de Execução: %dh%dmin%dseg\n\n',dadosMLP2.time(1),dadosMLP2.time(2),dadosMLP1.time(3))

save('a.mat')

system('shutdown -s -t 0')
%%
tic
dadosMLP3 = PSO_MLP(DataTrain, DataValid, DataTest,...
    num_particles, max_epochs, vetor3, nome3);
tempo = toc;

horas = floor(tempo / 3600);
minutos = floor(mod(tempo, 3600) / 60);
segundos = mod(tempo, 60);
dadosMLP3.time = [horas minutos segundos];

%% Modelo 2 - Neurofuzzy
tic
Opt = genfisOptions('FCMClustering');
NumClusters = 4;
% Opt = genfisOptions('SubtractiveClustering');
% Opt.ClusterInfluenceRange = 0.8; % influencia o raio de "vizinhaça" que cada cluster influenciará
redeFis = genfis(xTrain{1}(:,1:end-1), xTrain{1}(:,end), Opt); % 3 funções de pertinência e gaussianas

% configuração do ANFIS
opcoes = anfisOptions;

opcoes.EpochNumber = 200;
opcoes.ValidationData = xTest{1};
opcoes.DisplayErrorValues = 0;
opcoes.DisplayANFISInformation = 0;
opcoes.DisplayStepSize = 0;
opcoes.DisplayFinalResults = 0;
opcoes.InitialStepSize = 0.005;
opcoes.StepSizeIncreaseRate = 1.04;
opcoes.StepSizeDecreaseRate = 0.845;

dadosFuzzy = Neurofuzzy(xTrain{1}, xTest{1}, opcoes);
toc

%% Modelo 3 - GRNN

spread = 0.02; % Valor ajustável do parâmetro de suavização
dadosGRNN = GRNN(xTrain, xTest,spread);

%% Modelo 4 - SVM

dadosSVM = SVM(xTrain{1}, xTest{1});  % SVM para classificação multiclasse

%% Modelo 5 - Random Forest

nTrees = 100;
dadosFloresta = RandomForest(xTrain{1}, xTest{1}, nTrees);

%% Modelo 6 - Gaussian Process Regression

dadosGPR = GPR(xTrain{1}, xTest{1});

%% Ensemble 1

% Model 1: Random Forest (RF)
% Model 2: Support Vector Machine (SVM)
% Model 3: Multi-Layer Perceptron (MLP)
% Model 4: General Regression Neural Network (GRNN)

numParticles = 10;
max_epochs = 200;

ModelosEnsemble1.MLP = dadosMLP.Rede;
ModelosEnsemble1.Neurofuzzy = dadosFuzzy.Rede;
ModelosEnsemble1.SVM = dadosSVM.Rede;
ModelosEnsemble1.GRNN = dadosGRNN.Rede;
ModelosEnsemble1.Forest = dadosFloresta.Rede;
ModelosEnsemble1.GPR = dadosGPR.Rede;
ModelosEnsemble1.opcao = 1;

ModelosEnsemble1.parametros =...
    PSO_OptimizeModel(ModelosEnsemble1, xTrain, xValid, xTest, numParticles, max_epochs);


figure;
h1 = plot(ModelosEnsemble1.parametros.bestFitnessHistoryTrain, 'b-', 'LineWidth', 2); hold on;
h2 = plot(ModelosEnsemble1.parametros.bestFitnessHistoryValid, 'k-', 'LineWidth', 2);

% Marcar a época de melhor validação
h3 = plot(ModelosEnsemble1.parametros.bestEpoch, ...
    ModelosEnsemble1.parametros.bestFitnessHistoryValid(ModelosEnsemble1.parametros.bestEpoch), ...
    'ro', 'MarkerSize', 40, 'LineWidth', 2);

% Melhorias visuais
legend([h1 h2], {'Fitness de treinamento (melhor partícula)', 'Fitness de validação (melhor partícula)'}, ...
    'Location', 'northeast', 'AutoUpdate', 'off');


xline(ModelosEnsemble1.parametros.bestEpoch, '--r', sprintf('Melhor época: %d',ModelosEnsemble1.parametros.bestEpoch),...
    'LabelVerticalAlignment','bottom', ...
    'LabelHorizontalAlignment','left', 'FontWeight','bold');
xlabel('Épocas');
ylabel('Valor da fitness');
title('Treinamento do Ensemble com PSO');
grid on;
grid minor;

%% Ensemble 2


% Model 1: Neurofuzzy (NF)
% Model 2: Support Vector Machine (SVM)
% Model 3: Multi-Layer Perceptron (MLP)
% Model 4: General Regression Neural Network (GRNN)

ModelosEnsemble2.MLP = dadosMLP.Rede;
ModelosEnsemble2.Neurofuzzy = dadosFuzzy.Rede;
ModelosEnsemble2.SVM = dadosSVM.Rede;
ModelosEnsemble2.GRNN = dadosGRNN.Rede;
ModelosEnsemble2.Forest = dadosFloresta.Rede;
ModelosEnsemble2.GPR = dadosGPR.Rede;
ModelosEnsemble2.opcao = 2;

ModelosEnsemble2.parametros =...
    PSO_OptimizeModel(ModelosEnsemble2, xTrain, xValid, xTest, numParticles, max_epochs);


figure;
h1 = plot(ModelosEnsemble2.parametros.bestFitnessHistoryTrain, 'b-', 'LineWidth', 2); hold on;
h2 = plot(ModelosEnsemble2.parametros.bestFitnessHistoryValid, 'k-', 'LineWidth', 2);

% Marcar a época de melhor validação
h3 = plot(ModelosEnsemble2.parametros.bestEpoch, ...
    ModelosEnsemble2.parametros.bestFitnessHistoryValid(ModelosEnsemble2.parametros.bestEpoch), ...
    'ro', 'MarkerSize', 40, 'LineWidth', 2);

% Melhorias visuais
legend([h1 h2], {'Fitness de treinamento (melhor partícula)', 'Fitness de validação (melhor partícula)'}, ...
    'Location', 'northeast', 'AutoUpdate', 'off');


xline(ModelosEnsemble2.parametros.bestEpoch, '--r', sprintf('Melhor época: %d',ModelosEnsemble2.parametros.bestEpoch),...
    'LabelVerticalAlignment','bottom', ...
    'LabelHorizontalAlignment','left', 'FontWeight','bold');
xlabel('Épocas');
ylabel('Valor da fitness');
title('Evolução da otimização por PSO');
grid on;
grid minor;

%% Ensemble 3


% Model 1: Gaussian Process Regression (GPR)
% Model 2: Support Vector Machine (SVM)
% Model 3: Multi-Layer Perceptron (MLP)
% Model 4: General Regression Neural Network (GRNN)


ModelosEnsemble3.MLP = dadosMLP.Rede;
ModelosEnsemble3.Neurofuzzy = dadosFuzzy.Rede;
ModelosEnsemble3.SVM = dadosSVM.Rede;
ModelosEnsemble3.GRNN = dadosGRNN.Rede;
ModelosEnsemble3.Forest = dadosFloresta.Rede;
ModelosEnsemble3.GPR = dadosGPR.Rede;
ModelosEnsemble3.opcao = 3;

ModelosEnsemble3.parametros =...
    PSO_OptimizeModel(ModelosEnsemble3, xTrain, xValid, xTest ,numParticles, max_epochs);


figure;
h1 = plot(ModelosEnsemble3.parametros.bestFitnessHistoryTrain, 'b-', 'LineWidth', 2); hold on;
h2 = plot(ModelosEnsemble3.parametros.bestFitnessHistoryValid, 'k-', 'LineWidth', 2);

% Marcar a época de melhor validação
h3 = plot(ModelosEnsemble3.parametros.bestEpoch, ...
    ModelosEnsemble3.parametros.bestFitnessHistoryValid(ModelosEnsemble3.parametros.bestEpoch), ...
    'ro', 'MarkerSize', 40, 'LineWidth', 2);

% Melhorias visuais
legend([h1 h2], {'Fitness de treinamento (melhor partícula)', 'Fitness de validação (melhor partícula)'}, ...
    'Location', 'northeast', 'AutoUpdate', 'off');


xline(ModelosEnsemble3.parametros.bestEpoch, '--r', sprintf('Melhor época: %d',ModelosEnsemble3.parametros.bestEpoch),...
    'LabelVerticalAlignment','bottom', ...
    'LabelHorizontalAlignment','left', 'FontWeight','bold');
xlabel('Épocas');
ylabel('Valor da fitness');
title('Evolução da otimização por PSO');
grid on;
grid minor;
%%
% close all
SF = 12;
polarizacao = 2;
polarizacoes = {'HH','HV','VH','VV'};
altura = 70;

ind = (DataTest.Tabela_Atenuacao_Janelada.SF == SF) &(DataTest.Tabela_Atenuacao_Janelada.polarizacaoNum == polarizacao) & (DataTest.Tabela_Atenuacao_Janelada.altura == altura);
latitude = DataTest.Tabela_Atenuacao_Janelada.latitude(ind);
longitude = DataTest.Tabela_Atenuacao_Janelada.longitude(ind);
atenuacao = DataTest.Tabela_Atenuacao_Janelada.atenuacao_media(ind);

% atenuação dos modelos
atenuacaoModelMLP = dadosMLP.saidaTeste(ind);       % ======= MLP ======= %
atenuacaoNeuroFuzzy = dadosFuzzy.saidaTeste(ind);   % ===== Neurofuzzy ===== %
atenuacaoGRNN = dadosGRNN.saidaTeste(ind);           % ======= GRNN ======= %
atenuacaoSVM = dadosSVM.saidaTeste(ind);                % ======== SVM ======== %
atenuacaoFloresta = dadosFloresta.saidaTeste(ind);     % ==== Random Forest ==== %
atenuacaoGPR = dadosGPR.saidaTeste(ind);                 % = Gaussian Process Regression = %
% atenuacaoEnsamble = dadosEnsemble.saidaTeste(ind); % ==== Ensamble ==== %


distancias = DataTest.Tabela_Atenuacao_Janelada.distanciasR(ind);


% gráficos geoscatter comparando os dados reais e os dados preditos
% Criar o mapa de fundo
% figure
% geobasemap satellite;
% geoscatter(latitude, longitude, 50, atenuacao, 'filled');
% colorbar; % Adiciona a barra de cores
% colormap(jet); % Define o mapa de cores
% clim([min(atenuacao) max(atenuacao)]); % Define os limites da colorbar
% title(sprintf('Dados Reais: SF%d | %dm | %s',SF, altura, polarizacoes{polarizacao}))
% geolimits([min(latitude) max(latitude)], [min(longitude) max(longitude)]); % Ajusta os limites do mapa
% 
% 
% figure
% geobasemap satellite;
% geoscatter(latitude, longitude, 50, atenuacaoModel, 'filled');
% colorbar; % Adiciona a barra de cores
% colormap(jet); % Define o mapa de cores
% clim([min(atenuacaoModel) max(atenuacaoModel)]); % Define os limites da colorbar
% title(sprintf('Predição do Modelo MLP: SF%d | %dm | %s',SF, altura, polarizacoes{polarizacao}))
% geolimits([min(latitude) max(latitude)], [min(longitude) max(longitude)]); % Ajusta os limites do mapa


% gráficos de distância comparando os dados reais e os dados preditos
figure
plot(distancias,atenuacao,'ro','LineWidth',2)
hold on
plot(distancias,atenuacaoModelMLP,'s-','LineWidth',2)
plot(distancias,atenuacaoNeuroFuzzy,'*-','LineWidth',2)
plot(distancias,atenuacaoGRNN,'x-','LineWidth',2)
plot(distancias,atenuacaoSVM,'<-','LineWidth',2)
plot(distancias,atenuacaoFloresta, '>-', 'LineWidth',2)
plot(distancias,atenuacaoGPR, '^-', 'LineWidth',2)
% c = plot(distancias,atenuacaoEnsamble,'LineWidth',2)
grid on
grid minor
xlabel('distância (Tx - Rx) em metros')
ylabel('Atenuação')
title(sprintf('Dados Reais x Predição de modelos: SF%d | %dm | %s',SF, altura, polarizacoes{polarizacao}))
legend('Dados Reais','Modelo 1 - MLP','Modelo 2 - Neurofuzzy', 'Modelo 3 - GRNN', 'Modelo 4 - SVM',...
    'Modelo 5 - Random Forest', 'Modelo 6 - Gaussian Process Regression')
hold off

% a.Color = [0.9290 0.6940 0.1250];