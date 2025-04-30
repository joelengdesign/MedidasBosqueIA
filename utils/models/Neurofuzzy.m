function x = Neurofuzzy(dadosTreinoNorm, dadosTesteNorm, opcoesNeurofuzzy)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);

    [trainNFIS,trainNFISError,stepSize,validationNFIS,validationNFISError] = anfis([Xtrain Ytrain],opcoesNeurofuzzy);


    outNFISTeste = evalfis(trainNFIS, Xtest);
    rmseNFISTeste =  sqrt(immse(outNFISTeste,Ytest));
    RsquaredTeste = rsquared(Ytest,outNFISTeste);
    
    outNFISTreino = evalfis(trainNFIS, Xtrain);
    rmseNFISTreino =  sqrt(immse(outNFISTreino,Ytrain));
    RsquaredTreino = rsquared(Ytrain,outNFISTreino);

    x.Rede = trainNFIS;
    x.saidaTeste = outNFISTeste;
    x.saidaTreino = outNFISTreino;
    x.rmseTeste = rmseNFISTeste;
    x.rmseTreino = rmseNFISTreino;
    x.erroTreino = trainNFISError;
    x.erroValidacao = validationNFISError;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end