function x = SVM(dadosTreinoNorm, dadosTesteNorm)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);
    
    redeSVM = fitrsvm(Xtrain, Ytrain, ...
        'KernelFunction', 'rbf', ...
        'BoxConstraint', 10, ...
        'KernelScale', 1.5, ...
        'Epsilon', 0.2, ...
        'Standardize', true);

    outSVMTeste = predict(redeSVM, Xtest);
    rmseSVMTeste =  sqrt(immse(outSVMTeste,Ytest));
    RsquaredTeste = rsquared(Ytest, outSVMTeste);
    
    outSVMTreino = predict(redeSVM, Xtrain);
    rmseSVMTreino =  sqrt(immse(outSVMTreino,Ytrain));
    RsquaredTreino = rsquared(Ytrain, outSVMTreino);
    
    x.Rede = redeSVM;
    x.saidaTeste = outSVMTeste;
    x.saidaTreino = outSVMTreino;
    x.rmseTeste = rmseSVMTeste;
    x.rmseTreino = rmseSVMTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;

end