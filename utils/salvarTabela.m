function salvarTabela(nomeArquivo, tabela, caminho)
    % Converter o número para string e adicionar extensão .txt
    nomeArquivo = sprintf('%d.txt', nomeArquivo);
    
    % Construir o caminho completo
    caminhoCompleto = fullfile(caminho, nomeArquivo);
    
    % Salvar a tabela como um arquivo TXT
    writetable(tabela, caminhoCompleto, 'Delimiter', ','); % Usa vírgula como separador
end
