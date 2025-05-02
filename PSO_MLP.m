function params = PSO_MLP(DataTrain, DataValid, DataTest, num_particles, max_epochs)

SF = 12;
polarizacao = 1;
altura1 = 50;
altura2 = 110;

% separação dos dados para utilização dos modelos

% ============= Entrada ============== %
% distância entre Tx e RX em metros
% Spreading Factor
% Altura

% ============== Saída ============== %
% Atenuação - Pathloss(Referência) - Pathloss(Floresta)
dadosTreino = DataTrain.Tabela_Atenuacao_Janelada{:,[14 4:5 12]};
dadosTreino(:,1:end-1) = (dadosTreino(:,1:end-1) - min(dadosTreino(:,1:end-1), [], 1)) ./ (max(dadosTreino(:,1:end-1), [], 1) - min(dadosTreino(:,1:end-1), [], 1));

dadosTeste = DataTest.Tabela_Atenuacao_Janelada{:,[14 4:5 12]};
dadosTeste(:,1:end-1) = (dadosTeste(:,1:end-1) - min(dadosTeste(:,1:end-1), [], 1)) ./ (max(dadosTeste(:,1:end-1), [], 1) - min(dadosTeste(:,1:end-1), [], 1));

dadosValidacao = DataValid.Tabela_Atenuacao_Janelada{:,[14 4:5 12]};
dadosValidacao(:,1:end-1) = (dadosValidacao(:,1:end-1) - min(dadosValidacao(:,1:end-1), [], 1)) ./ (max(dadosValidacao(:,1:end-1), [], 1) - min(dadosValidacao(:,1:end-1), [], 1));

num_dimensions = 2;   % Quatro pesos (A, B, C, D)
min_val_fitness = inf;
% Geração inicial das partículas normalizadas
particles = round(40 * rand(num_particles, num_dimensions));
particles = corrigirParticulas(particles, 5, 40);
% particles = particles ./ sum(particles, 2);

w = 0.9;             % Inércia inicial
c1 = 1.2;           % Coeficiente cognitivo
c2 = 1.2;           % Coeficiente social

% Inicialização das partículas
velocities = zeros(num_particles, num_dimensions);

fig = figure('Visible', 'off');
fig.Position = [100, 100, 1280, 720];  % Resolução do vídeo

outputFolder = fullfile(pwd,'videos');
outputFolder = fullfile(outputFolder);  % resolve o caminho completo
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

videoPath = fullfile(outputFolder, 'EvolucaoTreinamentoPSOMLP');
video = VideoWriter(videoPath, 'Motion JPEG AVI');
video.Quality = 100;
video.FrameRate = 5;
open(video);

minimoFit = Inf;
% parpool('local', 6, 'IdleTimeout', 2*3600); % pc do max
parpool('IdleTimeout', 15*3600); % meu pc
semente = 1;
for k=1:num_particles
    minimoSemente = Inf;
    for s = 1:10
        rng(s)
        A = particles(k,:);
        if any(particles(k,:) == 0)
            estrutura = A(A>0);
        else
            estrutura = A;
        end
        model = feedforwardnet(estrutura);
        model.trainParam.showWindow = false;
        % Concatenar os dados
        dados = [dadosTreino; dadosValidacao; dadosTeste];

        % Separar entradas e saídas
        X = dados(:,1:end-1)';  % Entradas
        Y = dados(:,end)';      % Saída (alvo)

        % Determinar os índices
        nTreino = size(dadosTreino, 1);
        nVal    = size(dadosValidacao, 1);
        nTeste  = size(dadosTeste, 1);

        % Criar vetor de índices
        trainInd = 1:nTreino;
        valInd   = (nTreino+1):(nTreino+nVal);
        testInd  = (nTreino+nVal+1):(nTreino+nVal+nTeste);

        % Definir divisão na rede
        model.divideFcn = 'divideind';
        model.divideParam.trainInd = trainInd;
        model.divideParam.valInd   = valInd;
        model.divideParam.testInd  = testInd;
        [model, tr] = train(model,X, Y);

        % Calcular outputs da rede
        outputs = model(X);

        % Avaliar apenas nos dados de teste
        testTargets = Y(tr.testInd);
        testOutputs = outputs(tr.testInd);

        % Calcular desempenho (MSE por padrão)
        fit(s) = sqrt(perform(model, testTargets, testOutputs));

        if min(fit(s)) < minimoSemente
            net = model;
        end

    end
    fitness(k) = mean(fit);

    if min(fitness) < minimoFit
        minimoFit = min(fitness);
        nett = net;
    end
end

ind1 = DataTest.Tabela_Atenuacao_Janelada.SF == SF &...
    DataTest.Tabela_Atenuacao_Janelada.altura == altura1&...
    DataTest.Tabela_Atenuacao_Janelada.polarizacaoNum == polarizacao;

ind2 = DataTest.Tabela_Atenuacao_Janelada.SF == SF &...
    DataTest.Tabela_Atenuacao_Janelada.altura == altura2&...
    DataTest.Tabela_Atenuacao_Janelada.polarizacaoNum == polarizacao;

x1 = DataTest.Tabela_Atenuacao_Janelada.distanciasR(ind1);
y1 = DataTest.Tabela_Atenuacao_Janelada.atenuacao_media(ind1);
y = nett(X);
y_net1 = y(ind1);

x2 = DataTest.Tabela_Atenuacao_Janelada.distanciasR(ind2);
y2 = DataTest.Tabela_Atenuacao_Janelada.atenuacao_media(ind2);
y_net2 = y(ind2);


subplot(2,2,1)
[~,indiceBest] = min(fitness);
p1_0 = plot(particles(:,1),particles(:,2),'bx','LineWidth',2,'MarkerSize',10);
hold on
p1_1 = plot(particles(indiceBest,1),particles(indiceBest,2),'ro','LineWidth',2,'MarkerSize',15);
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
sgtitle('Época: 0')

drawnow;
frame = getframe(fig);
writeVideo(video, frame);


% Inicialização das melhores posições
pbest = particles;
pbest_fitness = fitness;
[gbest_fitness, best_idx] = min(pbest_fitness);
gbest = pbest(best_idx, :);

% Loop principal do PSO
for epoch = 1:max_epochs
    % Atualização das velocidades e posições
    r1 = rand(num_particles, num_dimensions);
    r2 = rand(num_particles, num_dimensions);
    velocities = w * velocities + ...
        c1 * r1 .* (pbest - particles) + ...
        c2 * r2 .* (gbest - particles);
    particles = particles + velocities;
    particles = corrigirParticulas(particles, 5, 40);

    for k=1:num_particles
        for s = 1:30
            rng(s)
            A = particles(k,:);
            if any(particles(k,:) == 0)
                estrutura = A(A>0);
            else
                estrutura = A;
            end
            model = feedforwardnet(estrutura);
            model.trainParam.showWindow = false;
            % Concatenar os dados
            dados = [dadosTreino; dadosValidacao; dadosTeste];

            % Separar entradas e saídas
            X = dados(:,1:end-1)';  % Entradas
            Y = dados(:,end)';      % Saída (alvo)

            % Determinar os índices
            nTreino = size(dadosTreino, 1);
            nVal    = size(dadosValidacao, 1);
            nTeste  = size(dadosTeste, 1);

            % Criar vetor de índices
            trainInd = 1:nTreino;
            valInd   = (nTreino+1):(nTreino+nVal);
            testInd  = (nTreino+nVal+1):(nTreino+nVal+nTeste);

            % Definir divisão na rede
            model.divideFcn = 'divideind';
            model.divideParam.trainInd = trainInd;
            model.divideParam.valInd   = valInd;
            model.divideParam.testInd  = testInd;
            [model, tr] = train(model,X, Y);

            % Calcular outputs da rede
            outputs = model(X);

            % Avaliar apenas nos dados de teste
            testTargets = Y(tr.testInd);
            testOutputs = outputs(tr.testInd);

            % Calcular desempenho (MSE por padrão)
            fit(s) = sqrt(perform(model, testTargets, testOutputs));

            if min(fit(s)) < minimoSemente
                net = model;
                sem = s;
            end
        end

        fitness(k) = mean(fit);
    end

    % Atualização das melhores posições individuais
    improved = fitness < pbest_fitness;
    pbest(improved, :) = particles(improved, :);
    pbest_fitness(improved) = fitness(improved);

    % Atualização do melhor global
    [min_fitness, min_idx] = min(pbest_fitness);
    if min_fitness < gbest_fitness
        gbest_fitness = min_fitness;
        gbest = pbest(min_idx, :);
        nett = net;
        semente = sem;
    end

    
    y= nett(X);
    y_net1 = y(ind1);
    y_net2 = y(ind2);

    % Armazena histórico
    avg_fitness_hist = mean(fitness);
    

    x_data(end+1) = epoch;
    y_data1(end+1) = mean(fitness);
    y_data2(end+1) = gbest_fitness;

    subplot(2,2,1)
    set(p1_0, 'XData', particles(:,1), 'YData', particles(:,2));
    set(p1_1, 'XData', gbest(1), 'YData', gbest(2));

    subplot(2,2,2)
    set(p2_avg, 'XData', x_data, 'YData', y_data1);
    set(p2_best, 'XData', x_data, 'YData', y_data2);

    subplot(2,2,3)
    set(p3, 'YData', y_net1);

    subplot(2,2,4)
    set(p4, 'YData', y_net2);

    sgtitle(sprintf('Época: %d', epoch))

    drawnow;
    frame = getframe(fig);
    writeVideo(video, frame);
end

close(video);
delete(gcp);

params.BestSolution = gbest;
params.BestModel = nett;
params.RMSE = gbest_fitness;
params.bestFitness = gbest_fitness;
params.bestSemente = semente;

    function particlesCorrigidas = corrigirParticulas(particles, min_neurons, max_neurons)
        % CORRIGIRPARTICULAS - Corrige partículas conforme restrições:
        % 1. Ambas < min_neurons -> uma = min_neurons, outra = 0
        % 2. Apenas uma < min_neurons -> essa vira 0, a outra permanece
        % 3. Nenhuma camada pode ultrapassar max_neurons

        particlesCorrigidas = round(particles); % Arredonda os valores

        for i = 1:size(particlesCorrigidas, 1)
            p = particlesCorrigidas(i, :);

            % Garante que não ultrapassem o máximo
            p(p > max_neurons) = max_neurons;

            % Verifica quantas estão abaixo do mínimo
            below_min = p < min_neurons;

            if all(below_min)
                % Ambas abaixo do mínimo → uma recebe min, a outra 0
                idx = randi(2);
                p(idx) = min_neurons;
                p(3 - idx) = 0;

            elseif any(below_min)
                % Apenas uma está abaixo → ela vira 0, a outra permanece
                for j = 1:2
                    if p(j) < min_neurons && p(3 - j) >= min_neurons
                        p(j) = 0;
                    end
                end
            end

            particlesCorrigidas(i, :) = p;
        end
    end
end
