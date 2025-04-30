function x = Ensemble(dadosTreinoNorm)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);
    
    nTrees = 100;
    modelo1 = TreeBagger(nTrees, Xtrain, Ytrain, 'OOBPrediction', 'On', 'Method', 'regression');
    
    modelo2 = fitrsvm(Xtrain, Ytrain, 'KernelFunction', 'rbf', 'Standardize', true); % SVM com kernel gaussiana
    
    quantidadeNeuronios = 15;
    modelo3 = feedforwardnet(quantidadeNeuronios);
    modelo3.trainParam.showWindow = 0;
    modelo3 = train(modelo3,Xtrain', Ytrain');
    
    modelo4 = newgrnn(Xtrain', Ytrain', 0.02);

    x.RandomForest = modelo1;
    x.SVM = modelo2;
    x.MLP = modelo3;
    x.GRNN = modelo4;
end