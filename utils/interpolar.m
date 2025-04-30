function [D,E,F,J,K,L] = interpolar(tabela1, tabela2, distancias,janela)

SF = [7 9 12];
alturas = 50:20:110;
contador = 1;
for a=1:4
    for p=1:4
        for s = 1:3

            tab1 = tabela1(tabela1.SF == SF(s) & tabela1.altura == alturas(a) & tabela1.polarizacaoNum == p,:);
            tab2 = tabela2(tabela2.SF == SF(s) & tabela2.altura == alturas(a) & tabela2.polarizacaoNum == p,:);

            % ======= Tratamento de valores repetidos para dados Bosque =======
            [dist_unicas, ~, ic] = unique(tab1.distanciasR);
            latitude_medio          = accumarray(ic, tab1.latitude, [], @mean);
            longitude_medio       = accumarray(ic, tab1.longitude, [], @mean);
            RSSI_medio               = accumarray(ic, tab1.RSSI, [], @mean);
            SNR_medio                = accumarray(ic, tab1.SNR, [], @mean);
            pathloss_medio         = accumarray(ic, tab1.pathloss, [], @mean);

            latitude_Interpol  = interp1(dist_unicas, latitude_medio, distancias, 'linear');
            longitude_Interpol  = interp1(dist_unicas, longitude_medio, distancias, 'linear');
            RSSI_Interpol      = interp1(dist_unicas, RSSI_medio, distancias, 'nearest');
            SNR_Interpol      = interp1(dist_unicas, SNR_medio, distancias, 'nearest');
            pathloss_Interpol      = interp1(dist_unicas, pathloss_medio, distancias, 'nearest');

            distanciasH = sqrt((distancias).^2-(tab1.altura(1)-2)^2);
            altura = ones(length(distancias),1)*tab1.altura(1);
            angulo = atand((tab1.altura(1)-2)./distanciasH');

            A = table(repmat('Dados Interpolados Bosque', length(distancias), 1),...
                'VariableNames', {'cenario'});
            A.latitude = latitude_Interpol;
            A.longitude = longitude_Interpol;
            A.SF = repmat(tab1.SF(1), length(distancias), 1);
            A.altura = altura;
            A.polarizacao = repmat(tab1.polarizacao(1,:), length(distancias), 1);
            A.polarizacaoNum = repmat(tab1.polarizacaoNum(1), length(distancias), 1);
            A.RSSI = RSSI_Interpol;
            A.SNR = SNR_Interpol;
            A.pathloss = pathloss_Interpol;
            A.distanciasR = distancias;
            A.distanciasH = distanciasH;
            A.angulo = angulo';
            

            % ======= Tratamento de valores repetidos para dados Referência  =======
            [dist_unicas, ~, ic] = unique(tab2.distanciasR);
            latitude_medio          = accumarray(ic, tab2.latitude, [], @mean);
            longitude_medio       = accumarray(ic, tab2.longitude, [], @mean);
            RSSI_medio               = accumarray(ic, tab2.RSSI, [], @mean);
            SNR_medio                = accumarray(ic, tab2.SNR, [], @mean);
            pathloss_medio         = accumarray(ic, tab2.pathloss, [], @mean);

            latitude_Interpol  = interp1(dist_unicas, latitude_medio, distancias, 'linear');
            longitude_Interpol  = interp1(dist_unicas, longitude_medio, distancias, 'linear');
            RSSI_Interpol      = interp1(dist_unicas, RSSI_medio, distancias, 'nearest');
            SNR_Interpol      = interp1(dist_unicas, SNR_medio, distancias, 'nearest');
            pathloss_Interpol      = interp1(dist_unicas, pathloss_medio, distancias, 'nearest');

            distanciasH = sqrt((distancias).^2-(tab2.altura(1)-2)^2);
            altura = ones(length(distancias),1)*tab2.altura(1);
            angulo = atand((tab2.altura(1)-2)./distanciasH');

            B = table(repmat('Dados Interpolados Referência', length(distancias), 1),...
                'VariableNames', {'cenario'});
            B.latitude = latitude_Interpol;
            B.longitude = longitude_Interpol;
            B.SF = repmat(tab2.SF(1), length(distancias), 1);
            B.altura = altura;
            B.polarizacao = repmat(tab2.polarizacao(1,:), length(distancias), 1);
            B.polarizacaoNum = repmat(tab2.polarizacaoNum(1), length(distancias), 1);
            B.RSSI = RSSI_Interpol;
            B.SNR = SNR_Interpol;
            B.pathloss = pathloss_Interpol;
            B.distanciasR = distancias;
            B.distanciasH = distanciasH;
            B.angulo = angulo';
            

            % ======= Tabela Atenuação =======
            C = table(repmat('Dados Atenuação', length(distancias), 1), 'VariableNames', {'cenario'});
            C.latitude = A.latitude;
            C.longitude = A.longitude;
            C.SF = repmat(A.SF(1), length(distancias), 1);
            C.altura = repmat(A.altura(1), length(distancias), 1);
            C.polarizacao = repmat(A.polarizacao(1,:), length(distancias), 1);
            C.polarizacaoNum = repmat(A.polarizacaoNum(1), length(distancias), 1);
            C.RSSI = A.RSSI-B.RSSI;
            C.SNR = A.SNR-B.SNR;
            C.atenuacao = tratar_diferencas(A.pathloss,B.pathloss);
            C.distanciasR = distancias;
            C.distanciasH = A.distanciasH;
            C.angulo = A.angulo;

             
            C(isnan(C.atenuacao),:) = [];


            D{contador} = A; % tabela interpolada bosque
            E{contador} = B; % tabela interpolada referência
            F{contador} = C; % tabela atenuação

            passo = janela;
            [G,num1(contador)] = janelarTabela(A, passo); % janelamento bosque

            [H,num2(contador)] = janelarTabela(B, passo); % janelamento referência

            [I,num3(contador)] = janelarTabela(C, passo); % janelamento atenuação

            J{contador} = G; % tabela bosque janelada
            K{contador} = H; % tabela referência janelada
            L{contador} = I; % tabela atenuação janelada
            contador = contador + 1;
        end
    end
end
D = vertcat(D{:});
E = vertcat(E{:});
F = vertcat(F{:});
J = vertcat(J{:});
K = vertcat(K{:});
L = vertcat(L{:});
    function diff_result = tratar_diferencas(vetor_floresta, vetor_referencia)
        % Verifica se os vetores têm o mesmo tamanho
        if length(vetor_floresta) ~= length(vetor_referencia)
            error('Os vetores devem ter o mesmo tamanho.');
        end

        % Calcula a diferença entre os dois vetores
        diff_result = vetor_floresta - vetor_referencia;

        % Encontra o menor valor não negativo
        min_positivo = min(diff_result(diff_result >= 0));

        % Identifica os índices onde vetor_floresta é menor que vetor_referencia
        indices_menores = vetor_floresta < vetor_referencia;

        % Itera sobre os elementos da diferença
        for i = find(indices_menores) % Apenas nos índices problemáticos
            % Se a diferença for negativa (caso proibido), tenta calcular a média das duas anteriores
            if i > 2
                diff_result(i) = mean(diff_result(i-2:i-1));
            else
                % Se não houver duas diferenças anteriores, substitui pelo valor mínimo não negativo
                diff_result(i) = min_positivo;
            end
        end
    end

end