clear,clc,close all

%% Carregar Todos os dados (floresta e orla)

% Diretórios base das medições
baseDirs = {'C:\Users\JoelA\OneDrive - Universidade Federal do Pará - UFPA\Computador LCT\Doutorado\Pesquisa\Medicoes2\ProjetoMedicoesDrone\Medicoes\Medida_Bosque', ...
            'C:\Users\JoelA\OneDrive - Universidade Federal do Pará - UFPA\Computador LCT\Doutorado\Pesquisa\Medicoes2\ProjetoMedicoesDrone\Medicoes\Medida_Referencia'}; % Adicione o caminho real

baseDirs2 = {'C:\Users\JoelA\OneDrive - Universidade Federal do Pará - UFPA\Computador LCT\Doutorado\Pesquisa\Medicoes2\ProjetoMedicoesDrone\MedicoesSeparadas\Medida_Bosque', ...
            'C:\Users\JoelA\OneDrive - Universidade Federal do Pará - UFPA\Computador LCT\Doutorado\Pesquisa\Medicoes2\ProjetoMedicoesDrone\MedicoesSeparadas\Medida_Referencia'}; % Adicione o caminho real


addpath('utils')
SFsBosque = dir(fullfile(baseDirs{1}));
SFsBosque = SFsBosque([SFsBosque.isdir] & ~startsWith({SFsBosque.name}, '.'));

SFsBosque2 = dir(fullfile(baseDirs2{1}));
SFsBosque2 = SFsBosque2([SFsBosque2.isdir] & ~startsWith({SFsBosque2.name}, '.'));

SFsReferencia = dir(fullfile(baseDirs{2}));
SFsReferencia = SFsReferencia([SFsReferencia.isdir] & ~startsWith({SFsReferencia.name}, '.'));

SFsReferencia2 = dir(fullfile(baseDirs2{2}));
SFsReferencia2 = SFsReferencia2([SFsReferencia2.isdir] & ~startsWith({SFsReferencia2.name}, '.'));


SF = {'SF7','SF9','SF12'};
altura = [50 70 90 110];
polarizacao = {'HH', 'HV', 'VH', 'VV'};
janela = 10;
% Estruturas para armazenar os dados
Tabela_Bosque = table();
Tabela_Referencia = table();
Tabela_Bosque_Interpolada = table();
Tabela_Referencia_Interpolada = table();
Tabela_Atenuacao = table();
Tabela_Bosque_Janelada = table();
Tabela_Referencia_Janelada = table();
Tabela_Atenuacao_Janelada = table();

tab1 = table();
tab2 = table();
tab3 = table();
tab4 = table();
tab5 = table();
tab6 = table();

T = table();
cenario = {'Dados Reais Bosque','Dados Reais Referência'};
minimo = -Inf;
maximo = Inf;

RefOrla = [-1.476047,-48.452625]; % Posição Tx GPS Orla Referencia
RefBosque = [-1.47473184,-48.45452]; % Posição Tx GPS Bosque

% Nomes das tabelas correspondentes às pastas
tabelas = {Tabela_Bosque, Tabela_Referencia};

contador = 1;
% Ler sobre cada SF (SF7, SF9 e SF12)
for s = 1:length(SF)
    % Loop sobre cada altura (50, 70, 90, 110)
    for a = 1:length(altura)
        % Loop sobre cada polarização (HH, HV, VH, VV)
        for p = 1:length(polarizacao)
            % ler sobre cada cenário /Em t = 1 - bosque/Em t = 2 - orla
            for t = 1:2
                baseDir = baseDirs{t};
                baseDir2 = baseDirs2{t};
                % Lista os diretórios de SF (SF7, SF9, SF12)
                SFs = dir(baseDir);
                SFs = SFs([SFs.isdir] & ~startsWith({SFs.name}, '.'));
                sfPath = fullfile(baseDir, SFs(s).name);

                SFs2 = dir(baseDir2);
                SFs2 = SFs2([SFs2.isdir] & ~startsWith({SFs2.name}, '.'));
                sfPath2 = fullfile(baseDir2, SFs2(s).name);
                
                % Lista as subpastas de altura (6m, 12m, 18m, etc.)
                alturas = dir(sfPath);
                alturas = alturas([alturas.isdir] & ~startsWith({alturas.name}, '.') & ~strcmp({alturas.name}, 'codigos'));
                alturaPath = fullfile(sfPath, alturas(a).name);

                alturas2 = dir(sfPath2);
                alturas2 = alturas2([alturas2.isdir] & ~startsWith({alturas2.name}, '.') & ~strcmp({alturas2.name}, 'codigos'));
                alturaPath2 = fullfile(sfPath2, alturas2(a).name);
    
                % Lista as subpastas de polarização (HH, HV, VH, VV)
                polarizacoes = dir(alturaPath);
                polarizacoes = polarizacoes([polarizacoes.isdir] & ~startsWith({polarizacoes.name}, '.'));
                polPath = fullfile(alturaPath, polarizacoes(p).name);

                polarizacoes2 = dir(alturaPath2);
                polarizacoes2 = polarizacoes2([polarizacoes2.isdir] & ~startsWith({polarizacoes2.name}, '.'));
                polPath2 = fullfile(alturaPath2, polarizacoes2(p).name);

                % Lista os arquivos TXT na pasta da polarização
                arquivos = dir(fullfile(polPath, '*.txt'));
                arquivos2 = dir(fullfile(polPath2, '*.txt'));
                polarizacoes_labels = {'HH', 'HV', 'VH', 'VV'};

                % Loop para ler cada arquivo TXT
                for k = 1:length(arquivos)
                    cont(contador) = length(arquivos);
                    contador = contador+1;
                    filePath = fullfile(polPath, arquivos(k).name);
                    tabela = readtable(filePath);
                    
                    % Adficionar as novas colunas de SF, altura e índice da polarização
                    altura_valor = str2double(extractBefore(alturas(a).name, 'm')); % Extrai altura numérica
                    pol_idx = find(strcmp(polarizacoes_labels, polarizacoes(p).name)); % Obtém índice da polarização
                    
                    % Criar colunas extras e anexar à tabela
                    tabela.Var14 = repmat(altura_valor, height(tabela), 1); % Adiciona Altura
                    tabela.Var15 = repmat(polarizacoes(p).name, height(tabela), 1);
                    tabela.Var16 = repmat(pol_idx, height(tabela), 1); % Adiciona índice da polarização

                    tabela = tabela(:,[3 4 5 7 8 14 15 16]);
                    tabela.Properties.VariableNames = {'latitude', 'longitude', 'SF', 'RSSI', 'SNR', 'altura', 'polarizacao','polarizacaoNum'};
                    tabela = tabela(:,[1 2 3 6 7 8 4 5]);

                    ESP = tabela.RSSI + tabela.SNR - 10*log10(1+10.^(tabela.SNR/10));
                    tabela.pathloss = 3 + 3 - ESP;
                    
                    if t==1
                        latRef = RefBosque(1);
                        longRef = RefBosque(2);
                    elseif t ==2
                        latRef = RefOrla(1);
                        longRef = RefOrla(2);
                    end
                    
                    d = arrayfun(@(x) ...
                    distance2Points(tabela.latitude(x), tabela.longitude(x), latRef, longRef),1:size(tabela,1));
                    tabela.distanciasR = sqrt(d'.^2+(tabela.altura-2).^2);
                    tabela.distanciasH = d';
                    tabela.angulo = atand((tabela.altura-2)./tabela.distanciasH);
                    % Armazena os dados na estrutura correta (Bosque ou Referência)
                    tabela.cenario = repmat(cenario{t}, height(tabela), 1);
                    tabela = tabela(tabela.latitude < 0 & tabela.longitude < 0, :);
                    tabela = tabela(:,[13 1:12]);
                    
                    % REVISAR FUNÇÃO DE SEPARAR ROTA
                    % [T1,T2] = separarRota(tabela);
                    % salvarTabela(k*2-1, T1, polPath2);
                    % salvarTabela(k*2, T2, polPath2);

                    % figure(1)
                    % set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 0.5, 1]);
                    % plotarGeo(T1)
                    % 
                    % figure(2)
                    % set(gcf, 'Units', 'normalized', 'OuterPosition', [0.5, 0, 0.5, 1]);
                    % plotarGeo(T2)
                    % close all
                    
                    T = [T;tabela];
                end
                [~, indices] = sort(T.distanciasH);
                T = T(indices,:);
                % Obtém os valores da coluna específica
                T = retirarOutliersPorJanela(T,'RSSI',janela, 1.5);
                T = retirarOutliersPorJanela(T,'SNR',janela, 1.5);
                T = retirarOutliersPorJanela(T,'pathloss', janela, 2);
                

                aux_min = min(T.distanciasR);
                aux_max = max(T.distanciasR);

                if (aux_min > minimo)
                    minimo = aux_min;
                end

                if (aux_max < maximo)
                    maximo = aux_max;
                end
                tabelas{t} = T;
                T = table();
            end

            Tabela_Bosque = [Tabela_Bosque;tabelas{1}];
            Tabela_Referencia = [Tabela_Referencia;tabelas{2}];
        end
    end
end

D = [Tabela_Bosque.distanciasR;Tabela_Referencia.distanciasR];
PL = [Tabela_Bosque.pathloss;Tabela_Referencia.pathloss];

D = D(D>=minimo & D<=maximo);

PL = PL(D>=minimo & D<=maximo);

distancias = escolher_distancias(D, PL, 'pca');

[Tabela_Bosque_Interpolada, Tabela_Referencia_Interpolada, Tabela_Atenuacao,...
Tabela_Bosque_Janelada, Tabela_Referencia_Janelada, Tabela_Atenuacao_Janelada] =...
interpolar(Tabela_Bosque, Tabela_Referencia, distancias, janela);
%% Salvar os dados

clearvars -except Tabela_Bosque Tabela_Referencia...
    Tabela_Bosque_Interpolada Tabela_Referencia_Interpolada Tabela_Atenuacao ...
    Tabela_Bosque_Janelada Tabela_Referencia_Janelada Tabela_Atenuacao_Janelada

caminho_relativo = 'dados/TabelasCenarios10.mat'; % Caminho relativo
save(caminho_relativo);