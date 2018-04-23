% This does not do the Matrix itself.
% This gives the correlation between two features.
% Made By: Serafim Barroca :)
function CM = CorrelationMatrix(n,f1data,f2data)
    f1mean = mean(f1data);
    f2mean = mean(f2data);
    num = std(f1data) * std(f2data);
    sum = 0;
    for k=1:n
        den = (f1data(k) - f1mean) * (f2data(k) - f2mean);
        sum = sum + (den / num);
    end
    CM = (1 / (n - 1)) * sum;
end

