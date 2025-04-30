function x = RandomForest(dadosTreinoNorm, dadosTesteNorm, nTrees)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);

    % Definir o número mínimo de exemplos por nó terminal (folha)
    MinLeafSize = 5;  % O número mínimo de observações por folha

    % Criar a Random Forest para regressão com os parâmetros definidos
    RFModel = TreeBagger(nTrees, Xtrain, Ytrain, ...
        'MinLeafSize', MinLeafSize, ...  % Ajustando o número mínimo de exemplos por folha
        'OOBPrediction', 'on', ...       % Habilita as previsões fora da bolsa para validação
        'Method', 'regression');        % Usando regressão

    outRFTeste = predict(RFModel, Xtest);
    rmseRFTeste =  sqrt(immse(outRFTeste,Ytest));
    RsquaredTeste = rsquared(Ytest,outRFTeste);
    
    outRFTreino = predict(RFModel, Xtrain);
    rmseRFTreino =  sqrt(immse(outRFTreino,Ytrain));
    RsquaredTreino = rsquared(Ytrain,outRFTreino);
    
    x.Rede = RFModel;
    x.saidaTeste = outRFTeste;
    x.saidaTreino = outRFTreino;
    x.rmseTeste = rmseRFTeste;
    x.rmseTreino = rmseRFTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end