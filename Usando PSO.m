numParticles = 10;
max_epochs = 100;

[bestWeights, bestRMSE, bestFitnessHistory, meanFitnessHistory] = PSO_OptimizeModel(ModelosEnsemble, xTrain, xValid, numParticles, max_epochs)