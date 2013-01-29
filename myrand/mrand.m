function [ X ] = mrand(m,n)
X = zeros(m,n);

for i=1:m
    for j=1:n
        X(i, j) = myrand_float();
    end
end

end

