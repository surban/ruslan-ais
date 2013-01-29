myrand_seed(10000);

N = 10000;
x = zeros(N,1);
for i=1:N
    x(i) = myrand_float();
end

hist(x,50);
