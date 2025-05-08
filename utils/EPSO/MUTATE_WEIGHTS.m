function mutated_Weights = MUTATE_WEIGHTS(weights, mutationRate)
    mutated_Weights = weights + randn(size(weights)) * mutationRate;
    mutated_Weights = max(0, min(1, mutated_Weights));
end