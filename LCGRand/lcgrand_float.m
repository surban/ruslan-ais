function [x] = lcgrand_float()
x = lcgrand_uint32() / 2^32;
end
