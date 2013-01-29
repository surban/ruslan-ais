function [x] = lcgrand_uint32()
global lcgrand_state

a = 1664525;
c = 1013904223;
m = 2^32;

lcgrand_state = mod(a * lcgrand_state + c, m);
x = lcgrand_state;

end