function T = dados_filtrados(dados, varargin)

% DADOS = dados a serem filtrados
% SF - variável String que indica o SF você deseja ('SF7', 'SF9' ou 'SF12')
% ALTURA - variável int que indica qual altura você deseja (50, 70, 90 ou 110)
%
% EXEMPLO
% dados = carregue os dados em forma de tabela
% SF = 'SF7';
% ALTURA = 50;
% dadosFiltrados = filtrarDados(DADOS,SF,ALTURA)
%

% varargin irá conter os parâmetros adicionais (altura, polarização, etc.)

% Inicializa as variáveis conforme os argumentos passados
altura = [];
polarizacao = [];

% Checa se os argumentos adicionais foram passados
if ~isempty(varargin) && ~isempty(varargin{1}) && ~isempty(varargin{2}) && isempty(varargin{3})
    SF = varargin{1}; % Caso o SF seja fornecido
    polarizacao = varargin{2}; % Caso polarização seja fornecida
    ind = find((dados.SF == SF) & (dados.polarizacaoNum == polarizacao));
elseif ~isempty(varargin) && isempty(varargin{1}) && ~isempty(varargin{2}) && ~isempty(varargin{3})
    polarizacao = varargin{2}; % Caso polarização seja fornecida
    altura = varargin{3}; % Caso polarização seja fornecida
    ind = find((dados.polarizacaoNum == polarizacao) & (dados.altura == altura));
elseif ~isempty(varargin) && ~isempty(varargin{1}) && isempty(varargin{2}) && ~isempty(varargin{3})
    SF = varargin{1}; % Caso o SF seja fornecido
    altura = varargin{3}; % Caso polarização seja fornecida
    ind = find((dados.SF == SF) & (dados.altura == altura));
elseif ~isempty(varargin) && ~isempty(varargin{1}) && isempty(varargin{2}) && isempty(varargin{3})
    SF = varargin{1}; % Caso o SF seja fornecido
    ind = find(dados.SF == SF);
elseif ~isempty(varargin) && isempty(varargin{1}) && ~isempty(varargin{2}) && isempty(varargin{3})
    polarizacao = varargin{2}; % Caso polarização seja fornecida
    ind = find(dados.polarizacaoNum == polarizacao);
elseif ~isempty(varargin) && isempty(varargin{1}) && isempty(varargin{2}) && ~isempty(varargin{3})
    altura = varargin{3}; % Caso polarização seja fornecida
    ind = find(dados.altura == altura);
end

T = dados(ind, :);  % Retorna os dados filtrados

end