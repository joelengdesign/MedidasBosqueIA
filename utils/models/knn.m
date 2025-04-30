function x = knn(dadosTreinoNorm, dadosTesteNorm)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);

    knnModel = fitcknn(Xtrain, Ytrain);

    outknnTeste = predict(knnModel, Xtest);
    rmseknnTeste =  sqrt(immse(outknnTeste,Ytest));
    RsquaredTeste = rsquared(Ytest,rmseknnTeste);
    
    outknnTreino = predict(knnModel, Xtrain);
    rmseknnTreino =  sqrt(immse(outknnTreino,Ytrain));
    RsquaredTreino = rsquared(Ytrain,outknnTreino);
    
    x.Rede = knnModel;
    x.saidaTeste = outknnTeste;
    x.saidaTreino = outknnTreino;
    x.rmseTeste = rmseknnTeste;
    x.rmseTreino = rmseknnTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end