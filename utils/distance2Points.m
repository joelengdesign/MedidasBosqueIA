function distance = distance2Points(lat1,long1,lat2,long2)

% Função para calcular a distância entre dois pontos utilizando a
% a equação de Haversine.
% Parâmetros:
% lat1: latitude do ponto 1
% long1: longitude do ponto 1
% lat2: latitude do ponto 2
% long2: longitude do ponto 2
% Return:
% distance: distância entre dois pontos em metros.
radius = 6371;
dLat  = ((lat1*pi)./180) - ((lat2*pi)./180);
dLong = ((long1*pi)./180) - ((long2*pi)./180);
a = sin((dLat)./2).^2 + cos((lat2.*pi)./180).*cos((lat1.*pi)./180)*sin(dLong./2).^2;
c = 2*atan2(sqrt(a),sqrt(1-a));

distance = (radius*c)*1000;

end






