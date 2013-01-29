lcgrand_seed(0)

fprintf('uint32s:\n')
for i=1:10 
    fprintf('%.f\n', lcgrand_uint32())
end

fprintf('floats:\n')
for i=1:10
    fprintf('%.20f\n', lcgrand_float())
end

    
    
    