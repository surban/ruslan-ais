function myrand_seed(j)
global myrand_u myrand_v myrand_w

myrand_u = uint64(0);
myrand_v = uint64(4101842887655102017);
myrand_w = uint64(1); %#ok<*NASGU>

%fprintf('u: %20u v: %20u w: %20u\n', myrand_u, myrand_v, myrand_w);

myrand_u = bitxor(uint64(j), myrand_v, 'uint64');
%fprintf('u: %20u v: %20u w: %20u\n', myrand_u, myrand_v, myrand_w);
myrand_int64();
%fprintf('u: %20u v: %20u w: %20u\n', myrand_u, myrand_v, myrand_w);

myrand_v = myrand_u;
myrand_int64();
myrand_w = myrand_v;
myrand_int64();

end