function x = objetiveFunctionEnsemble(modelos, dadosTeste, pesos)

Xtest = dadosTeste(:, 1:end-1);
Ytest = dadosTeste(:, end);

A = pesos(1);
B = pesos(2);
C = pesos(3);
D = pesos(4);

if modelos.opcao == 1
    saida1 = A*predict(modelos.Forest, Xtest);
elseif modelos.opcao == 2
    saida1 = A*evalfis(modelos.Neurofuzzy, Xtest);
elseif modelos.opcao == 3
    saida1 = A*predict(modelos.GPR, Xtest);
else
    error('Opção inválida')
end

saida2 = B*predict(modelos.SVM, Xtest);
saida3 = C*modelos.MLP(Xtest');
saida3 = saida3';
saida4 = D*sim(modelos.GRNN,Xtest');
saida4 = saida4';

saida = saida1 + saida2 + saida3 + saida4;
rmse = sqrt(immse(saida, Ytest));

x = rmse;

end