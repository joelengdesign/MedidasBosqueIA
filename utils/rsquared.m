function x = rsquared(y,yt)
    x = 1-(sum((y-yt).^2)/sum((y-mean(y)).^2));
end