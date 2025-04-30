function x = ArvoreDecisao(dadosTreinoNorm, dadosTesteNorm)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);

    redeArvore = fitctree(Xtrain, Ytrain);

    outArvoreTeste = predict(redeArvore, Xtest);
    rmseArvoreTeste =  sqrt(immse(outArvoreTeste,Ytest));
    RsquaredTeste = rsquared(Ytest,outArvoreTeste);
   
    outArvoreTreino = predict(redeArvore, Xtrain);
    rmseredeArvoreTreino = sqrt(immse(outArvoreTreino,Ytrain));
    RsquaredTreino = rsquared(Ytrain,outArvoreTreino);

    x.Rede = redeArvore;
    x.saidaTeste = outArvoreTeste;
    x.saidaTreino = outArvoreTreino;
    x.rmseTeste = rmseArvoreTeste;
    x.rmseTreino = rmseredeArvoreTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end