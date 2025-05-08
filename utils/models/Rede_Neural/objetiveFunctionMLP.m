function param = objetiveFunctionMLP(n1, n2, dadosTreino, dadosValidacao, dadosTeste, numSeeds)

dados = [dadosTreino; dadosValidacao; dadosTeste];

X = dados(:,1:end-1)';
Y = dados(:,end)';
minimoSeed = Inf;
perf = zeros(1, numSeeds);
sem = 0;

data = [dadosTreino; dadosValidacao; dadosTeste];

input = data(:,1:end-1)';
target = data(:,end)';

indiceTreino = size(dadosTreino, 1);
indiceValidacao    = size(dadosValidacao, 1);
indiceTeste  = size(dadosTeste, 1);

N1 = size(dadosTreino, 1);
N2    = size(dadosValidacao, 1);
N3  = size(dadosTeste, 1);

indiceTreino = 1:N1;
indiceValidacao   = (N1+1):(N1+N2);
indiceTeste  = (N1+N2+1):(N1+N2+N3);

estruturaTemp = [n1 n2];
if any(estruturaTemp == 0)
    estrutura = estruturaTemp(estruturaTemp>0);
else
    estrutura = estruturaTemp;
end
somAcum = 0;
for s = 1:numSeeds
    rng(s)
    % Criar e treinar a rede neural com o número de neurônios especificado
    Net = feedforwardnet(estrutura);  % Rede neural com n1 neurônios na camada 1 e n2 na camada 2
    Net.trainParam.showWindow = false;
    Net.divideFcn = 'divideind';
    Net.divideParam.trainInd = indiceTreino;
    Net.divideParam.valInd   = indiceValidacao;
    Net.divideParam.testInd  = indiceTeste;


    [Net,tr] = train(Net, input, target);

    % Calcular a performance usando o conjunto de teste
    yPred = Net(X);

    perf = sqrt(perform(Net, Y(:,tr.testInd), yPred(:,tr.testInd)));
    somAcum = somAcum + perf;

    if perf<minimoSeed
        Semente = s;
        Model = Net;
    end
end
param.performance = somAcum/numSeeds;
param.model = Model;
param.semente = Semente;
end