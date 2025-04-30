function x = GRNN(dadosTreinoNorm, dadosTesteNorm,spread)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);

    netGRNN = newgrnn(Xtrain', Ytrain', spread);

    outGRNNTeste = sim(netGRNN, Xtest');
    rmseGRNNTeste = sqrt(immse(outGRNNTeste, Ytest'));
    RsquaredTeste = rsquared(Ytest',outGRNNTeste);
    
    % treino
    outGRNNTreino = sim(netGRNN,Xtrain');
    rmseGRNNTreino =  sqrt(immse(outGRNNTreino, Ytrain'));
    RsquaredTreino = rsquared(Ytrain',outGRNNTreino);

    x.Rede = netGRNN;
    x.saidaTeste = outGRNNTeste;
    x.saidaTreino = outGRNNTreino;
    x.rmseTeste = rmseGRNNTeste;
    x.rmseTreino = rmseGRNNTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end