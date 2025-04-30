function Output = calcularSaidaWeissberger(f, dados)
    d = dados(:,1);

     fspl = freeSpacePathLoss(f*1000,d/1000);
    Output = zeros(size(d));
    for i = 1:length(d)
        if d(i) < 14
            Output(i) = 0.45 * (f^0.284) * d(i)+fspl(i);
        elseif d(i) < 400
            Output(i) = 1.33 * (f^0.284) * (d(i)^0.588)+fspl(i);
        else
            Output(i) = inf;
        end
    end
end