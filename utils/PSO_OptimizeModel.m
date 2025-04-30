function params = PSO_OptimizeModel(Ensemble, dadosTreino, dadosValidacao, dadosTeste, num_particles, max_epochs)

num_dimensions = 4;   % Quatro pesos (A, B, C, D)
min_val_fitness = inf;
patience = 50;
% Geração inicial das partículas normalizadas
particles = rand(num_particles, num_dimensions);
% particles = particles ./ sum(particles, 2);

w = 0.9;             % Inércia inicial
c1 = 1.2;           % Coeficiente cognitivo
c2 = 1.2;           % Coeficiente social

% Inicialização das partículas
velocities = zeros(num_particles, num_dimensions);

% Avaliação da função objetivo
fitness = arrayfun(@(i) objetiveFunctionEnsemble(Ensemble, dadosTreino, particles(i, :)), 1:num_particles)';

% Inicialização das melhores posições
pbest = particles;
pbest_fitness = fitness;
[gbest_fitness, best_idx] = min(pbest_fitness);
gbest = pbest(best_idx, :);

% Armazenamento para plot
parpool;
% Loop principal do PSO
for epoch = 1:max_epochs
    % Atualização das velocidades e posições
    r1 = rand(num_particles, num_dimensions);
    r2 = rand(num_particles, num_dimensions);
    velocities = w * velocities + ...
        c1 * r1 .* (pbest - particles) + ...
        c2 * r2 .* (gbest - particles);
    particles = particles + velocities;

    % Avaliação da função objetivo nos dados de treino
    fitnessTrain = arrayfun(@(i) objetiveFunctionEnsemble(Ensemble, dadosTreino, particles(i, :)), 1:num_particles)';

    % Atualização das melhores posições individuais
    improved = fitnessTrain < pbest_fitness;
    pbest(improved, :) = particles(improved, :);
    pbest_fitness(improved) = fitnessTrain(improved);

    % Atualização do melhor global
    [min_fitness, min_idx] = min(pbest_fitness);
    if min_fitness < gbest_fitness
        gbest_fitness = min_fitness;
        gbest = pbest(min_idx, :);
    end

    % Armazena histórico
    best_fitness_hist(epoch) = gbest_fitness;
    avg_fitness_hist(epoch) = mean(fitnessTrain);

    % Avaliação da fitness de validação com a melhor partícula
    fitnessValid(epoch) = objetiveFunctionEnsemble(Ensemble, dadosValidacao, gbest);

    % Verificação de melhora na fitness de validação
    if fitnessValid(epoch) < min_val_fitness
        min_val_fitness = fitnessValid(epoch);
        best_epoch = epoch;
        best_gbest = gbest;
        best_gbest_fitness = gbest_fitness;
        wait = 0;  % zera contador de paciência
        fitnessTest = objetiveFunctionEnsemble(Ensemble, dadosTeste, gbest);
    else
        wait = wait + 1;
    end

    % Redução gradual da inércia
    w = w * 0.99;

    % Parada antecipada se validação não melhorar por 'patience' épocas
    if wait >= patience
        fprintf('Early stopping na época %d. Melhor época de validação: %d\n', epoch, best_epoch);
        break;
    end
end
delete(gcp);

params.Weights = best_gbest;
params.RMSETrain = best_gbest_fitness;
params.RMSETest = fitnessTest;
params.bestFitnessHistoryTrain = best_fitness_hist;
params.bestFitnessHistoryValid = fitnessValid;
params.bestEpoch = best_epoch;


end
