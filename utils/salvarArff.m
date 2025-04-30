function salvarArff(dados, nomeArquivo)
    % Abre o arquivo para escrita
    fid = fopen(nomeArquivo, 'w');
    
    if fid == -1
        error('Não foi possível criar o arquivo.');
    end
    
    % Escreve o cabeçalho
    fprintf(fid, '@relation dados\n\n');
    
    % Obtém os nomes das colunas (atributos)
    nomesAtributos = dados.Properties.VariableNames;
    
    % Identifica os tipos de dados
    for i = 1:numel(nomesAtributos)
        coluna = dados.(nomesAtributos{i});
        if isnumeric(coluna)
            fprintf(fid, '@attribute %s numeric\n', nomesAtributos{i});
        elseif iscellstr(coluna) || isstring(coluna)
            valoresUnicos = unique(coluna);
            valoresStr = strjoin("{" + valoresUnicos + "}", ',');
            fprintf(fid, '@attribute %s %s\n', nomesAtributos{i}, valoresStr);
        else
            warning('Tipo de dado não reconhecido para %s. Usando string.', nomesAtributos{i});
            fprintf(fid, '@attribute %s string\n', nomesAtributos{i});
        end
    end
    
    % Escreve os dados
    fprintf(fid, '\n@data\n');
    
    for i = 1:height(dados)
        linha = dados(i, :);
        valores = strings(1, numel(nomesAtributos));
        for j = 1:numel(nomesAtributos)
            valor = linha.(nomesAtributos{j});
            if isnumeric(valor)
                valores(j) = num2str(valor);
            elseif iscell(valor) || isstring(valor)
                valores(j) = valor; % Strings já são tratadas corretamente
            else
                valores(j) = '?'; % Para valores desconhecidos
            end
        end
        fprintf(fid, '%s\n', strjoin(valores, ','));
    end
    
    % Fecha o arquivo
    fclose(fid);
    fprintf('Arquivo %s salvo com sucesso!\n', nomeArquivo);
end
