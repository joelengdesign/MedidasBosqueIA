function x = GPR(dadosTreinoNorm, dadosTesteNorm)
    
    Xtrain = dadosTreinoNorm(:, 1:end-1);
    Ytrain = dadosTreinoNorm(:, end);

    Xtest = dadosTesteNorm(:, 1:end-1);
    Ytest = dadosTesteNorm(:, end);


    % Define parâmetros adequados para o kernel Matern32
    lengthScale = 1.5;   % Comprimento de escala (> 0)
    sigmaF = 2.0;        % Escala do kernel (> 0)

    % Modelo GPR com kernel 'matern32'
    GPRModel = fitrgp(Xtrain, Ytrain, ...
        'KernelFunction', 'matern32', ...
        'Sigma', 0.1, ...                             % Variância do ruído (> 0)
        'KernelParameters', [lengthScale; sigmaF]);


    outGPRTeste = predict(GPRModel, Xtest);
    rmseGPRTeste =  sqrt(immse(outGPRTeste,Ytest));
    RsquaredTeste = rsquared(Ytest,rmseGPRTeste);
    
    outGPRTreino = predict(GPRModel, Xtrain);
    rmseGPRTreino =  sqrt(immse(outGPRTreino,Ytrain));
    RsquaredTreino = rsquared(Ytrain,outGPRTreino);
    
    x.Rede = GPRModel;
    x.saidaTeste = outGPRTeste;
    x.saidaTreino = outGPRTreino;
    x.rmseTeste = rmseGPRTeste;
    x.rmseTreino = rmseGPRTreino;
    x.RsquaredTeste = RsquaredTeste;
    x.RsquaredTreino = RsquaredTreino;
end