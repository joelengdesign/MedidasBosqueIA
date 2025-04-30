function x = RedeNeural(dadosTreinoNorm, dadosTesteNorm,quantidadeNeuronios)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);

    netMLP = feedforwardnet(quantidadeNeuronios);
    
    netMLP.trainParam.showWindow = false;
    netMLP = train(netMLP,Xtrain', Ytrain');

    % teste
    outMLPTeste = netMLP(Xtest');
    rmseMLPTeste = sqrt(immse(outMLPTeste, Ytest'));
    RsquaredTeste = rsquared(Ytest', outMLPTeste);
    
    % treino
    % erro de treinamento
    outMLPTreino = netMLP(Xtrain');
    rmseMLPTreino =  sqrt(immse(outMLPTreino,Ytrain'));
    RsquaredTreino = rsquared(Ytrain', outMLPTreino);
  
    x.Rede = netMLP;
    x.saidaTeste = outMLPTeste;
    x.saidaTreino = outMLPTreino;
    x.rmseTeste = rmseMLPTeste;
    x.rmseTreino = rmseMLPTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end