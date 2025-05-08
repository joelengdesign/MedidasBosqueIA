function params = PSO_MLP(DataTrain, DataValid, DataTest, num_particles, max_epochs, vetor, nome)

SF = 7;
polarizacao = 1;
altura1 = 50;
altura2 = 110;

dadosTreino = DataTrain.Tabela_Atenuacao_Janelada{:,vetor};
dadosTreino(:,1:end-1) = (dadosTreino(:,1:end-1) - min(dadosTreino(:,1:end-1), [], 1)) ./ (max(dadosTreino(:,1:end-1), [], 1) - min(dadosTreino(:,1:end-1), [], 1));

dadosTeste = DataTest.Tabela_Atenuacao_Janelada{:,vetor};
dadosTeste(:,1:end-1) = (dadosTeste(:,1:end-1) - min(dadosTeste(:,1:end-1), [], 1)) ./ (max(dadosTeste(:,1:end-1), [], 1) - min(dadosTeste(:,1:end-1), [], 1));

dadosValidacao = DataValid.Tabela_Atenuacao_Janelada{:,vetor};
dadosValidacao(:,1:end-1) = (dadosValidacao(:,1:end-1) - min(dadosValidacao(:,1:end-1), [], 1)) ./ (max(dadosValidacao(:,1:end-1), [], 1) - min(dadosValidacao(:,1:end-1), [], 1));

dados = [dadosTreino; dadosValidacao; dadosTeste];

X = dados(:,1:end-1)';
Y = dados(:,end)'; 

n1 = size(dadosTreino, 1);
n2    = size(dadosValidacao, 1);
n3  = size(dadosTeste, 1);

nTreino = 1:n1;
nVal   = (n1+1):(n1+n2);
nTeste  = (n1+n2+1):(n1+n2+n3);

num_dimensions = 2; 
min_val_fitness = inf;
particles = randi([10, 40], num_particles, num_dimensions);
particles(particles < 0) = 0;
particles(particles > 40) = 40;
rowsToReplace = ismember(particles, [0 0], 'rows');
if any(rowsToReplace)
    particles(rowsToReplace, :) = repmat([0 2], sum(rowsToReplace), 1); 
end

w = 0.95;             % Inércia inicial
c1 = 1.2;           % Coeficiente cognitivo
c2 = 1.2;           % Coeficiente social
minW = 0.4;     % Inércia final
alpha = (w - minW) / max_epochs;

velocities = zeros(num_particles, num_dimensions);

screenSize = get(0, 'ScreenSize'); 
screenWidth = screenSize(3);
screenHeight = screenSize(4);

% fig = figure('Visible', 'off', 'Position', [0, 0, screenWidth, screenHeight]);
fig = figure('Position', [0, 0, screenWidth, screenHeight]);

outputFolder = fullfile(pwd,'videos');
outputFolder = fullfile(outputFolder);
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% videoPath = fullfile(outputFolder, nome);
% video = VideoWriter(videoPath, 'Motion JPEG AVI');
% video.Quality = 100;
% video.FrameRate = 5;
% open(video);

minimoFit = Inf;
% parpool('local', 6, 'IdleTimeout', 2*3600); % pc do max
% parpool('IdleTimeout', 24*3600); % meu pc

camada1 = particles(:,1);
camada2 = particles(:,2);

scores = arrayfun(@(n1, n2) objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste), camada1, camada2);
fitness = [scores.performance];
[~, best_idx] = min(fitness);
semente = [scores.semente];
net = {scores.model};
best_net = net{best_idx};
best_semente = semente(best_idx);

ind1 = DataTest.Tabela_Atenuacao_Janelada.SF == SF &...
    DataTest.Tabela_Atenuacao_Janelada.altura == altura1&...
    DataTest.Tabela_Atenuacao_Janelada.polarizacaoNum == polarizacao;

ind2 = DataTest.Tabela_Atenuacao_Janelada.SF == SF &...
    DataTest.Tabela_Atenuacao_Janelada.altura == altura2&...
    DataTest.Tabela_Atenuacao_Janelada.polarizacaoNum == polarizacao;

y = best_net(X);
y_teste = y(nTeste);
y_net1 = y_teste(ind1);
y_net2 = y_teste(ind2);

x1 = DataTest.Tabela_Atenuacao_Janelada.distanciasR(ind1);
y1 = DataTest.Tabela_Atenuacao_Janelada.atenuacao_media(ind1);

x2 = DataTest.Tabela_Atenuacao_Janelada.distanciasR(ind2);
y2 = DataTest.Tabela_Atenuacao_Janelada.atenuacao_media(ind2);

subplot(2,2,1)
[~,indiceBest] = min(fitness);
p1_0 = scatter(particles(:,1),particles(:,2),50,'b','filled');
hold on
p1_1 = plot(particles(best_idx,1),particles(best_idx,2), 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
grid on
grid minor
xlabel('Primeira Camada')
ylabel('Segunda Camada')
title('Evolução da População')
legend('Partículas','Melhor partícula')
xlim([-4 42])
ylim([-4 42])
hold off

x_data = 0;
y_data1 = mean(fitness);
y_data2 = min(fitness);
subplot(2,2,2)
p2_avg = plot(x_data,y_data1,'b','LineWidth',2);
hold on
p2_best = plot(x_data,y_data2,'r','LineWidth',2);
grid on
grid minor
xlabel('Épocas')
ylabel('Fitness')
title('Evolução da fitness do PSO')
hold off
xlim([-3 max_epochs+3])
legend('avg fitness','best fitness')
hold off

subplot(2,2,3)
plot(x1,y1,'bo','LineWidth',2,'MarkerSize',5)
hold on
p3 = plot(x1,y_net1,'k','LineWidth',3);
grid on
grid minor
xlabel('distância radial')
ylabel('atenuação janelada')
title('Cenário SF12 - HH - 50m')
legend('Saída Real','MLP')

subplot(2,2,4)
plot(x2,y2,'bo','LineWidth',1.5,'MarkerSize',6)
hold on
p4 = plot(x2,y_net2,'k','LineWidth',3);
grid on
grid minor
xlabel('distância radial')
ylabel('atenuação janelada')
title('Cenário SF12 - HH - 110m')
legend('Saída Real','MLP')
sgtitle(sprintf('Época 0 — Melhor partícula: [%d, %d]  |  Fitness: %.4f', ...
    particles(best_idx,1), particles(best_idx,2), min(fitness)));

drawnow;
% frame = getframe(fig);
% writeVideo(video, frame);

pbest = particles;
pbest_fitness = fitness;
[gbest_fitness, best_idx] = min(pbest_fitness);
gbest = pbest(best_idx, :);

for epoch = 1:max_epochs
    r1 = rand(num_particles, num_dimensions);
    r2 = rand(num_particles, num_dimensions);
    velocities = w * velocities + ...
        c1 * r1 .* (pbest - particles) + ...
        c2 * r2 .* (gbest - particles);
    particles = particles + velocities;

    if w>minW
        w= w - epoch*alpha;
    end
    particles = round(particles);
    particles(particles < 0) = 0;
    particles(particles > 40) = 40;
    rowsToReplace = ismember(particles, [0 0], 'rows');
    if any(rowsToReplace)
        particles(rowsToReplace, :) = repmat([0 2], sum(rowsToReplace), 1);
    end
    
    camada1 = particles(:,1);
    camada2 = particles(:,2);

    % Avaliação do fitness de cada partícula na população atual
    scores = arrayfun(@(n1, n2) objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste), camada1, camada2);
    fitness = [scores.performance];
    semente_iter = [scores.semente];
    net_iter = {scores.model};


    improved = fitness < pbest_fitness;
    pbest(improved, :) = particles(improved, :);
    pbest_fitness(improved) = fitness(improved);
    semente(improved) = semente_iter(improved);
    net(improved) = net_iter(improved);

    % Passo 1: encontra o valor mínimo de fitness
    min_fitness = min(pbest_fitness);

    % Passo 2: encontra todos os índices que têm esse fitness mínimo
    candidatos_idx = find(pbest_fitness == min_fitness);

    % Passo 3: calcula a soma dos neurônios (componentes da partícula) dos candidatos
    somas_neuronios = sum(pbest(candidatos_idx, :), 2);

    % Passo 4: escolhe o índice com menor soma de neurônios
    [~, menor_idx_local] = min(somas_neuronios);
    melhor_idx = candidatos_idx(menor_idx_local);

    if min_fitness < gbest_fitness
        gbest_fitness = min_fitness;
        gbest = pbest(melhor_idx, :);
        best_net = net{melhor_idx};
        best_semente = semente(melhor_idx);
    end

    y = best_net(X);
    y_teste = y(nTeste);
    y_net1 = y_teste(ind1);
    y_net2 = y_teste(ind2);

    x_data(end+1) = epoch;
    y_data1(end+1) = mean(pbest_fitness);
    y_data2(end+1) = gbest_fitness;

    subplot(2,2,1)
    set(p1_0, 'XData', pbest(:,1), 'YData', pbest(:,2));
    set(p1_1, 'XData', gbest(1), 'YData', gbest(2));

    subplot(2,2,2)
    set(p2_avg, 'XData', x_data, 'YData', y_data1);
    set(p2_best, 'XData', x_data, 'YData', y_data2);

    subplot(2,2,3)
    set(p3, 'YData', y_net1);

    subplot(2,2,4)
    set(p4, 'YData', y_net2);

    sgtitle(sprintf('Época %d — Melhor partícula: [%d, %d]  |  Fitness: %.4f', ...
    epoch,gbest(1), gbest(2), gbest_fitness));

    drawnow;
    % frame = getframe(fig);
    % writeVideo(video, frame);
end

% close(video);
% delete(gcp);

params.BestSolution = gbest;
params.Bestmodel = best_net;
params.RMSE = gbest_fitness;
params.bestSemente = best_semente;

    function param = objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste)

        minimoSeed = Inf;
        numSeeds = 1;
        perf = zeros(1, numSeeds);
        sem = 0;

        data = [dadosTreino; dadosValidacao; dadosTeste];

        input = data(:,1:end-1)';
        target = data(:,end)';

        indiceTreino = size(dadosTreino, 1);
        indiceValidacao    = size(dadosValidacao, 1);
        indiceTeste  = size(dadosTeste, 1);

        N1 = size(dadosTreino, 1);
        N2    = size(dadosValidacao, 1);
        N3  = size(dadosTeste, 1);

        indiceTreino = 1:N1;
        indiceValidacao   = (N1+1):(N1+N2);
        indiceTeste  = (N1+N2+1):(N1+N2+N3);

        estruturaTemp = [n1 n2];
        if any(estruturaTemp == 0)
            estrutura = estruturaTemp(estruturaTemp>0);
        else
            estrutura = estruturaTemp;
        end
        somAcum = 0;
        for s = 1:numSeeds
            rng(s)
            % Criar e treinar a rede neural com o número de neurônios especificado
            Net = feedforwardnet(estrutura);  % Rede neural com n1 neurônios na camada 1 e n2 na camada 2
            Net.trainParam.showWindow = false;
            Net.divideFcn = 'divideind';
            Net.divideParam.trainInd = indiceTreino;
            Net.divideParam.valInd   = indiceValidacao;
            Net.divideParam.testInd  = indiceTeste;


            [Net,tr] = train(Net, input, target);

            % Calcular a performance usando o conjunto de teste
            yPred = Net(X);

            perf = sqrt(perform(Net, Y(:,tr.testInd), yPred(:,tr.testInd)));
            somAcum = somAcum + perf;

            if perf<minimoSeed
                Semente = s;
                Model = Net;
            end
        end
        param.performance = somAcum/numSeeds;
        param.model = Model;
        param.semente = Semente;
    end
end