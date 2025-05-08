function parametros = EPSO(DataTrain, DataValid, DataTest, popSize, mutationRate,...
    communicationProbability, maxGen, maxGenWoChangeBest,numSeeds, vetor, nome)

global epso_par;
global ff_par;

SF = 7;
polarizacao = 1;
altura1 = 110;

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

epso_par.maxGen = maxGen;
epso_par.maxGenWoChangeBest = maxGenWoChangeBest;

epso_par.popSize = popSize;
epso_par.mutationRate = mutationRate;
epso_par.communicationProbability = communicationProbability;

weights = rand(epso_par.popSize, 4);

Xmin = 0;
Xmax = 40;
Vmin = -Xmax + Xmin;
Vmax = -Vmin;
pos = zeros(epso_par.popSize, ff_par.D);
vel = zeros(epso_par.popSize, ff_par.D);

pos = Xmin + (Xmax - Xmin) .* rand(epso_par.popSize, ff_par.D);

pos = randi([Xmin, Xmax], epso_par.popSize, ff_par.D);
vel = Vmin + (Vmax - Vmin) .* rand(epso_par.popSize, ff_par.D);

[temp, temp1] = COMPUTE_NEW_POS(pos, vel);
clear temp1

camada1 = temp(:,1);
camada2 = temp(:,2);

scores = arrayfun(@(n1, n2) objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste, numSeeds), camada1, camada2);
fit = [scores.performance];
sementes = [scores.semente];
nets = {scores.model};

[gbestval, gbestid] = min(fit);
gbest = pos(gbestid, :);
gbestsemente = sementes(gbestid);
gbestnet = nets{gbestid};

memGbestval = zeros(1, (epso_par.maxGen + 1));
memGbestval(1) = gbestval;

myBestPos = pos;
myBestPosFit = fit;

countGen = 0;
countGenWoChangeBest = 0;

ind1 = DataTest.Tabela_Atenuacao_Janelada.SF == SF &...
    DataTest.Tabela_Atenuacao_Janelada.altura == altura1&...
    DataTest.Tabela_Atenuacao_Janelada.polarizacaoNum == polarizacao;


y = gbestnet(X);
y_teste = y(nTeste);
y_net1 = y_teste(ind1);

x1 = DataTest.Tabela_Atenuacao_Janelada.distanciasR(ind1);
y1 = DataTest.Tabela_Atenuacao_Janelada.atenuacao_media(ind1);

screenSize = get(0, 'ScreenSize'); 
screenWidth = screenSize(3);
screenHeight = screenSize(4);

% fig = figure('Visible', 'off', 'Position', [0, 0, screenWidth, screenHeight]);
fig = figure;
set(fig, 'WindowState', 'maximized');

subplot(2,2,1)
grid on
grid minor
xlabel('Primeira Camada')
ylabel('Segunda Camada')
title('Partículas (Pré-avaliação)')
xlim([-4 42])
ylim([-4 42])

subplot(2,2,2)
p1_0 = scatter(camada1,camada2,50,'b','filled');
hold on
p1_2 = plot(camada1(gbestid),camada2(gbestid), 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
grid on
grid minor
xlabel('Primeira Camada')
ylabel('Segunda Camada')
title('Evolução das Melhores Soluções')
legend('Partículas','Melhor partícula')
xlim([-4 42])
ylim([-4 42])
hold off

x_data = 0;
y_data1 = mean(fit);
y_data2 = gbestval;
subplot(2,2,3)
p2_avg = plot(x_data,y_data1,'b','LineWidth',2);
hold on
p2_best = plot(x_data,y_data2,'r','LineWidth',2);
grid on
grid minor
xlabel('Épocas')
ylabel('Fitness')
title('Evolução da fitness do EPSO')
hold off
xlim([-3 maxGen+3])
legend('avg fitness','best fitness')
hold off


subplot(2,2,4)
plot(x1,y1,'bo','LineWidth',2,'MarkerSize',5)
hold on
p3 = plot(x1,y_net1,'k','LineWidth',3);
grid on
grid minor
xlabel('distância radial')
ylabel('atenuação janelada')
title('Cenário SF12 - HH - 50m')
legend('Saída Real','MLP')

sgtitle(sprintf('Geração 0 — Melhor solução: [%d neurônios, %d neurônios]  |  Fitness: %.4f', gbest(1), gbest(2), gbestval));

drawnow;

while countGen < epso_par.maxGen && countGenWoChangeBest <= epso_par.maxGenWoChangeBest
    
    countGen = countGen + 1;
    copyPos = pos;
    copyVel = vel;
    copyWeights = weights;
    
    copyWeights = MUTATE_WEIGHTS(weights, epso_par.mutationRate );
    copyVel = COMPUTE_NEW_VEL(ff_par.D, copyPos, myBestPos, gbest, ...
            copyVel, Vmin, Vmax, copyWeights, epso_par.communicationProbability);
    [copyPos, copyVel] = COMPUTE_NEW_POS(copyPos, copyVel);
    vel = COMPUTE_NEW_VEL( ff_par.D, pos, myBestPos, gbest, ...
        vel, Vmin, Vmax, weights, epso_par.communicationProbability);
    [pos, vel] = COMPUTE_NEW_POS(pos, vel);
    

    camada1 = copyPos(:,1);
    camada2 = copyPos(:,2);
    
    scores = arrayfun(@(n1, n2) objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste, numSeeds), camada1, camada2);
    copyFit = [scores.performance];
    copySementes = [scores.semente];
    copyNets = {scores.model};

    camada1 = pos(:,1);
    camada2 = pos(:,2);

    scores = arrayfun(@(n1, n2) objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste, numSeeds), camada1, camada2);
    fit = [scores.performance];
    sementes = [scores.semente];
    nets = {scores.model};

    temp = pos;

    selParNewSwarm = (copyFit < fit);  % vetor lógico
    fit(selParNewSwarm)        = copyFit(selParNewSwarm);
    pos(selParNewSwarm, :)     = copyPos(selParNewSwarm, :);
    vel(selParNewSwarm, :)     = copyVel(selParNewSwarm, :);
    weights(selParNewSwarm, :) = copyWeights(selParNewSwarm, :);
    sementes(selParNewSwarm) = copySementes(selParNewSwarm);
    nets(selParNewSwarm) = copyNets(selParNewSwarm);

    % Atualiza melhor posição individual
    % melhorou = fit < myBestPosFit;
    % myBestPos(melhorou, :) = pos(melhorou, :);
    % myBestPosFit(melhorou) = fit(melhorou);

    tmpgbestval = min(fit);
    gbestid_candidates = find(fit == tmpgbestval);


    if tmpgbestval < gbestval
        soma_componentes = sum(pos(gbestid_candidates, :), 2);

        % Escolhe o índice com a menor soma
        [~, idx_menor_soma] = min(soma_componentes);
        gbestid = gbestid_candidates(idx_menor_soma);

        gbestval = tmpgbestval;
        gbest = pos( gbestid, : );
        gbestsemente = sementes(gbestid);
        gbestnet = nets{gbestid};
        countGenWoChangeBest = 0;

    else
        countGenWoChangeBest = countGenWoChangeBest + 1;
    end

    if countGen==1
        subplot(2,2,1)
        p0_0 = scatter(copyPos(selParNewSwarm,1), copyPos(selParNewSwarm,2), 50, ...
            'filled', 'MarkerFaceColor', [0.85 0.7 0.1]);  %  amarelo
        hold on
        p0_1 = scatter(copyPos(~selParNewSwarm,1), copyPos(~selParNewSwarm,2), 70, 's', ...
            'MarkerFaceColor', [0.7 0.2 0.2], ...  % vermelho escuro
            'MarkerEdgeColor', [0.7 0.2 0.2]);
        xlabel('Primeira Camada')
        ylabel('Segunda Camada')
        title('Partículas (Pré-avaliação)')
        grid on
        grid minor
        legend([p0_0 p0_1], {'Partículas Selecionadas', 'Partículas Descartadas'})
        xlim([-4 42])
        ylim([-4 42])
        hold off


        subplot(2,2,2)
        p1_0 = scatter(pos(~selParNewSwarm,1), pos(~selParNewSwarm,2), 50, ...
            'filled', 'MarkerFaceColor', 'b');  % azul MATLAB padrão
        hold on
        p1_1 = scatter(pos(selParNewSwarm,1), pos(selParNewSwarm,2), 50, ...
            'filled', 'MarkerFaceColor', [0.85 0.7 0.1]);  % Amarelo
        p1_2 = plot(gbest(1), gbest(2), 'rp', ...
            'MarkerSize', 12, 'MarkerFaceColor', 'r');  % Vermelho forte para destacar a melhor global
        grid on
        grid minor
        xlabel('Primeira Camada')
        ylabel('Segunda Camada')
        title('Evolução das Melhores Soluções')
        legend('Partículas Mantidas', 'Partículas Melhoradas', 'Melhor Global')
        xlim([-4 42])
        ylim([-4 42])
        hold off

    else
        subplot(2,2,1)
        set(p0_0, 'XData', copyPos(selParNewSwarm,1), 'YData', copyPos(selParNewSwarm,2));
        set(p0_1, 'XData', copyPos(~selParNewSwarm,1), 'YData', copyPos(~selParNewSwarm,2));

        subplot(2,2,2)
        set(p1_0, 'XData', pos(selParNewSwarm,1), 'YData', pos(selParNewSwarm,2));
        set(p1_1, 'XData', pos(~selParNewSwarm,1), 'YData', pos(~selParNewSwarm,2));
        set(p1_2, 'XData', gbest(1), 'YData', gbest(2));
    end
    
    y = gbestnet(X);
    y_teste = y(nTeste);
    y_net1 = y_teste(ind1);

    x_data(end+1) = countGen;
    y_data1(end+1) = mean(fit);
    y_data2(end+1) = gbestval;

    subplot(2,2,3)
    set(p2_avg, 'XData', x_data, 'YData', y_data1);
    set(p2_best, 'XData', x_data, 'YData', y_data2);

    subplot(2,2,4)
    set(p3, 'YData', y_net1);

    sgtitle(sprintf('Geração %d — Melhor solução: [%d neurônios, %d neurônios]  |  Fitness: %.4f', ...
    countGen, gbest(1), gbest(2), gbestval));

    drawnow;
    
end

parametros.bestRMSE = gbestval;
parametros.bestSolution = gbest;


end
