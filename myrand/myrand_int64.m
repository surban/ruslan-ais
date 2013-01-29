function [ r ] = myrand_int64()
global myrand_u myrand_v myrand_w

fprintf('u: %20u v: %20u w: %20u\n', myrand_u, myrand_v, myrand_w);
myrand_u = myrand_u * uint64(2862933555777941757) + uint64(7046029254386353087);
fprintf('u: %20u v: %20u w: %20u\n', myrand_u, myrand_v, myrand_w);

myrand_v = bitxor(myrand_v, bitshift(myrand_v, -17, 'uint64'), 'uint64');
myrand_v = bitxor(myrand_v, bitshift(myrand_v, +31, 'uint64'), 'uint64');
myrand_v = bitxor(myrand_v, bitshift(myrand_v,  -8, 'uint64'), 'uint64');

myrand_w = uint64(4294957665) * bitand(myrand_w, uint64(hex2dec('ffffffff')), 'uint64') + ...
           bitshift(myrand_w, -32, 'uint64');
x = bitxor(myrand_u, bitshift(myrand_u, 21, 'uint64'), 'uint64');
x = bitxor(x, bitshift(x, -35, 'uint64'), 'uint64');
x = bitxor(x, bitshift(x,   4, 'uint64'), 'uint64');

r = bitxor(x + myrand_v, myrand_w, 'uint64');

end