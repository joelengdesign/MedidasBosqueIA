clear,clc,close all

%% Carregar Todos os dados (floresta e orla)

baseDirs = {'C:\Users\JoelA\OneDrive - Universidade Federal do Pará - UFPA\Computador LCT\Doutorado\Pesquisa\Medicoes2\ProjetoMedicoesDrone\MedicoesSeparadas\Medida_Bosque', ...
            'C:\Users\JoelA\OneDrive - Universidade Federal do Pará - UFPA\Computador LCT\Doutorado\Pesquisa\Medicoes2\ProjetoMedicoesDrone\MedicoesSeparadas\Medida_Referencia'};

addpath('utils')
SFsBosque = dir(fullfile(baseDirs{1}));
SFsBosque = SFsBosque([SFsBosque.isdir] & ~startsWith({SFsBosque.name}, '.'));
SFsReferencia = dir(fullfile(baseDirs{2}));
SFsReferencia = SFsReferencia([SFsReferencia.isdir] & ~startsWith({SFsReferencia.name}, '.'));

SF = {'SF7','SF9','SF12'};
altura = [50 70 90 110];
polarizacao = {'HH', 'HV', 'VH', 'VV'};
janela = 3;

% Inicializar tabelas vazias
A_Treino = table();
B_Treino = table();
Tabela_BosqueTreino_Interpolada = table();
Tabela_ReferenciaTreino_Interpolada = table();
Tabela_AtenuacaoTreino = table();
Tabela_BosqueTreino_Janelada = table();
Tabela_ReferenciaTreino_Janelada = table();
Tabela_AtenuacaoTreino_Janelada = table();

A_Validacao = table();
B_Validacao = table();
Tabela_BosqueValidacao_Interpolada = table();
Tabela_ReferenciaValidacao_Interpolada = table();
Tabela_AtenuacaoValidacao = table();
Tabela_BosqueValidacao_Janelada = table();
Tabela_ReferenciaValidacao_Janelada = table();
Tabela_AtenuacaoValidacao_Janelada = table();

A_Teste = table();
B_Teste = table();
Tabela_BosqueTeste_Interpolada = table();
Tabela_ReferenciaTeste_Interpolada = table();
Tabela_AtenuacaoTeste = table();
Tabela_BosqueTeste_Janelada = table();
Tabela_ReferenciaTeste_Janelada = table();
Tabela_AtenuacaoTeste_Janelada = table();


tab1 = table();
tab2 = table();
tab3 = table();
tab4 = table();
tab5 = table();
tab6 = table();

cenario = {'Dados Reais Bosque','Dados Reais Referência'};
minimoTreino = -Inf;
maximoTreino = Inf;

minimoTeste = -Inf;
maximoTeste = Inf;

minimoValidacao = -Inf;
maximoValidacao = Inf;

Tabela_Bosque = table();
Tabela_Referencia = table();

RefOrla = [-1.476047,-48.452625]; % Posição Tx GPS Orla Referencia
RefBosque = [-1.47473184,-48.45452]; % Posição Tx GPS Bosque

% Nomes das tabelas correspondentes às pastas
tabelas = {Tabela_Bosque, Tabela_Referencia};
cont = 1;
for k_fold = 1:16
    % Ler sobre cada SF (SF7, SF9 e SF12)
    for s = 1:length(SF)
        % Loop sobre cada altura (50, 70, 90, 110)
        for a = 1:length(altura)
            % Loop sobre cada polarização (HH, HV, VH, VV)
            for p = 1:length(polarizacao)
                % ler sobre cada cenário /Em t = 1 - bosque/Em t = 2 - orla
                for t = 1:2
                    baseDir = baseDirs{t};
                    % Lista os diretórios de SF (SF7, SF9, SF12)
                    SFs = dir(baseDir);
                    SFs = SFs([SFs.isdir] & ~startsWith({SFs.name}, '.'));
                    sfPath = fullfile(baseDir, SFs(s).name);

                    % Lista as subpastas de altura (6m, 12m, 18m, etc.)
                    alturas = dir(sfPath);
                    alturas = alturas([alturas.isdir] & ~startsWith({alturas.name}, '.') & ~strcmp({alturas.name}, 'codigos'));
                    alturaPath = fullfile(sfPath, alturas(a).name);

                    % Lista as subpastas de polarização (HH, HV, VH, VV)
                    polarizacoes = dir(alturaPath);
                    polarizacoes = polarizacoes([polarizacoes.isdir] & ~startsWith({polarizacoes.name}, '.'));
                    polPath = fullfile(alturaPath, polarizacoes(p).name);

                    % Lista os arquivos TXT na pasta da polarização
                    arquivos = dir(fullfile(polPath, '*.txt'));
                    polarizacoes_labels = {'HH', 'HV', 'VH', 'VV'};
                    % Loop para ler cada arquivo TXT
                    for k = 1:length(arquivos)
                        filePath = fullfile(polPath, arquivos(k).name);
                        tabela = readtable(filePath);
                        T{k} = tabela;
                    end

                    numT = length(T);
                    indices = randperm(numT); % Sorteia os índices

                    if numT == 3
                        TTreino = vertcat(T{indices(mod(k_fold-1, 3) + 1)});
                        TTeste = vertcat(T{indices(mod(k_fold, 3) + 1)});
                        TValidacao = vertcat(T{indices(mod(k_fold + 1, 3) + 1)});
                    elseif numT == 4
                        TTreino = vertcat(T{indices([mod(k_fold - 1, 4) + 1 mod(k_fold, 4) + 1])});
                        TTeste = vertcat(T{indices(mod(k_fold+1, 4) + 1)});
                        TValidacao = vertcat(T{indices(mod(k_fold+2, 4) + 1)});
                    elseif numT == 6
                        vetor = mod(k_fold:k_fold+3, 6);  % Gira entre 1 e 6
                        vetor(vetor == 0) = 6;
                        TTreino = vertcat(T{indices(vetor)});
                        TTeste = vertcat(T{indices(mod(k_fold+3, 6)+1)});
                        TValidacao = vertcat(T{indices(mod(k_fold+4, 6)+1)});
                    elseif numT == 8
                        vetor = mod(k_fold:k_fold+4, 8);
                        vetor(vetor == 0) = 8;
                        TTreino = vertcat(T{indices(vetor)});

                        vetor = mod((k_fold+4):(k_fold+4)+1, 8)+1;
                        TTeste = vertcat(T{indices(vetor)});

                        TValidacao = vertcat(T{indices(mod(k_fold+6, 8)+1)});
                    elseif numT == 10
                        vetor = mod(k_fold:k_fold+10, 10);
                        vetor(vetor == 0) = 10;
                        TTreino = vertcat(T{indices(vetor)});
                        
                        vetor = mod((k_fold+6):(k_fold+6)+1, 10)+1;
                        TTeste = vertcat(T{indices(vetor)});

                        TValidacao = vertcat(T{indices(mod(k_fold+8, 10)+1)});
                    elseif numT == 12
                        vetor = mod(k_fold:k_fold+8, 12);
                        vetor(vetor == 0) = 12;
                        TTreino = vertcat(T{indices(vetor)});
                        
                        vetor = mod((k_fold+8):(k_fold+8)+1, 12)+1;
                        TTeste = vertcat(T{indices(vetor)});
                        
                        TValidacao = vertcat(T{indices(mod(k_fold+10, 12)+1)});
                    elseif numT == 16
                        vetor = mod(1:1+12, 16);
                        vetor(vetor == 0) = 16;
                        TTreino = vertcat(T{indices(vetor)});

                        vetor = mod((k_fold+12):(k_fold+12)+1, 16)+1;
                        TTeste = vertcat(T{indices(vetor)});

                        TValidacao = vertcat(T{indices(mod(k_fold+14, 16)+1)});
                    end


                    clear T;
                    [~, indices] = sort(TTreino.distanciasR);
                    TTreino = TTreino(indices,:);

                    [~, indices] = sort(TTeste.distanciasR);
                    TTeste = TTeste(indices,:);

                    [~, indices] = sort(TValidacao.distanciasR);
                    TValidacao = TValidacao(indices,:);

                    % Obtém os valores da coluna específica
                    TTreino = retirarOutliersPorJanela(TTreino,'RSSI',janela, 1.5);
                    TTreino = retirarOutliersPorJanela(TTreino,'SNR',janela, 1.5);
                    TTreino = retirarOutliersPorJanela(TTreino,'pathloss', janela, 2);

                    TTeste = retirarOutliersPorJanela(TTeste,'RSSI',janela, 1.5);
                    TTeste = retirarOutliersPorJanela(TTeste,'SNR',janela, 1.5);
                    TTeste = retirarOutliersPorJanela(TTeste,'pathloss', janela, 2);

                    TValidacao = retirarOutliersPorJanela(TValidacao,'RSSI',janela, 1.5);
                    TValidacao = retirarOutliersPorJanela(TValidacao,'SNR',janela, 1.5);
                    TValidacao = retirarOutliersPorJanela(TValidacao,'pathloss', janela, 2);

                    aux_minTreino = min(TTreino.distanciasR);
                    aux_maxTreino = max(TTreino.distanciasR);

                    aux_minTeste = min(TTeste.distanciasR);
                    aux_maxTeste = max(TTeste.distanciasR);

                    aux_minValidacao = min(TValidacao.distanciasR);
                    aux_maxValidacao = max(TValidacao.distanciasR);

                    % Atualizar o máximo dos mínimos
                    minimoTreino = max([minimoTreino, aux_minTreino]);
                    minimoTeste = max([minimoTeste, aux_minTeste]);
                    minimoValidacao = max([minimoValidacao, aux_minValidacao]);

                    % Atualizar o mínimo dos máximos
                    maximoTreino = min([maximoTreino, aux_maxTreino]);
                    maximoTeste = min([maximoTeste, aux_maxTeste]);
                    maximoValidacao = min([maximoValidacao, aux_maxValidacao]);


                    % disp(['minimoValidacao antes: ', num2str(minimoValidacao)]);
                    % disp(['aux_minValidacao: ', num2str(aux_minValidacao)]);
                    % disp(['maximoValidacao antes: ', num2str(maximoValidacao)]);
                    % disp(['aux_maxValidacao: ', num2str(aux_maxValidacao)]);



                    tabelasTreino{t} = TTreino;

                    dist = sort(TTreino.distanciasR);  % ordena as distâncias
                    espacamento_medio = mean(diff(dist));  % distância média entre pontos
                    densidadeTreino{t}(cont) = 1 / espacamento_medio;  % pontos por metro

                    TTreino = table();

                    tabelasTeste{t} = TTeste;

                    dist = sort(TTeste.distanciasR);  % ordena as distâncias
                    espacamento_medio = mean(diff(dist));  % distância média entre pontos
                    densidadeTeste{t}(cont) = 1 / espacamento_medio;  % pontos por metro
                    
                    TTeste = table();

                    tabelasValidacao{t} = TValidacao;

                    dist = sort(TValidacao.distanciasR);  % ordena as distâncias
                    espacamento_medio = mean(diff(dist));  % distância média entre pontos
                    densidadeValidacao{t}(cont) = 1 / espacamento_medio;  % pontos por metro

                    TValidacao = table();
                end
                cont = cont+1;

                A_Treino = [A_Treino;tabelasTreino{1}];
                B_Treino = [B_Treino;tabelasTreino{2}];

                A_Teste = [A_Teste;tabelasTeste{1}];
                B_Teste = [B_Teste;tabelasTeste{2}];

                A_Validacao = [A_Validacao;tabelasValidacao{1}];
                B_Validacao = [B_Validacao;tabelasValidacao{2}];

                % height(A_Treino)
                % height(A_Teste)
                % height(A_Validacao)
                % B_Validacao;
            end
        end
    end
    Tabela_BosqueTreino = A_Treino;
    Tabela_ReferenciaTreino = B_Treino;

    Tabela_BosqueTeste = A_Teste;
    Tabela_ReferenciaTeste = B_Teste;

    Tabela_BosqueValidacao = A_Validacao;
    Tabela_ReferenciaValidacao = B_Validacao;


    DTreino = [Tabela_BosqueTreino.distanciasR;Tabela_ReferenciaTreino.distanciasR];
    PLTreino = [Tabela_BosqueTreino.pathloss;Tabela_ReferenciaTreino.pathloss];
    distanciasTreino = escolher_distancias(DTreino, PLTreino, 'pca');

    DTeste = [Tabela_BosqueTeste.distanciasR;Tabela_ReferenciaTeste.distanciasR];
    PLTeste = [Tabela_BosqueTeste.pathloss;Tabela_ReferenciaTeste.pathloss];
    distanciasTeste = escolher_distancias(DTeste, PLTeste, 'pca');

    DValidacao = [Tabela_BosqueValidacao.distanciasR;Tabela_ReferenciaValidacao.distanciasR];
    PLValidacao = [Tabela_BosqueValidacao.pathloss;Tabela_ReferenciaValidacao.pathloss];
    distanciasValidacao = escolher_distancias(DValidacao, PLValidacao, 'pca');

    [Tabela_BosqueTreino_Interpolada, Tabela_ReferenciaTreino_Interpolada, Tabela_AtenuacaoTreino,...
        Tabela_BosqueTreino_Janelada, Tabela_ReferenciaTreino_Janelada, Tabela_AtenuacaoTreino_Janelada] =...
        interpolar(Tabela_BosqueTreino, Tabela_ReferenciaTreino, distanciasTreino, janela);

    [Tabela_BosqueValidacao_Interpolada, Tabela_ReferenciaValidacao_Interpolada, Tabela_AtenuacaoValidacao,...
        Tabela_BosqueValidacao_Janeladado, Tabela_ReferenciaValidacao_Janelada, Tabela_AtenuacaoValidacao_Janelada] =...
        interpolar(Tabela_BosqueValidacao, Tabela_ReferenciaValidacao, distanciasValidacao, janela);

    [Tabela_BosqueTeste_Interpolada, Tabela_ReferenciaTeste_Interpolada, Tabela_AtenuacaoTeste,...
        Tabela_BosqueTeste_Janelada, Tabela_ReferenciaTeste_Janelada, Tabela_AtenuacaoTeste_Janelada] =...
        interpolar(Tabela_BosqueTeste, Tabela_ReferenciaTeste, distanciasTeste, janela);


    % Dados de Treino
    A.Tabela_Bosque = Tabela_BosqueTreino;
    A.Tabela_Referencia = Tabela_ReferenciaTreino;
    A.Tabela_Bosque_Interpolada = Tabela_BosqueTreino_Interpolada;
    A.Tabela_Referencia_Interpolada = Tabela_ReferenciaTreino_Interpolada;
    A.Tabela_Atenuacao = Tabela_AtenuacaoTreino;
    A.Tabela_Bosque_Janelada = Tabela_BosqueTreino_Janelada;
    A.Tabela_Referencia_Janelada = Tabela_ReferenciaTreino_Janelada;
    A.Tabela_Atenuacao_Janelada = Tabela_AtenuacaoTreino_Janelada;
    DataTrain{k_fold} = A;

    % Dados de Validação
    B.Tabela_Bosque = Tabela_BosqueValidacao;
    B.Tabela_Referencia = Tabela_ReferenciaValidacao;
    B.Tabela_Bosque_Interpolada = Tabela_BosqueValidacao_Interpolada;
    B.Tabela_Referencia_Interpolada = Tabela_ReferenciaValidacao_Interpolada;
    B.Tabela_Atenuacao = Tabela_AtenuacaoValidacao;
    B.Tabela_Bosque_Janelada = Tabela_BosqueValidacao_Janelada;
    B.Tabela_Referencia_Janelada = Tabela_ReferenciaValidacao_Janelada;
    B.Tabela_Atenuacao_Janelada = Tabela_AtenuacaoValidacao_Janelada;
    DataValid{k_fold} = B;

    % Dados de Teste
    C.Tabela_Bosque = Tabela_BosqueTeste;
    C.Tabela_Referencia = Tabela_ReferenciaTeste;
    C.Tabela_Bosque_Interpolada = Tabela_BosqueTeste_Interpolada;
    C.Tabela_Referencia_Interpolada = Tabela_ReferenciaTeste_Interpolada;
    C.Tabela_Atenuacao = Tabela_AtenuacaoTeste;
    C.Tabela_Bosque_Janelada = Tabela_BosqueTeste_Janelada;
    C.Tabela_Referencia_Janelada = Tabela_ReferenciaTeste_Janelada;
    C.Tabela_Atenuacao_Janelada = Tabela_AtenuacaoTeste_Janelada;
    DataTest{k_fold} = C;
end


%% Salvar os dados

clearvars -except DataTrain DataValid DataTest


caminho_relativo = 'DadosSeparados/SeparateDataStruct.mat'; % Caminho relativo
save(caminho_relativo);